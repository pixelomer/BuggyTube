#import <UIKit/UIKit.h>

static NSURL *memeURL;

@interface YTAppDelegate : UIResponder<UIApplicationDelegate>
@end

%hook YTAppDelegate

- (BOOL)application:(UIApplication *)application
	didFinishLaunchingWithOptions:(NSDictionary<UIApplicationLaunchOptionsKey, id> *)options
{
	BOOL ret = %orig;
	if (!options[UIApplicationLaunchOptionsUserActivityDictionaryKey]) {
		// It seems like the app was opened without a URL. We need to fool the app
		// to make it think it *was* opened with a URL by invoking the handler
		// method manually.
		NSUserActivity *activity = [[NSUserActivity alloc]
			initWithActivityType:NSUserActivityTypeBrowsingWeb
		];
		[self
			application:application
			continueUserActivity:activity
			restorationHandler:^(NSArray *objects){
				/* Maybe I'm supposed to put something in here? idk ¯\_(ツ)_/¯ */
			}
		];
	}
	return ret;
}

- (BOOL)application:(UIApplication *)application
	continueUserActivity:(NSUserActivity *)userActivity
	restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
	// Replace the URL with the meme URL.
	userActivity.webpageURL = memeURL;

	// Original implementation does some magic that ends up opening the video
	// at the requested URL.
	return %orig;
}

%end

%ctor {
	memeURL = [NSURL URLWithString:@"https://www.youtube.com/watch?v=fC7oUOUEEi4"];
	%init;
}