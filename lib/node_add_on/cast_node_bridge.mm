#include "cast_node_bridge.h"

#include <iostream>
#include <stdlib.h>
#import <Foundation/Foundation.h>
#import "../../sdk/mac/CastSDK/HPOfficeCastWork.framework/Versions/A/Headers/HPOfficeCast.h"
#import "../../sdk/mac/CastSDK/HPOfficeCastWork.framework/Versions/A/Headers/HPOfficeBase.h"
#import "../../sdk/mac/CastSDK/HPOfficeCastWork.framework/Versions/A/Headers/HPSystemAuthorize.h"
#import "../../sdk/mac/CastSDK/HPOfficeCastWork.framework/Versions/A/Headers/HPServiceModel.h"


CHPCastNodeBridge *g_pCast = NULL;
@interface HPOfficeCastDelegate ()<HPOfficeCastDelegate>{
     
}

@end

@implementation HPOfficeCastDelegate

- (instancetype)init{
    if (self = [super init]) {
        [self addAllObserver];
    }
    return self;
}

- (void)dealloc {
    [super dealloc];
    
    [self removeAllObserver];
   

}

- (void)removeAllObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHPOfficeCastVideoCacheFrameNumberNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [[HPOfficeCast sharedOfficeCast] removeObserver:self forKeyPath:@"isCasting"];
    [[[NSWorkspace sharedWorkspace] notificationCenter] removeObserver:self name:NSWorkspaceWillSleepNotification object:nil];
    [[NSDistributedNotificationCenter defaultCenter] removeObserver:self name:@"com.apple.screenIsLocked" object:nil];
}

- (void)addAllObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoCacheFrameNumberNotification:) name:kHPOfficeCastVideoCacheFrameNumberNotification object:nil];
    
    [[HPOfficeCast sharedOfficeCast] addObserver:self forKeyPath:@"isCasting" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];

     // 添加mac睡眠监听
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(workspaceWillSleepOrScreenIsLockedNotification:) name:NSWorkspaceWillSleepNotification object:NULL];
     // 添加mac锁定屏幕
    NSDistributedNotificationCenter* distCenter =
    [NSDistributedNotificationCenter defaultCenter];
    [distCenter addObserver:self
                   selector:@selector(workspaceWillSleepOrScreenIsLockedNotification:)
                       name:@"com.apple.screenIsLocked"
                     object:nil];
}

//pragma mark - kvo
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    id newObject = [change objectForKey:NSKeyValueChangeNewKey];
    id oldObject = [change objectForKey:NSKeyValueChangeOldKey];
    if ([keyPath isEqualToString:@"isCasting"]  && ([newObject boolValue] != [oldObject boolValue])) {
        NSLog(@"isCasting:%@",[change objectForKey:NSKeyValueChangeNewKey]);
        if ([newObject boolValue] == NO) {
            [self castEnd];
        }else{
            [self castSucceed];
        }
    }
}

- (void)castSucceed{
    g_pCast->CallBack("isCastingObserveChange",true,0,"");
}

- (void)castEnd{
    g_pCast->CallBack("isCastingObserveChange",false,0,"");
}

#pragma mark - 系统休眠或者锁屏
- (void)workspaceWillSleepOrScreenIsLockedNotification:(NSNotification *)notif{
    NSLog(@"workspaceWillSleepOrScreenIsLockedNotification");
    g_pCast->CallBack("workspaceWillSleepOrScreenIsLockedNotification:",true,0,"");
}

- (void)videoCacheFrameNumberNotification:(NSNotification *)notif{
    NSLog(@"videoCacheFrameNumberNotification:%@",notif);
    NSNumber *cacheFrameNumber = [notif object];
    NSInteger cacheFrameCount = [cacheFrameNumber integerValue];
    NSString *cacheFrame= [NSString stringWithFormat:@"%zd",cacheFrameCount];
    std::string cacheFrameCString = [cacheFrame UTF8String];
    g_pCast->CallBack("kHPOfficeCastVideoCacheFrameNumberNotification",true,0,cacheFrameCString);
}

