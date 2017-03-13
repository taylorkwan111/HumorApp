//
//  DWEssenceViewController.m
//  百思不得姐
//
//  Created by dw on 2017/3/6.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWEssenceViewController.h"
#import "DWRecommendTagsViewController.h"

@interface DWEssenceViewController ()

@end

@implementation DWEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏内容
    self.navigationItem.titleView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    self.navigationItem.leftBarButtonItem=[UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    self.view.backgroundColor=DWGlobalBg;
   
    
    
}
- (void)tagClick
{
    DWRecommendTagsViewController *tags=[[DWRecommendTagsViewController alloc]init];
    [self.navigationController pushViewController:tags animated:YES];
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
