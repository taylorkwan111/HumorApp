//
//  DWRecommendTagCell.m
//  百思不得姐
//
//  Created by dw on 2017/3/13.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWRecommendTagCell.h"
#import "DWRecommendTag.h"
#import "UIImageView+WebCache.h"
@interface DWRecommendTagCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageListImageView;
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subNumberLabel;

@end
@implementation DWRecommendTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setRecommendTag:(DWRecommendTag *)recommendTag
{
    _recommendTag=recommendTag;
    [self.imageListImageView sd_setImageWithURL:[NSURL URLWithString:recommendTag.image_list] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.themeNameLabel.text=recommendTag.theme_name;
    NSString *subNumber=nil;
    if(recommendTag.sub_number<10000)
    {
        subNumber=[NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number];
    }
    else
    {
        subNumber=[NSString stringWithFormat:@"%zd人订阅",recommendTag.sub_number/10000];

    }
    self.subNumberLabel.text=subNumber;
}

@end
