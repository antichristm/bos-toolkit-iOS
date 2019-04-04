////  AdvancedSetViewController.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AdvancedSetViewController.h"

@interface AdvancedSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titleArray;
@property(nonatomic,strong)NSString * cloudPassword;
@end

@implementation AdvancedSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BOS_H(10) ;
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *titles = self.titleArray[section];
    return titles.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleTableViewCell * cell = [TitleTableViewCell initWithTableView:tableView ID:@"TitleTableViewCell"];
    cell.titleString = self.titleArray[indexPath.section][indexPath.row];
    NSArray *titles = self.titleArray[indexPath.section];
    cell.line.hidden = indexPath.row + 1 == titles.count;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(50);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(weakSelf);
    if (indexPath.section) {
        [self deleteAccount];
    }else{
        switch (indexPath.row) {
            case 0:{
                PermissionsSetViewController * VC = [[PermissionsSetViewController alloc] init];
                VC.currentModel = self.currentModel;
                [self.navigationController pushViewController:VC animated:YES];
            }
                break;
            case 1:{
                [BOSExportManager selectKeys:self.currentModel title:NSLocalizedString(@"导出私钥", nil) limit:nil exist:nil  completion:^(NSString * _Nonnull enPri) {
                    if (enPri && enPri.length > 0) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf verifyPassword:enPri];
                        });
                    }else{
                        [XWHUDManager showTipHUD:NSLocalizedString(@"当前账户没有可导出权限", nil)];
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
}
-(void)verifyPassword:(NSString * )enPrivate{
    WeakSelf(weakSelf);
    [BOSExportManager verifyPassword:enPrivate completion:^(BOOL result, NSString * _Nonnull password,NSString * dePrivate) {
        if (result && dePrivate) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                ExportAlertViewController * vc = [[ExportAlertViewController alloc] init];
                vc.navigationItem.title = NSLocalizedString(@"导出私钥", nil);
                vc.key = dePrivate;
                vc.isprivate = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                weakSelf.currentModel.isBackup = YES;
                [[BOSWCDBManager sharedManager]BOSUpdateIsBackupWithModel:weakSelf.currentModel];
            });
        }else{
            [XWHUDManager showErrorTipHUD:NSLocalizedString(@"密码错误", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf verifyPassword:enPrivate];
            });
        }
    }];
}
-(void)deleteAccount{
    WeakSelf(weakSelf);
    PassWorldView * view = [[PassWorldView alloc]init];
    view.title = NSLocalizedString(@"删除账户", nil);
    [view showView];
    [view setPasswordBlock:^(NSString * _Nonnull password) {
        NSDictionary * keyInfo = self.currentModel.keys.mj_JSONObject;
        NSDictionary * ranInfo = keyInfo.allValues.firstObject;
        NSString * enPrivate = ranInfo[@"private"];
        NSString * private = [[EOSTools shared]DecryptWith:enPrivate password:password];
        BOOL ver = [PassWordTool verifyPassword:password];
        if (ver && private) {
            BOOL result =  [[BOSWCDBManager sharedManager]BOSDeleteAccountWhereAccountName:self.currentModel.accountName];
            if (result) {
                [XWHUDManager showTipHUD:NSLocalizedString(@"删除成功", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf deleteCloud];
                });
            }else{
                [XWHUDManager showTipHUD:NSLocalizedString(@"删除失败", nil)];
            }
        }else{
            [XWHUDManager showErrorTipHUD:NSLocalizedString(@"密码错误", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf deleteAccount];
            });
        }
    }];
}
-(void)deleteCloud{
    WeakSelf(weakSelf);
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"是否删除云端备份", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (![OneDriveManager sharedManager].client) {
            [[OneDriveManager sharedManager]login:^(BOOL result) {
                if (result) {
                    [weakSelf deleteKeyWithCloudPassword:weakSelf.cloudPassword];
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"删除取消", nil) type:2];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                        });
                    });
                }
            }];
        }else{
            [weakSelf deleteKeyWithCloudPassword:nil];
        }
    }]];
    [weakSelf presentViewController:alert animated:YES completion:nil];
}
-(void)deleteKeyWithCloudPassword:(NSString *)password{
    WeakSelf(weakSelf);
    [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"删除中......", nil) type:3];
    [[OneDriveManager sharedManager]getBackupAccountModelsWithPassWord:password completion:^(NSArray<NSDictionary *> * _Nonnull origin, NSArray<AccountListModel *> * _Nonnull models, NSError * _Nonnull error) {
        if (error) {
            [XWHUDManager hide];
            if (error.code == -10005) {
                if (weakSelf.cloudPassword && weakSelf.cloudPassword.length != 0) {                
                    [[OneDriveManager sharedManager]showHudMessage:NSLocalizedString(@"密码错误", nil) type:2];
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    PassWorldView * view = [[PassWorldView alloc]init];
                    view.title = NSLocalizedString(@"云端加密密码", nil);
                    view.isShowForget = NO;
                    [view showView];
                    [view setPasswordBlock:^(NSString * _Nonnull password) {
                        weakSelf.cloudPassword = password;
                        if (password && password.length > 0) {
                            [weakSelf deleteKeyWithCloudPassword:password];
                        }else{
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                            });
                        }
                    }];
                });
                return ;
            }else{
                [XWHUDManager hide];
                [XWHUDManager showErrorTipHUD:NSLocalizedString(@"OneDrive删除失败", nil)];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                });
                return ;
            }
        }
        NSMutableArray * copy = models.mutableCopy;
        NSMutableArray * deletes = [NSMutableArray array];
        
        for (AccountListModel * model in copy) {
            if ([model.accountName isEqualToString:self.currentModel.accountName]) {
                [deletes addObject:model];
            }
        }
        if (deletes.count > 0) {
            [copy removeObjectsInArray:deletes];
            [[OneDriveManager sharedManager]backupAccounts:copy  password:password completion:^(NSError * _Nonnull error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [XWHUDManager hide];
                    if (!error) {
                        [XWHUDManager showTipHUD:NSLocalizedString(@"OneDrive删除成功", nil)];
                    }else{
                        [XWHUDManager showTipHUD:NSLocalizedString(@"OneDrive删除失败", nil)];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    });
                });
                
            }];
        }else{
            [XWHUDManager hide];
            [XWHUDManager showTipHUD:NSLocalizedString(@"OneDrive未备份", nil)];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
            NSLog(@"云端未备份");
        }
    }];
}
- (void)createUI {
    self.title = NSLocalizedString(@"高级配置", nil);
    self.view.backgroundColor = COLOR(@"F6F6F9");
    [self.view addSubview:self.tableview];
    WeakSelf(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"F6F6F9") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:50 superView:nil];
        _tableview.scrollEnabled = NO;
    }
    return _tableview;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@[NSLocalizedString(@"权限管理", nil),NSLocalizedString(@"导出私钥", nil)], @[NSLocalizedString(@"删除账号", nil)]];
    }
    return _titleArray;
}

@end
