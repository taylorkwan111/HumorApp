//
//  DWRecommendCategoryCell.m
//  百思不得姐
//
//  Created by dw on 2017/3/9.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWRecommendCategoryCell.h"
#import "DWRecommendCategory.h"
@interface DWRecommendCategoryCell()
//选中时的指示控制器
@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@end

@implementation DWRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor=DWGlobalBg;
    [self.textLabel setTextAlignment:NSTextAlignmentCenter];
    self.textLabel.textColor=[UIColor blackColor];
    self.textLabel.highlightedTextColor=DWRGBColor(219, 21, 26);
    
}

-(void)setCategory:(DWRecommendCategory *)category
{
    _category=category;
    
    self.textLabel.text=category.name;
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.y=2;
    self.textLabel.height=self.contentView.height-2*self.textLabel.y;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.selectedIndicator.hidden=!selected;
    self.textLabel.textColor=selected?DWRGBColor(219, 21, 26):[UIColor blackColor];
    self.textLabel.backgroundColor=selected?[UIColor whiteColor]:[UIColor clearColor];
    self.backgroundColor=selected?[UIColor whiteColor]:[UIColor clearColor];


}
@end
