 //
//  HCHomeViewController.m
//  Project
//
//  Created by 陈福杰 on 15/12/15.
//  Copyright © 2015年 com.xxx. All rights reserved.
//

#import "HCHomeFamilyViewController.h"
#import "HCHomeDetailViewController.h"
#import "HCShareViewController.h"
#import "HCHomeUserTimeViewController.h"
#import "HCEditCommentViewController.h"
#import "HCHomePictureDetailViewController.h"
#import "MJRefresh.h"
#import "HCWelcomeJoinGradeViewController.h"
#import "HCHomeTableViewCell.h"
#import "HCHomeInfo.h"
#import "HCHomeApi.h"
#import "HCHomeLikeCountApi.h"
//下载 时光的图片
#import "NHCDownLoadManyApi.h"
#import "NHCListOfTimeAPi.h"
//点赞
#import "NHCHomeLikeApi.h"
#import "HCCreateGradeViewController.h"

#define HCHomeCell @"HCHomeTableViewCell"

@interface HCHomeFamilyViewController ()<HCHomeTableViewCellDelegate>{
    NSMutableArray *arr_image_all;
    //下拉加载 用到的m
    int m;

    
}

@property (nonatomic, strong) NSString *start;
@property (nonatomic, assign) NSIndexPath *inter;
@property (nonatomic, strong) HCWelcomeJoinGradeViewController *welcomJoinGrade;

@end

@implementation HCHomeFamilyViewController

#pragma mark - life cycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    arr_image_all = [NSMutableArray array];
    [self readLocationData];
    
    self.tableView.tableHeaderView = HCTabelHeadView(0.1);
    [self.tableView registerClass:[HCHomeTableViewCell class] forCellReuseIdentifier:HCHomeCell];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestHomeData)];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreHomeData)];

}

- (void)viewWillAppear:(BOOL)animated
{
    m = 0;
    _inter=nil;
    [super viewWillAppear:animated];
    [self requestHomeData];
    [self.tableView reloadData];
}

#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HCHomeCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.delegate = self;
    HCHomeInfo *info = self.dataSource[indexPath.section];
    if (IsEmpty(_inter)) {
        
    }else{
        if (indexPath.section == _inter.section) {
            info.isLike = @"1";
        }
    }
    cell.info = info;
    return cell;
}
//时光详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HCHomeInfo *info = self.dataSource[indexPath.section];
    HCHomeDetailViewController *detail = [[HCHomeDetailViewController alloc] init];
    detail.data = @{@"data": info};
    detail.timeID = info.TimeID;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 60 + WIDTH(self.view)*0.15;
    
    HCHomeInfo *info = self.dataSource[indexPath.section];
    
    height = height + [Utils detailTextHeight:info.FTContent lineSpage:4 width:WIDTH(self.view)-20 font:14];

    if (!IsEmpty(info.FTImages))
    {
        if (info.FTImages.count < 5)
        {
            NSInteger row = ((int)info.FTImages.count/3) + 1;
            height += WIDTH(self.view) * 0.33 * row;
        }else
        {
            NSInteger row = ((int)MIN(info.FTImages.count, 9)/3.5) + 1;
            height += WIDTH(self.view) * 0.33 * row;
        }
    }
    
    if (!IsEmpty(info.CreateAddrSmall))
    {
        height = height + 30;
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - HCHomeTableViewCellDelegate 功能 都是点击事件
//功能 都是点击事件
- (void)hcHomeTableViewCell:(HCHomeTableViewCell *)cell indexPath:(NSIndexPath *)indexPath functionIndex:(NSInteger)index
{
    HCHomeInfo *info = self.dataSource[indexPath.section];
    if (index == 2)
    {
        //评论界面
        HCEditCommentViewController *editComment = [[HCEditCommentViewController alloc] init];
        editComment.data = @{@"data": info};
        UIViewController *rootController = self.view.window.rootViewController;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
            editComment.modalPresentationStyle=
            UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        }else
        {
            rootController.modalPresentationStyle=
            UIModalPresentationCurrentContext|UIModalPresentationFullScreen;
        }
        [rootController presentViewController:editComment animated:YES completion:nil];
    }else if (index == 1){
        HCShareViewController  *shareVC = [[HCShareViewController alloc] init];
        [self presentViewController:shareVC animated:YES completion:nil];
    }else if (index == 0)
    {//     点赞触发的方法
        [self requestLikeCount:info indexPath:indexPath];
    }
}
#pragma mark  图片详情
- (void)hcHomeTableViewCell:(HCHomeTableViewCell *)cell indexPath:(NSIndexPath *)indexPath moreImgView:(NSInteger)index
{
    HCHomePictureDetailViewController *pictureDetail = [[HCHomePictureDetailViewController alloc] init];
    pictureDetail.data = @{@"data": self.dataSource[indexPath.section], @"index": @(index)};
    pictureDetail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pictureDetail animated:YES];
}
#pragma mark 时光详情
- (void)hcHomeTableViewCell:(HCHomeTableViewCell *)cell indexPath:(NSIndexPath *)indexPath seleteHead:(UIButton *)headBtn
{
    HCHomeInfo *info = self.dataSource[indexPath.section];
    HCHomeUserTimeViewController *userTime = [[HCHomeUserTimeViewController alloc] init];
    userTime.data = @{@"data": info};
    userTime.userID = info.creator;
    userTime.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:userTime animated:YES];
}

