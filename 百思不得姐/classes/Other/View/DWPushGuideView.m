//
//  DWPushGuideView.m
//  百思不得姐
//
//  Created by dw on 2017/3/15.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWPushGuideView.h"

@implementation DWPushGuideView

+(instancetype)guideView
{
    return [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
- (IBAction)close {
    [self removeFromSuperview];
}
+(void)show
{
    // 获得当前软件的版本号
    NSString *key=@"CFBundleShortVersionString";
    //获得沙盒中存储的版本号
    NSString *currentVersion=[NSBundle mainBundle].infoDictionary[key];
    NSString *sanboxVersion=[[NSUserDefaults standardUserDefaults]stringForKey:key];
    
    if(![currentVersion isEqualToString:sanboxVersion])
    {
        UIWindow *window=[UIApplication sharedApplication].keyWindow;
        DWPushGuideView *guideView=[DWPushGuideView guideView];
        guideView.frame=window.bounds;
        [window addSubview:guideView];
        //存储版本号
        [[NSUserDefaults standardUserDefaults]setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

}
@end
