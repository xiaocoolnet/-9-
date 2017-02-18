//
//  RecordPlayViewController.m
//  lechangeDemo
//
//  Created by mac318340418 on 16/7/12.
//  Copyright © 2016年 dh-Test. All rights reserved.
//

#import "RecordPlayViewController.h"
#import "VideoPlay.h"
#import "UIDevice+Lechange.h"
#import "LCOpenSDK_Utils.h"

#define RECORD_BAR_HEIGHT     40.0
#define TIME_LAB_WIDTH        60.0



typedef NS_ENUM(NSInteger, PlayState)
{
    Play  = 0,
    Pause = 1,
    Stop  = 2
};

@interface RecordPlayViewController ()
{
    LCOpenSDK_Utils    *m_Utils;
    
    CGRect             m_screenFrame;
    VideoPlay          *m_play;
   
    RecordType         m_playType;
    PlayState          m_playState;
    BOOL               m_isSeeking;
    NSTimeInterval     m_deltaTime;
}

@end

@implementation RecordPlayViewController

- (void)viewDidLoad {
    
   
    
    [super viewDidLoad];
    [self initWindowView];
    [self.view bringSubviewToFront:m_playBarView];
    
    dispatch_queue_t playRecord = dispatch_queue_create("playRecord", nil);
    dispatch_async(playRecord, ^{
        [self onPlay];
    });
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onResignActive:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];
    signal(SIGPIPE, SIG_IGN);
}

-(void) initWindowView
{
    m_screenFrame = [UIScreen mainScreen].bounds;

    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"录像播放"];
    self.view.backgroundColor = LGBackColor;
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50,30)];
    UIImage *img = [UIImage imageNamed:@"common_btn_back.png"];
    
    [left setBackgroundImage:img forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];
    
    [self.view addSubview:super.m_navigationBar];
    
    m_playImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width*9/16)];
    [m_playImg setImage:m_imgPicSelected];
    [self.view addSubview:m_playImg];
    [self layOutBar];
    
    m_tipLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, m_screenFrame.size.width-20, 20)];
    m_tipLab.center = CGPointMake(m_playImg.center.x, m_playImg.center.y + CGRectGetHeight(m_playImg.frame)/2 + 50);
    [m_tipLab setBackgroundColor:[UIColor clearColor]];
    m_tipLab.textAlignment = NSTextAlignmentCenter;
    [m_tipLab setFont:[UIFont systemFontOfSize:15.0]];
    [self.view addSubview:m_tipLab];
    m_play = [[VideoPlay alloc] initWithRect:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width*9/16) Index:1];
    [self.view addSubview:[m_play getWindowView]];
    
    m_progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    m_progressInd.center=CGPointMake(self.view.center.x,m_playImg.center.y);
    [self.view addSubview:m_progressInd];
    
    [self.view bringSubviewToFront:m_playImg];
    [self.view bringSubviewToFront:m_playBarView];
    [self.view bringSubviewToFront:m_progressInd];
    [m_play setListener:(id<LCOpenSDK_EventListener>)self];
    
    m_Utils = [[LCOpenSDK_Utils alloc] init];
    
    m_playState = Stop;
    m_isSeeking = NO;
    [self enableOtherBtn:NO];
    
    m_deltaTime = [self transformToDeltaTime:m_beginTimeSelected EndTime:m_endTimeSelected];
    
    signal(SIGPIPE, SIG_IGN);

}

