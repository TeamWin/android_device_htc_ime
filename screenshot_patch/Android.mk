LOCAL_PATH := $(call my-dir)

# Dummy file to apply post-install patch for screenshot
include $(CLEAR_VARS)

LOCAL_MODULE := $(TARGET_DEVICE)_screenshot
LOCAL_MODULE_TAGS := optional eng
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/system/bin
LOCAL_REQUIRED_MODULES := teamwin
LOCAL_POST_INSTALL_CMD += \
    $(hide) sed -i 's:power+voldown:power+home:' $(TARGET_RECOVERY_ROOT_OUT)/twres/portrait.xml; \
    sed -i 's:power+voldown:power+home:' $(TARGET_RECOVERY_ROOT_OUT)/twres/ui.xml;
include $(BUILD_PHONY_PACKAGE)