/// 投屏过程中异常断开
- (void)officeCastDisconnect{
    NSLog(@"officeCastDisconnect");
    g_pCast->CallBack("officeCastDisconnect",true,0,"");
}
/// 投屏被其它设备抢占
- (void)officeCastOccupy{
    NSLog(@"officeCastOccupy");
    g_pCast->CallBack("officeCastOccupy",true,0,"");
}
/// 投屏在被接收端主动关闭
- (void)officeCastReceivedUserStop{
    NSLog(@"officeCastReceivedUserStop");
    g_pCast->CallBack("officeCastReceivedUserStop",true,0,"");
}

@end

SimpleAsyncWorker::SimpleAsyncWorker(Napi::Function& callback)
    : AsyncWorker(callback){};

void SimpleAsyncWorker::SetTypeParam(std::string type,bool success,int errType,std::string param){
    m_sType = type;
    m_sSuccess = success;
    m_sErrType = errType;
    m_sParam = param;
}

void SimpleAsyncWorker::Execute() {
};

void SimpleAsyncWorker::OnOK() {
    Callback().Call({Napi::String::New(Env(), m_sType), Napi::Boolean::New(Env(), m_sSuccess),Napi::Number::New(Env(), m_sErrType),Napi::String::New(Env(), m_sParam)});
};

Napi::FunctionReference CHPCastNodeBridge::constructor;

Napi::Object CHPCastNodeBridge::Init(Napi::Env env, Napi::Object exports) {
    Napi::HandleScope scope(env);

    Napi::Function func =
        DefineClass(env,
            "CHPCastNodeBridge",
            {
            InstanceMethod("Open", &CHPCastNodeBridge::Open),
            InstanceMethod("Close", &CHPCastNodeBridge::Close),
            InstanceMethod("Start", &CHPCastNodeBridge::Start),
            InstanceMethod("Stop", &CHPCastNodeBridge::Stop),
            InstanceMethod("GetIsSupportCastSystemSound", &CHPCastNodeBridge::GetIsSupportCastSystemSound),
            InstanceMethod("InstallAudioDriver", &CHPCastNodeBridge::InstallAudioDriver),
            InstanceMethod("UninstallAudioDriver", &CHPCastNodeBridge::UninstallAudioDriver),
            InstanceMethod("GetProperty", &CHPCastNodeBridge::GetProperty),
            InstanceMethod("SetProperty", &CHPCastNodeBridge::SetProperty),
            InstanceMethod("SystemAuthorize", &CHPCastNodeBridge::SystemAuthorize),
            InstanceMethod("SetCallback", &CHPCastNodeBridge::SetCallback)
            }
        );
    constructor = Napi::Persistent(func);
    constructor.SuppressDestruct();

    exports.Set("CHPCastNodeBridge", func);
    return exports;
}

CHPCastNodeBridge::CHPCastNodeBridge(const Napi::CallbackInfo& info):
    Napi::ObjectWrap<CHPCastNodeBridge>(info),
    m_usServerPort(0)
{
    g_pCast = this;
}

CHPCastNodeBridge::~CHPCastNodeBridge()
{
    if (0 != DeInitCast())
    {
        printf("deinit cast fail\r\n");
    }
}

      //输入参数分别为：appkey(乐播提供的key)/userid（用户id）/userid（用户id）/pinserver（pin码服务器）/pinserverport（pin码服务器端口）/https开关（服务器是否https）/日志开关
