# drink_bot
A new datalab drink bot project.
## Using
open iOS Simulator
```bash=
$ open -a simulator 
```

run mobile app
```bash=
$ flutter run
```

run web app
```bash=
$ flutter run -d chrome
```
## Build apk
step1.
Open android studio.

step2.
Click shift two times.

step3.
enter build apk and select.

## Build ipa
檢查版本

```bush=
$ xcodebuild -showsdks
```
#### Create .xcarchive
打開置 Runner.xcworkspace 資料夾下面
```bash=
$ xcodebuild -workspace Runner.xcworkspace -scheme Runner -sdk iphoneos clean archive -configuration release archive -archivePath $PWD/build/Runner.xcarchive
```
#### Create ipa
```bash=
$ xcodebuild -exportArchive -archivePath $PWD/build/Runner.xcarchive -exportOptionsPlist build/ExportOptions.plist -exportPath $PWD/build
```

## Installation
https://chucs.github.io/flutter-001-install/

https://flutter.dev/docs/get-started/install

## Development
https://dart.dev/

https://flutter.dev/
## Api
https://github.com/pin-yu/datalab-drinks-backend