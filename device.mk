#
# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

LOCAL_PATH := device/htc/ime

# Inherit from common AOSP configuration
$(call inherit-product, build/target/product/embedded.mk)

# Platform
TARGET_BOARD_PLATFORM := sdm845

# Use the A/B updater.
AB_OTA_UPDATER := true

# Enable update engine sideloading by including the static version of the
# boot_control HAL and its dependencies.
PRODUCT_STATIC_BOOT_CONTROL_HAL := \
    bootctrl.$(TARGET_BOARD_PLATFORM) \
    libgptutils \
    libz

PRODUCT_PACKAGES += \
    update_engine_sideload

# qcom standard decryption for TWRP
PRODUCT_PACKAGES += \
    qcom_decrypt

# tzdata
PRODUCT_PACKAGES += \
    tzdata_twrp

# HTC otacert
PRODUCT_EXTRA_RECOVERY_KEYS += \
    $(LOCAL_PATH)/security/htc
