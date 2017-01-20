//
//  LCOpenSDK_Download.h
//  LCOpenSDK
//
//  Created by baozhiyong on 16/9/5.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCOpenSDK/LCOpenSDK_DownloadListener.h"

@interface LCOpenSDK_Download : NSObject
/**
 *  获取云录像下载组件单例
 *
 *  @return LCOpenSDK_Download单例指针
 */
+ (LCOpenSDK_Download *) shareMyInstance;
/**
 *  设置监听对象
 *
 *  @param listener 监听对象指针
 */
- (void) setListener:(id<LCOpenSDK_DownloadListener>)listener;
/**
 *  获取监听对象指针
 *
 *  @return 监听对象指针
 */
- (id<LCOpenSDK_DownloadListener>) getListener;
/**
 *  开始下载云录像
 *
 *  @param index     下载索引值
 *  @param filepath  下载路径
 *  @param accessTok 管理员token/用户token
 *  @param deviceID  设备ID
 *  @param recordID  录像ID
 *  @param timeout   接口调用超时时间
 *
 *  @return   0, 接口调用成功
 *           -1, 接口调用失败
 */
- (NSInteger) startDownload:(NSInteger)index filepath:(NSString *)filepath token:(NSString*)accessTok devID:(NSString*)deviceID recordID:(int64_t)recordID Timeout:(NSInteger)timeout;
/**
 *  停止下载云录像
 *
 *  @param index 下载索引值
 *
 *  @return YES, 接口调用成功
 *          NO,  接口调用失败
 */
- (BOOL) stopDownload:(NSInteger)index;

@end
