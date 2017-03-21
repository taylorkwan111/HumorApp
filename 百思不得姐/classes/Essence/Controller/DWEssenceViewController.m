//
//  DWEssenceViewController.m
//  百思不得姐
//
//  Created by dw on 2017/3/6.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWEssenceViewController.h"
#import "DWRecommendTagsViewController.h"
#import "DWAllViewController.h"
#import "DWVideoViewController.h"
#import "DWVoiceViewController.h"
#import "DWPictureViewController.h"
#import "DWWordViewController.h"

@interface DWEssenceViewController ()<UIScrollViewDelegate>
//底部的红色指示器
@property(nonatomic,weak)UIView *indicatorView;
//当前选中的button
@property(nonatomic,weak)UIButton *selectedButton;
//当前选中的titleView
@property(nonatomic,weak)UIView *titleView;
//所有内容contentView
@property(nonatomic,weak)UIScrollView *contentView;

@end

@implementation DWEssenceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置导航栏内容
    [self setupNav];
    //初始化子控制器
    [self setupChildVces];
    //设置顶部的标签
    [self setupTitlesView];
    // 底部的srcollView
    [self setupContentView];
    
}
-(void) setupChildVces
{
    DWAllViewController *all=[[DWAllViewController alloc]init];
    [self addChildViewController:all];
    
    DWVideoViewController *video=[[DWVideoViewController alloc]init];
    [self addChildViewController:video];
    
    DWVoiceViewController *voice=[[DWVoiceViewController alloc]init];
    [self addChildViewController:voice];
    
    DWPictureViewController *picture=[[DWPictureViewController alloc]init];
    [self addChildViewController:picture];
    
    DWWordViewController *word=[[DWWordViewController alloc]init];
    [self addChildViewController:word];
    
    
}
//设置顶部的标签
-(void)setupTitlesView
{
    UIView *titleView=[[UIView alloc]init];
    titleView.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.7];
    titleView.width=self.view.width;
    titleView.height=35;
    titleView.y=64;
    [self.view addSubview:titleView];
    self.titleView=titleView;
    
    //底部的红色标签
    UIView *indicatorView=[[UIView alloc]init];
    indicatorView.backgroundColor=[UIColor redColor];
    indicatorView.height=2;
    indicatorView.y=titleView.height-indicatorView.height;
   
    
    self.indicatorView=indicatorView;
    
    
    NSArray *titles=@[@"全部",@"视频",@"声音",@"图片",@"段子"];
    CGFloat width=titleView.width/titles.count;
    CGFloat height=titleView.height;
    //内部的子标签
    for (NSInteger i=0; i<5; i++)
    {
        UIButton *button=[[UIButton alloc]init];
        button.tag=i;
        button.height=height;
        button.width=width;
        button.x=i*width;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        [button layoutIfNeeded];
        button.titleLabel.font=[UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleView addSubview:button];
        //默认点击了第一个按钮
        if (i==0) {
            [self titleClick:button];
        }
    }
    [titleView addSubview:indicatorView];
 
}
// 底部的srollView
-(void)setupContentView
{
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIScrollView * contentView=[[UIScrollView alloc]init];
//    contentView.backgroundColor=[UIColor blackColor];
    contentView.frame=self.view.bounds;
    self.contentView=contentView;
    contentView.delegate=self;
    contentView.pagingEnabled=YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize=CGSizeMake(contentView.width*self.childViewControllers.count, 0);
    //添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
    
}
-(void)titleClick:(UIButton *)button
{
    // 修改按钮状态
    self.selectedButton.enabled=YES;
    button.enabled=NO;
    self.selectedButton=button;
    // 动画
    [UIView animateWithDuration:0.15 animations:^{
            self.indicatorView.width=button.titleLabel.width;
            self.indicatorView.centerX=button.centerX;}];
    // 滚动
    CGPoint offset=self.contentView.contentOffset;
    offset.x= button.tag*self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
}
//设置导航栏内容
-(void)setupNav
{
    
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
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 添加子控制器
    
    //当前索引
    NSInteger index=scrollView.contentOffset.x/scrollView.width;
    //取出控制器
    UITableViewController *vc=self.childViewControllers[index];
    vc.view.x=scrollView.contentOffset.x;
    vc.view.y=0;
    vc.view.height=scrollView.height;
    
    //设置内边距
    CGFloat bottom=self.tabBarController.tabBar.height;
    CGFloat top=CGRectGetMaxY(self.titleView.frame);
    vc.tableView.contentInset=UIEdgeInsetsMake(top, 0, bottom, 0);
    //设置滚动条的内边距
    vc.tableView.scrollIndicatorInsets=vc.tableView.contentInset;
    [scrollView addSubview:vc.view];
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击按钮
    NSInteger index=scrollView.contentOffset.x/scrollView.width;
    [self titleClick:self.titleView.subviews[index]];
}

@end
