//
//  UIBarButtonItem+DWExtension.h
//  百思不得姐
//
//  Created by dw on 2017/3/7.
//  Copyright © 2017年 dw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DWExtension)
+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highimage target:(id)target action:(SEL)action;
@end
