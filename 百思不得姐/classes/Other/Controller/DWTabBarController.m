//
//  DWTabBarController.m
//  百思不得姐
//
//  Created by dw on 2017/3/6.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWTabBarController.h"
#import "DWEssenceViewController.h"
#import "DWNewViewController.h"
#import "DWFriendTrendsViewController.h"
#import "DWMeViewController.h"
#import "DWTabBar.h"
#import "DWNavigationController.h"


@interface DWTabBarController ()

@end

@implementation DWTabBarController
+(void)initialize
{
    //统一设置
    NSMutableDictionary *attr=[NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName]=[UIColor lightGrayColor];
    
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName]=[UIColor grayColor];
    
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:attr forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrs forState:UIControlStateSelected];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //添加子控制器
    [self setupChildVc:[[DWEssenceViewController alloc]init] title:@"精华" image:@"tabBar_essence_icon" selectedImage:@"tabBar_essence_click_icon"];
    [self setupChildVc:[[DWNewViewController alloc] init] title:@"新帖" image:@"tabBar_new_icon" selectedImage:@"tabBar_new_click_icon"];
    [self setupChildVc:[[DWFriendTrendsViewController alloc] init] title:@"关注" image:@"tabBar_friendTrends_icon" selectedImage:@"tabBar_friendTrends_click_icon"];
    [self setupChildVc:[[DWMeViewController alloc]init] title:@"我" image:@"tabBar_me_icon" selectedImage:@"tabBar_me_click_icon"];
    
    [self setValue:[[DWTabBar alloc]init] forKeyPath:@"tabBar"];
  
}

-(void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    vc.view.backgroundColor=[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0];
    vc.navigationItem.title=title;
    vc.tabBarItem.title=title;
    vc.tabBarItem.image=[UIImage imageNamed:image];
    vc.tabBarItem.selectedImage=[UIImage imageNamed:selectedImage];
    DWNavigationController *nav=[[DWNavigationController alloc]initWithRootViewController:vc];
    [self addChildViewController:nav];
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
