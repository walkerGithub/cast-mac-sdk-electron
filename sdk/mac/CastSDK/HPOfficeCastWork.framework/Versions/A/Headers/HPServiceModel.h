//
//  HPServiceModel.h
//  HappyCast
//
//  Created by 王志军 on 16/5/13.
//  Copyright © 2016年 王志军. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    HPCastDeviceStateShut = 0,  //关机状态
    HPCastDeviceStateFree,      //空闲状态
    HPCastDeviceStateInUse,     //投屏使用中
}HPCastDeviceState;//设备状态

typedef enum : NSInteger {
    HPCastDeviceStateReasonNull = -1,             //状态原因为空
    HPCastDeviceStateReasonCastSucceed = 200,      //投屏成功
    HPCastDeviceStateReasonConnectFailure = 101,       //连接失败
    HPCastDeviceStateReasonCastFailureNotAllow = 102,  //投屏不允许抢占
    HPCastDeviceStateReasonNormalDisconnect = 110,     //正常断开
    HPCastDeviceStateReasonFromDeviceDisconnect = 111, //从接收端设备主动断开
    HPCastDeviceStateReasonDisconnectBeOccupy = 112,   //被抢占断开
    HPCastDeviceStateReasonFromServerBackgroundDisconnect = 113,   //从服务器后台断开
    HPCastDeviceStateReasonRemoteDeviceNoExist = 114,   //远端设备不存在
    HPCastDeviceStateReasonDisconnectUnknown = 199,    //未知断开
}HPCastDeviceStateReason;//设备状态原因

@interface HPServiceModel : NSObject

/**
 *  service
 */
@property (nonatomic,strong)NSNetService *service;
// 服务名称
@property (nonatomic,copy)NSString *name;

/**
 *  ip地址
 */
@property (nonatomic,copy)NSString *ipAddress;

/**
 *  端口
 */
@property (nonatomic,assign)NSInteger port;

/**
 *  remote端口
 */
@property (nonatomic,assign)NSInteger remotePort;

/**
 *  leboPlayPort
 */
@property (nonatomic,assign)NSInteger leboPlayPort;

/**
 *  lelinkport端口
 */
@property (nonatomic,assign)NSInteger lelinkPort;


/**
 *  raop端口
 */
@property (nonatomic,assign)NSInteger raopPort;


/**
 *  mirrorPort端口
 */
@property (nonatomic,assign)NSInteger mirrorPort;


/**
 *  agentPort端口
 */
@property (nonatomic,assign)NSInteger agentPort;

/**
 *  版本号
 */
@property (nonatomic,copy)NSString *version;

/**
 *  功能 功能 1 -->应用安装     2 --> 应用卸载         4 --> 应用打开    8 -->点播推送   16 -->直播推送
 64-->表示弹幕   128-->表示音乐连接推送
 */
@property (nonatomic,assign)NSInteger feature;

/**
 *  通道channel
 */
@property (nonatomic,copy)NSString *channel;

/**
 *  设备mac唯一标示
 */
@property (nonatomic,copy)NSString *deviceMac;


/**
 airplay服务信息
 */
@property (nonatomic,strong)NSMutableDictionary *leboPlayTxt;
/**
 Raop服务信息
 */
@property (nonatomic,strong)NSMutableDictionary *leboRaopTxt;

/**
 * 发布服务的主机名 ，可能是ip或者域名
 */
@property (nonatomic,copy)NSString *hostName;
/// 扩展字段
@property (nonatomic,strong)NSDictionary *extendDic;
/// 投屏码
@property (nonatomic,copy)NSString *codeNumber;
/// 反向事件端口
@property (nonatomic,assign)NSInteger reLelinkPort;
/// 反向触摸端口
@property (nonatomic,assign)NSInteger reTouchPort;
/// 是否选择
@property (nonatomic,assign)BOOL isSelect;
/// 接收端设备名，应与name一致，接收端bug
@property (nonatomic,copy)NSString *deviceName;
/**
 *  使用状态
 */
@property (nonatomic,assign)HPCastDeviceState deviceState;


/**
 *  状态原因
 */
@property (nonatomic,assign)HPCastDeviceStateReason stateReason;

/**
 *  区域名称
 */
@property (nonatomic,copy)NSString *areaName;

/**
 *  城市名称
 */
@property (nonatomic,copy)NSString *cityName;

/**
 *  原数据
 */
@property (nonatomic,strong)NSDictionary *originalDataDic;
/**
 快速构建方法
 
 @param dataContentDic 字典
 @return model对象
 */
+ (HPServiceModel *)getServiceModelWithBasisDataDic:(NSDictionary *)dataContentDic;

@end
