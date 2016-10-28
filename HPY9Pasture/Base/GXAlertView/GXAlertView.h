//
//  GXAlertView.h
//  NewWorkers
//
//  Created by dubaoquan on 15/12/2.
//  Copyright © 2015年 Conductss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^clickHandle)(void);

@interface GXAlertView : NSObject

@property(nonatomic,strong) UILabel *messageLabel;

+(void)showOneButtonWithTitleWithMidButton:(NSString *)title message:(NSString *)message  buttonTitle:(NSString *)buttonTitle middleButtonTitle:(NSString *)middleButtonTitle imageButton:(UIImage *)imageButton  click:(clickHandle)click knownclick:(clickHandle)knownclick ;

+ (void)showOneButtonWithTitle:(NSString *)title message:(NSString *)message  buttonTitle:(NSString *)buttonTitle;

+ (void)showTwoButtonAlertWithTitle:(NSString *)title message:(NSString *)message  actionButtonTitle:(NSString *)actionButtonTitle click:(clickHandle)click;

+ (void)showTwoActionAlertViewWithTitle:(NSString *)title message:(NSString *)message  leftButtonTitle:(NSString *)leftButtonTitle rightButtonTitle:(NSString *)rightButtonTitle leftClick:(clickHandle)leftClick rightClick:(clickHandle)rightClick;
+(void)changeMessageTitle:(NSString *)changeStr;
+(void)changeMidButtonType;
@end
