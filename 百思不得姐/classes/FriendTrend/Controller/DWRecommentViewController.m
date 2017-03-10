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

@end
@implementation DWRecommentViewController

static NSString *const DWCategoryId=@"category";
static NSString *const DWUserId=@"user";

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
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params
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
    self.userTableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.userTableView.mj_footer.hidden=YES;
    
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
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //字典数组->模型数组
        NSArray *users=[DWRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        //添加到当前类别对应的用户数组中
        [category.users addObjectsFromArray:users];
        //刷新右边表格
        [self.userTableView reloadData];
        
        if(category.users.count==category.total)
        {
            [self.userTableView.mj_footer endRefreshingWithNoMoreData];
        }
        else
        {
            [self.userTableView.mj_footer endRefreshing];
        }
        

        //让底部空间结束刷新
        [self.userTableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        DWLog(@"%@",error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView==self.categoryTableView)
    {
        return self.categories.count;
    }
    else
    {
        NSInteger count=[DWSelectedCategory users].count;
        //每次刷新右边数据时，都控制footer显示或者隐藏
        self.userTableView.mj_footer.hidden=([DWSelectedCategory users].count==0);
        return count;
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
    
    DWRecommendCategory *c=self.categories[indexPath.row];
    
    if(c.users.count)
    {
        [self.userTableView reloadData];
    }
    else
    {
        //赶紧刷新表格，目的是：马上显示当前category的用户数据，不然用户看见上一个cotegory的残留数据，解决网络慢的问题
        [self.userTableView reloadData];
        
        //设置当前页码为1
        c.currentPage=1;
        //发送请求给服务器，请求右边的数据
        NSMutableDictionary *params=[NSMutableDictionary dictionary];
        params[@"a"]=@"list";
        params[@"c"]=@"subscribe";
        params[@"category_id"]=@(c.id);
        params[@"page"]=@(c.currentPage);
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            nil;
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //字典数组->模型数组
            NSArray *users=[DWRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            //添加到当前类别对应的用户数据类型
            [c.users addObjectsFromArray:users];
            //保存总数
            c.total=[responseObject[@"total"] integerValue];
            //刷新右边表格
            [self.userTableView reloadData];
            if(c.users.count==c.total)
            {
                [self.userTableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DWLog(@"%@",error);
        }];
    }
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
