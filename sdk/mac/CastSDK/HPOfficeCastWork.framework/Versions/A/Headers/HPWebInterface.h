//
//  HPWebInterface.h
//  HPOfficeCastSDKMac
//
//  Created by 王志军 on 9/6/19.
//  Copyright © 2019 王志军. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HPServiceModel;

NS_ASSUME_NONNULL_BEGIN

@interface HPWebInterface : NSObject

/**
 请求接受端服务模型
 
 @param code 投屏码
 @param block 结果block status:200:成功 221:投屏码错误 222:f数据不完整 400和其它:请求失败
 */
+ (void)requestCastReceiveInfoWithCastCode:(NSString *)code completeBlock:(void (^)(NSInteger status,HPServiceModel *serviceModel, NSError *error))block;

/**
 匹配接收端设备
 
 @param keyword 关键字模糊搜索（会议室名称或投屏码）
 @param pageIndex 页索引,从1开始
 @param pageNumber 每页的数量
 @param block 匹配结果 totalCount：总个数
 */
+ (void)matchDeviceServiceModelWith:(NSString *)keyword page:(NSInteger)pageIndex pageNumber:(NSInteger)pageNumber completeBlock:(void (^)(BOOL succeed,NSInteger totalCount,NSArray *serviceModelAry,NSError * error))block;

/**
 管理员授权验证
 
 @param userName 用户名
 @param password 密码
 @param block 授权结果获得token
 */
+ (void)adminAuthWithName:(NSString *)userName password:(NSString *)password completeHandler:(void (^)(BOOL succeed,NSString *token,NSError * error))block;

/**
 设置设备为访客模式
 
 @param serviceModel 设备服务模型
 @param token 管理员token
 @param block 设置结果
 */
+ (void)setGuestModeWithServiceModel:(HPServiceModel *)serviceModel token:(NSString *)token completeHandler:(void (^)(BOOL succeed,NSError * error))block;

/**
 设置设备为正常模式
 
 @param code 访客模式投屏码
 @param block 设置结果
 */
+ (void)setNormalModeWithCastCode:(NSString *)code completeHandler:(void (^)(BOOL succeed,NSError * error))block;

/**
设置设备为访客模式 方式二:通知盒子切换

@param serviceModel 设备服务模型
@param token 管理员token
@param block 设置结果
*/
+ (void)setGuestModeWithServiceModelWayTwo:(HPServiceModel *)serviceModel token:(NSString *)token completeHandler:(void (^)(BOOL succeed,NSError * error))block;


@end

NS_ASSUME_NONNULL_END
