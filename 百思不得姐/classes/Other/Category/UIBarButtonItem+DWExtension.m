//
//  UIBarButtonItem+DWExtension.m
//  百思不得姐
//
//  Created by dw on 2017/3/7.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "UIBarButtonItem+DWExtension.h"

@implementation UIBarButtonItem (DWExtension)
+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highimage target:(id)target action:(SEL)action
{
    UIButton * button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highimage]  forState:UIControlStateHighlighted];
    button.size=button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc]initWithCustomView:button];
}
@end
