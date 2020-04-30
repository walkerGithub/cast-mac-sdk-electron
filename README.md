# Cast Mac Electron SDK 

### 什么是Cast Mac Electron SDK？
可将SDK与Mac Electron环境下APP集成，借助SDK增加投屏相关功能。

* 投屏码投屏：用户输入6位投屏码，即可快速投屏主屏。
* 投屏扩展屏：可供选择Airplay方式，扩展屏幕投屏，抗干扰，精准投屏。

### 准备条件
在试用我们的SDK之前，您需要具备以下条件才能开始使用：

*  装有Mac OS的设备：MacOS 10.10或更高版本。
*  一个Appkey:如果您没有这个appkey，需向乐播商务申请。
*  一个会议室投屏接收端硬件和后台系统，硬件可显示投屏码，与Mac OS的设备在同一wifi，Mac OS的设备可链接到后台。

### Cast Mac Electron SDK的结构说明
```
├── [sdk]
    └──[mac] <-- 构建的mac端node文件和原生SDK动态库
├── binding.gyp <-- 构建node文件的JSON配置表
├── build_nodeaddon_mac.sh <-- 用于重新构建node文件的脚本
├── build_app_mac.sh <--  用于打包APP的脚本，以供测试人员测试App
├── run_demo_mac.sh <-- 运行可调试的demo脚本
├── README.md <-- 集成说明文档
├── CHANGELOG.md <-- 版本变更记录
├── [demo] <--  demo项目代码
    └──[OutApp] <-- Electron打包生成的App
├── [lib] <-- js文件和cast electron SDK桥接层的源码
└── [xcode-text] <-- Xcode代码编辑项目
```

### 变更记录
有关所有更改，请参考我们的./CHANGELOG.md

### 常见问题解答（FAQ）
打包出的APP，投屏可能无法访问服务器，需在APP内**.app/Contents/Info.plist配置ATS,允许http访问
```
<key>NSAppTransportSecurity</key>
<dict>
<key>NSAllowsArbitraryLoads</key>
<true/>
</dict>
```
## 一、Mac的开发环境配置

1.安装node.js 12.0.0版本，下载网址：https : //nodejs.org/download/release/v12.0.0/。也可以运行ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" 并sudo brew install node安装node.js

2.安装电子版5.0.2，使用命令运行 npm install --save-dev electron@5.0.2 -g

3.运行npm install node-gyp -g安装node-gyp

4.运行npm install bindings -g安装bindings

## 二、Cast Electron SDK 演示

1、运行sh build_nodeaddon_mac.sh以重新构建node文件。

2、运行sh run_demo_mac.sh以运行Electron演示demo。

## 三、集成Electron SDK

### 1、导入SDK库和JS代码
在项目里拖入sdk文件夹和lib/cast_sdk.js文件，cast_sdk.js是对外提供调用接口。


### 2、添加依赖库
在项目package.json配置如下，路径根据实际情况修改。
```
"scripts": {
  "start": "./node_modules/.bin/electron .",
  "test": "echo \"Error: no test specified\" && exit 1",
  "packager-mac": "electron-packager ./ castsdkapp --platform=darwin --arch=x64 --out ./OutApp --electron-version=5.0.2 --overwrite && yes|cp -R  -H ../lib ./OutApp/castsdkapp-darwin-x64/castsdkapp.app/Contents/Resources/ && rm -rf ../sdk/win32 && rm -rf ../sdk/win64 && yes|cp -R  -H ../sdk ./OutApp/castsdkapp-darwin-x64/castsdkapp.app/Contents/Resources/ && yes|cp -R  -H ../sdk/mac/Resources ./OutApp/castsdkapp-darwin-x64/castsdkapp.app/Contents/&& yes|cp -R  -H ../sdk/mac/CastSDK/* ./OutApp/castsdkapp-darwin-x64/castsdkapp.app/Contents/Frameworks && yes|cp -R  -H ../sdk/mac/Resources ./OutApp/castsdkapp-darwin-x64/castsdkapp.app/Contents/Frameworks/castsdkapp\\ Helper.app/Contents/",
  "postinstall-mac": "yes|cp -R  -H ../sdk/mac/CastSDK/ ./node_modules/electron/dist/Electron.app/Contents/Frameworks && yes|cp -R  -H ../sdk/mac/Resources ./node_modules/electron/dist/Electron.app/Contents/ && yes|cp -R  -H ../sdk/mac/Resources ./node_modules/electron/dist/Electron.app/Contents/Frameworks/Electron\\ Helper.app/Contents/"
},
"devDependencies": {
  "electron-packager": "^12.0.0",
  "electron-rebuild": "^1.5.10",
  "electron": "^5.0.2",
  "node-addon-api": "^1.0.0"
},
"dependencies": {
  "electron": "^5.0.2",
  "electron-rebuild": "^1.5.10",
  "electron-packager": "^12.0.0"
}
```

