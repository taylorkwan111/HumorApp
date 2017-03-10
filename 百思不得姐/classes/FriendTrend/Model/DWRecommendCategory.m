//
//  DWRecommendCategory.m
//  百思不得姐
//
//  Created by dw on 2017/3/9.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWRecommendCategory.h"

@implementation DWRecommendCategory
-(NSMutableArray *)users
{
    if(!_users)
    {
        _users=[NSMutableArray array];
    }
    return _users;
}
@end
