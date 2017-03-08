//
//  DWNavigationController.m
//  百思不得姐
//
//  Created by dw on 2017/3/7.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWNavigationController.h"

@interface DWNavigationController ()

@end

@implementation DWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    // Do any additional setup after loading the view.
}
//当第一次使用这个类时会调用一次
+(void)initialize
{
    UINavigationBar *bar=[UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if(self.childViewControllers.count>0)
    {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.size=CGSizeMake(70, 30);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        //让按钮向左边靠
        //让所有按钮左对齐
        button.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [button sizeToFit];
        button.contentEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 0);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:button];
        viewController.hidesBottomBarWhenPushed=YES;
    }
      [super pushViewController:viewController animated:animated];
}
-(void)back
{
    [self popViewControllerAnimated:YES];
}

@end
