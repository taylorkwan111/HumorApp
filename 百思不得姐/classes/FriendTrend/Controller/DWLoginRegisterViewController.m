//
//  DWLoginRegisterViewController.m
//  百思不得姐
//
//  Created by dw on 2017/3/14.
//  Copyright © 2017年 dw. All rights reserved.
//
#import "DWLoginRegisterViewController.h"
#import "DWTextFiled.h"
@interface DWLoginRegisterViewController ()
//登录框距离控制器左边的间距

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;


- (IBAction)showLoginOrRegister:(UIButton *)button;


@end

@implementation DWLoginRegisterViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //NSAttributedString：带有属性的文字，富文本技术
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//让当前控制器的导航栏变为白色
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)showLoginOrRegister:(UIButton *)button
{
    [self.view endEditing:YES];
    if(self.loginViewLeftMargin.constant==0)
    {//显示注册界面
        self.loginViewLeftMargin.constant=self.view.width;
        button.selected=YES;
//        [button setTitle:@"已有账号?" forState:UIControlStateNormal];
    }
    else
    {// 显示登录界面
        self.loginViewLeftMargin.constant=0;
//        [button setTitle:@"注册账号" forState:UIControlStateNormal];
        button.selected=NO;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
@end
