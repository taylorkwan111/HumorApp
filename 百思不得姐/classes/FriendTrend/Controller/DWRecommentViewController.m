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

@interface DWRecommentViewController ()<UITableViewDelegate,UITableViewDataSource>
/**左边的数据类别**/
@property(nonatomic,strong)NSArray *categories;
/**左边的数据表格**/
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
@end
@implementation DWRecommentViewController

static NSString *const DWCategoryId=@"category";

-(void)viewDidLoad {
    [super viewDidLoad];
    //注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DWRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:DWCategoryId];
    
    
    self.categoryTableView.backgroundColor=DWGlobalBg;
    [self.categoryTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.categoryTableView setLayoutMargins:UIEdgeInsetsZero];
    self.categoryTableView.separatorColor=[UIColor whiteColor];
    //除去底部多余的分割线
    self.categoryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.title=@"推荐关注";
    self.view.backgroundColor=DWGlobalBg;
    //显示指示器
    
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
        NSLog(@"%@",responseObject[@"list"]);
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categories.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DWRecommendCategoryCell *cell=[tableView dequeueReusableCellWithIdentifier:DWCategoryId];
    cell.category=self.categories[indexPath.row];
    return cell;
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
