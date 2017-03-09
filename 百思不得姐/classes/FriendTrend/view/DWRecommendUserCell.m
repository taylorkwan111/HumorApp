//
//  DWRecommendUserCell.m
//  百思不得姐
//
//  Created by dw on 2017/3/9.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWRecommendUserCell.h"
#import "DWRecommendUser.h"
#import "UIImageView+WebCache.h"
@interface DWRecommendUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;

@end
@implementation DWRecommendUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setUser:(DWRecommendUser *)user
{
    _user=user;
    self.screenNameLabel.text=user.screen_name;
    self.fansCountLabel.text=[NSString stringWithFormat:@"%zd人关注",user.fans_count];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}
@end
