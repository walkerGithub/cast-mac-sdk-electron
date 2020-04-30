//
//  HPOfficeBase.h
//  HPOfficeCastSDKMac
//
//  Created by wangzhijun on 2020/4/7.
//  Copyright © 2020 wzj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct{//媒体音量
    NSInteger maxVolume;        // 最大音量
    NSInteger currentVolume;    // 现在音量   0-30
}HPCastVolume;

typedef enum { //播放状态
    HPCastStateUnknown = 0, // 投屏未知
    HPCastStatePause,     // 投屏暂停
    HPCastStatePlaying,     // 投屏正常播放
}HPCastState;

typedef enum : NSUInteger{ // 支持可投屏码的类型
    HPCastSupportCastCodeTypeServer  = 0, // 支持服务器投屏码投屏
    HPCastSupportCastCodeTypeLocalNineBit, // 支持本地9位投屏码投屏
    HPCastSupportCastCodeTypeLocalSixBit, // 支持本地6位投屏码投屏,访客模式使用
    HPCastSupportCastCodeTypeDefault = HPCastSupportCastCodeTypeServer, // 默认同时支持服务器投屏码和本地投屏码投屏
}HPCastSupportCastCodeType;


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

/* Log等级类型 */
typedef NS_ENUM(NSUInteger, HPCastLogLevelType) {
    HPCastLogLevelTypeUndefine = 0, //未定义
    HPCastLogLevelTypeDebug,        //调试
    HPCastLogLevelTypeInfo,         //提示
    HPCastLogLevelTypeWarnning,     //警告
    HPCastLogLevelTypeError,        //错误
    HPCastLogLevelTypeFatal,        //致命
};

/* Log输出方式 */
typedef  NS_ENUM(NSUInteger, HPCastLogOutputStyle) {
    HPCastLogOutputStyleConsole = 0,//控制台输出
    HPCastLogOutputStyleDelegateProtocol , //代理协议输出
    HPCastLogOutputStyleFileSave, //log文件保存，保存路径在[NSHomeDirectory()]/Library/CastLB/[CFBundleIdentifier]/Log/，[]需要动态获取
};

@interface HPOfficeBase : NSObject

@end

NS_ASSUME_NONNULL_END