### 3、初始化投屏SDK

加载投屏模块
```
//项目代码里导入对cast_sdk.js的引用
const CASTSDKMOD = require('../lib/cast_sdk.js');

//node加载路径
const node_path = './../sdk/mac/castsdk.node';
// 获取cast_nodejs_SDK
const castsdk = CASTSDKMOD.CastSDK.getInstance(node_path);

```

设置C++回调JS接口
```
SetCallback: function (callback) {
...
}
参数说明
callback:js function
return:-1设置失败，0设置成功

示例
// 回调接口
function callBack(type, success, errType,param) {
    //在这里处理所有回调事件
    console.log('callBack call',type,success,errType,param);
}
// 设置C++回调JS接口，
var ret = castsdk.SetCallback(callBack);
```

初始化投屏参数配置
```
InitSDK: function (appkey,userid,department,pinserver,pinserverport,httpsbool,logbool) {
...
}
参数说明
appkey:乐播提供的key,字符串类型,需向商务咨询，向乐播需提供APP的bundle id，
userid:员工id，字符串类型，m空字符填写"",不可填写NULL，null,下同
department:员工部门,字符串类型
pinserver:pin码服务器ip或域名,字符串类型
pinserverport:pin码服务器端口,int类型
httpsbool:https开关,服务器是否https,bool类型
logbool:日志开关，bool类型
return:-1调用失败，0调用成功 int类型

示例
var ret = castsdk.InitSDK("011e99a33c4cd35545baf6c896e9916f","0001",
"研发一部","192.168.8.230",8000,false,true);

```

设置log输出方式
```
SetProperty: function (property,value) {
...
}
参数说明
property:原生SDK属性名称，字符串类型
value:设置值支持bool，string，int三种数据类型，
return:-1调用失败，0调用成功

示例
//设置log输出方式
castsdk.SetProperty("logOutputStyle",2);
log输出方式value说明：0:终端输出，1:代理方法输出,2:文件保存（log文件保存，保存路径在~/Library/CastLB/[CFBundleIdentifier]/Log/，CFBundleIdentifier为APP的boundle ID）
```

### 4、基本功能使用
#### 1) 开始投屏
```
StartCast: function (pincode) {
...
}
参数说明
pincode:投屏码，字符串类型
return:-1调用失败，0调用成功，投屏是否成功在代理回调返回

示例
var ret = castsdk.StartCast(pincode);
```

#### 2) 停止投屏
```
StopCast: function () {
...
}
参数说明
return:-1调用失败，0调用成功，投屏是否结束在代理回调返回

示例
var ret = castsdk.StopCast();
```

#### 3) 代理回调处理
在初始化SDK时设置的回调JS接口，处理所有回调事件，type是回调的事件类型。
```
设置回调时callBack
function callBack(type, success, errType,param) {
    //在这里处理所有回调事件
    console.log('callBack call',type,success,errType,param);
}
参数说明
type：事件类型，字符串类型
success：成功与否，bool类型
errType：错误码，int类型
param：参数，字符串类型

type事件字符串说明{
startHappyCastWithCastCode:completeBlock://开始投屏结果回调 success:投屏是否成功 errType：错误码(参考->四.投屏相关错误码)，param：错误说明/会议室名称(errType==4048时，param为会议室名称即发布服务名称)
stopHappyCastCompleteBlock://停止投屏结果回调 success:停止投屏是否成功 errType：错误码 param：错误说明
isCastingObserveChange//投屏状态监听变化回调，success:true代表正在投屏，false代表投屏结束 errType:忽略  param:忽略
workspaceWillSleepOrScreenIsLockedNotification://系统休眠或者锁屏回调,可执行停止投屏业务逻辑，success:忽略 errType:忽略  param:忽略
kHPOfficeCastVideoCacheFrameNumberNotification//视频缓存帧通知回调，param:缓存帧数，一帧时间间隔为33ms，用于上层做网络延时提醒,例如：param=100，投屏延时达到100*33=3300ms
officeCastDisconnect//投屏过程中异常断开 success:停止投屏是否成功 errType：错误码 param：错误说明
officeCastOccupy//投屏被其它设备抢占 success:忽略 errType:忽略  param:忽略
officeCastReceivedUserStop//投屏在被接收端主动关闭 success:忽略 errType:忽略  param:忽略
}
```

