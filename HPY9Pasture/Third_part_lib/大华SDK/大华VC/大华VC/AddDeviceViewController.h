//
//  HintViewController.h
//  LCOpenSDKDemo
//
//  Created by chenjian on 16/7/11.
//  Copyright (c) 2016年 lechange. All rights reserved.
//
#ifndef LCOpenSDKDemo_AddDeviceViewController_h
#define LCOpenSDKDemo_AddDeviceViewController_h

#import <UIKit/UIKit.h>
#import "MyViewController.h"
#import "RestApiService.h"

@interface AddDeviceViewController : MyViewController<UITextFieldDelegate>
{
    LCOpenSDK_Api *m_hc;
    
    NSString      *m_strAccessToken;
}
@property IBOutlet UITextField *m_textSerial;
@property IBOutlet UITextField *m_textPasswd;
@property IBOutlet UILabel     *m_lblSsid;
@property IBOutlet UILabel     *m_lblHint;
@property IBOutlet UIButton    *m_btnWifi;
@property IBOutlet UIButton    *m_btnWired;
-(void) onBack:(id)sender;
-(void) setInfo:(LCOpenSDK_Api*)hc token:(NSString*)token devView:(id)view;

-(IBAction)onWifi:(id)sender;
-(IBAction)onWired:(id)sender;
-(void) notify:(NSInteger)event;

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField;
-(BOOL) textFieldShouldEndEditing:(UITextField*)textField;
-(BOOL) textFieldShouldReturn:(UITextField *)textField;
@end
#endif