Napi::Value CHPCastNodeBridge::Open(const Napi::CallbackInfo& info)
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    Napi::Env env = info.Env();
    int length = info.Length();

    if (length < 7 ||
     !info[0].IsString() ||
     !info[1].IsString() ||
     !info[2].IsString() ||
     !info[3].IsString() ||
     !info[4].IsNumber() ||
     !info[5].IsBoolean() ||
     !info[6].IsBoolean()) {
     Napi::TypeError::New(env, "Open parame error").ThrowAsJavaScriptException();
     return Napi::Number::New(env, -1);
    }

    m_sAppID = std::string(info[0].As<Napi::String>());
    m_sUserID = std::string(info[1].As<Napi::String>());
    m_sUserDepartment = std::string(info[2].As<Napi::String>());
    m_sServerIp = std::string(info[3].As<Napi::String>());
    m_usServerPort = info[4].As<Napi::Number>().Int32Value();
    m_bServerHttps = info[5].As<Napi::Boolean>().Value();
    m_bLogEnable = info[6].As<Napi::Boolean>().Value();

    // Napi::Function cb = info[6].As<Napi::Function>();
    // m_pReport = new CStatusReport(cb, 10, 0, 0);// cbª· ß–ß
    
    if (0 != InitCast())
    {
        printf("init cast fail");
        return Napi::Number::New(env, -1);
    }

    printf("open succ\r\n");
    return Napi::Number::New(env, 0);
}

 Napi::Value CHPCastNodeBridge::Close(const Napi::CallbackInfo& info)
 {
     printf("close\r\n");
     Napi::Env env = info.Env();
     if (0 != DeInitCast())
     {
         printf("deinit cast fail");
         return Napi::Number::New(env, -1);
     }

     return Napi::Number::New(env, 0);
 }

 Napi::Value CHPCastNodeBridge::Start(const Napi::CallbackInfo& info)
 {
     NSLog(@"%s code line:%d",__func__,__LINE__);
     Napi::Env env = info.Env();
     int length = info.Length();

     if (length < 1 ||
         !info[0].IsString()) {
         Napi::TypeError::New(env, "args error").ThrowAsJavaScriptException();
     }

     m_sPincode = std::string(info[0].As<Napi::String>());
     if (0 != StartCast(m_sPincode))
     {
         printf("start cast fail");
         return Napi::Number::New(env, -1);

     }
     printf("start succ\r\n");
     return Napi::Number::New(env, 0);
 }

 Napi::Value CHPCastNodeBridge::Stop(const Napi::CallbackInfo& info)
 {
     NSLog(@"%s code line:%d",__func__,__LINE__);
     Napi::Env env = info.Env();
     if (0 != StopCast())
     {
         printf("stop cast fail");
         return Napi::Number::New(env, -1);
     }

     printf("stop succ\r\n");
     return Napi::Number::New(env, 0);
 }

Napi::Value CHPCastNodeBridge::GetIsSupportCastSystemSound(const Napi::CallbackInfo& info)
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if ([[HPOfficeCast sharedOfficeCast] isSupportCastSystemSound]) {
        return Napi::Number::New(info.Env(), 1);
    }else {
        return Napi::Number::New(info.Env(), 0);
    }
    return Napi::Number::New(info.Env(), -1);
}

Napi::Value CHPCastNodeBridge::InstallAudioDriver(const Napi::CallbackInfo& info)
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if ([[HPOfficeCast sharedOfficeCast] installAudioDriver]) {
        return Napi::Number::New(info.Env(), 0);
    }
    return Napi::Number::New(info.Env(), -1);
}

Napi::Value CHPCastNodeBridge::UninstallAudioDriver(const Napi::CallbackInfo& info)
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if ([[HPOfficeCast sharedOfficeCast] uninstallAudioDriver]) {
       return Napi::Number::New(info.Env(), 0);
    }
    return Napi::Number::New(info.Env(), -1);
}

Napi::Value CHPCastNodeBridge::GetProperty(const Napi::CallbackInfo& info)
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if (!info[0].IsString()){
        return Napi::Number::New(info.Env(), -1);
    }
    std::string property = std::string(info[0].As<Napi::String>());
    printf("GetProperty [%s]\r\n", property.c_str());

    NSString *propertyStr= [NSString stringWithCString:property.c_str() encoding:NSUTF8StringEncoding];

    id value = [[HPOfficeCast sharedOfficeCast] valueForKeyPath:propertyStr];
    if ([value isKindOfClass:[NSNumber class]]) {
       int valueInter = [value intValue];
       NSLog(@"GetProperty propertyStr:%@ valueInter:%d",propertyStr,valueInter);

       return Napi::Number::New(info.Env(), valueInter);
    } else if ([value isKindOfClass:[NSString class]]){
        NSString *valueString = value;
        std::string valueCString = [valueString UTF8String];
        NSLog(@"GetProperty propertyStr:%@ valueString:%@",propertyStr,valueString);
        return Napi::String::New(info.Env(), valueCString);
    } else{
        
    }
    return Napi::Number::New(info.Env(), -1);
}

