//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DeviceViewController.h"
#import "AddDeviceViewController.h"
#import "LiveVideoViewController.h"
#import "RecordViewController.h"
#import "DeviceOperationViewController.h"
//#import "MessageViewController.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    self.navigationController.navigationBar.hidden = YES;
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"设备列表"];
    super.m_navigationBar.tintColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //添加新设备
//    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
//    [right setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-5-40, 0, 50,30)];
//    [right setBackgroundImage:[UIImage imageNamed:@"list_icon_adddevice.png"] forState:UIControlStateNormal];
//    [right addTarget:self action:@selector(onAddDevice:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:right];
//    [item setRightBarButtonItem:rightBtn animated:NO];
//    [bar pushNavigationItem:item animated:NO];
    
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50,30)];
    UIImage *imgLeft = [UIImage imageNamed:@"common_btn_back.png"];
    
    [left setBackgroundImage:imgLeft forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];
    self.view.backgroundColor = [UIColor lightGrayColor];
    m_devListView = [[UITableView alloc]initWithFrame:CGRectMake(0,super.m_yOffset, self.view.frame.size.width, self.view.frame.size.height-super.m_yOffset-10)];
    [self.view addSubview:m_devListView];
    m_devListView.delegate = self;
    m_devListView.dataSource = self;
    
    m_devListView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    m_devListView.separatorColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    m_devListView.allowsSelection = YES;

    m_progressInd=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    m_progressInd.transform = CGAffineTransformMakeScale(2.0, 2.0);
    m_progressInd.center=CGPointMake(self.view.center.x,self.view.center.y);
    [self.view addSubview:m_progressInd];
    
    m_toastLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    m_toastLab.center = self.view.center;
    m_toastLab.backgroundColor = [UIColor whiteColor];
    m_toastLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:m_toastLab];
    
    [self.view bringSubviewToFront:m_toastLab];
    [self.view bringSubviewToFront:m_progressInd];
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cert" ofType:@"pem"];
    self.m_hc = [[LCOpenSDK_Api shareMyInstance]initOpenApi:m_strSvr port:m_iPort CA_PATH:cerPath];

    RestApiService * restApiService = [RestApiService shareMyInstance];
    m_devList = [[NSMutableArray alloc]init];
    if (nil != self.m_hc && nil != self.m_accessToken)
    {
        [restApiService initComponent:self.m_hc Token:self.m_accessToken];
    }
    else
    {
        NSLog(@"DeviceViewController, m_hc or m_accessToken is nil");
    }

    
    for (int i = 0; i < DEV_CHANNEL_MAX*DEV_NUM_MAX;i++)
    {
        m_downloadPicture[i] = [[DownloadPicture alloc] init];
    }
    
    m_iPos = 0;
    m_downloadingPos = -1;
    
    m_downStatusLock = [[NSLock alloc]init];
    m_devLock = [[NSLock alloc]init];
    m_looping = YES;
    m_conn = nil;
    self.m_imgDeviceNULL.hidden = YES;
    m_toastLab.hidden = YES;
    
    [self showLoading];
    dispatch_queue_t get_devlist = dispatch_queue_create("get_devlist", nil);
    dispatch_async(get_devlist, ^{
        if(![restApiService getDevList:m_devList Begin:DEV_BEGIN End:DEV_END])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                NSLog(@"网络超时");
                m_toastLab.text = @"网络超时，请重试";
                m_toastLab.hidden = NO;
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];

            if (0 == m_devList.count )
            {
                NSLog(@"DeviceViewController getDevList NULL");
                self.m_imgDeviceNULL.hidden = NO;
            }
            else
            {
                [m_devListView reloadData];
                [self.view bringSubviewToFront:m_progressInd];
            }
            
        });
    });
    
    dispatch_queue_t downQueue = dispatch_queue_create("thumbnailDown", nil);
    dispatch_async(downQueue, ^{
        [self downloadThread];
    });
}

