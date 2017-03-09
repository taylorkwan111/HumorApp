//
//  DWRecommendUser.h
//  百思不得姐
//
//  Created by dw on 2017/3/9.
//  Copyright © 2017年 dw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWRecommendUser : NSObject
/**头像**/
@property(nonatomic,copy)NSString *header;
/**粉丝数**/
@property(nonatomic,assign)NSInteger fans_count;
/**昵称**/
@property(nonatomic,copy)NSString *screen_name;
@end
