//
//  DWTopic.h
//  百思不得姐
//
//  Created by dw on 2017/3/29.
//  Copyright © 2017年 dw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DWTopic : NSObject
/**名称**/
@property(nonatomic,copy)NSString *name;
/**头像**/
@property(nonatomic,copy)NSString *profile_image;
/**发帖时间**/
@property(nonatomic,copy)NSString *create_time;
/**文字内容**/
@property(nonatomic,strong)NSString *text;
/**顶的数量**/
@property(nonatomic,assign)NSInteger ding;
/**踩的数量**/
@property(nonatomic,assign)NSInteger cai;
/**转发的数量**/
@property(nonatomic,assign)NSInteger repost;
/**评论的数量**/
@property(nonatomic,assign)NSInteger comment;


@end
