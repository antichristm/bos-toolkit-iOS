////  PermissionsSetViewController.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "PermissionsSetViewController.h"

@interface PermissionsSetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) EOSAccountModel *Model;
@property (nonatomic, strong) NSArray *ownerArr;
@property (nonatomic, strong) NSArray *activeArr;
@property (nonatomic, strong) required_auth *ownerAuth;
@property (nonatomic, strong) required_auth *activeAuth;

@end

@implementation PermissionsSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
     [self requestAccount];
}
-(void)requestAccount{
    WeakSelf(weakSelf);
    EOS_API_get_account(@{@"account_name":self.currentModel.accountName}, ^(id  _Nonnull responseObject) {
        EOSAccountModel * model = [EOSAccountModel mj_objectWithKeyValues:responseObject];
        weakSelf.Model = model;
        for (permissionsItem * item in model.permissions) {
            if ([item.perm_name isEqualToString:@"owner"]) {
                //owner权限
                NSArray * keys = item.required_auth.keys;
                NSMutableArray * arr = [NSMutableArray array];
                for (keysItem * keyItem in keys) {
                    [arr addObject:keyItem.key];
                }
                if (arr.count > 0) {
                    weakSelf.ownerArr = [NSArray arrayWithArray:arr];
                }
                weakSelf.ownerAuth = item.required_auth;
                
            } else if ([item.perm_name isEqualToString:@"active"]) {
                //active权限
                NSArray * keys = item.required_auth.keys;
                NSMutableArray * arr = [NSMutableArray array];
                for (keysItem * keyItem in keys) {
                    [arr addObject:keyItem.key];
                }
                if (arr.count > 0) {
                    weakSelf.activeArr = [NSArray arrayWithArray:arr];
                }
                 weakSelf.activeAuth = item.required_auth;
            } else {
                //其他权限不显示
            }
        }
        [weakSelf.tableview reloadData];
    }, ^(id  _Nonnull failure, id  _Nonnull message) {
        // 网络请求错误
    });
}
- (void)createUI {
    self.view.backgroundColor = COLOR(@"F6F6F9");
    [self.view addSubview:self.tableview];
    self.title = NSLocalizedString(@"权限管理", nil);
    WeakSelf(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section) {
        return 0.1f;
    } else {
        return BOS_H(10) ;
    }
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            {
                return 1;
            }
            break;
        case 1:
        {
            return self.ownerArr.count;
        }
            break;
        case 2:
        {
            return self.activeArr.count;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
        default:
            return 0;
            break;
    }
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            {
                AccountNameTableViewCell * cell = [AccountNameTableViewCell initWithTableView:tableView ID:@"AccountNameTableViewCell"];
                cell.leftString = NSLocalizedString(@"账号名", nil);
                cell.attRightString = [BOSTools attributString:self.currentModel.accountName color:TEXTCOLOR font:FONT(20) Spac:0 textAligment:0 attribute:nil];
                return cell;
            }
            break;
        case 1:
        {
            SingleKeyTableViewCell * cell = [SingleKeyTableViewCell initWithTableView:tableView ID:@"SingleKeyTableViewCell"];
            cell.titleString = @"Owner Key";
            cell.detailString = self.ownerArr[indexPath.row];
            WeakSelf(weakSelf);
            cell.block = ^(NSString * _Nonnull title, NSString * _Nonnull detail) {
                PermissionChangeViewController * VC = [[PermissionChangeViewController alloc] init];
                  VC.currentModel = self.currentModel;
                VC.permissionTitle = title;
                VC.permissionName = @"owner";
                VC.permissionKey = detail;
                VC.permissionAuth = weakSelf.ownerAuth;
                 [weakSelf.navigationController pushViewController:VC animated:YES];
            };
            return cell;
            
        }
            break;
        case 2:
        {
            SingleKeyTableViewCell * cell = [SingleKeyTableViewCell initWithTableView:tableView ID:@"SingleKeyTableViewCell"];
            cell.titleString = @"Active Key";
            cell.detailString = self.activeArr[indexPath.row];
            WeakSelf(weakSelf);
            cell.block = ^(NSString * _Nonnull title, NSString * _Nonnull detail) {
                PermissionChangeViewController * VC = [[PermissionChangeViewController alloc] init];
                VC.currentModel = self.currentModel;
                VC.permissionTitle = title;
                VC.permissionName = @"active";
                VC.permissionKey = detail;
                VC.permissionAuth = weakSelf.activeAuth;
                [weakSelf.navigationController pushViewController:VC animated:YES];
            };
            return cell;
        }
            break;
        case 3:
        {
            TextTableViewCell * cell = [TextTableViewCell initWithTableView:tableView ID:@"TextTableViewCell"];
            cell.attMessage = [self message];
            return cell;
        }
            break;
            
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            {
                return BOS_H(50);
            }
            break;
        case 1:
        {
             return BOS_H(140);
        }
            break;
        case 2:
        {
            return BOS_H(140);
        }
            break;
        case 3:
        {
            return UITableViewAutomaticDimension;
        }
            break;
            
        default:
            return BOS_H(50);
            break;
    }
  
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
}

- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"F6F6F9") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:50 superView:nil];
        _tableview.scrollEnabled = NO;
    }
    return _tableview;
}

- (NSAttributedString *)message {
    NSAttributedString * alert = [BOSTools attributString:NSLocalizedString(@"注意:\n", nil) color:COLOR(@"#E65062") font:FONT(13) Spac:5 textAligment:0 attribute:nil];
    NSAttributedString * message = [BOSTools attributString:NSLocalizedString(@"1、 Owner：拥有当前EOS账户的所有权限\n2、Active：默认情况下，可以完成除更改Owner以外的所有交易\n3、为了您的资产安全，建议使用 Active 权限导入钱包日常使用 ", nil) color:COLOR(@"#968585") font:FONT(12) Spac:5 textAligment:0 attribute:nil];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    [att appendAttributedString:alert];
    [att appendAttributedString:message];
    return att;
}


@end
