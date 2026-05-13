ifeq ($(CONFIG_BUILD_ARM64_DT_OVERLAY),y)
    dtbo-$(CONFIG_ARCH_KONA) += \
        kona-instantnoodle-overlay.dtbo \
        kona-instantnoodlep-overlay.dtbo \
        kona-kebab-overlay.dtbo \
        kona-lemonades-overlay.dtbo \
        kona-PEDM00-overlay.dtbo \
        kona-RMX3366-overlay.dtbo \
        kona-RMX3370-overlay.dtbo

    kona-instantnoodle-overlay.dtbo-base := kona.dtb kona-v2.dtb kona-v2.1.dtb
    kona-instantnoodlep-overlay.dtbo-base := kona.dtb kona-v2.dtb kona-v2.1.dtb
    kona-kebab-overlay.dtbo-base := kona.dtb kona-v2.dtb kona-v2.1.dtb
    kona-lemonades-overlay.dtbo-base := kona.dtb lemonades/kona-v2-lemonades.dtb kona-v2.1.dtb
    kona-PEDM00-overlay.dtbo-base := kona-oppo.dtb kona-v2-oppo.dtb kona-v2.1-oppo.dtb
    kona-RMX3366-overlay.dtbo-base := kona-oppo.dtb kona-v2-oppo.dtb kona-v2.1-oppo.dtb
    kona-RMX3370-overlay.dtbo-base := kona-oppo.dtb kona-v2-oppo.dtb kona-v2.1-oppo.dtb
endif

always		:= $(dtb-y)
subdir-y	:= $(dts-dirs)
clean-files    := *.dtb *.dtbo
