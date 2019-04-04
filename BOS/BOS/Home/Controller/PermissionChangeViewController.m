////  PermissionChangeViewController.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "PermissionChangeViewController.h"

@interface PermissionChangeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITableViewCell *bottomCell;//底部的cell
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) PassWorldView *passwordView;
@property (nonatomic, strong) EOSKeyModel *keyModel;

@end

@implementation PermissionChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createUI];
   
}
//点击修改，提示用户备份
- (void)sureChange {
     [self getUserAuthorization];
}
//获取用户授权,解密私钥
-(void)getUserAuthorization{
//       NSLog(@"修改权限上传新的工钥了\n%@ \n%@",publicKey,privateKey);
   //密码验证
    NSString * ownerkey = nil;
     NSDictionary * dic = self.currentModel.keys.mj_JSONObject;
    for (NSString * key in dic) {
        if ([key hasSuffix:@"_owner"]) {
            //
            NSDictionary * subDic = dic[key];
            ownerkey = subDic[@"private"];
            break;
        }
    }
    if (ownerkey) {
        WeakSelf(weakSelf);
        self.passwordView.passwordBlock = ^(NSString * _Nonnull password) {
          NSString * ownerPrivateKey =  [[EOSTools shared] DecryptWith:ownerkey password:password];
            //修改权限
            if (ownerPrivateKey.length > 0) {
                [weakSelf changePerimissionWithOwnerkey:ownerPrivateKey passWord:password];
            }else{
                [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
            }
        };
        [self.passwordView showView];
    }else{
        [XWHUDManager showTipHUD:NSLocalizedString(@"请导入owner权限再进行操作", nil)];
    }
}
//发起修改
-(void)changePerimissionWithOwnerkey:(NSString *)ownerkey passWord:(NSString *)passWord{
    NSString * newPubkey = self.keyModel.publicKey;
    NSString * newPrivateKey = self.keyModel.privateKey;
    NSString * account = self.currentModel.accountName;
    NSString * permission = self.permissionName;
    NSString * parent = [self.permissionName isEqualToString:@"active"] ? @"owner" :@"" ;
    //替换原来的公钥
    NSDictionary * auth = nil;
    for (keysItem * item in self.permissionAuth.keys) {
        if ([item.key isEqualToString:self.permissionKey]) {
            //这个公钥要替换成新的公钥
            item.key = newPubkey;
            auth = self.permissionAuth.mj_JSONObject;
            item.key = self.permissionKey;
            break;
        }
    }
    NSDictionary * dict = @{
                            @"account" :account,
                            @"permission" : permission,
                            @"parent" : parent,
                            @"auth": auth
                            };
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            @"eosio",@"code",
                            @"updateauth",@"action",
                            dict,@"args",nil];
    WeakSelf(weakSelf);
    [XWHUDManager showHUDMessage:NSLocalizedString(@"修改权限中...", nil)];
    [[EOSTools shared] eosActions:@[params] actor:self.currentModel.accountName permission:@"owner" privateKey:ownerkey success:^(id  _Nonnull responseObject) {
        [XWHUDManager hideInWindow];
        //修改权限成功，导入新的权限
        [weakSelf changeAccountListModelWithNewPubkey:newPubkey privateKey:newPrivateKey passWord:passWord];
        BOOL isSuccess = [[BOSWCDBManager sharedManager] BOSUpdateAccountWithModel:weakSelf.currentModel];
        if (isSuccess) {
            [XWHUDManager showTipHUD:NSLocalizedString(@"权限修改成功", nil)];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [XWHUDManager showTipHUD:NSLocalizedString(@"权限修改成功,本地数据修改失败", nil)];
        }
        
    } failure:^(id  _Nonnull failure, id  _Nonnull message) {
        [XWHUDManager hideInWindow];
        NSError * error = (NSError *)message;
        [XWHUDManager showTipHUD:error.localizedDescription];
    }];
    
}

-(void)changeAccountListModelWithNewPubkey:(NSString *)pubkey privateKey:(NSString *)privateKey passWord:(NSString *)passWord{
    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:self.currentModel.keys.mj_JSONObject];
    NSString * oldKey = [NSString stringWithFormat:@"%@_%@",self.permissionKey,self.permissionName];
     NSString * newKey = [NSString stringWithFormat:@"%@_%@",pubkey,self.permissionName];
    NSString * newPrivete = [[EOSTools shared] EncryptWith:privateKey password:passWord];
    NSDictionary * detailDic = @{@"permission":self.permissionName,@"private":newPrivete};
    [dic removeObjectForKey:oldKey];
    [dic setObject:detailDic forKey:newKey];
    self.currentModel.keys = dic.mj_JSONString;
    
}