-(void) onBack:(id)sender
{
    [self destroyThread];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [m_devLock lock];
    int iChCount = 0;
    for (DeviceInfo * dev in m_devList)
    {
        if (nil == dev->ID)
        {
            break;
        }
        iChCount += dev->channelSize;
    }
    [m_devLock unlock];
    return iChCount;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    [m_devLock lock];
    NSInteger devKeyIndex = [self locateDevKeyIndex:[indexPath row]];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:[indexPath row]];
    if (devKeyIndex < 0 || chnKeyIndex < 0)
    {
        NSLog(@"cellForRowAtIndexPath devKeyIndex[%ld],chnKeyIndex[%ld]",(long)devKeyIndex,(long)chnKeyIndex);
        [m_devLock unlock];
        return cell;
    }

    UIImage *imgPic = nil;
    if (nil != m_downloadPicture[[indexPath row]].picData)
    {
        imgPic = [UIImage imageWithData:m_downloadPicture[[indexPath row]].picData];
    }
    else
    {
        NSLog(@"test cell image default");
        imgPic = [UIImage imageNamed:@"common_defaultcover.png"];
    }
    
    UIImageView *imgPicView = [[UIImageView alloc]initWithFrame:CGRectMake(0, Device_Cell_Separate, Device_Cell_Width, Device_Cell_Height-Device_Cell_Separate)];
    [imgPicView setImage:imgPic];
    [cell addSubview:imgPicView];
    
    
    UILabel *lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, Device_Cell_Width, Device_Cell_Separate)];
    lblTitle.text = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelName[chnKeyIndex];
    NSLog(@"录像   %@",((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelPic[chnKeyIndex]);
    [lblTitle setFont:[UIFont systemFontOfSize:14.0f]];
    lblTitle.textColor = [UIColor colorWithRed:159.0/255 green:159.0/255 blue:166/255 alpha:1];
    lblTitle.backgroundColor = [UIColor whiteColor];
    [cell addSubview:lblTitle];
    
    UIButton *btnDelDev = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDelDev.frame = CGRectMake(Device_Cell_Width-40-5, 0, 40, Device_Cell_Separate);
    UIImage *imgDelDev = [UIImage imageNamed:@"list_icon_trash.png"];
    [btnDelDev setImage:imgDelDev forState:UIControlStateNormal];
    [cell addSubview:btnDelDev];
    btnDelDev.tag = [indexPath row];
    [btnDelDev addTarget:self action:@selector(onDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *imgBottom = [UIImage imageNamed:@"common_toast_bg.png"];
    UIImageView *imgBottomView = [[UIImageView alloc]initWithFrame:CGRectMake(-50, Device_Cell_Height-60, Device_Cell_Width+100, 60)];
    imgBottomView.layer.masksToBounds = YES;
    imgBottomView.contentMode = UIViewContentModeScaleAspectFill;
    
    [imgBottomView setImage:imgBottom];
    [cell addSubview:imgBottomView];
    
    UIImage *imgLive = [UIImage imageNamed:@"list_icon_livevideo.png"];
    UIButton *btnLive = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLive.frame = CGRectMake(5, Device_Cell_Height-50,50, 40);
    CGFloat step = (Device_Cell_Width-2*5-5*50)/4;
    [btnLive setImage:imgLive forState:UIControlStateNormal];
    [cell addSubview:btnLive];
    btnLive.tag = [indexPath row];
    [btnLive addTarget:self action:@selector(onLive:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *imgVideo = [UIImage imageNamed:@"list_icon_video.png"];
    UIButton *btnVideo = [UIButton buttonWithType:UIButtonTypeCustom];
    btnVideo.frame = CGRectMake(btnLive.frame.origin.x+btnLive.frame.size.width+step, Device_Cell_Height-50,50, 40);
    [btnVideo setImage:imgVideo forState:UIControlStateNormal];
    [cell addSubview:btnVideo];
    btnVideo.tag = [indexPath row];
    [btnVideo addTarget:self action:@selector(onVideo:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *imgCloud = [UIImage imageNamed:@"list_icon_cloudvideo.png"];
    UIButton *btnCloud = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCloud.frame = CGRectMake(btnVideo.frame.origin.x+btnVideo.frame.size.width+step, Device_Cell_Height-50,50, 40);
    [btnCloud setImage:imgCloud forState:UIControlStateNormal];
    [cell addSubview:btnCloud];
    btnCloud.tag = [indexPath row];
    [btnCloud addTarget:self action:@selector(onCloud:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *imgMessage = [UIImage imageNamed:@"list_icon_message.png"];
    UIButton *btnMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnMessage.frame = CGRectMake(btnCloud.frame.origin.x+btnCloud.frame.size.width+step, Device_Cell_Height-50,50, 40);
    [btnMessage setImage:imgMessage forState:UIControlStateNormal];
    [cell addSubview:btnMessage];
    btnMessage.tag = [indexPath row];
    [btnMessage addTarget:self action:@selector(onMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *imgSetting = [UIImage imageNamed:@"list_icon_setting.png"];
    UIButton *btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = CGRectMake(btnMessage.frame.origin.x+btnMessage.frame.size.width+step, Device_Cell_Height-50,50, 40);
    [btnSetting setImage:imgSetting forState:UIControlStateNormal];
    [cell addSubview:btnSetting];
    btnSetting.tag = [indexPath row];
    [btnSetting addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->isOnline[chnKeyIndex])
    {
        UIImage *imgOffline = [UIImage imageNamed:@"list_icon_offline.png"];
        UIImageView *imgOfflineView = [[UIImageView alloc]initWithFrame:CGRectMake(Device_Cell_Width/2-50, (Device_Cell_Height-Device_Cell_Separate)/2+Device_Cell_Separate-50, 100, 100)];
        [imgOfflineView setImage:imgOffline];
        
        UILabel *lblCover = [[UILabel alloc]initWithFrame:CGRectMake(0, Device_Cell_Separate, Device_Cell_Width, Device_Cell_Height-Device_Cell_Separate)];
        lblCover.text = @"";
        lblCover.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [cell addSubview:lblCover];
        [cell addSubview:imgOfflineView];
        
        btnLive.enabled = NO;
        btnCloud.enabled = NO;
        btnMessage.enabled = NO;
        btnSetting.enabled = NO;
        btnVideo.enabled = NO;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    cell.selectionStyle = NO;
    
    [m_devLock unlock];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Device_Cell_Height;
}
-(NSInteger) locateDevKeyIndex:(NSInteger)index
{
    int iChCount = 0;
    int i = 0;
    for (DeviceInfo * dev in m_devList) {
        if (nil == dev->ID) {
            break;
        }
        iChCount += dev->channelSize;
        if (iChCount >= index + 1) {
            break;
        }
        i++;
    }
    return (iChCount >= index+1)?i:-1;
}

-(NSInteger) locateDevChannelKeyIndex:(NSInteger)index
{
    int iChCount = 0;
    int i = 0;
    for (DeviceInfo * dev in m_devList) {
        
        if (nil == dev->ID) {
            break;
        }
        iChCount += dev->channelSize;
        if (iChCount >= index + 1) {
            break;
        }
        i++;
    }
    return (iChCount >= index+1)?(index-iChCount+((DeviceInfo *)[m_devList objectAtIndex:i])->channelSize):-1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setAdminInfo:(NSString*) token address:(NSString*)addr port:(NSInteger)port appId:(NSString*)appId appSecret:(NSString*)appSecret
{
    self.m_accessToken = [NSString stringWithString:token];
    m_strSvr = [NSString stringWithString:addr];
    m_iPort = port;
    m_strAppId = [NSString stringWithString:appId];
    m_strAppSecret = [NSString stringWithString:appSecret];
    NSLog(@"m_accessToken:%@,m_strSvr:%@,m_iPort:%ld,m_strAppId:%@,m_strAppSecret:%@",self.m_accessToken,m_strSvr,(long)m_iPort,m_strAppId,m_strAppSecret);
}

-(void) onLive:(id)sender
{
    UIButton *btnLive = (UIButton*)sender;
    
    NSInteger devKeyIndex = [self locateDevKeyIndex:btnLive.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnLive.tag];

    self.m_strDevSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->ID;
    self.m_devAbilitySelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->ability;
    self.m_devChnSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelId[chnKeyIndex];
    self.m_imgPicSelected = [UIImage imageWithData:m_downloadPicture[btnLive.tag].picData];
    
    NSLog(@"onLive device[%@],channel[%ld]",self.m_strDevSelected,(long)self.m_devChnSelected);
    
//    UIStoryboard *currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LiveVideoViewController *liveVideoView = [[LiveVideoViewController alloc]init];
    [self.navigationController pushViewController:liveVideoView animated:NO];
    [liveVideoView setInfo:self.m_accessToken Dev:self.m_strDevSelected Chn:self.m_devChnSelected Img:self.m_imgPicSelected Abl:self.m_devAbilitySelected];
}
-(void) onVideo:(id)sender
{
    UIButton *btnVideo = (UIButton*)sender;
    
    NSInteger devKeyIndex = [self locateDevKeyIndex:btnVideo.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnVideo.tag];
    self.m_strDevSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->ID;
    // TODO
    self.m_devChnSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelId[chnKeyIndex];
    NSLog(@"onLive device[%@],channel[%ld]",self.m_strDevSelected,(long)self.m_devChnSelected);
    
    UIStoryboard *currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordViewController *recordView = [[RecordViewController alloc]init];
    [recordView setInfo:self.m_accessToken Dev:self.m_strDevSelected Chn:self.m_devChnSelected Type:DeviceRecord];
    [self.navigationController pushViewController:recordView animated:NO];
}

-(void) onCloud:(id)sender
{
    UIButton *btnCloudVideo = (UIButton*)sender;
    
    NSInteger devKeyIndex = [self locateDevKeyIndex:btnCloudVideo.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnCloudVideo.tag];
    self.m_strDevSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->ID;
    self.m_devChnSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelId[chnKeyIndex];
    NSLog(@"onCloud device[%@],channel[%ld]",self.m_strDevSelected,(long)self.m_devChnSelected);
    
//    UIStoryboard *currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RecordViewController *recordView = [[RecordViewController alloc]init];
    [recordView setInfo:self.m_accessToken Dev:self.m_strDevSelected Chn:self.m_devChnSelected Type:CloudRecord];
    [self.navigationController pushViewController:recordView animated:NO];
}

-(void) onMessage:(id)sender
{
    UIButton *btnMessage = (UIButton*)sender;
    
    NSInteger devKeyIndex = [self locateDevKeyIndex:btnMessage.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnMessage.tag];
    self.m_strDevSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->ID;
    self.m_devChnSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelId[chnKeyIndex];
    
//    UIStoryboard *currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
//    MessageViewController *msgView = [currentBoard instantiateViewControllerWithIdentifier:@"MessageView"];
//    [self.navigationController pushViewController:msgView animated:NO];
//    [msgView setInfo:self.m_hc token:self.m_accessToken dev:self.m_strDevSelected chn:self.m_devChnSelected];
}

-(void) onSetting:(id)sender
{
    UIButton *btnCloudVideo = (UIButton*)sender;
    
    NSInteger devKeyIndex = [self locateDevKeyIndex:btnCloudVideo.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnCloudVideo.tag];
    self.m_strDevSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->ID;;
    self.m_devChnSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelId[chnKeyIndex];
    
    UIStoryboard *currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DeviceOperationViewController *deviceOperationView  = [[DeviceOperationViewController alloc]init];
    [deviceOperationView setInfo:self.m_hc Token:self.m_accessToken Dev:self.m_strDevSelected Chn:self.m_devChnSelected];
    [self.navigationController pushViewController:deviceOperationView animated:NO];
}

-(void) onDelete:(id)sender
{
    UIButton *btnDetelte = (UIButton*)sender;
    
    NSInteger devKeyIndex = [self locateDevKeyIndex:btnDetelte.tag];
    NSInteger chnKeyIndex = [self locateDevChannelKeyIndex:btnDetelte.tag];
    
    [m_devLock lock];
    self.m_strDevSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->ID;
    self.m_devChnSelected = ((DeviceInfo *)[m_devList objectAtIndex:devKeyIndex])->channelId[chnKeyIndex];
    [m_devLock unlock];
    
    alertDelView = [[UIAlertView alloc] initWithTitle:@"alarm" message:@"confirm to delete?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alertDelView show];
    
    return;
}


-(void) onAddDevice:(id)sender
{
    UIStoryboard *currentBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddDeviceViewController *addDevView = [[AddDeviceViewController alloc]init];
    [self.navigationController pushViewController:addDevView animated:NO];
    [addDevView setInfo:self.m_hc token:self.m_accessToken devView:self];
}

-(void) alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertDelView)
    {
        if (0 == buttonIndex)
        {
            NSLog(@"cancel delete[%@]",self.m_strDevSelected);
            return;
        }
        else if (1 == buttonIndex)
        {
            [self showLoading];
            m_devListView.hidden = YES;
            dispatch_queue_t unbind_device = dispatch_queue_create("unbind_device", nil);
            dispatch_async(unbind_device, ^{
                NSString * destOut;
                RestApiService * restApiService = [RestApiService shareMyInstance];
                if(![restApiService unBindDevice:self.m_strDevSelected Desc:&destOut])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"解绑失败");
                        [self hideLoading];
                        m_devListView.hidden = NO;
                        m_toastLab.text = @"解绑失败";
                        m_toastLab.hidden = NO;
                        [self performSelector:@selector(hideToastDelay) withObject:nil afterDelay:2.0f];
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self refreshDevList];
                });
            });
        }
        
    }
}

-(void) refreshDevList
{
    [m_devLock lock];
    [m_devList removeAllObjects];
    [m_devLock unlock];
    
    [m_downStatusLock lock];
    m_iPos = 0;
    m_downloadingPos = -1;
    m_conn = nil;
    for (int i = 0; i < DEV_CHANNEL_MAX*DEV_NUM_MAX;i++)
    {
        [m_downloadPicture[i] clearData];
    }
    [m_downStatusLock unlock];
    
    [self showLoading];
    m_devListView.hidden = YES;
    m_toastLab.hidden = YES;
    dispatch_queue_t get_devList = dispatch_queue_create("get_devList", nil);
    dispatch_async(get_devList, ^{
        RestApiService * restApiService = [RestApiService shareMyInstance];
        if (![restApiService getDevList:m_devList Begin:DEV_BEGIN End:DEV_END]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideLoading];
                NSLog(@"网络超时");
                m_devListView.hidden = YES;
                m_toastLab.text = @"网络超时，请重试";
                m_toastLab.hidden = NO;
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideLoading];
            [m_devLock lock];
            if (0 == m_devList.count)
            {
                [m_devLock unlock];
                NSLog(@"refreshDevList hasn't got any device\n");
                self.m_imgDeviceNULL.hidden = NO;
                return;
            }
            else
            {
                self.m_imgDeviceNULL.hidden = YES;
                [m_devLock unlock];
                [m_devListView reloadData];
                m_devListView.hidden = NO;
            }
        });
    });
    
}

-(void) hideToastDelay
{
    m_toastLab.hidden = YES;
}

-(void) downloadThread
{
    m_iPos = 0;
    m_downloadingPos = -1;
    int j;
    while (m_looping)
    {
        usleep(20*1000);
        BOOL bNeedDown = YES;
        NSString *picUrl;
        
        [m_devLock lock];
        [m_downStatusLock lock];
        do{
            picUrl = nil;
            NSInteger iDevKey = [self locateDevKeyIndex:m_iPos];
            NSInteger iChnKey = [self locateDevChannelKeyIndex:m_iPos];
            if (iDevKey < 0 || iChnKey < 0)
            {
                bNeedDown = NO;
                m_iPos = (m_iPos+1)%(DEV_CHANNEL_MAX*DEV_NUM_MAX);
                break;
            }
            
            for (j = 0; j < DEV_CHANNEL_MAX*DEV_NUM_MAX;j++)
            {
                if (DOWNLOADING == m_downloadPicture[j].downStatus)
                {
                    break;
                }
            }
            if (j < DEV_CHANNEL_MAX*DEV_NUM_MAX)
            {
                bNeedDown = NO;
                break;
            }
            if (NONE != m_downloadPicture[m_iPos].downStatus)
            {
                bNeedDown = NO;
                m_iPos = (m_iPos+1)%(DEV_CHANNEL_MAX*DEV_NUM_MAX);
                break;
            }
            
            picUrl = [NSString stringWithString:((DeviceInfo *)[m_devList objectAtIndex:iDevKey])->channelPic[iChnKey]];
        }while (0);
        
        [m_devLock unlock];
        if (NO == bNeedDown)
        {
            [m_downStatusLock unlock];
            continue;
        }
    
        //download
        m_httpUrl = [NSURL URLWithString:picUrl];
        
        m_downloadPicture[m_iPos].downStatus = DOWNLOADING;
        m_downloadingPos = m_iPos;
        m_iPos = (m_iPos+1)%(DEV_CHANNEL_MAX*DEV_NUM_MAX);
        NSURLRequest *request = [NSMutableURLRequest requestWithURL:m_httpUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
        NSHTTPURLResponse *response = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
        
        if(m_downloadingPos < 0)
        {
            NSLog(@"connectionDidFinishLoading m_downloadingPos[%ld]",(long)m_downloadingPos);
            return;
        }
        if (response == nil)
        {
            NSLog(@"download failed");
            m_downloadPicture[m_downloadingPos].downStatus = DOWNLOADFAILED;
        } else
        {
            [m_downloadPicture[m_downloadingPos] setData:data status:DOWNLOADFINISHED];
            dispatch_async(dispatch_get_main_queue(), ^{
                [m_devListView reloadData];
            });
        }
        [m_downStatusLock unlock];
        
        //end
    }
}
-(void) destroyThread
{
    m_looping = NO;
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

- (void) dealloc
{
}

@end