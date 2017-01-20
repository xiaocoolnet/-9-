//
//  VideoPlay.h
//  LCOPenSDKDemo
//
//  Created by bao_zhiyong on 16/10/11.
//  Copyright (c) 2016年 bao_zhiyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LCOpenSDK_PlayWindow.h"
#import "LCOpenSDK_EventListener.h"

@interface VideoPlay:UIView <LCOpenSDK_EventListener>

- (id) initWithRect:(CGRect)rect Index:(int)index;
- (void) uninit;
- (UIView *)getWindowView;
- (void) setWindowFrame:(CGRect)rect;
- (void) setListener:(id<LCOpenSDK_EventListener>) listener;
- (void) setSurfaceBGColor:(UIColor*)normalColor;
- (void) snapShot:(NSString*)path;
- (BOOL) startRecord:(NSString*)path;
- (void) stopRecord;
- (void) playRtspReal:(NSString*)accessTok devID:(NSString *)deviceID channel:(NSInteger)chn definition:(NSInteger)defiMode;
- (void) stopRtspReal;
- (void) playRtspPlayback:(NSString*)accessTok devID:(NSString*)deviceID filename:(NSString*)fileName;
- (NSInteger) playRtspPlaybackByUtcTime:(NSString*)accessTok devID:(NSString*)deviceID channel:(NSInteger)chn begin:(long)beginTime end:(long)endTime;
- (void) stopRtspPlayback;
- (void) playCloud:(NSString*)accessTok devID:(NSString *)deviceID recordID:(int64_t)recordID;
- (void) stopCloud;
- (void) stopAudio;
- (void) playAudio;

- (NSInteger) seek:(long)timeInfo;
- (NSInteger) pause;
- (NSInteger) resume;

- (void) doScale:(CGFloat)scale;
- (void) doTranslateX:(CGFloat)x Y:(CGFloat)y;

@end
