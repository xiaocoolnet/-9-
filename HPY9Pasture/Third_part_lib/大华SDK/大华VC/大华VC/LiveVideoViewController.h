//
//  LiveVideoViewController.h
//  LCOpenSDKDemo
//
//  Created by mac318340418 on 16/7/13.
//  Copyright © 2016年 lechange. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "VideoPlay.h"
#import "LCOpenSDK_EventListener.h"
#import "DeviceViewController.h"
#import "LCOpenSDK_TalkerListener.h"
#import "LCOpenSDK_AudioTalk.h"

#define RTSP_Result_String(enum) [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"99",@"100"] objectAtIndex:enum]

typedef NS_ENUM(NSInteger, PlayerResultCode)
{
    STATE_PACKET_FRAME_ERROR = 0,    // 组帧失败,错误状态
    STATE_RTSP_TEARDOWN_ERROR,       // 内部要求关闭，如连接断开等，错误状态
    STATE_RTSP_DESCRIBE_READY,       // 会话已经收到Describe响应，连接建立中
    STATE_RTSP_AUTHORIZATION_FAIL,   // RTSP鉴权失败，错误状态
    STATE_RTSP_PLAY_READY,           // 收到PLAY响应，连接成功
    STATE_RTSP_FILE_PLAY_OVER,       // 录像文件回放正常结束
    STATE_RTSP_PLAY_PAUSE,           // 收到PAUSE响应
    STATE_RTSP_SERVICE_UNAVAILABEL,  // 基于503错误吗的连接最大数错误，错误状态
    STATE_RTSP_USER_INFO_BASE_STAT   // 用户信息起始码，服务端上层传过来的信息码会在该起始码基础上累加，错误状态
};

typedef NS_ENUM(NSInteger, ProgressIndType)
{
    VIDEO_PROGRESS_IND = 0,
    TALK_PROGRESS_IND = 1
};

@interface LiveVideoViewController: MyViewController<LCOpenSDK_EventListener>
{
    VideoPlay         *m_play;
    LCOpenSDK_AudioTalk  *m_talker;
    UIImageView       *m_screenImg;
    UIButton          *m_replayBtn;
    UIView            *livePlayBarView;
    UIButton          *m_HDBtn;
    UIButton          *m_PTZBtn;
    UIButton          *m_fullScreenBtn;
    UIButton          *m_soundBtn;
    UIButton          *m_snapBtn;
    UIButton          *m_talkBtn;
    UIButton          *m_recordBtn;
    UILabel           *m_tipLab;
    
    NSString          *m_accessToken;
    NSString          *m_strDevSelected;
    NSInteger         m_devChnSelected;
    UIImage           *m_imgPicSelected;
    NSString          *m_devAbilitySelected;
    
    UIActivityIndicatorView *m_videoProgressInd;
    UIActivityIndicatorView *m_talkProgressInd;
}

- (void) setInfo:(NSString*)token Dev:(NSString*)deviceId Chn:(NSInteger)chn Img:(UIImage*)img Abl:(NSString *)abl;
- (void) onPlayerResult:(NSString *)code Type:(NSInteger)type Index:(NSInteger)index;
- (void) onPlayBegan:(NSInteger)index;
- (void) onReceiveData:(NSInteger)len Index:(NSInteger)index;
- (void) onTalkResult:(NSString *) error TYPE:(NSInteger) type;
- (void) onControlClick:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void) onWindowDBClick:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void) onWindowLongPressBegin:(Direction)dir dx:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void) onWindowLongPressEnd:(NSInteger)index;
- (bool) onSlipBegin:(Direction)dir dx:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;
- (void) onSlipping:(Direction)dir preX:(CGFloat)preX preY:(CGFloat)preY dx:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void) onSlipEnd:(Direction)dir dx:(CGFloat)currentX dy:(CGFloat)currentY Index:(NSInteger)index;
- (void) onZooming:(CGFloat)scale Index:(NSInteger)index;
- (void) onZoomEnd:(ZoomType)zoom Index:(NSInteger)index;

- (void) onActive:(id)sender;
- (void) onResignActive:(id)sender;

@end