- (void) layOutBar
{
    m_playBarView = [[UIView alloc]initWithFrame:CGRectMake(0, super.m_yOffset - RECORD_BAR_HEIGHT+m_playImg.frame.size.height, m_playImg.frame.size.width, RECORD_BAR_HEIGHT)];
    [m_playBarView setBackgroundColor:[UIColor grayColor]];
    m_playBarView.alpha = 0.5;
    [self.view addSubview:m_playBarView];
    
    m_playBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
    [m_playBtn addTarget:self action:@selector(onPlay) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_playBtn];
    
    m_scalBtn = [[UIButton alloc]initWithFrame:CGRectMake(m_playBarView.frame.size.width-RECORD_BAR_HEIGHT, 0,RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_scalBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_fullscreen"] forState:UIControlStateNormal];
    [m_scalBtn addTarget:self action:@selector(onFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_scalBtn];
    
    m_startTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
    [m_startTimeLab setBackgroundColor:[UIColor clearColor]];
    [m_startTimeLab setFont:[UIFont systemFontOfSize:12.0]];
    m_startTimeLab.textAlignment = NSTextAlignmentCenter;
    [m_playBarView addSubview:m_startTimeLab];
    
    m_endTimeLab = [[UILabel alloc]initWithFrame:CGRectMake(m_playBarView.frame.size.width-TIME_LAB_WIDTH-RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    m_endTimeLab.text = [self transformToShortTime:m_endTimeSelected];
    [m_endTimeLab setBackgroundColor:[UIColor clearColor]];
    [m_endTimeLab setFont:[UIFont systemFontOfSize:12.0]];
    m_endTimeLab.textAlignment = NSTextAlignmentCenter;
    [m_playBarView addSubview:m_endTimeLab];
    
    m_playSlider = [[UISlider alloc]initWithFrame:CGRectMake(RECORD_BAR_HEIGHT+TIME_LAB_WIDTH, 0, m_playBarView.frame.size.width-2*(RECORD_BAR_HEIGHT+TIME_LAB_WIDTH), RECORD_BAR_HEIGHT)];
    m_playSlider.value = m_playSlider.minimumValue;
    [m_playSlider addTarget:self action:@selector(onSeek) forControlEvents:UIControlEventTouchUpInside];
    [m_playBarView addSubview:m_playSlider];
}

- (void)refreshSubView
{
    [m_playBtn setFrame:CGRectMake(0, 0, RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_scalBtn setFrame:CGRectMake(m_playBarView.frame.size.width-RECORD_BAR_HEIGHT, 0,RECORD_BAR_HEIGHT, RECORD_BAR_HEIGHT)];
    [m_startTimeLab setFrame:CGRectMake(RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_endTimeLab setFrame:CGRectMake(m_playBarView.frame.size.width-TIME_LAB_WIDTH-RECORD_BAR_HEIGHT, 0, TIME_LAB_WIDTH, RECORD_BAR_HEIGHT)];
    [m_playSlider setFrame:CGRectMake(RECORD_BAR_HEIGHT+TIME_LAB_WIDTH, 0, m_playBarView.frame.size.width-2*(RECORD_BAR_HEIGHT+TIME_LAB_WIDTH), RECORD_BAR_HEIGHT)];
}

// 除播放按键以外的其他按键的使能操作
- (void) enableOtherBtn:(BOOL)bFalg
{
    m_playSlider.enabled = bFalg;
    m_scalBtn.enabled = bFalg;
}

- (void) setInfo:(NSString*)token Dev:(NSString*)deviceId Chn:(NSInteger)chn Type:(RecordType)type
{
    m_accessToken = [NSString stringWithString:token];
    m_strDevSelected = [NSString stringWithString:deviceId];
    m_devChnSelected = chn;
    m_recordType = type;
}

- (void) setRecInfo:(NSString *)rec Begin:(NSString*)begin End:(NSString*)end Img:(UIImage *)img
{
    m_strRecSelected = [NSString stringWithString:rec];
    m_beginTimeSelected = [NSString stringWithString:begin];
    m_endTimeSelected = [NSString stringWithString:end];
    m_imgPicSelected = img;
}

- (void)onPlay{
    switch (m_recordType)
    {
        case DeviceRecord:
            [self playDeviceRecord];
            break;
        case CloudRecord:
            [self playCloudRecord];
            break;
        default:
            break;
    }
}


#pragma mark - 播放设备本地录像文件
- (void) playDeviceRecord
{
    if (!m_play)
    {
        NSLog(@"play failed\n");
        return;
    }
    switch (m_playState) {
        case Stop:
            [m_play stopRtspPlayback];
            m_isSeeking = NO;
            [self showLoading];
            [m_play playRtspPlayback:m_accessToken devID:m_strDevSelected filename:m_strRecSelected];
            m_tipLab.text = @"ready play";
            m_playState = Play;
            m_playBtn.enabled = NO;
            break;
        case Pause:
            [m_play resume];
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_pause"] forState:UIControlStateNormal];
            m_playState = Play;
            m_tipLab.text = @"play";
            break;
        case Play:
            [m_play pause];
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
            m_playState = Pause;
            m_tipLab.text = @"pause";
            break;
        default:
            break;
    }
}

#pragma mark - 播放云录像
- (void) playCloudRecord
{
    if (!m_play)
    {
        NSLog(@"play failed\n");
        return;
    }
    switch (m_playState) {
        case Stop:
            [m_play stopCloud];
            m_isSeeking = NO;
            [self showLoading];
            [m_play playCloud:m_accessToken devID:m_strDevSelected recordID:[m_strRecSelected longLongValue]];
            m_playState = Play;
            m_tipLab.text = @"ready play";
            m_playBtn.enabled = NO;
            break;
        case Pause:
            [m_play resume];
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_pause"] forState:UIControlStateNormal];
            m_playState = Play;
            m_tipLab.text = @"play";
            break;
        case Play:
            [m_play pause];
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
            m_playState = Pause;
            m_tipLab.text = @"pause";
            break;
        default:
            break;
    }
}

#pragma mark - 拖动
- (void)onSeek{
    m_isSeeking = YES;
    [self showLoading];
    
    if (Pause == m_playState)
    {
        [m_play resume];
        [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_pause"] forState:UIControlStateNormal];
        if (DeviceRecord == m_recordType)
        {
            return;
        }
    }
    
    m_playState = Play;
    
    // seek到录像最后2秒内，录像可能无法播放,强制使seek在录像最后2秒以外
    Float64 delta = m_playSlider.maximumValue - m_playSlider.value;
    if(delta < (2.0/m_deltaTime))
    {
        m_playSlider.value = (m_playSlider.maximumValue -2.0/m_deltaTime) < m_playSlider.minimumValue ? m_playSlider.minimumValue : (m_playSlider.maximumValue -2.0/m_deltaTime);
    }
    Float64 rate = m_playSlider.value / (m_playSlider.maximumValue - m_playSlider.minimumValue);
    [m_play seek:rate * m_deltaTime];
}

#pragma mark - 全屏
- (void)onFullScreen{
    [UIDevice lc_setRotateToSatusBarOrientation];
}

#pragma mark - 双击屏幕
- (void) onWindowDBClick:(CGFloat)dx dy:(CGFloat)dy Index:(NSInteger)index
{
    if (YES == m_playBarView.hidden) {
        m_playBarView.hidden = NO;
    }
    else
    {
        m_playBarView.hidden = YES;
    }
}

- (void) onPlayerResult:(NSString *)code Type:(NSInteger)type Index:(NSInteger)index
{
    switch (m_recordType) {
        case DeviceRecord:
            [self onPlayDeviceRecordResult:code Type:type];
            break;
        case CloudRecord:
            [self onPlayCloudRecordResult:code Type:type];
        default:
            break;
    }
}

#pragma mark - 设备录像播放回调
- (void) onPlayDeviceRecordResult:(NSString *)code Type:(NSInteger)type
{
    if (99 == type)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"RecordPlayViewController, 网络交互超时!");
            m_tipLab.text = @"网络交互超时";
            [self hideLoading];
            m_playState = Stop;
            m_playImg.hidden = NO;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
        });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_DESCRIBE_READY) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"describe ready";
        });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_PLAY_READY) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (YES == m_isSeeking)
            {
                if (Pause == m_playState)
                {
                    m_playState = Play;
                    Float64 m_Rate = m_playSlider.value/(m_playSlider.maximumValue -m_playSlider.minimumValue);
                    [m_play seek:m_Rate * m_deltaTime];
                }
                else
                {
                    m_isSeeking = NO;
                }
            }
        });
        return;
    }
    if ([RTSP_Result_String(STATE_PACKET_FRAME_ERROR) isEqualToString:code]||
             [RTSP_Result_String(STATE_RTSP_TEARDOWN_ERROR) isEqualToString:code] ||
             [RTSP_Result_String(STATE_RTSP_AUTHORIZATION_FAIL) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"rtsp connection closed";
            [self hideLoading];
            m_playImg.hidden = NO;
            m_playState = Stop;
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
            [m_play stopRtspPlayback];
            
            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_FILE_PLAY_OVER) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            m_tipLab.text = @"play over";
            m_playImg.hidden = NO;
            m_playState = Stop;
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
            [m_play stopRtspPlayback];
            
            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if ([RTSP_Result_String(STATE_RTSP_PLAY_PAUSE) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        return;
    }

    NSString *hint = [code isEqualToString:@"-1000"]?[NSString stringWithFormat:@"rest timeout"]:[NSString stringWithFormat:@"%@",code];
    dispatch_async(dispatch_get_main_queue(), ^{
        m_tipLab.text = hint;
        m_playBtn.enabled = YES;
        m_playImg.hidden = NO;
        [self hideLoading];
        m_playState = Stop;
        [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
    });

}

#pragma mark - 云录像播放回调
- (void) onPlayCloudRecordResult:(NSString *)code Type:(NSInteger)type
{

    NSLog(@"code[%@] type[%ld]",code, (long)type);
    if (99 == type) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"RecordPlayViewController, 网络交互超时!");
            m_tipLab.text = @"网络交互超时";
            [self hideLoading];
            m_playState = Stop;
            m_playImg.hidden = NO;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
        });
        return;
    }
    if([HLS_Result_String(HLS_DOWNLOAD_FAILD) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS DOWNLOAD FAILED!");
            m_tipLab.text = @"HLS download failed";
            [self hideLoading];
            m_playState = Stop;
            m_playImg.hidden = NO;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:NO];
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
            
            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if([HLS_Result_String(HLS_DOWNLOAD_BEGIN) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS DOWNLOAD BEGIN!");
        });
        return;
    }
    if([HLS_Result_String(HLS_DOWNLOAD_END) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS DOWNLOAD END!");
        });
        return;
    }
    if ([HLS_Result_String(HLS_SEEK_SUCCESS) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS SEEK SUCCESS!");
            m_isSeeking = NO;
            [self hideLoading];
        });
        return;
    }
    if([HLS_Result_String(HLS_SEEK_FAILD) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS SEEK FAILD!");
            [m_play stopCloud];
            m_playState = Stop;
            [self hideLoading];
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
            
            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if([HLS_Result_String(HLS_ABORT_DONE) isEqualToString:code])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS ABORT DONE!");
            m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
            [m_playSlider setValue:0];
        });
        return;
    }
    if ([HLS_Result_String(HLS_RESUME_DONE) isEqualToString:code])
    {

        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"HLS RESUME DONE!");
        });
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"HLS PlayResult code = %@", code);
        [m_play stopCloud];
        m_playState = Stop;
        [self hideLoading];
        [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
        
        m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
        [m_playSlider setValue:0];
    });
}

