//
//  LCOpenSDK_AudioTalk.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/16.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_AudioTalk_h
#define LCOpenSDK_LCOpenSDK_AudioTalk_h
#import <Foundation/Foundation.h>
@interface LCOpenSDK_AudioTalk: NSObject
/**
 *  设置监听对象
 *
 *  @param lis 监听对象指针
 */
- (void) setListener:(id) lis;
/**
 *  获取监听对象指针
 *
 *  @return 监听对象指针
 */
- (id) getListener;
 /**
 *  播放语音对讲
 *
 *  @param accessTok 管理员token／用户token
 *  @param deviceID  设备ID
 *
 *  @return 接口调用返回值    0, 成功
 *                        －1, 失败
 */
- (NSInteger) playTalk:(NSString*)accessTok devID:(NSString*)deviceID;
/**
 *  停止语音对讲
 *
 *  @return 接口调用返回值    0, 成功
 *                         -1, 失败
 */
- (NSInteger) stopTalk;
@end
#endif
