////  RedPacketCreateHistoryViewController.m
//  BOS
//
//  Created by BOS on 2019/1/5.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketCreateHistoryViewController.h"

@interface RedPacketCreateHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) BOOL isEmpty;

@end

@implementation RedPacketCreateHistoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:COLOR(@"#CE2344")];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:SUBJECTCOLOR];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //    [self requestData];
    self.isEmpty = NO;
    [self.tableView.mj_header beginRefreshing];
    
}
-(void)requestData{
    WeakSelf(weakSelf);
    EOS_API_get_table_rows(@{
                             @"scope":KRedContractName,
                             @"code":KRedContractName,
                             @"table":@"redpacket",
                             @"json":@"true",
                             @"key_type": @"i64",
                             @"index_position": @"2",
                             @"lower_bound":self.accountName?:@""
                             }, ^(id  _Nonnull responseObject) {
                                 weakSelf.isEmpty = NO;
                                 [weakSelf.tableView.mj_header endRefreshing];
                                 NSArray * arr = responseObject[@"rows"];
                                 NSMutableArray * tempArr = [NSMutableArray array];
                                 for (NSDictionary * dic in arr) {
                                     RedModel * model = [RedModel mj_objectWithKeyValues:dic];
                                     if (model) {
                                         if ([model.sender isEqualToString:weakSelf.accountName]) {
                                             [tempArr addObject:model];
                                         }
                                     }
                                 }
                                 NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"expire" ascending:NO];
                                 [weakSelf.dataArr removeAllObjects];
                                 [weakSelf.dataArr addObjectsFromArray: [tempArr sortedArrayUsingDescriptors:@[sortDescriptor]]];
                                 [weakSelf.tableView reloadData];
                             }, ^(id  _Nonnull failure, id  _Nonnull message) {
                                 [weakSelf.tableView.mj_header endRefreshing];
                                 weakSelf.isEmpty = YES;
                                [weakSelf.tableView reloadData];
                             });
}

- (void)createUI {
    self.title = NSLocalizedString(@"红包记录", nil);
    self.view.backgroundColor = COLOR(@"f5f5f5");
    [self.view addSubview:self.tableView];
    WeakSelf(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).mas_offset(BOS_H(10));
    }];
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RedPacketHBHistoryTableViewCell * cell = [RedPacketHBHistoryTableViewCell initWithTableView:tableView ID:@"RedPacketHBHistoryTableViewCell"];
    HistoryAccountModel * model = self.dataArr[indexPath.row];
    [cell configModel:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(75);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.isEmpty == 0) {
        return NullImage;
    }else{
        return IMAGE(@"msg_nonetwork");
    }
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    if (self.isEmpty == 0) {
        return - BOS_H(100);
    }else{
        return - BOS_H(77);
    }
}
//允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *title ;
    if (self.isEmpty == 0) {
        title = NSLocalizedString(@"暂无数据", nil);
    }else{
        title = NSLocalizedString(@"检查网络哟", nil);
    }
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13],
                                 NSForegroundColorAttributeName:[COLOR(@"#999999")colorWithAlphaComponent:0.5]
                                 };
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"f5f5f5") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:200 superView:nil];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        WeakSelf(weakSelf);
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

@end
