//
//  DWRecommendTag.h
//  百思不得姐
//
//  Created by dw on 2017/3/13.
//  Copyright © 2017年 dw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWRecommendTag : NSObject
/**图片**/
@property(nonatomic,copy)NSString *image_list;
/**名字**/
@property(nonatomic,copy)NSString *theme_name;
/**订阅数**/
@property(nonatomic,assign)NSInteger sub_number;
@end