#pragma mark - private methods 加载数据 保存数据 写入数据

- (void)readLocationData
{
    NSString *path = [self getSaveLocationDataPath];
    NSArray *arrayData = [NSArray arrayWithContentsOfFile:path];

    [self.dataSource addObjectsFromArray:[HCHomeInfo mj_objectArrayWithKeyValuesArray:arrayData]];
    [self.tableView reloadData];
    [self requestHomeData];
}

- (NSString *)getSaveLocationDataPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory=[paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"homedata.plist"];
}

- (void)writeLocationData:(NSArray *)array
{
    NSString *path = [self getSaveLocationDataPath];
    NSMutableArray *arrayM = [NSMutableArray arrayWithCapacity:array.count];
    for (NSInteger i = 0; i < array.count; i++)
    {
        HCHomeInfo *info = array[i];
        NSDictionary *dic = [info mj_keyValues];
        [arrayM addObject:dic];
    }
    [arrayM writeToFile:path atomically:YES];
}

#pragma mark - setter or getter 视图创建

- (void)setGradeId:(NSString *)gradeId
{
    if (!IsEmpty(gradeId))
    {
        _welcomJoinGrade = [[HCWelcomeJoinGradeViewController alloc] init];
        _welcomJoinGrade.gradeId = [NSString stringWithFormat:@"欢迎加入%@班级", gradeId];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIViewController *rootController = window.rootViewController;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        {
          _welcomJoinGrade.modalPresentationStyle=
          UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        }else
        {
          rootController.modalPresentationStyle=
          UIModalPresentationCurrentContext|UIModalPresentationFullScreen;
        }
      [_welcomJoinGrade setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
      [rootController presentViewController:_welcomJoinGrade animated:YES completion:nil];
    }
}

#pragma mark - network  网络请求

//上啦刷新
- (void)requestHomeData
{
    NHCListOfTimeAPi *api = [[NHCListOfTimeAPi alloc]init];
    api.start_num = @"0";
    api.home_conut = @"10";
    [api startRequest:^(HCRequestStatus resquestStatus, NSString *message, id Data) {
        [self.tableView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:Data];
        [self.tableView reloadData];
    }];
    _baseRequest = api;
}
//更多数据  下拉加载
- (void)requestMoreHomeData
{
    NHCListOfTimeAPi *api = [[NHCListOfTimeAPi alloc] init];
    api.start_num = [NSString stringWithFormat:@"%d",10 * (m+1)];
    api.home_conut = [ NSString stringWithFormat:@"%d",10 * (m+2)];
    [api startRequest:^(HCRequestStatus requestStatus, NSString *message, NSArray *array) {
        [self.tableView.mj_footer endRefreshing];
        if (requestStatus == HCRequestStatusSuccess)
        {
            [self.dataSource addObjectsFromArray:array];
            [self writeLocationData:array];
            [self.tableView reloadData];
            m ++;
        }else
        {
            [self showHUDError:message];
        }
    }];
}

// 请求点赞
- (void)requestLikeCount:(HCHomeInfo *)info indexPath:(NSIndexPath *)indexPath
{
    _inter = indexPath;
    
    NHCHomeLikeApi *api = [[NHCHomeLikeApi alloc]init];
    api.TimeID = info.TimeID;
    [api startRequest:^(HCRequestStatus requestStatus, NSString *message, id responseObject) {
        
        if (requestStatus == 401) {
            [self showHUDText:@"您已经点过赞了,请刷新"];
            
        }
       
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
       
    }];
  
//    HCHomeLikeCountApi *api = [[HCHomeLikeCountApi alloc] init];
//    api.TimesId = info.KeyId;
//    [api startRequest:^(HCRequestStatus requestStatus, NSString *message, id responseObject) {
//        if (requestStatus == HCRequestStatusSuccess)
//        {
//            info.FTLikeCount = [NSString stringWithFormat:@"%@", @([info.FTLikeCount integerValue]+1)];
//            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        }else
//        {
//            [self showHUDError:message];
//        }
//    }];
    
}



@end
