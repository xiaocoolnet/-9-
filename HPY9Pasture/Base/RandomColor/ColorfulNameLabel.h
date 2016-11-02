//
//  ColorfulNameLabel.h
//  NewWorkers
//
//  Created by dubaoquan on 15/12/4.
//  Copyright © 2015年 Conductss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorfulNameLabel : UILabel
@property (nonatomic,strong) NSString *colorFulText;
@property (nonatomic,strong) NSString *socialOrgsColorFulText;//显示社会组织的名字
-(instancetype)initWithFrame:(CGRect)frame;
@end