### 5、系统权限API
投屏前需先获取屏幕录制权限和麦克风录制权限
```
SystemAuthorize: function (selector) {
...
}
参数说明
selector:权限选择，字符串类型
return:0，无权限，1:有权限 -1:获取权限失败

selector字符串说明{
canRecordScreen//获取录制屏幕系统权限
canRecordAudio//获取录制系统声音权限
openSystemSettingRecordScreenAuthorize//打开系统设置录制屏幕授权界面
openSystemSettingRecordAudioAuthorize//打开系统设置录制声音授权界面
}

示例
// 获取录制屏幕系统权限 ret==0，无录制屏幕权限，1:有录制屏幕权限 -1:获取权限失败
var ret = castsdk.SystemAuthorize("canRecordScreen");
//获取录制系统声音权限 同上
var ret = castsdk.SystemAuthorize("canRecordAudio");
// 打开系统设置录制屏幕授权 ret>=0，打开成功，-1：打开失败
var ret = castsdk.SystemAuthorize("openSystemSettingRecordScreenAuthorize");
//打开系统设置录制声音授权 同上
var ret = castsdk.SystemAuthorize("openSystemSettingRecordAudioAuthorize");

```

### 6、安装所需插件
投屏系统声音，需安装声卡插件
```
获取是否已安装声卡插件
GetIsSupportCastSystemSound: function () {
...
}
参数说明
return:0，无声卡插件，1:有声卡插件 -1:获取失败

示例
var ret = castsdk.GetIsSupportCastSystemSound();


在未安装声卡插件情况下，安装声卡插件
InstallAudioDriver: function () {
...
}
参数说明
return:0安装成功，-1:安装失败

示例
var ret = castsdk.InstallAudioDriver();

卸载声卡插件
UninstallAudioDriver: function () {
...

}
参数说明
return:0卸载成功，-1:卸载失败
示例
var ret = castsdk.UninstallAudioDriver();
```

### 7、获取和设置属性接口
JS可通过 SetProperty/GetProperty的js接口设置/获取属性值。
例如设置启动系统投屏和获取投屏状态
```
设置属性值
SetProperty: function (property,value) {
...
}
参数说明
property:原生SDK属性名称，字符串类型
value:属性值，支持bool，string，int 三种数据类型，
return:0设置成功，-1:设置失败

示例：启用系统投屏
var ret = castsdk.SetProperty("enableSystemCast",true);

获取属性值
GetProperty: function (property) {
...
}
参数说明
property:原生SDK属性名称，字符串类型
return:-1:获取失败，其它:value属性值

示例：获取投屏状态
var isCasting = castsdk.GetProperty("isCasting");

more:更多属性值设置或获取，可通过HPOfficeCastWork.framework/Versions/A/Headers/HPOfficeCast.h原生SDK属性名称查看
```


