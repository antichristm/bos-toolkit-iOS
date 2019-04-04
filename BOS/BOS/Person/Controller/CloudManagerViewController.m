////  CloudManagerViewController.m
//  BOS
//
//  Created by BOS on 2018/12/25.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "CloudManagerViewController.h"

@interface CloudManagerViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)UIButton * editButton;
@property(nonatomic,strong)UIButton * sureButton;
@property(nonatomic,strong)NSString * locPassword;
@end
static NSString * const CloudManagerCellID = @"CloudManagerCellID";
@implementation CloudManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}
#pragma mark  🐷Life cycle🐷
#pragma mark  🐷System Delegate🐷
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(80);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    ImportCloudListCell * cell = [ImportCloudListCell initWithTableView:tableView cellID:CloudManagerCellID];
    cell.model = accountModel;
    cell.selectedButton.hidden = YES;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    NSLog(@"--->%@",accountModel.keys);
}
#pragma mark  🐷Custom Delegate🐷
#pragma mark  🐷Event  Response🐷
-(void)editAction:(UIButton *)button{
    WeakSelf(weakSelf);
    if ([OneDriveManager sharedManager].client) {
        [[OneDriveManager sharedManager]logout:^(NSInteger result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result == 1) {
                    weakSelf.editButton.selected = NO;
                }else if (result == 0){
                    weakSelf.editButton.selected = YES;
                }else{
                    weakSelf.editButton.selected = NO;
                }
            });
        }];
    }else{
        [self login:^(BOOL result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [XWHUDManager showTipHUD:NSLocalizedString(result ? @"登录成功" : @"登录失败",   nil)];
            });
        }];
    }
}
-(void)sureAction:(UIButton *)button{
    if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
        return;
    }
    WeakSelf(weakSelf);
    [self passwordView:NSLocalizedString(@"本地密码", nil) result:^(NSString * _Nonnull password) {
        if ([PassWordTool verifyPassword:password]) {
            weakSelf.locPassword = password;
            [weakSelf synchronization];
        }else{
            [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
        }
    }];
}
-(void)synchronization{
    WeakSelf(weakSelf);
    if ([OneDriveManager sharedManager].client) {
        [weakSelf backUpToCloud];
    }else{
        [self login:^(BOOL result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result) {
                    [weakSelf backUpToCloud];
                }else{
                    [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"同步失败", nil) type:2];
                }
            });
        }];
    }
}
#pragma mark  🐷Private Methods🐷
//获取云端数据
-(void)getCloudAccount:(NSString *)password{
    WeakSelf(weakSelf);
    if (![OneDriveManager sharedManager].client) {
        [self login:^(BOOL result) {
            if (result) {
                [weakSelf getBackupAccountModels:password];
            }else{
                [weakSelf.tableView.mj_header endRefreshing];
                [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"OneDrive登录失败", nil) type:2];
            }
        }];
    }else{
        self.editButton.selected = YES;
        [self getBackupAccountModels:password];
    }
}
//获取云端数据模型
-(void)getBackupAccountModels:(NSString *)password{
    WeakSelf(weakSelf);
    [[OneDriveManager sharedManager]getBackupAccountModelsWithPassWord:password completion:^(NSArray<NSDictionary *> * _Nonnull origin, NSArray<AccountListModel *> * _Nonnull models, NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataArray = models.mutableCopy;
                [weakSelf.tableView reloadData];
            });
        }else{
            if (error.code == -10001) {
                [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"获取失败", nil) type:2];
            }else if(error.code == -1001){
                [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"请求超时", nil) type:2];
            }else if(error.code == -10005){
                if (weakSelf.locPassword && weakSelf.locPassword.length != 0) {
                    [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"密码错误", nil) type:2];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf passwordView:NSLocalizedString(@"云端加密密码", nil) result:^(NSString * _Nonnull password) {
                        if (password) {
                            weakSelf.locPassword = password;
                            [weakSelf.tableView.mj_header beginRefreshing];
                        }
                    }];
                });
            }else{
                [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"获取失败", nil) type:2];
            }
        }
    }];
}
-(void)synchronizationFromCloud{
    [XWHUDManager showHUDMessage:NSLocalizedString(@"导入中......", nil)];
    [BOSImportManager synchronizationFromCloudAccounts:self.dataArray completion:^(NSDictionary * _Nonnull info) {
        [XWHUDManager hide];
        NSString * code = info[@"code"];
        [BOSImportManager showFailMessage:code.integerValue message:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (code.integerValue == 10000) {
                UIViewController * rootVC = self.navigationController.childViewControllers[0];
                if ([rootVC isKindOfClass:[FirstViewController class]]) {
                    [BOSTools RestoreRootViewController:[[BaseTabBarController alloc]init]];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        });
    }];
}
//备份至云盘
-(void)backUpToCloud{
    [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"同步中.....", nil) type:3];
    [BOSImportManager synchronizationFromCloudAccounts:self.dataArray completion:^(NSDictionary * _Nonnull info) {
        [XWHUDManager hide];
        NSString * code = info[@"code"];
        if (code.integerValue == 10000) {
            [self backupAccounts];
        }else{
            [BOSImportManager showFailMessage:code.integerValue message:NSLocalizedString(@"同步失败", nil)];
        }
    }];
}
//备份本地账户数组
-(void)backupAccounts{
    WeakSelf(weakSelf);
    [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"同步中......", nil) type:3];
    NSArray * locAccounts = [[BOSWCDBManager sharedManager]BOSSelectedAllObjectFromTable:BOSDBAccountTableName objClass:AccountListModel.class];
    [[OneDriveManager sharedManager]backupAccounts:locAccounts password:self.locPassword completion:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"同步失败", nil) type:2];
            }else{
                [[BOSWCDBManager sharedManager]BOSUpdateCloudBackupsWithValue:NSLocalizedString(@"已备份", nil)];
                [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"同步成功", nil) type:0];
                UIViewController * rootVC = weakSelf.navigationController.childViewControllers[0];
                if ([rootVC isKindOfClass:[FirstViewController class]]) {
                    [BOSTools RestoreRootViewController:[[BaseTabBarController alloc]init]];
                }else{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        });
    }];
}
-(void)login:(void(^)(BOOL result))completion{
    WeakSelf(weakSelf);
    [[OneDriveManager sharedManager]login:^(BOOL result) {
        if (completion) {
            completion(result);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                weakSelf.editButton.selected = YES;
            }else{
                weakSelf.editButton.selected = NO;
            }
        });
    }];
}
-(void)passwordView:(NSString *)title result:(void(^)(NSString * _Nonnull password))result{
    PassWorldView * alert = [[PassWorldView alloc]init];
    alert.title = title;
    [alert showView];
    [alert setPasswordBlock:result];
}
#pragma mark  🐷Lazy loading🐷
-(UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView  = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.clipsToBounds = NO;
        tableView.backgroundColor = BACKGROUNDCOLOR;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            tableView.scrollIndicatorInsets = tableView.contentInset;
        }else{
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        WeakSelf(weakSelf);
        tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getCloudAccount:weakSelf.locPassword];
        }];
        _tableView = tableView;
    }
    return _tableView;
}
-(UIButton *)editButton{
    if (!_editButton) {
        UIButton * edit = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        [edit addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
        [edit setTitle:NSLocalizedString(@"登录", nil) forState:UIControlStateNormal];
        [edit setTitle:NSLocalizedString(@"登出", nil) forState:UIControlStateSelected];
        edit.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14] ;
        _editButton = edit;
    }
    return _editButton;
}
-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [[UIButton alloc]init];
        _sureButton.backgroundColor = SUBJECTCOLOR;
        _sureButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [_sureButton setTitleColor:COLOR(@"#FFFFFF") forState:UIControlStateNormal];
        [_sureButton setTitle:NSLocalizedString(@"同步", nil) forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    for (AccountListModel * account in _dataArray) {
        NSArray * loc = [[BOSWCDBManager sharedManager]BOSSelectAccountWhereAccountName:account.accountName];
        if (loc.count > 0) {
            account.locExsit = NSLocalizedString(@"已导入", nil);
        }
        account.cloudBackups = NSLocalizedString(@"已备份", nil);
    }
    if (_dataArray.count == 0) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"尚未进行备份", nil)];
    }
}
#pragma mark --> 🐷 setter and getter 🐷
#pragma mark  🐷Init SubViews🐷
-(void)loadDefaultsSetting{
    self.view.backgroundColor = BACKGROUNDCOLOR;
}
-(void)initSubViews{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.sureButton];
    
    [self defaultLayout];
}

-(void)defaultLayout{
    WeakSelf(weakSelf);
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.sureButton.mas_top).offset(-BOS_H(8));
    }];
    
    [self.sureButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(42.5));
        make.bottom.equalTo(weakSelf.view).offset(-Height_Bottom);
    }];
}
@end