#pragma mark - 录像开始播放回调
- (void) onPlayBegan:(NSInteger)index
{
    if (DeviceRecord == m_recordType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_pause"] forState:UIControlStateNormal];
            m_tipLab.text = @"start to play";
            m_playState = Play;
            [self hideLoading];
            m_playImg.hidden = YES;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:YES];
        });
    }
    else if(CloudRecord == m_recordType)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            m_tipLab.text = @"start to play";
            m_playState = Play;
            [self hideLoading];
            m_playImg.hidden = YES;
            m_playBtn.enabled = YES;
            [self enableOtherBtn:YES];
            [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_pause"] forState:UIControlStateNormal];
            
        });
    }
}

#pragma mark - 录像播放结束回调
- (void) onPlayFinished:(NSInteger)index
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (DeviceRecord == m_playType)
        {
            [m_play stopRtspPlayback];
        }
        else if (CloudRecord == m_playType)
        {
            [m_play stopCloud];
        }
        m_tipLab.text = @"play over";
        [self hideLoading];
        m_playImg.hidden = NO;
         [self enableOtherBtn:NO];
        [m_startTimeLab setText:[self transformToShortTime:m_beginTimeSelected]];
        [m_playSlider setValue:m_playSlider.minimumValue animated:YES];
        m_playState = Stop;
        [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
    });
}

