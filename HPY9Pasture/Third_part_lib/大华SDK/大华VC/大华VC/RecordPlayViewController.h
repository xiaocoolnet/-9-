//
//  RecordPlayViewController.h
//  lechangeDemo
//
//  Created by mac318340418 on 16/7/12.
//  Copyright © 2016年 dh-Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "RecordViewController.h"
#import "LCOpenSDK_EventListener.h"
#import "LiveVideoViewController.h"
#import "LCOpenSDK/LCOpenSDK_DownloadListener.h"

#define LGBackColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1]

#define NavColor [UIColor colorWithRed:81/255.0 green:166/255.0 blue:255/255.0 alpha:1]

#define HLS_Result_String(enum) [@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7"] objectAtIndex:enum]

typedef NS_ENUM(NSInteger, HLSResultCode)
{
    HLS_DOWNLOAD_FAILD = 0,  // 下载失败
    HLS_DOWNLOAD_BEGIN,      // 开始下载
    HLS_DOWNLOAD_END,        // 下载结束
    HLS_SEEK_SUCCESS,        // 定位成功
    HLS_SEEK_FAILD,          // 定位失败
    HLS_ABORT_DONE,
    HLS_RESUME_DONE,
    HLS_DOWNLOAS_TIMEOUT     // 下载超时
};

@interface RecordPlayViewController : MyViewController<LCOpenSDK_DownloadListener, LCOpenSDK_EventListener>
{
    UIImageView             *m_playImg;
    UIView                  *m_playBarView;
    UIButton                *m_playBtn;
    UIButton                *m_scalBtn;
    UILabel                 *m_startTimeLab;
    UILabel                 *m_endTimeLab;
    UISlider                *m_playSlider;
    UILabel                 *m_tipLab;
    UIActivityIndicatorView *m_progressInd;
    
    NSString         *m_accessToken;
    NSString         *m_strDevSelected;
    NSInteger        m_devChnSelected;
    RecordType       m_recordType;
    NSString         *m_strRecSelected;
    NSString         *m_beginTimeSelected;
    NSString         *m_endTimeSelected;
    UIImage          *m_imgPicSelected;
}

- (void) setInfo:(NSString*)token Dev:(NSString*)deviceId Chn:(NSInteger)chn Type:(RecordType)type;

- (void) setRecInfo:(NSString *)rec Begin:(NSString*)begin End:(NSString*)end Img:(UIImage *)img;

- (void) onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index;

- (void) onPlayerResult:(NSString *)code Type:(NSInteger)type Index:(NSInteger)index;

- (void) onPlayBegan:(NSInteger)index;

- (void) onPlayFinished:(NSInteger)index;

- (void) onPlayerTime:(long)time Index:(NSInteger)index;

- (void) onActive:(id)sender;

- (void) onResignActive:(id)sender;

@end
