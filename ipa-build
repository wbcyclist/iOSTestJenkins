#!/bin/bash

xcodebuild -archivePath "build/test.xcarchive" -workspace iOSTestJenkins.xcworkspace -sdk iphoneos -scheme "iOSTestJenkins" -configuration "AdHoc" archive
xcodebuild -exportArchive -exportFormat IPA -exportProvisioningProfile "WildcardAppProfile" -archivePath "build/test.xcarchive" -exportPath "build/test_AdHoc.ipa"
echo "Archive Successfully"