### 8、投屏相关错误码
```
/** 投屏错误码 */
typedef enum : NSUInteger {
    HPCastDevicesErrorCodeBusy = 4000,//投屏繁忙
    HPCastDevicesErrorCodeTimeOut,//投屏失败超时
    HPCastDevicesErrorCodeReceiverCastingAllowOccupy,//投屏失败接收端投屏中允许抢占
    HPCastDevicesErrorCodeReceiverCastingNoAllowOccupy,//投屏失败接收端投屏中不允许抢占
    HPCastDevicesErrorCodeUnknown,//投屏失败未知
    HPCastDevicesErrorCodeOpenLeboCastFailBecauseIsLeboCasting,//打开投屏失败，因为投屏已经打开了
    HPCastDevicesErrorCodeCloseLeboCastFailBecauseIsClosed,//关闭投屏失败，因为投屏已经处于关闭状态
    HPCastDevicesErrorCodeOpenLeboCastFailBecauseCastWindowIdNotExist,//打开投屏失败，选择的窗口ID不存在
    HPCastDevicesErrorCodeReceiverCastNoAllow,//投屏失败接收端设备不允许
    HPCastDevicesErrorCodeRecordScreenUnauthorized,//录制屏幕未获得授权
    HPCastDevicesErrorCodeAppkeyVerifyFailure = 4040,//appkey验证失败
    HPCastDevicesErrorCodeCastCodeEmpty,//投屏码为空
    HPCastDevicesErrorCodeCastCodeLengthOverstep,//投屏码长度超出范围
    HPCastDevicesErrorCodeServiceIpNoSet,//服务地址未设置
    HPCastDevicesErrorCodeServiceRequestFailed,//服务请求失败
    HPCastDevicesErrorCodeCastCodeError,//投屏码错误，查找不到或解析错误
    HPCastDevicesErrorCodeServiceRequestResultsInfoImperfect,//服务请求的结果信息不完整
    HPCastDevicesErrorCodeDnsPublishFailed,//dns发布失败
    HPCastDevicesErrorCodeDnsPublishSucceedWaitSystemCast,//dns发布成功,等待系统投屏
    HPCastDevicesErrorCodeCloseLeboCastLackDeviceInfo,//关闭投屏失败，缺少设备信息，需先通过投屏码请求
    HPCastDevicesErrorCodeCloseLeboCastRequestFailed,//关闭投屏失败，请求错误
    HPCastDevicesErrorCodeCloseLeboCastFailMACNotMatch,//关闭投屏失败，mac不匹配
    HPCastDevicesErrorCodeCtrNotConnectedReceiveDevice,//投屏控制未连接
    HPCastDevicesErrorCodeCastDeviceModelPropertiesAbnormal, // 设备模型属性参数异常
    HPCastDevicesErrorCodeMatchDeviceFailedKeywordEmpty = 4100,//匹配设备关键词为空
    HPCastDevicesErrorCodeMatchDeviceFailedPageIndexParamAbnormal,//匹配设备失败页索引参数异常
    HPCastDevicesErrorCodeMatchDeviceFailedPageNumberParamAbnormal,//匹配设备失败页数量参数异常
    HPCastDevicesErrorCodeMatchDeviceFailedPageIndexOverstep,//匹配设备页索引超出范围
    HPCastDevicesErrorCodeMatchDeviceFailedOther,//匹配设备失败其它
    HPCastDevicesErrorCodeCastRemoteDeviceModelEmpty, // 远端设备模型为空
    HPCastDevicesErrorCodeCastRemoteDeviceModelPropertiesAbnormal, // 远端设备模型属性参数异常
    HPCastDevicesErrorCodeAddCastRemoteDeviceFailBecauseCastingOrPrepareCast,//添加远端设备失败，因为已在投屏中或准备投屏中
    HPCastDevicesErrorCodeAddCastRemoteDeviceFailBecauseConnectionFailure,//添加远端设备失败，连接远端失败
    HPCastDevicesErrorCodeAddCastRemoteDeviceFailBecauseNotAllowOccupy,//添加远端设备失败，因为不允许抢占
    HPCastDevicesErrorCodeRemoveCastRemoteDeviceFailBecauseNoCast,//移除远端设备失败，因为不在投屏中
    HPCastDevicesErrorCodeRemoteDeviceDisconnectBecauseBeOccupy,//远端设备断开，被其它设备抢占
    HPCastDevicesErrorCodeRemoteDeviceDisconnectFromRemoteDeviceDisconnect,//远端设备断开，从远端主动断开
    HPCastDevicesErrorCodeRemoteDeviceDisconnectFromServerBackgroundDisconnect,//远端设备断开，从服务器后台断开
    HPCastDevicesErrorCodeRemoteDeviceDisconnectUnknown,//远端设备断开，未知断开

}HPCastDevicesErrorCode;
```
