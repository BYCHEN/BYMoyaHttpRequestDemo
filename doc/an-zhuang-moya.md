# 安裝Moya

#### 請前往Moya的Github

> #### [https://github.com/Moya/Moya](https://github.com/Moya/Moya)

#### 

建立Podfile

```
# pod init
```

![](/doc/assets/螢幕快照 2017-06-21 11.12.08.png)

編輯podfile

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'BYMoyaHttpRequestDemo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BYMoyaHttpRequestDemo
  pod 'Moya'
end
```

執行pod install來安裝第三方套件

```
# pod install
```

![](/doc/assets/螢幕快照 2017-06-21 11.12.45.png)