#pragma mark - 录像时间状态回调
- (void) onPlayerTime:(long)time Index:(NSInteger)index
{
    if(YES == m_isSeeking)
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(),^{
        NSString * currentTime = [self transformTimeFromLong:time];
        [m_startTimeLab setText:[self transformToShortTime:currentTime]];
        NSLog(@"_m_startTimeLab.text = %@", m_startTimeLab.text);
        Float64 rate =  [self transformToDeltaTime:m_beginTimeSelected EndTime:currentTime] / m_deltaTime;
        Float64 slider_value = rate * (m_playSlider.maximumValue - m_playSlider.minimumValue);
        [m_playSlider setValue:slider_value animated:YES];
    });
    
}

#pragma mark - 返回
- (void) onBack
{
    if (m_play)
    {
        switch (m_playType)
        {
            case DeviceRecord:
                [m_play stopRtspPlayback];
                break;
            case CloudRecord:
                [m_play stopCloud];
            default:
                break;
        }
        m_playState = Stop;
        
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSTimeInterval)timeIntervalOfString:(NSString *)strTime
{
    NSString *regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}";//正常字符范围
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];//比较处理
    
    //不符合格式的返回0
    if (![pred evaluateWithObject:strTime])
    {
        NSLog(@"Time format error:%@",strTime);
        return 0;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:strTime];
    return [date timeIntervalSince1970];
}

