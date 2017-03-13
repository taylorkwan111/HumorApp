//
//  DWRecommentViewController.m
//  百思不得姐
//
//  Created by dw on 2017/3/9.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWRecommentViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "DWRecommendCategoryCell.h"
#import "MJExtension.h"
#import "DWRecommendCategory.h"
#import "DWRecommendUserCell.h"
#import "DWRecommendUser.h"
#import "MJRefresh.h"

#define DWSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface DWRecommentViewController ()<UITableViewDelegate,UITableViewDataSource>
/**左边的数据类别**/
@property(nonatomic,strong)NSArray *categories;
/**左边的数据表格**/
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/**右边的数据表格**/
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/**请求参数**/
@property(nonatomic,strong) NSMutableDictionary *params;
/**AFN的请求管理者**/
@property(nonatomic,strong)AFHTTPSessionManager *manager;

@end
@implementation DWRecommentViewController

static NSString *const DWCategoryId=@"category";
static NSString *const DWUserId=@"user";

-(AFHTTPSessionManager *)manager
{
    if(!_manager)
    {
        _manager=[AFHTTPSessionManager manager];
    }
    return _manager;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    //显示指示器
    [self setupTableView];
    //显示刷新控件
    [self setupRefrsh];
    [SVProgressHUD showWithStatus:@"加载中"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"category";
    params[@"c"]=@"subscribe";
    // 发送请求
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params
    progress:^(NSProgress * _Nonnull downloadProgress)
    {
        nil;
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
        //服务器返回的JSON数据,用了MJExtension框架
        self.categories=[DWRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //刷新表格
        [self.categoryTableView reloadData];
        //默认选中首行
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
       
        //让用户表格进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
        
        //隐藏指示器
        [SVProgressHUD dismiss];
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
    {
        [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败"];;
    }
     ];
    
}
// 显示指示器
-(void)setupTableView
{
    
    //注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DWRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:DWCategoryId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DWRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:DWUserId];
    
    
    self.categoryTableView.backgroundColor=DWGlobalBg;
    [self.categoryTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.categoryTableView setLayoutMargins:UIEdgeInsetsZero];
    [self.userTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.userTableView setLayoutMargins:UIEdgeInsetsZero];
    self.categoryTableView.separatorColor=[UIColor whiteColor];
    //除去底部多余的分割线
    self.categoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     //设置inset
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.categoryTableView.contentInset=UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset=self.categoryTableView.contentInset;
    
    self.userTableView.rowHeight=65;
    self.title=@"推荐关注";
    self.view.backgroundColor=DWGlobalBg;
}
//显示刷新控件
-(void)setupRefrsh
{
    self.userTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    self.userTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.userTableView.mj_footer.hidden=YES;
    
}
-(void)loadNewUsers
{
    //必须要把左边的参数传给服务器，他才知道要返回哪一个数据
    DWRecommendCategory *rc=DWSelectedCategory;
    rc.currentPage=1;
    //清楚所有旧数据
    [rc.users removeAllObjects];
    //请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"subscribe";
    params[@"category_id"]=@(rc.id);
    params[@"page"]=@(rc.currentPage);
    self.params=params;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
        NSArray *users=[DWRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //添加到当前类别对应的用户数据类型
        [rc.users addObjectsFromArray:users];
        //保存总数
        rc.total=[responseObject[@"total"] integerValue];
        if(self.params!=params) return ;

        //刷新右边表格
        [self.userTableView reloadData];
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
        [self checkFooterState];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
        {
            if(self.params!=params) return ;
            //提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"] ;
            //结束刷新
            [self.userTableView.mj_header endRefreshing];
        }];

}
-(void)loadMoreUsers
{
    DWRecommendCategory *category=DWSelectedCategory;
    //发送请求给服务器，请求右边的数据
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"subscribe";
    params[@"page"]=@(++category.currentPage);
    params[@"category_id"]=@([DWSelectedCategory id]);
    self.params=params;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
        NSArray *users=[DWRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        if (self.params!=params)  return ;
        
        //刷新右边表格
        [self.userTableView reloadData];
        
        //让底部空间结束刷新
        [self.userTableView.mj_footer endRefreshing];
        [self checkFooterState];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (self.params!=params) return;
        //提醒
        [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"] ;
        //结束刷新
        [self.userTableView.mj_header endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// 时刻监测footer的状态
-(void)checkFooterState
{
    DWRecommendCategory *rc=DWSelectedCategory;
    //每次刷新右边数据时，都控制footer显示或者隐藏
    self.userTableView.mj_footer.hidden=(rc.users.count==0);
    if(rc.users.count==rc.total)
    {
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }
    else
    {
        [self.userTableView.mj_footer endRefreshing];
    }

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.categoryTableView)
    {
        return self.categories.count;
    }
    else// 右边的用户数据表格
    {
        [self checkFooterState];
        return [DWSelectedCategory users].count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.categoryTableView) {
        DWRecommendCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:DWCategoryId];
        cell.category=self.categories[indexPath.row];
        return cell;
    }
    else
    {
        DWRecommendUserCell *cell=[tableView dequeueReusableCellWithIdentifier:DWUserId];
        cell.user=[DWSelectedCategory users][indexPath.row];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    DWRecommendCategory *c=self.categories[indexPath.row];
    
    if(c.users.count)
    {
        [self.userTableView reloadData];
    }
    else
    {
        //赶紧刷新表格，目的是：马上显示当前category的用户数据，不然用户看见上一个cotegory的残留数据，解决网络慢的问题
        [self.userTableView reloadData];
        //自动进入下啦刷新状态
        [self.userTableView.mj_header beginRefreshing];
     }
}
// 控制器的销毁
-(void)dealloc
{
    //停止所有请求操作
    [self.manager.operationQueue cancelAllOperations];
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
