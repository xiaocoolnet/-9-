//
//  LCOpenSDK_PlayWindow.h
//  LCOpenSDK
//
//  Created by chenjian on 16/5/16.
//  Copyright (c) 2016年 lechange. All rights reserved.
//

#ifndef LCOpenSDK_LCOpenSDK_PlayWindow_h
#define LCOpenSDK_LCOpenSDK_PlayWindow_h
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LCOpenSDK_EventListener.h"

@interface LCOpenSDK_PlayWindow: NSObject<LCOpenSDK_EventListener>
/**
 *  初始化播放窗口
 *
 *  @param frame 窗口
 *  @param index 播放窗口索引
 *
 *  @return LCOpenSDK_PlayWindow指针
 */
- (id) initPlayWindow:(CGRect) frame Index:(NSInteger) index;
/**
 *  反初始化播放窗口
 */
- (void) uninitPlayWindow;
/**
 *  设置播放窗口
 *
 *  @param rect 播放窗口
 */
- (void) setWindowFrame:(CGRect)rect;
/**
 *  设置播放窗口背景色
 *
 *  @param normalColor 背景色
 */
- (void) setSurfaceBGColor:(UIColor*)normalColor;
/**
 *  获取播放窗口
 *
 *  @return 播放窗口指针
 */
- (UIView*)getWindowView;
/**
 *  设置播放窗口监听对象
 *
 *  @param lis 监听对象指针
 */
- (void) setWindowListener:(id<LCOpenSDK_EventListener>) lis;
/**
 *  获取播放窗口监听对象指针
 *
 *  @return 监听对象指针
 */
- (id<LCOpenSDK_EventListener>) getWindowListener;
/**
 *  设置播放窗口手势操作事件是否被上层窗口捕获
 *
 *  @param flag 布尔值
 */
- (void) openTouchListener:(BOOL)flag;
/**
 *  播放实时视频
 *
 *  @param accessTok 管理员token/用户token
 *  @param deviceID  设备ID
 *  @param chn       通道ID
 *  @param defiMode  流媒体HD/SD模式
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) playRtspReal:(NSString*)accessTok devID:(NSString*)deviceID channel:(NSInteger)chn definition:(NSInteger)defiMode;
/**
 *  停止实时视频播放
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) stopRtspReal;
/**
 *  按文件名回放设备本地录像
 *
 *  @param accessTok 管理员token／用户token
 *  @param deviceID  设备ID
 *  @param fileName  设备本地录像文件名
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) playRtspPlaybackByFileName:(NSString*)accessTok devID:(NSString*)deviceID fileName:(NSString*)fileName;
/**
 *  按开始/结束时间回放设备本地录像
 *
 *  @param accessTok 管理员token/用户token
 *  @param deviceID  设备ID
 *  @param chn       通道ID
 *  @param beginTime 本地录像开始播放时间
 *  @param endTime   本地录像结束播放时间
 *
 *  @return 0, 接口调用成功
 *        －1, 接口调用失败
 */
- (NSInteger) playRtspPlaybackByUtcTime:(NSString*)accessTok devID:(NSString*)deviceID channel:(NSInteger)chn begin:(long)beginTime end:(long)endTime;
/**
 *  停止播放设备本地录像文件
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) stopRtspPlayback;
/**
 *  播放云录像(默认超时时长)
 *
 *  @param accessTok 管理员token/用户token
 *  @param deviceID  设备ID
 *  @param recordID  录像ID
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) playCloud:(NSString*)accessTok devID:(NSString*)deviceID recordID:(int64_t)recordID;
/**
 *  播放云录像(可设置接口调用超时时长)
 *
 *  @param accessTok 管理员token/用户token
 *  @param deviceID  设备ID
 *  @param recordID  录像ID
 *  @param timeOut   超时时长
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) playCloud:(NSString*)accessTok devID:(NSString*)deviceID recordID:(int64_t)recordID timeOut:(int)timeOut;
/**
 *  停止云录像播放
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) stopCloud;
/**
 *  播放音频
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) playAudio;
/**
 *  停止音频
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) stopAudio;
/**
 *  录像拖动
 *
 *  @param timeInfo 相对开始时间偏移的秒数
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) seek:(NSInteger)timeInfo;
/**
 *  暂停播放
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) pause;
/**
 *  恢复播放
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) resume;
/**
 *  截图
 *
 *  @param filePath 图片保存路径
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) snapShot:(NSString *)filePath;
/**
 *  开始录制视频
 *
 *  @param filePath    录制视频保存路径
 *  @param nRecordType 录制视频格式: 0, dav
 *                                 1, mp4
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) startRecord:(NSString *)filePath recordType: (NSInteger)nRecordType;
/**
 *  停止录制视频
 *
 *  @return 0, 接口调用成功
 *         -1, 接口调用失败
 */
- (NSInteger) stopRecord;
/**
 *  EPTZ缩放操作
 *
 *  @param scale 缩放比例
 */
- (void) doScale:(CGFloat)scale;
/**
 *  获取EPTZ缩放比例
 *
 *  @return －1, 失败
 *         其他, 成功
 */
- (CGFloat) getScale;
/**
 *  EPTZ滑动操作
 *
 *  @param x 播放窗口X坐标值
 *  @param y 播放窗口Y坐标值
 */
- (void) doTranslateX:(CGFloat)x Y:(CGFloat)y;
@end
#endif
