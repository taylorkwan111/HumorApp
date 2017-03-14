//
//  DWTextFiled.m
//  百思不得姐
//
//  Created by dw on 2017/3/14.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWTextFiled.h"
#import "objc/runtime.h"
@implementation DWTextFiled
// 改变占位图片颜色方法一
//-(void)drawPlaceholderInRect:(CGRect)rect
//{
//    [self.placeholder drawInRect:CGRectMake(0, 10, 100, 25) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
//                                                       NSFontAttributeName:self.font}];
//}
//  改变占位图片颜色方法二
-(void)awakeFromNib
{
    [super awakeFromNib];
//    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //设置光标颜色和文字一致
    self.tintColor=self.textColor;
    
    //不成为第一响应者
    [self resignFirstResponder];
}
//当前文本框聚焦时就会调用
-(BOOL)becomeFirstResponder
{
     //修改占位文字颜色
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    return [super becomeFirstResponder];
}
//当前文本框失去焦距时调用
-(BOOL)resignFirstResponder
{
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}
@end