- (NSTimeInterval) transformToDeltaTime:(NSString*)beginTime EndTime:(NSString *)endTime
{
    NSTimeInterval t_beginTime;
    NSTimeInterval t_endTime;
    NSTimeInterval t_deltaTime;
    
    t_beginTime = [self timeIntervalOfString:beginTime];
    t_endTime = [self timeIntervalOfString:endTime];
   
    if (t_endTime >= t_beginTime && t_beginTime != 0 && t_endTime != 0)
    {
         t_deltaTime = t_endTime - t_beginTime;
    }
    else
    {
        return 0;
    }
    return t_deltaTime;
}

- (NSString *) transformToShortTime:(NSString *)time
{
    NSString *regex = @"[1-9]\\d{3}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}";//正常字符范围
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];//比较处理
    if (![pred evaluateWithObject:time])
    {
        NSLog(@"Time format error:%@",time);
        return 0;
    }
    NSString * shortTime;
    NSArray *array = [time componentsSeparatedByString:@" "]; //从字符' '中分隔成2个元素的数组
    NSLog(@"array:%@",array); //结果是"yyyy-mm-dd"和"HH:MM:SS"
    shortTime = array[1];

    return shortTime;
}

- (NSString *) transformTimeFromLong:(long)time
{
    NSDate *resDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSString *strTime = [formatter stringFromDate:resDate];
    NSLog(@"时间戳转日期%@", strTime);
    return strTime;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutViews:toInterfaceOrientation force:NO];
}

- (void)viewWillLayoutSubviews
{
    NSLog(@"do nothing, but rewrite method! ");
}

- (void)layoutViews:(UIInterfaceOrientation)InterfaceOrientation force:(BOOL)beForce
{
     CGFloat width = [[[UIDevice currentDevice] systemVersion] floatValue] <7?m_screenFrame.size.width - 20:m_screenFrame.size.width;
    if (UIInterfaceOrientationIsPortrait(InterfaceOrientation))
    {
        [m_scalBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_fullscreen"] forState:UIControlStateNormal];
        [m_play setWindowFrame:CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width * 9/16)];
        m_playImg.frame = CGRectMake(0, super.m_yOffset, m_screenFrame.size.width, m_screenFrame.size.width*9/16);
        m_progressInd.center = m_playImg.center;
        m_playBarView.frame = CGRectMake(0, super.m_yOffset+m_playImg.frame.size.height-RECORD_BAR_HEIGHT, m_playImg.frame.size.width, RECORD_BAR_HEIGHT);
        [self refreshSubView];
        super.m_navigationBar.hidden = NO;
    }
    else
    {
        [m_scalBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_smallscreen"] forState:UIControlStateNormal];
        [m_play setWindowFrame:CGRectMake(0, 0, m_screenFrame.size.height, width)];
        m_playImg.frame = CGRectMake(0, 0, m_screenFrame.size.height, width);
        m_progressInd.center = m_playImg.center;
        m_playBarView.frame = CGRectMake(0, width-RECORD_BAR_HEIGHT, m_screenFrame.size.height, RECORD_BAR_HEIGHT);
        [self refreshSubView];
        [self.view bringSubviewToFront:m_playBarView];
        super.m_navigationBar.hidden = YES;

    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

// 显示滚动轮指示器
-(void)showLoading
{
    [m_progressInd startAnimating];
}
// 消除滚动轮指示器
-(void)hideLoading
{
    if ([m_progressInd isAnimating])
    {
        [m_progressInd stopAnimating];
    }
}

- (void) onActive:(id)sender
{
    
}

- (void) onResignActive:(id)sender
{
    if (m_play)
    {
        [m_play stopCloud];
        [m_play stopRtspPlayback];
        [m_play stopAudio];
        m_playState = Stop;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
//        m_tipLab.text = @"rtsp connection closed";
        [self hideLoading];
        m_playImg.hidden = NO;
        [m_playBtn setBackgroundImage:[UIImage imageNamed:@"videoplay_icon_play"] forState:UIControlStateNormal];
        [self enableOtherBtn:NO];
        
        m_startTimeLab.text = [self transformToShortTime:m_beginTimeSelected];
        [m_playSlider setValue:0];
    });
    
}

@end
