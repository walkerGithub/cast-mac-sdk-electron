//
//  HPSystemAuthorize.h
//  HPOfficeCastSDKMac
//
//  Created by wangzhijun on 2019/11/20.
//  Copyright © 2019 王志军. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HPSystemAuthorize : NSObject

/**
 是否能录制屏幕
 */
+ (BOOL)canRecordScreen;

/**
 打开系统设置录制屏幕授权
*/
+ (BOOL)openSystemSettingRecordScreenAuthorize;

/**
 是否能录制系统声音
*/
+ (BOOL)canRecordAudio;

/**
 打开系统设置录制声音授权
*/
+ (BOOL)openSystemSettingRecordAudioAuthorize;

@end

NS_ASSUME_NONNULL_END
