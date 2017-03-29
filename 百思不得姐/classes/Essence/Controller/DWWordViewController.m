//
//  DWWordViewController.m
//  百思不得姐
//
//  Created by dw on 2017/3/16.
//  Copyright © 2017年 dw. All rights reserved.
//

#import "DWWordViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DWTopic.h"
#import "MJExtension.h"
#import "MJRefresh.h"
@interface DWWordViewController ()
//帖子数据
@property(nonatomic,strong) NSMutableArray *topics;
/**当前页数**/
@property(nonatomic,assign) NSInteger page;
/**下拉刷新时需要用到的参数**/
@property(nonatomic,copy)NSString * maxtime;
@end

@implementation DWWordViewController
-(NSMutableArray *)topics
{
    if(!_topics)
    {
        _topics=[NSMutableArray array];
    }
    return _topics;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupRefresh];
}
-(void)setupRefresh
{
    
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header.automaticallyChangeAlpha=YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}
-(void)loadNewTopics
{
    self.page=0;
    //参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"data";
    params[@"type"]=@"29";
    
    
    //params[@"maxtime"]=@"";
    //发送请求
    [[AFHTTPSessionManager manager]  GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject)
     {
         self.maxtime=responseObject[@"info"][@"maxtime"];
         self.topics=[DWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
         [self.tableView reloadData];
         [self.tableView.mj_header endRefreshing];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [self.tableView.mj_header endRefreshing];
     }];
}
-(void)loadMoreTopics
{
    self.page++;
    //参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"a"]=@"list";
    params[@"c"]=@"data";
    params[@"type"]=@"29";
    params[@"page"]=@(self.page);
    params[@"maxtime"]=self.maxtime;
    
    //发送请求
    [[AFHTTPSessionManager manager]  GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary * _Nullable responseObject)
     {
         //存储maxtime
         self.maxtime=responseObject[@"info"][@"maxtime"];
         NSArray * newTopics=[DWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
         [self.topics addObjectsFromArray:newTopics];
         
         [self.tableView reloadData];
         [self.tableView.mj_footer endRefreshing];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         [self.tableView.mj_footer endRefreshing];
     }];
    self.page--;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID=@"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    DWTopic *topic=self.topics[indexPath.row];
    cell.textLabel.text=topic.name;
    cell.detailTextLabel.text=topic.text;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
