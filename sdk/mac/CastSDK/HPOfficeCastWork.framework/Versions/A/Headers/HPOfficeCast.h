//
//  HPOfficeCast.h
//  OfficeCastingSDK
//
//  Created by wzj on 2017/4/1.
//  Copyright © 2017年 wzj. All rights reserved.

// SDK 版本号
#define OfficeCastSDKVersion @"2.3.5"

#import <Foundation/Foundation.h>
#import "HPOfficeBase.h"

@class HPServiceModel;

// 投屏缓存帧数量通知，通知间隔约一秒
extern NSString *kHPOfficeCastVideoCacheFrameNumberNotification;

@class HPOfficeCast;
@protocol HPOfficeCastDelegate <NSObject>
@optional
/// 投屏过程中异常断开
- (void)officeCastDisconnect;
/// 投屏被其它设备抢占
- (void)officeCastOccupy;
/// 投屏在被接收端主动关闭
- (void)officeCastReceivedUserStop;
// 准备投屏的近端设备模型，isSupportAddRemote：是否支持添加远端设备
- (void)officeCastPrepareCastReceivingDevice:(HPServiceModel *)serviceModel supportAddRemote:(BOOL)isSupportAddRemote;
// 远程设备投屏成功
- (void)officeCastAddRemoteDeviceCastSuccessful:(HPServiceModel *)serviceModel;
// 远程设备投屏失败
- (void)officeCastAddRemoteDeviceCastFailure:(HPServiceModel *)serviceModel error:(NSError *)error;
// 远程设备主动移除或主动断开成功
- (void)officeCastRemoveRemoteDeviceCastOrNormalDisconnectSuccessful:(HPServiceModel *)serviceModel;
// 远程设备投屏非主动断开
- (void)officeCastRemoteDeviceCastAbnormalDisconnect:(HPServiceModel *)serviceModel error:(NSError *)error;
//日志输出:string  levelType:等级类型
- (void)officeCastLogOutput:(NSString *)string level:(HPCastLogLevelType)levelType;

@end

/// 投屏结果返回
typedef void (^CastCompleteBlock)(BOOL succeed,NSError * error);

@interface HPOfficeCast : NSObject
/// 是否正在投屏中
@property (nonatomic,assign,readonly)BOOL isCasting;
///  投屏代理
@property (nonatomic,weak)id<HPOfficeCastDelegate> delegate;
/// 投屏的屏幕ID 默认主屏幕 castWindowId = 0，投其它应用屏幕Id从getCanCastAllAppWindowInfo获取
@property (nonatomic,assign)NSInteger castWindowId;
/// 支持可投屏码的类型 默认HPCastSupportCastCodeTypeDefault
@property (nonatomic,assign)HPCastSupportCastCodeType supportCastCodeType;
/// 是否启动log输出,默认NO
@property (nonatomic,assign)BOOL isLogEnable;
/// log输出方式
@property (nonatomic,assign)HPCastLogOutputStyle logOutputStyle;
/// 是否打开udp发送视频数据 默认NO
@property (nonatomic,assign)BOOL isOpenUdpSend;
/// 是否抢占投屏 默认NO
@property (nonatomic,assign)BOOL isOccupyCast;
/// 启用系统投屏 默认NO
@property (nonatomic,assign)BOOL enableSystemCast;
// 请求回来的服务模型
@property (nonatomic,strong,readonly)HPServiceModel *serviceModel;

///  获取投屏实例
+ (instancetype)sharedOfficeCast;

///  appKey验证 通过返回YES;
- (BOOL)appkeyVerify:(NSString *)appkey;
///  设置后台服务端地址，用户信息，是否https请求 默认http
- (void)setServiceIp:(NSString *)serviceIpAddress servicePort:(NSInteger)servicePort userId:(NSString *)userId department:(NSString *)department isHttpsRequest:(BOOL)isHttpsRequest;
///  获取可以投屏的app窗口信息
- (NSArray *)getCanCastAllAppWindowInfo;
///  开始投屏
- (void)startHappyCastWithCastCode:(NSString *)code completeBlock:(CastCompleteBlock)completeBlock;
///  搜索服务设备serviceModelAry<HPServiceModel>，每次返回总设备数
- (void)searchServiceCompleteBlock:(void (^)(NSArray *serviceModelAry))updateBlock;
///  停止搜索服务设备
- (void)stopSearchService;
/// 开始镜像通过搜索到的设备模型
- (void)startHappyCastWithServiceModel:(HPServiceModel *)serviceModel completeBlock:(CastCompleteBlock)completeBlock;
///  停止投屏
- (void)stopHappyCastCompleteBlock:(CastCompleteBlock)completeBlock;
///  是否支持投放系统声音
- (BOOL)isSupportCastSystemSound;
///  安装音频插件
- (BOOL)installAudioDriver;
///  卸载音频插件
- (BOOL)uninstallAudioDriver;

/**
 添加投屏远程设备
 
 @param serviceModel 会议室服务模型,serviceModel从[HPWebInterface matchDeviceServiceModelWith...]获取
 @param addError 添加错误
 */
- (void)addCastRemoteDevice:(HPServiceModel *)serviceModel error:(NSError **)addError;

/**
 移除投屏远程设备
 
 @param serviceModel 会议室服务模型
 @param removeError 移除错误
 */
- (void)removeCastRemoteDevice:(HPServiceModel *)serviceModel error:(NSError **)removeError;

/**
 移除所有投屏远程设备
 */
- (void)removeAllCastRemoteDevice;

/**
 添加的投屏远程设备
 */
@property (nonatomic,strong,readonly)NSMutableArray <HPServiceModel *>*allAddRemoteDeviceAry;
/**
 所有投屏中的远程设备
 */
@property (nonatomic,strong,readonly)NSMutableArray <HPServiceModel *>*allCastingRemoteDeviceAry;

/**
 暂停投屏
 */
- (void)suspendCast;

/**
 继续投屏
 */
- (void)continueCast;

- (void)setValue:(id)value forOption:(NSString *)hpOption;

@end