#pragma mark - 处理界面
- (void)createUI {
    self.view.backgroundColor = COLOR(@"F6F6F9");
    [self.view addSubview:self.tableview];
    self.title = NSLocalizedString(@"更改权限", nil);
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
    if (section == 2) {
         return BOS_H(65) ;
    } else {
         return BOS_H(10) ;
    }
   
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
         return 1;
    } else {
         return 2;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AccountNameTableViewCell * cell = [AccountNameTableViewCell initWithTableView:tableView ID:@"AccountNameTableViewCell"];
            cell.leftString = [self.permissionTitle?:@"" stringByAppendingString:NSLocalizedString(@"（当前）", nil)];
            return cell;
        } else {
            TextTableViewCell * cell = [TextTableViewCell initWithTableView:tableView ID:@"TextTableViewCell"];
            cell.backgroundColor = COLOR(@"FFFFFF");
            cell.message = self.permissionKey;
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            SingleKeyTableViewCell * cell = [SingleKeyTableViewCell initWithTableView:tableView ID:@"SingleKeyTableViewCell"];
            cell.rightBtnString = NSLocalizedString(@"生成新公钥", nil);
            cell.detailString = self.keyModel.publicKey;
            cell.titleString = NSLocalizedString(@"公钥（更改）", nil);
            WeakSelf(weakSelf);
            cell.block = ^(NSString * _Nonnull title, NSString * _Nonnull detail) {
                weakSelf.keyModel = [[EOSTools shared] getEOSKey];
                [weakSelf.tableview reloadData];
            };
         return cell;
        } else {
            TextTableViewCell * cell = [TextTableViewCell initWithTableView:tableView ID:@"TextTableViewCell"];
            cell.attMessage = [self message];
            return cell;
        }
        
    } else {
         return self.bottomCell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                  return BOS_H(50);
            } else {
                return UITableViewAutomaticDimension;
            }
          
        }
            break;
        case 1:
        {
            if (indexPath.row == 0) {
                return BOS_H(145);
            } else {
                return UITableViewAutomaticDimension;
            }
           
        }
            break;
        case 2:
        {
            return BOS_W(45);
            
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
    }
    return _tableview;
}

- (NSAttributedString *)message {
    NSAttributedString * alert = [BOSTools attributString:NSLocalizedString(@"注意:\n", nil) color:COLOR(@"#E65062") font:FONT(13) Spac:5 textAligment:0 attribute:nil];
    NSAttributedString * message = [BOSTools attributString:NSLocalizedString(@"如果更换公钥为当前使用的公钥，更换后需重新导入变更后私钥", nil) color:COLOR(@"#968585") font:FONT(12) Spac:5 textAligment:0 attribute:nil];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    [att appendAttributedString:alert];
    [att appendAttributedString:message];
    return att;
}

-(UITableViewCell *)bottomCell {
    if (!_bottomCell) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton * button = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(sureChange) text:NSLocalizedString(@"确认修改", nil) image:nil cornerRadius:3 superView:cell];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.height.equalTo(cell);
            make.width.equalTo(cell).mas_offset( - BOS_W(30));
        }];
        _bottomCell = cell;
    }
    return _bottomCell;
}
-(AlertView *)alertView{
    if (!_alertView) {
        _alertView = [[AlertView alloc] init];
        _alertView.titleStr = NSLocalizedString(@"注意", nil);
        _alertView.detailStr = NSLocalizedString(@"当前正在变更账户权限，请确认你已经备份好最新私钥", nil);
        _alertView.cancelTitle = NSLocalizedString(@"我已备份", nil);
        _alertView.sureTitle = NSLocalizedString(@"立即备份", nil);
        
    }
    return _alertView;
}
-(PassWorldView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[PassWorldView alloc] init];
    }
    return _passwordView;
}

- (EOSKeyModel *)keyModel {
    if (!_keyModel) {
        _keyModel = [[EOSTools shared] getEOSKey];
    }
    return _keyModel;
}

@end
