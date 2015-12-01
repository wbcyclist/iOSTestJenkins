#!/bin/bash
if [ "${WORKSPACE}" ]; then
	echo "cd WORKSPACE"
	cd ${WORKSPACE}
fi

#创建build文件夹
if [ -d ./build ];then
	rm -rf build
fi
mkdir build
# 清除项目
xcodebuild clean
# pod 安装
pod install --no-repo-update

#xcodebuild -list -workspace iOSTestJenkins.xcworkspace
xcodebuild -archivePath "build/test.xcarchive" -workspace iOSTestJenkins.xcworkspace -sdk iphoneos -scheme "iOSTestJenkins" -configuration "AdHoc" archive
xcodebuild -exportArchive -exportFormat IPA -exportProvisioningProfile "WildcardAppProfile" -archivePath "build/test.xcarchive" -exportPath "build/test_AdHoc.ipa"
echo "Archive Successfully"