Napi::Value CHPCastNodeBridge::SetProperty(const Napi::CallbackInfo& info)
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if (!info[0].IsString()){
        return Napi::Number::New(info.Env(), -1);
    }
    std::string property = std::string(info[0].As<Napi::String>());
    printf("SetProperty [%s]\r\n", property.c_str());

    int length = info.Length();
    
    if (length != 2){
        return Napi::Number::New(info.Env(), -1);
    }

    
    NSString *propertyStr= [NSString stringWithCString:property.c_str() encoding:NSUTF8StringEncoding];

    if (info[1].IsString()) {
        std::string valueCString = std::string(info[1].As<Napi::String>());
        NSString *valueStr= [NSString stringWithCString:valueCString.c_str() encoding:NSUTF8StringEncoding];
        [[HPOfficeCast sharedOfficeCast] setValue:valueStr forKeyPath:propertyStr];
        NSLog(@"SetProperty propertyStr:%@ valueStr:%@",propertyStr,valueStr);
    } else if (info[1].IsNumber()){
        int valueInter = info[1].As<Napi::Number>().Int32Value();
        NSNumber *valueNumber = [NSNumber numberWithInt:valueInter];
        [[HPOfficeCast sharedOfficeCast] setValue:valueNumber forKeyPath:propertyStr];
        NSLog(@"SetProperty propertyStr:%@ valueNumber:%@",propertyStr,valueNumber);
    } else if (info[1].IsBoolean()){
        bool valuebool = info[1].As<Napi::Boolean>().Value();
        NSNumber *valueNumber = [NSNumber numberWithBool:valuebool];
        [[HPOfficeCast sharedOfficeCast] setValue:valueNumber forKeyPath:propertyStr];
        NSLog(@"SetProperty propertyStr:%@ valueNumber:%@",propertyStr,valueNumber);
    }else {
        return Napi::Number::New(info.Env(), -1);

    }
    return Napi::Number::New(info.Env(), 0);
}


Napi::Value CHPCastNodeBridge::SystemAuthorize(const Napi::CallbackInfo& info){
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if (!info[0].IsString()){
        return Napi::Number::New(info.Env(), -1);
    }
    std::string selector = std::string(info[0].As<Napi::String>());
    NSString *selectorStr= [NSString stringWithCString:selector.c_str() encoding:NSUTF8StringEncoding];
    
    if (![HPSystemAuthorize respondsToSelector:NSSelectorFromString(selectorStr)]) {
        return Napi::Number::New(info.Env(), -1);
    }
//    BOOL isbool = NO;
    id idbool = [HPSystemAuthorize performSelector:NSSelectorFromString(selectorStr)];
    if (idbool){
       return Napi::Number::New(info.Env(), 1);
    }
    return Napi::Number::New(info.Env(), 0);
}


Napi::Value CHPCastNodeBridge::SetCallback(const Napi::CallbackInfo& info)
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if (!info[0].IsFunction()){
           return Napi::Number::New(info.Env(), -1);
    }
    
    Napi::Function callbackFunction = info[0].As<Napi::Function>();
    asyncWorker = new SimpleAsyncWorker(callbackFunction);
    asyncWorker->SuppressDestruct();
    
    return Napi::Number::New(info.Env(), 0);
}

static id officeCastDelegate;

