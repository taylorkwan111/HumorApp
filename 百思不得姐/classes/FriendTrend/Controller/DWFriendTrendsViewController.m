//
//  DWFriendTrendsViewController.m
//  百思不得姐
//
//  Created by dw on 2017/3/6.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWFriendTrendsViewController.h"

@interface DWFriendTrendsViewController ()

@end

@implementation DWFriendTrendsViewController

- (void)viewDidLoad
{
    
    self.navigationItem.title=@"我的关注";

    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendClick)];
    self.view.backgroundColor=DWGlobalBg;
}

- (void)friendClick
{
    DWLogFunc;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
