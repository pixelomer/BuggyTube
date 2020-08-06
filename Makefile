TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BuggyTube

BuggyTube_FILES = Tweak.x
BuggyTube_CFLAGS = -fobjc-arc

#
# I don't remember why I wanted to make the tweak load before every other tweak, but
# I'll keep this here so that I can easily find and use this code in the future
#
after-stage::
	@	$(PRINT_FORMAT_GREEN) "Renaming tweak files"; \
		dir="$(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries"; \
		rename() { \
			mv "$${dir}/$(TWEAK_NAME).$$1" "$${dir}/$(shell printf "\x01\x01\x01")$(TWEAK_NAME).$$1"; \
		}; \
		rename plist; \
		rename dylib;

include $(THEOS_MAKE_PATH)/tweak.mk
