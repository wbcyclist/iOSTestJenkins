#!/bin/bash

# Get the current git commmit hash (first 7 characters of the SHA)
# GITREVSHA=$(git --git-dir="${PROJECT_DIR}/.git" --work-tree="${PROJECT_DIR}" rev-parse --short HEAD)
GITREVSHA=$(git rev-parse --short HEAD)
GITComment=$(git log -1 --pretty=%B)

if [ "${WORKSPACE}" ]; then
	GITREVSHA=$(git --git-dir="${WORKSPACE}/.git" --work-tree="${WORKSPACE}" rev-parse --short HEAD)
	GITComment=$(git --git-dir="${WORKSPACE}/.git" --work-tree="${WORKSPACE}" log -1 --pretty=%B)
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

# 原生xcodebuild命令打包
#xcodebuild -archivePath "build/test.xcarchive" -workspace iOSTestJenkins.xcworkspace -sdk iphoneos -scheme "iOSTestJenkins" -configuration "AdHoc" archive
#xcodebuild -exportArchive -exportFormat IPA -exportProvisioningProfile "WildcardAppProfile" -archivePath "build/test.xcarchive" -exportPath "build/test_AdHoc.ipa"
#echo "Archive Successfully"

# fir封装打包
# fir build_ipa <workspace的目录> -w -S <scheme name> -C <要打包的项目配置> -o <输出目录> -p -T <FIR_TOKEN(-p -T为上传至fir.im)> -c <YOUR_CHANGELOG>
# 更多参数介绍fir build_ipa -h
out="${GITREVSHA} : ${GITComment}"
fir build_ipa ./ -w -S iOSTestJenkins -C AdHoc -o ./build -n iOSTestJenkins -p -T 9857ecbff1e5bf9cd0686d01e90c3a97 -c "${out}"

# 上传蒲公英
uKey="f91076c2494b5b01a6311c7cc2b9dd2e"
apiKey="f4efaf8945b1d5675dc588c61ad5b674"
filePath="${WORKSPACE}/build/iOSTestJenkins.ipa"
curl -F "file=${filePath}" -F "uKey=${uKey}" -F "_api_key=${apiKey}" -F "publishRange=2" -F "updateDescription=${out}" http://www.pgyer.com/apiv1/app/upload
