//
//  DWVerticalButton.m
//  百思不得姐
//
//  Created by dw on 2017/3/14.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWVerticalButton.h"

@implementation DWVerticalButton
-(void)setup
{
    self.titleLabel.textAlignment=NSTextAlignmentCenter;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self setup];
    }
    return self;

}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //调整图片
    self.imageView.x=0;
    self.imageView.y=0;
    self.imageView.width=self.width;
    self.imageView.height=self.imageView.height;
    //调整文字
    self.titleLabel.x=0;
    self.titleLabel.y=self.imageView.height;
    self.titleLabel.width=self.width;
    self.titleLabel.height=self.height-self.titleLabel.y;
}

@end
