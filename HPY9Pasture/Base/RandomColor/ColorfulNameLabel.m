//
//  ColorfulNameLabel.m
//  NewWorkers
//
//  Created by dubaoquan on 15/12/4.
//  Copyright © 2015年 Conductss. All rights reserved.
//

#import "ColorfulNameLabel.h"
#define RGB_color(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@implementation ColorfulNameLabel

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.925 alpha:1.000];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = frame.size.height/2;
        self.font = [UIFont systemFontOfSize:12];
        self.textAlignment = NSTextAlignmentCenter;
        NSArray * array1 = @[RGB_color(59,197,217),RGB_color(246,163,17),RGB_color(75,209,82),RGB_color(189,132,247),RGB_color(132,156,247),RGB_color(231,138,101),RGB_color(236,119,133)];
        self.textColor = array1[arc4random() % 7];
    }
    return self;
}

-(void)setColorFulText:(NSString *)text{
   
    NSString*str = (text.length>0)?[text substringFromIndex:text.length-1]:@"⛑️";

    self.text = str;
}
-(void)setSocialOrgsColorFulText:(NSString *)text{
    NSString*str = (text.length>4)?[text substringToIndex:3]:text;
    self.font = [UIFont systemFontOfSize:13.0];
    self.text = str;
}
@end
