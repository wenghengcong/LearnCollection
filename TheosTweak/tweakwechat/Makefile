
# ARCHS = arm64
# tweakwechat_FRAMEWORKS = UIKit
# TARGET = iPhone:latest:8.0
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = tweakwechat
tweakwechat_FILES = Tweak.xm Cell/MMTableViewCell.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
