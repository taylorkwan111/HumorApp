//
//  DWTabBar.m
//  百思不得姐
//
//  Created by dw on 2017/3/6.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWTabBar.h"

@interface DWTabBar()
@property (nonatomic,strong)UIButton *publishButton;
@end
@implementation DWTabBar
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        UIButton *publishButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [self addSubview:publishButton];
        self.publishButton=publishButton;
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width=self.width;
    CGFloat height=self.height;
    //设置发布按钮的frame
    self.publishButton.width=self.publishButton.currentBackgroundImage.size.width;
    self.publishButton.height=self.publishButton.currentBackgroundImage.size.height;
    self.publishButton.center=CGPointMake(width*0.5, height*0.5);
    //设置其它UITabBarButton的frame
    
    CGFloat buttonY= 0 ;
    CGFloat buttonW=width/5;
    CGFloat buttonH=height;
    NSInteger index=0;
    for(UIView *button in self.subviews)
    {
        //if (![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        if (![button isKindOfClass:[UIControl class]]||button==self.publishButton) continue;
        CGFloat buttonX= buttonW * ((index >1)?(index+1):index) ;
        button.frame=CGRectMake(buttonX, buttonY, buttonW, buttonH);
        index++;
    }
}

@end
