////  AccountListViewController.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountListViewController.h"
#import <OneDriveSDK.h>
@interface AccountListViewController()
<
UITableViewDelegate,
UITableViewDataSource,
UINavigationControllerDelegate
>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)AccountListToolBarView * toolBarView;
@end
static NSString * AccountListCellID = @"AccountListCellID";
@implementation AccountListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
    [self backHint];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.dataArray.count == 0) {
        [BOSTools RestoreRootViewController:[[BaseNavigationController alloc]initWithRootViewController:[[FirstViewController alloc]init]]];
    }
}
#pragma mark -- System Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    AccountListCell * cell = [AccountListCell initWithTableView:tableView cellID:AccountListCellID];
    cell.model = accountModel;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    AccountManagerViewController * vc = [[AccountManagerViewController alloc]init];
    vc.currentModel = accountModel;
    vc.navigationItem.title = NSLocalizedString(@"账户管理", nil);
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(100);
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isHomePage = [viewController isKindOfClass:[self class]] || [viewController isKindOfClass:[AccountManagerViewController class]]|| [viewController isKindOfClass:[RedPacketOpenViewController class]];
    [self.navigationController setNavigationBarHidden:isHomePage animated:YES];
}
-(void)addAccount:(UIButton *)sender{
    NSArray *titleArr = @[
                          NSLocalizedString(@"创建账户", nil),
                          NSLocalizedString(@"导入账户", nil)];
    
    NSArray *imageArr = @[
                          @"account_icon_packet_default",
                          @"account_icon_tolead_default"
                          ];
    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorView:sender titleArray:titleArr imageArray:imageArr];
    menuView.zwPullMenuStyle = PullMenuLightStyle;
    menuView.coverBgColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    menuView.menuCellHeight = BOS_H(50);
    menuView.blockSelectedMenu = ^(NSInteger menuRow) {
        switch (menuRow) {
            case 0:{
                RedPacketCreateAccountViewController * VC = [[RedPacketCreateAccountViewController alloc] init];
                VC.navigationItem.title = NSLocalizedString(@"红包中心", nil);
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            default:{
                AccountImportViewController * VC = [[AccountImportViewController alloc]init];
                VC.navigationItem.title = NSLocalizedString(@"导入账户", nil);
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
        }
    };
}
-(void)reloadData{
    WeakSelf(weakSelf);
    NSArray <AccountListModel *>* locAccounts = [[BOSWCDBManager sharedManager]BOSSelectAccountWhereCreatTimestampAsc:NO];
    self.dataArray = locAccounts.mutableCopy;
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (AccountListModel * locAccount in locAccounts) {
        NSDictionary * param = @{
                                 @"code": BOSCode,
                                 @"account":locAccount.accountName,
                                 @"symbol":BOSSymbol
                                 };
        EOS_API_get_currency_balance(param, ^(id  _Nonnull responseObject) {
            NSString * balance = ((NSArray *)responseObject).firstObject;
            locAccount.balance = balance;
            [[BOSWCDBManager sharedManager]BOSUpdateBalanceWithModel:locAccount];
            dispatch_semaphore_signal(semaphore);
        }, ^(id  _Nonnull failure, id  _Nonnull message) {
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    dispatch_group_notify(group, queue, ^{
        for(NSInteger index = 0; index < locAccounts.count; index++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
}
-(void)backHint{
    WeakSelf(weakSelf);
    NSArray <AccountListModel *>* accounts = [[BOSWCDBManager sharedManager]BOSSelectAccountWhereIsBackup:NO];
    NSArray *accountNames = [accounts valueForKey:@"accountName"];
    NSString * accountString = [accountNames componentsJoinedByString:@","];
    if (accountNames.count > 0 && accountString) {
        BackUpAlertView * hint = [[BackUpAlertView alloc]init];
        hint.titleStr = NSLocalizedString(@"备份提示", nil);
        hint.sureTitle = NSLocalizedString(@"我已备份", nil);
        hint.detailStr = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"以下账户尚未进行备份：", nil),accountString];
        [hint ShowView];
        [hint setBlock:^(NSInteger index) {
            [accounts setValue:@YES forKey:@"isBackup"];
            [[BOSWCDBManager sharedManager]BOSUpdateAccounts:accounts];
            [weakSelf reloadData];
        }];
    }
}
#pragma mark -- Lazy loading
-(UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView  = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource =self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.clipsToBounds = NO;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            tableView.scrollIndicatorInsets = tableView.contentInset;
        }
        WeakSelf(weakSelf);
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf reloadData];
        }];
        _tableView = tableView;
    }
    return _tableView;
}
-(AccountListToolBarView *)toolBarView{
    if (!_toolBarView) {
        _toolBarView = [[AccountListToolBarView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, Height_NavBar)];
        _toolBarView.backgroundColor = COLOR(@"#FFFFFF");
        _toolBarView.layer.zPosition = 10;
        WeakSelf(weakSelf);
        [_toolBarView setAccountListToolBarAddBlock:^(UIButton * _Nonnull button) {
            NSLog(@"是否添加呢");
            [weakSelf addAccount:button];
        }];
    }
    return _toolBarView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray * locAccounts = [[BOSWCDBManager sharedManager]BOSSelectedAllObjectFromTable:BOSDBAccountTableName objClass:AccountListModel.class];
        [_dataArray addObjectsFromArray:locAccounts];
    }
    return _dataArray;
}
-(void)initSubViews{
    [self.navigationController changeCurrentStatusBarStyle:1];
    self.navigationController.delegate = self;
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:self.toolBarView];
    [self.view addSubview:self.tableView];
    
    WeakSelf(weakSelf);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolBarView.mas_bottom);
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(-BOS_H(5));
    }];
}
@end