int CHPCastNodeBridge::InitCast()
{
    NSLog(@"isLogEnable :%d",m_bLogEnable);
    if (m_bLogEnable) {
        [HPOfficeCast sharedOfficeCast].isLogEnable = YES;
    } else {
        [HPOfficeCast sharedOfficeCast].isLogEnable = NO;
    }

    NSLog(@"%s code line:%d",__func__,__LINE__);
    NSDictionary *infoDictionary = [NSBundle mainBundle].infoDictionary;
    NSLog(@"MainBundle infoDictionary :%@",infoDictionary);
    
    NSString *appkey= [NSString stringWithCString:m_sAppID.c_str() encoding:NSUTF8StringEncoding];
    NSLog(@"appkey :%@",appkey);
    [[HPOfficeCast sharedOfficeCast] appkeyVerify:appkey];
    
    if (officeCastDelegate == nil) {
        officeCastDelegate = [[HPOfficeCastDelegate alloc] init];
    }
    [HPOfficeCast sharedOfficeCast].delegate = officeCastDelegate;
    
    NSString *serviceIp= [NSString stringWithCString:m_sServerIp.c_str() encoding:NSUTF8StringEncoding];
    NSString *userId= [NSString stringWithCString:m_sUserID.c_str() encoding:NSUTF8StringEncoding];
    NSString *department= [NSString stringWithCString:m_sUserDepartment.c_str() encoding:NSUTF8StringEncoding];

    NSLog(@"serviceIp:%@ m_usServerPort:%d userId:%@ department:%@ m_bServerHttps:%d",serviceIp,m_usServerPort,userId,department,m_bServerHttps);

    [[HPOfficeCast sharedOfficeCast] setServiceIp:serviceIp servicePort:m_usServerPort userId:userId department:department isHttpsRequest:(BOOL)m_bServerHttps];
    
    NSLog(@"HPOfficeCast sharedOfficeCast InitCast end");

    return 0;
}

int CHPCastNodeBridge::DeInitCast()
{
    NSLog(@"%s code line:%d",__func__,__LINE__);
    StopCast();
    return 0;
}

 int CHPCastNodeBridge::StartCast(std::string sPinCode)
 {
    printf("start cast[%s]\r\n", sPinCode.c_str());
    NSLog(@"%s code line:%d",__func__,__LINE__);
    NSString *pinCode= [NSString stringWithCString:sPinCode.c_str() encoding:NSUTF8StringEncoding];
    [[HPOfficeCast sharedOfficeCast] startHappyCastWithCastCode:pinCode completeBlock:^(BOOL succeed, NSError *error) {
        if (succeed) {
            g_pCast->CallBack("startHappyCastWithCastCode:completeBlock:",true,0,"");
        } else {
            std::string param;
            if (error.code == HPCastDevicesErrorCodeDnsPublishSucceedWaitSystemCast) {
                // 对系统投屏，发布服务成功做特殊处理，需把发布的服务名称上报给JS层做UI展示
                NSString *serviceName = [NSString stringWithFormat:@"%@",[HPOfficeCast sharedOfficeCast].serviceModel.name];
                std::string serviceNameCString = [serviceName UTF8String];
                param = serviceNameCString;
            }else{
                NSString *errorInfo = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"errorInfo"]];
                std::string errorInfoCString = [errorInfo UTF8String];
                param = errorInfoCString;
            }
            g_pCast->CallBack("startHappyCastWithCastCode:completeBlock:",false,(int)error.code,param);
        }
        NSLog(@"startHappyCastWithCastCode:CompleteBlock succeed :%d error:%@",succeed,error);
    }];

    return 0;
 }

 int CHPCastNodeBridge::StopCast()
 {
    NSLog(@"%s code line:%d",__func__,__LINE__);
    [[HPOfficeCast sharedOfficeCast] stopHappyCastCompleteBlock:^(BOOL succeed, NSError *error) {
        if (succeed) {
            g_pCast->CallBack("stopHappyCastCompleteBlock:",true,0,"");
        } else {
            NSString *errorInfo = [NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"errorInfo"]];
            std::string errorInfoCString = [errorInfo UTF8String];
            g_pCast->CallBack("stopHappyCastCompleteBlock:",false,(int)error.code,errorInfoCString);
        }
        NSLog(@"stopHappyCastCompleteBlock succeed :%d error:%@",succeed,error);
    }];

    return 0;
 }

int QueueNumber = 0;

int CHPCastNodeBridge::CallBack(std::string type,bool success,int errType,std::string param){
    
    NSLog(@"%s code line:%d",__func__,__LINE__);
    if (asyncWorker != nullptr) {
        NSLog(@"asyncWorker != nullptr");
        if (QueueNumber == 0) {
            QueueNumber++;
            asyncWorker->SetTypeParam(type,success,errType,param);
            asyncWorker->Queue();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                QueueNumber--;
            });
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2*QueueNumber++ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                asyncWorker->SetTypeParam(type,success,errType,param);
                asyncWorker->Queue();
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    QueueNumber--;
                });
            });
        }
    }else{
        NSLog(@"asyncWorker == nullptr");
    }
    return 0;
}

