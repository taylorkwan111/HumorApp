//
//  DWMeViewController.m
//  百思不得姐
//
//  Created by dw on 2017/3/6.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWMeViewController.h"

@interface DWMeViewController ()

@end

@implementation DWMeViewController

- (void)viewDidLoad
{
     
    self.navigationItem.title=@"我的";
    
    UIBarButtonItem * settingButton=[UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    
    UIBarButtonItem * moonItem=[UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(moonClick)];
    
    self.navigationItem.rightBarButtonItems=@[settingButton,moonItem];
    self.view.backgroundColor=DWGlobalBg;

}

-(void)settingClick
{
    DWLogFunc;
}
-(void)moonClick
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
