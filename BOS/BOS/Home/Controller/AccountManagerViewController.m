////  AccountManagerViewController.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountManagerViewController.h"

@interface AccountManagerViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)AccountManagerHeadView * tableHead;
@property(nonatomic,strong)AccountManagerNaviView * accountManagerNaviView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@end
static NSString * AccountManagerCellID = @"AccountManagerCellID";
@implementation AccountManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}
#pragma mark -- System method
#pragma mark -- System delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray * array = self.dataArray[section];
    return array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BOS_H(10);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountManagerModel * model = self.dataArray[indexPath.section][indexPath.row];
    AccountManagerCell * cell = [AccountManagerCell initWithTableView:tableView cellID:AccountManagerCellID];
    cell.model = model;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AccountManagerModel * model = self.dataArray[indexPath.section][indexPath.row];
    switch (model.ID.integerValue) {
            
        case 2:{
            [BOSExportManager selectKeys:self.currentModel title:NSLocalizedString(@"导出Keystore", nil) limit:nil exist:nil  completion:^(NSString * _Nonnull enPri) {
                if (enPri && enPri.length > 0) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self verifyPassword:enPri];
                    });
                }else{
                    [XWHUDManager showTipHUD:NSLocalizedString(@"当前账户没有可导出权限", nil)];
                }
            }];
        }
            break;
            
        case 4:{
            AdvancedSetViewController * VC = [[AdvancedSetViewController alloc] init];
            VC.currentModel = self.currentModel;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;

            
        default:{
            AdvancedSetViewController * VC = [[AdvancedSetViewController alloc] init];
            VC.currentModel = self.currentModel;
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
    }
}
//验证密码
-(void)verifyPassword:(NSString * )enPrivate{
    [BOSExportManager verifyPassword:enPrivate completion:^(BOOL result, NSString * _Nonnull password ,NSString * dePrivate) {
        if (result && dePrivate) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ExportAlertViewController * vc = [[ExportAlertViewController alloc] init];
                vc.navigationItem.title = NSLocalizedString(@"导出Keystore", nil);
                vc.key = [[EOSTools shared]EncryptKeystoreWith:dePrivate password:password];
                [self.navigationController pushViewController:vc animated:YES];
                self.currentModel.isBackup = YES;
                [[BOSWCDBManager sharedManager]BOSUpdateIsBackupWithModel:self.currentModel];
            });
        }else{
            [XWHUDManager showErrorTipHUD:NSLocalizedString(@"密码错误", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self verifyPassword:enPrivate];
            });
        }
    }];
}
#pragma mark -- Lazy loading
-(UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView  = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource =self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            tableView.scrollIndicatorInsets = tableView.contentInset;
        }
        _tableView = tableView;
    }
    return _tableView;
}
-(AccountManagerHeadView *)tableHead{
    if (!_tableHead) {
        CGFloat h = IS_IPHONE_X ? BOS_H(182) : BOS_H(158);
        _tableHead = [[AccountManagerHeadView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, h)];
    }
    return _tableHead;
}
-(AccountManagerNaviView *)accountManagerNaviView{
    if (!_accountManagerNaviView) {
        _accountManagerNaviView = [AccountManagerNaviView initAccountManagerNaviView];
        _accountManagerNaviView.backgroundColor = [UIColor clearColor];
        WeakSelf(weakSelf);
        [_accountManagerNaviView setAccountManagerBackBlock:^(UIButton * _Nonnull button) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }
    return _accountManagerNaviView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSString * accountManagerList = [[NSBundle mainBundle]pathForResource:@"AccountManagerList" ofType:@"plist"];
        NSArray * infos = [NSArray arrayWithContentsOfFile:accountManagerList];
        for (NSArray * section in infos) {
            NSMutableArray * temp = [NSMutableArray arrayWithCapacity:section.count];
            for (NSDictionary * dict in section) {
                AccountManagerModel * model = [AccountManagerModel initModelWithObject:dict];
                [temp addObject:model];
            }
             [_dataArray addObject:temp];
        }
    }
    return _dataArray;
}
#pragma mark --> 🐷 Setter and getter 🐷
-(void)setCurrentModel:(AccountListModel *)currentModel{
    _currentModel = currentModel;
    self.tableHead.walletLabel.text = _currentModel.accountName;
    self.tableHead.balanceLabel.text = _currentModel.balance;
}
-(void)initSubViews{
    self.view.backgroundColor = BACKGROUNDCOLOR;
    
    self.accountManagerNaviView.titleLabel.text = NSLocalizedString(@"账号管理", nil);
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.tableHead;
    [self.view addSubview:self.accountManagerNaviView];
    
    WeakSelf(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.top.equalTo(weakSelf.view);
    }];
}
@end

@implementation AccountManagerNaviView
+(instancetype)initAccountManagerNaviView{
    AccountManagerNaviView * navi = [[AccountManagerNaviView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, Height_NavBar)];
    return navi;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}

-(void)backAction:(UIButton *)button{
    if (self.accountManagerBackBlock) {
        self.accountManagerBackBlock(button);
    }
}
#pragma mark --> Setter and getter


#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    
}
#pragma mark -- Lazy loading
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
        _titleLabel.textColor = COLOR(@"#FFFFFF");
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc]init];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setImage:IMAGE(@"icon_back") forState:UIControlStateNormal];
    }
    return _backButton;
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.backButton];
    [self addSubview:self.titleLabel];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    WeakSelf(weakSelf);
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf).offset(-10);
        make.leading.equalTo(weakSelf).offset(17);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.centerY.equalTo(weakSelf.backButton);
        make.width.lessThanOrEqualTo(weakSelf).mas_offset(BOS_W(100));
    }]; 
}

@end
