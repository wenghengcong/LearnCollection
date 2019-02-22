Sparkle 使用

下载release包

1. 进入bin，generate_keys，生成公钥，指定`Info.plist` as a [`SUPublicEDKey`](https://sparkle-project.org/documentation/customization/) 为公钥。
2. 发布新版本，将新版本的.app，压缩成zip，放到某一路径。
3. 生成xml文件， $ generate_appcast /Users/wenghengcong/MyApps/BeeFun/BeeFunMac/resource/sparkle_sign/
4. 将xml文件放到https路径，并指定Info.plist中的SUFeedURL
5. 将压缩zip包上传到xml中指定的路径。