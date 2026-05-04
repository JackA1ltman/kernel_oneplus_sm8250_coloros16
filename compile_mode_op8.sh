#!/bin/bash
if [ -z "$1" ]; then
	echo "Currently, no selection has been made, defaulting to Mode 1."
	MODE=1
else
	MODE=$1
fi

# Basic Var
IMAGE_DIR="$(pwd)/out/arch/arm64/boot"
TIME=$(date +"%Y%m%d%H%M%S")
CURRENT_FOLDER=$(basename "$(pwd)")
USER_HOME=/home/jackaltman/Kernel_Build
DEVICE_NAME="OP9P"

# Compiler Var
CLANG_SELECT=clang_los_12
export PATH=$USER_HOME/Clang/$CLANG_SELECT/bin:$PATH
GCC_64=CROSS_COMPILE=$USER_HOME/Gcc/gcc-64/bin/aarch64-linux-android-
GCC_32=CROSS_COMPILE_ARM32=$USER_HOME/Gcc/gcc-32/bin/arm-linux-androideabi-
#GCC_64=CROSS_COMPILE=aarch64-linux-gnu-
#GCC_32=CROSS_COMPILE_ARM32=arm-none-eabi-
CLANG_OTHER=CLANG_TRIPLE=aarch64-linux-gnu-
COMPILER_OPTION="BRAND_SHOW_FLAG=oneplus LD=ld.lld"
COMPILER_ARCH=ARCH=arm64
COMPILER_OUT=O=out
COMPILER_DEFCONFIG=vendor/kona-perf_defconfig

build(){
make mrproper && rm -f error.log
rm -rf out
make -j$(nproc --all) CC="ccache clang" $COMPILER_OUT $COMPILER_ARCH $COMPILER_OPTION $CLANG_OTHER $GCC_64 $GCC_32 $COMPILER_DEFCONFIG
make -j$(nproc --all) CC="ccache clang" $COMPILER_OUT $COMPILER_ARCH $COMPILER_OPTION $CLANG_OTHER $GCC_64 $GCC_32 2>&1|tee error.log
}

anykernel3(){
# AnyKernel3 Var
AK3_LOCATION="$(pwd)/Anykernel3"
GENERATE_DTB=0

mkdir -p tmp
if [ -f "$IMAGE_DIR/Image.gz-dtb" ]; then
		echo "Found Image.gz-dtb!"
	cp -fp $IMAGE_DIR/Image.gz-dtb tmp
elif [ -f "$IMAGE_DIR/Image.gz" ]; then
	echo "Found Image.gz!"
	cp -fp $IMAGE_DIR/Image.gz tmp
elif [ -f "$IMAGE_DIR/Image" ]; then
	echo "Found Image!"
	cp -fp $IMAGE_DIR/Image tmp
fi

if [ -f "$IMAGE_DIR/dtbo.img" ]; then
	echo "Found dtbo.img!"
	cp -fp $IMAGE_DIR/dtbo.img tmp
else
	echo "Not found dtbo.img!"
fi

if [ -f "$IMAGE_DIR/dtb" ]; then
	echo "Found DTB!"
	cp -fp $IMAGE_DIR/dtb tmp
else
	if [ $GENERATE_DTB == 1 ]; then
		cat $IMAGE_DIR/dts/vendor/qcom/*.dtb > tmp/DTB
		echo "Generated DTB!"
	fi
	echo "Doesn't found DTB! u device maybe needn't the file."
fi
cp -rp $AK3_LOCATION/* tmp
cd tmp
7za a -mx9 tmp.zip *
cd ..
rm *.zip
cp -fp tmp/tmp.zip $DEVICE_NAME-$TIME.zip
rm -rf tmp
}

mkbootimg(){
# MKBOOTIMG Var
FORMAT_MKBOOTIMG=$(echo `$USER_HOME/mkbootimg/unpack_bootimg.py --boot_img=$USER_HOME/Kernel_Source_IMGs/boot_$CURRENT_FOLDER.img --out outKernel --format mkbootimg`)
IMAGE_MKBOOTIMG=Image.gz-dtb

if [ $? -eq 0 ]; then
        if [ -f "outKernel" ]; then
        	mkdir outKernel
        fi
        rm -f outKernel/*
        $USER_HOME/mkbootimg/unpack_bootimg.py --boot_img $USER_HOME/Kernel_Source_IMGs/boot_$CURRENT_FOLDER.img --out outKernel
	cp $IMAGE_DIR/$IMAGE_MKBOOTIMG outKernel/kernel
	$USER_HOME/mkbootimg/mkbootimg.py --kernel outKernel/kernel --ramdisk outKernel/ramdisk $FORMAT_MKBOOTING -o boot_${CURRENT_FOLDER}_${TIME}.img
	echo "========================"
	echo "=                      ="
	echo "= Compile Successfully ="
	echo "=                      ="
	echo "========================"
	echo "$(ls boot_${CURRENT_FOLDER}_${TIME}.img)"
else
        echo "Compile Failed!Please check error.log."
fi
}

if [ $MODE == 1 ]; then
	echo "======================"
	echo "=                    ="
	echo "=  Execution Mode 1  ="
	echo "=                    ="
	echo "======================"
	echo "  Please waiting 5s.  "
	sleep 5s
	build
	anykernel3
elif [ $MODE == 2 ]; then
	echo "======================"
	echo "=                    ="
	echo "=  Execution Mode 2  ="
	echo "=                    ="
	echo "======================"
	echo "  Please waiting 5s.  "
	sleep 5s
	build
	mkbootimg
elif [ $MODE == 3 ]; then
	echo "======================"
	echo "=                    ="
	echo "=Execution Mode Build="
	echo "=                    ="
	echo "======================"
	echo "  Please waiting 2s.  "
	sleep 2s
	build
elif [ $MODE == 4 ]; then
	echo "======================"
	echo "=                    ="
	echo "=     Anykernel3     ="
	echo "=                    ="
	echo "======================"
	echo "  Please waiting 2s.  "
	sleep 2s
	anykernel3
elif [ $MODE == 5 ]; then
	echo "======================"
	echo "=                    ="
	echo "=     MKBOOT IMG     ="
	echo "=                    ="
	echo "======================"
	echo "  Please waiting 2s.  "
	sleep 2s
	mkbootimg
else
	echo "======================"
	echo "=                    ="
	echo "=  Execution Error!  ="
	echo "=                    ="
	echo "======================"
	echo "        Exit !        "
	exit
fi
