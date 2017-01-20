//
//  HintViewController.m
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "AddDeviceViewController.h"
#import "LCOpenSDK_ConfigWifi.h"
#import "DeviceViewController.h"

void callBack(LC_ConfigWifi_Event event, void *userData)
{
    printf("smartconfig result[%ld]\n",(long)event);
    if (1)
    {
        AddDeviceViewController *pCont = (__bridge AddDeviceViewController*)userData;
        [pCont notify:event];
    }
}
typedef NS_ENUM(NSInteger, DeviceListState)
{
    Normal = 0,
    HasChanged,
};

@interface AddDeviceViewController ()
{
    LCOpenSDK_ConfigWIfi *m_configWifi;
    id info;

    id devView;
    DeviceListState deviceListState;
}
@end

@implementation AddDeviceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UINavigationItem *item = [[UINavigationItem alloc]initWithTitle:@"添加设备"];
    
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    [left setFrame:CGRectMake(0, 0, 50,30)];
    UIImage *imgLeft = [UIImage imageNamed:@"common_btn_back.png"];
    
    [left setBackgroundImage:imgLeft forState:UIControlStateNormal];
    [left addTarget:self action:@selector(onBack:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc]initWithCustomView:left];
    [item setLeftBarButtonItem:leftBtn animated:NO];
    [super.m_navigationBar pushNavigationItem:item animated:NO];

    [self.view addSubview:super.m_navigationBar];
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    deviceListState = Normal;
    self.m_lblHint.layer.masksToBounds = YES;
    self.m_lblHint.lineBreakMode = UIControlStateNormal;
    self.m_lblHint.numberOfLines = 0;
    
    self.m_textSerial.delegate = self;
    self.m_textPasswd.delegate = self;
    //self.m_lblHint.hidden = YES;
    
    CFArrayRef __nullable interface = CNCopySupportedInterfaces();
    for (NSString *interf in (__bridge id)interface)
    {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interf));
        if (info && [info count])
        {
            break;
        }
    }
    CFRelease(interface);
    NSString *sID = @"SSID:";
    if (nil == info[@"SSID"] || 0 == [info[@"SSID"] length])
    {
        return;
    }
    self.m_lblSsid.text = [sID stringByAppendingString:info[@"SSID"]];
    
    m_configWifi = [[LCOpenSDK_ConfigWIfi alloc]init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onBack:(id)sender
{
    if(HasChanged == deviceListState)
    {
        [(DeviceViewController*)devView refreshDevList];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) setInfo:(LCOpenSDK_Api*)hc token:(NSString*)token devView:(id)view
{
    m_hc = hc;
    m_strAccessToken = [NSString stringWithString:token];
    devView = view;
}

-(void)onWifi:(id)sender
{
    if (nil == self.m_textSerial.text || 0 == self.m_textSerial.text.length || [self.m_textSerial.text isEqualToString: @"请输入设备序列号"])
    {
        self.m_lblHint.text = @"请输入设备序列号";
        return;
    }
    if (nil == self.m_textPasswd.text || 0 == self.m_textPasswd.text.length || [self.m_textPasswd.text isEqualToString:@"请输入WiFi密码"])
    {
        self.m_textPasswd.text = @"";
    }
    RestApiService * restApiService = [RestApiService shareMyInstance];
    if ([restApiService checkDeviceBindOrNot:self.m_textSerial.text])
    {
        self.m_lblHint.text = @"设备已被绑定";
        return;
    }
    
    UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"hint" message:@"请根据说明书开启设备配对键" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
    
    self.m_lblHint.text = @"开始无线配网";
    
    NSLog(@"[%@][%@][%@]",self.m_textSerial.text,info[@"SSID"],self.m_textPasswd.text);
    NSInteger iRet = [m_configWifi configWifiStart:self.m_textSerial.text ssid:info[@"SSID"] password:self.m_textPasswd.text secure:@"" callback:callBack userData:self timeout:60];
    if (iRet < 0)
    {
        NSLog(@"smartconfig failed\n");
        return;
    }

}
-(void)onWired:(id)sender
{
    if (nil == self.m_textSerial.text || 0 == self.m_textSerial.text.length || [self.m_textSerial.text isEqualToString: @"请输入设备序列号"])
    {
        self.m_lblHint.text = @"请输入设备序列号";
        return;
    }
    RestApiService * restApiService = [RestApiService shareMyInstance];
    if (true == [restApiService checkDeviceBindOrNot:self.m_textSerial.text])
    {
        self.m_lblHint.text = @"设备已被绑定";
        return;
    }
    if (false == [restApiService checkDeviceOnline:self.m_textSerial.text])
    {
        self.m_lblHint.text = @"设备未上线";
        return;
    }
    NSString * errMsg_Out;
    bool bRet = [restApiService bindDevice:self.m_textSerial.text Desc:&errMsg_Out];
    if (true == bRet)
    {
        self.m_lblHint.text = @"绑定成功";
        deviceListState = HasChanged;
    }
    else
    {
        self.m_lblHint.text = errMsg_Out;
    }
}

-(void) notify:(NSInteger)event
{
    dispatch_async(dispatch_get_main_queue(), ^{
        RestApiService * restApiService = [RestApiService shareMyInstance];
        if (LC_ConfigWifi_Event_Success == event)
        {
            //配网成功后，等待设备上线，超时时间60S。
            time_t lBegin,lCur;
            NSInteger lLeftTime=60;
            time(&lBegin);
            lCur = lBegin;
            BOOL bOnline = NO;
            self.m_lblHint.text = @"准备绑定";
     
            [m_configWifi configWifiStop];
            if ([restApiService checkDeviceBindOrNot:self.m_textSerial.text])
            {
                self.m_lblHint.text = @"设备已被绑定";
                return;
            }
            while(lCur >= lBegin && lCur-lBegin < lLeftTime)
            {
                if (![restApiService checkDeviceOnline:self.m_textSerial.text])
                {
                    self.m_lblHint.text = [NSString stringWithFormat:@"等待时间%ld秒",lCur-lBegin];
                    usleep(5*1000*1000);
                    time(&lCur);
                    continue;
                }
                bOnline = YES;
                break;
            }
            if (NO == bOnline)
            {
                self.m_lblHint.text = @"设备未上线";
                return;
            }
            NSString * destOut;
            bool bRet = [restApiService bindDevice:self.m_textSerial.text Desc:&destOut];
            if (true == bRet)
            {
                self.m_lblHint.text = @"绑定成功";
                deviceListState = HasChanged;
            }
            else
            {
                self.m_lblHint.text = destOut;
            }
        }
        else
        {
            [m_configWifi configWifiStop];
            if (LC_ConfigWifi_Event_Timeout == event)
            {
                //超时后再检测一次是否上线，若上线则绑定
                if (true == [restApiService checkDeviceOnline:self.m_textSerial.text])
                {
                    NSString * destOut;
                    bool bRet = [restApiService bindDevice:self.m_textSerial.text Desc:&destOut];
                    if (true == bRet)
                    {
                        self.m_lblHint.text = @"绑定成功";
                        deviceListState = HasChanged;
                    }
                    else
                    {
                        self.m_lblHint.text = destOut;
                    }
                }
                else
                {
                    self.m_lblHint.text = @"配网超时";
                }
            }
        }
    });
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField
{
    
    textField.text = @"";
    textField.textColor = [UIColor blackColor];
    CGFloat offset = self.view.frame.size.height - (textField.frame.origin.y+textField.frame.size.height+216+50);
    if (offset <= 0)
    {
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

-(BOOL) textFieldShouldEndEditing:(UITextField*)textField
{
    [UIView animateWithDuration:0.1 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = 0;
        self.view.frame = rect;
    }];
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
@end