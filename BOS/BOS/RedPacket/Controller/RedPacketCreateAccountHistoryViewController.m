////  RedPacketCreateAccountHistoryViewController.m
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketCreateAccountHistoryViewController.h"

@interface RedPacketCreateAccountHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,RedPacketAccountHistoryDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView *tabelview;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, assign) BOOL isEmpty;
@property (nonatomic, strong) PassWorldView *passView;
@property (nonatomic, copy) NSString *password;

@end

@implementation RedPacketCreateAccountHistoryViewController
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
    self.view.backgroundColor = COLOR(@"F5F5F5");
    self.title = NSLocalizedString(@"创建历史", nil);
    self.isEmpty = NO;
    [self createUI];
    
}

-(void)deleteModel:(HistoryAccountModel *)model{
    BOOL isSuccess = [[BOSWCDBManager sharedManager] BOSDeleteHistoryModelWhereAccountId:model.accountId];
    if (isSuccess) {
        NSMutableArray * arr = [NSMutableArray arrayWithArray:self.dataArr];
        [arr removeObject:model];
        self.dataArr = [NSArray arrayWithArray:arr];
    } else {
        [XWHUDManager showTipHUD:NSLocalizedString(@"删除失败", nil)];
    }
}

-(void)RedPacketAccountHistoryCheck:(NSInteger)index{
    HistoryAccountModel * modle = self.dataArr[index];
    WeakSelf(weakSelf);
    self.passView.passwordBlock = ^(NSString * _Nonnull password) {
        if ([PassWordTool verifyPassword:password]) {
            weakSelf.password = password;
             [weakSelf localSaveAccountWithName:modle.accountName privateKey:modle.privateKey pubKey:modle.publicKey];
        }else{
            [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
        }
    };
    [self.passView showView];
    
}

-(void)localSaveAccountWithName:(NSString *)accountName privateKey:(NSString *)privateKey pubKey:(NSString *)pubkey{
    NSLog(@"创建成功，私钥导入");
    WeakSelf(weakSelf);
    [XWHUDManager showHUDMessage:NSLocalizedString(@"账号查询中", nil)];
    EOS_API_get_account(@{@"account_name":accountName}, ^(id  _Nonnull responseObject) {
        [XWHUDManager hideInWindow];
        BOOL canImprot = YES;
        EOSAccountModel * model = [EOSAccountModel mj_objectWithKeyValues:responseObject];
        //判断公钥是否一致
        for (permissionsItem * item in model.permissions) {
            //因为新用户创建只用了一个公钥，所以可以这样判断
            NSString * key = item.required_auth.keys.firstObject.key;
            if (![key isEqualToString:pubkey]) {
                canImprot = NO;
                break;
            }
            
        }
        if (canImprot) {
            [XWHUDManager showHUDMessage:NSLocalizedString(@"账号导入中", nil)];
            //TODO
            [BOSImportManager importWithType:BOSImportTypePrivate info:@{@"content":privateKey} locPass:weakSelf.password completion:^(NSDictionary * _Nonnull info) {
                [XWHUDManager hideInWindow];
                if ([info[@"code"] integerValue] == 10000 ){
                    [XWHUDManager showTipHUD:NSLocalizedString(@"导入成功", nil)];
                    BaseTabBarController * VC = [[BaseTabBarController alloc] init];
                    [BOSTools RestoreRootViewController:VC];
                }else if ([info[@"code"] integerValue] == 10004){
                    [XWHUDManager showTipHUD:NSLocalizedString(@"账号已经存在", nil)];
                }else{
                    [XWHUDManager showTipHUD:NSLocalizedString(@"数据库插入失败", nil)];
                }
            }];
        } else {
            [XWHUDManager showTipHUD:NSLocalizedString(@"无效权限", nil)];
        }
    }, ^(id  _Nonnull failure, id  _Nonnull message) {
        [XWHUDManager hideInWindow];
        [XWHUDManager showTipHUD:NSLocalizedString(@"账号不存在或网络错误", nil)];
    });
}

-(void)RedPacketAccountHistoryDelete:(NSInteger)index{
    HistoryAccountModel * modle = self.dataArr[index];
    [self deleteModel:modle];
    [self.tabelview reloadData];
}

- (void)createUI {
    [self.view addSubview:self.tabelview];
    WeakSelf(weakSelf);
    [self.tabelview mas_makeConstraints:^(MASConstraintMaker *make) {
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
    RedPacketAccountHistoryTableViewCell * cell = [RedPacketAccountHistoryTableViewCell initWithTableView:tableView ID:@"RedPacketAccountHistoryTableViewCell"];
    HistoryAccountModel * model = self.dataArr[indexPath.row];
    cell.titleString = model.accountName;
    cell.timeString = model.accountId;
    cell.index = indexPath.row;
    cell.delegate = self;
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

- (UITableView *)tabelview {
    if (!_tabelview) {
        _tabelview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"#F5F5F5") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:200 superView:nil];
        _tabelview.emptyDataSetSource = self;
        _tabelview.emptyDataSetDelegate = self;
    }
    return _tabelview;
}
- (NSArray *)dataArr {
    if (!_dataArr) {
        if (self.localArray) {
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"accountId" ascending:NO];
             NSMutableArray *sortArr = [NSMutableArray array];
              sortArr = [NSMutableArray arrayWithArray: [self.localArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]]];
            _dataArr = sortArr;
            
        }else{
            NSArray * array = [[BOSWCDBManager sharedManager] BOSSelectedAllObjectFromTable:BOSDBHistoryAccountTableName objClass:HistoryAccountModel.class];
            NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"accountId" ascending:NO];
            NSMutableArray *sortArr = [NSMutableArray array];
            // 排序结果
            sortArr = [NSMutableArray arrayWithArray: [array sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]]];
            _dataArr = sortArr;
        }
       
    }
    return _dataArr;
}
-(AlertView *)alertView {
    if (!_alertView) {
        _alertView = [[AlertView alloc] init];
        _alertView.titleStr = NSLocalizedString(@"提示", nil);
        _alertView.detailStr = NSLocalizedString(@"确认是否删除", nil);
        _alertView.cancelTitle = NSLocalizedString(@"取消", nil);
        _alertView.sureTitle = NSLocalizedString(@"确定", nil);
        WeakSelf(weakSelf);
        _alertView.block = ^(NSInteger index) {
            if (index == 1) {
                RedPacketCreateAccountHistoryViewController * VC = [[RedPacketCreateAccountHistoryViewController alloc] init];
                [weakSelf.navigationController pushViewController:VC animated:YES];
            }
        };
    }
    return _alertView;
}
-(PassWorldView *)passView {
    if (!_passView) {
        _passView = [[PassWorldView alloc] init];
    }
    return _passView;
}

@end
