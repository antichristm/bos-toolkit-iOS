////  RedPacketBosCreateAccountViewController.m
//  BOS
//
//  Created by BOS on 2019/1/4.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketBosCreateAccountViewController.h"

@interface RedPacketBosCreateAccountViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITableViewCell *bottomCell;

@property (nonatomic, strong) AccountKeyListAlertView *chooseAccountView;
@property (nonatomic, strong) NSArray *accountListArr;
@property (nonatomic, strong) AccountListModel *selectAccount;

@property (nonatomic, strong) PassWorldView *passView;
@property (nonatomic, copy) NSString *password;

@end

@implementation RedPacketBosCreateAccountViewController
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
}
- (void)sureClick {
    NSLog(@"点击转账");
    FieldTableViewCell * cell = [self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * bos = cell.field.text;
    if (bos.doubleValue > 0.1) {
//       选择账号
        WeakSelf(weakSelf);
        self.chooseAccountView.Block = ^(NSArray * _Nonnull selectArray) {
            weakSelf.selectAccount = weakSelf.accountListArr[[selectArray.firstObject integerValue]];
            NSDictionary * permission = [weakSelf permission];
            if (!permission) {
                [XWHUDManager showTipHUD:NSLocalizedString(@"请导入active权限再进行操作", nil)];
                return;
            }
            [weakSelf createAccountWithBos:bos permission:permission];
        };
        [self.chooseAccountView showView];
    }else{
        [XWHUDManager showTipHUD:NSLocalizedString(@"输入金额过小", nil)];
    }
}

- (void)createAccountWithBos:(NSString *)bos permission:(NSDictionary *)permissionDic{
    WeakSelf(weakSelf);
    self.passView.passwordBlock = ^(NSString * _Nonnull password) {
        
        NSString *private = [[EOSTools shared] DecryptWith:permissionDic[@"private"] password:password];
        if (private.length > 0) {
            weakSelf.password  = password;
            NSArray * array = [weakSelf.memo componentsSeparatedByString:@"^"];
            [XWHUDManager showHUDMessage:NSLocalizedString(@"账号创建中", nil)];
            [RedPacketTool createAccountFromTransferWithNewAccountName:array[1] ownerPublicKey:array[2] activePublicKey:array[3] selfAccountName:weakSelf.selectAccount.accountName selfPrivateKey:private currentPermission:permissionDic[@"permission"] amount:bos success:^(id  _Nonnull responseObject) {
                [XWHUDManager hideInWindow];
                //创建成功
                 [weakSelf localSaveAccountWithName:array[1] privateKey:weakSelf.privateKey pubKey:array[2]];
                
            } failure:^(id  _Nonnull failure, id  _Nonnull message) {
                [XWHUDManager hideInWindow];
                NSError * error = (NSError *)message;
                [XWHUDManager showTipHUD:error.localizedDescription];
            }];
        }else {
            [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
        }
    };
   [self.passView showView];
   
}

-(NSDictionary *)permission{
    NSDictionary * dic = self.selectAccount.keys.mj_JSONObject;
    for (NSString * key in dic) {
        if ([key hasSuffix:@"_active"]) {
            return dic[key];
        }
    }
    return nil;
}
-(void)localSaveAccountWithName:(NSString *)accountName privateKey:(NSString *)privateKey pubKey:(NSString *)pubkey{
    NSLog(@"创建成功，私钥导入");
    WeakSelf(weakSelf);
    [XWHUDManager showHUDMessage:NSLocalizedString(@"账号复查中", nil)];
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
            [BOSImportManager importWithType:BOSImportTypePrivate info:@{@"content":privateKey} locPass:weakSelf.password completion:^(NSDictionary * _Nonnull info) {
                if ([info[@"code"] integerValue] == 10000 || [info[@"code"] integerValue] == 10004) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [XWHUDManager showTipHUD:NSLocalizedString(@"数据库插入失败", nil)];
                }
            }];
        }
    }, ^(id  _Nonnull failure, id  _Nonnull message) {
        [XWHUDManager hideInWindow];
        [XWHUDManager showTipHUD:message];
    });
}

- (void)createUI{
    self.title = NSLocalizedString(@"创建EOS账号", nil);
    self.view.backgroundColor = COLOR(@"FFFFFF");
    [self.view addSubview:self.tableview];
    WeakSelf(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.height.equalTo(weakSelf.view);
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [BOSTools viewWithFrame:CGRectZero color:COLOR(@"f5f5f5") cornerRadius:0 superView:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BOS_H(10);
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            {
                FieldTableViewCell * cell = [FieldTableViewCell initWithTableView:tableView ID:@"FieldTableViewCellFrist"];
                cell.titleString = NSLocalizedString(@"收款账户", nil);
                cell.field.text = KGetRedPacketName;
                cell.rightButton.hidden = NO;
                cell.field.userInteractionEnabled = NO;
                return cell;
                
            }
            break;
        case 1:
        {
            FieldTableViewCell * cell = [FieldTableViewCell initWithTableView:tableView ID:@"FieldTableViewCell"];
            cell.titleString = NSLocalizedString(@"转账金额", nil);
            UILabel * label = [BOSTools labelWithFrame:CGRectMake(0, 0, BOS_W(60), BOS_W(30)) font:FONT(14) color:COLOR(@"333333") alpha:1 textAlignment:NSTextAlignmentCenter text:@"BOS" superView:nil];
            cell.field.customRightView = label;
            cell.placeString = @"0.1000";
            cell.field.maxLength = 15;
            cell.field.limitedType = TYLimitedTextFieldTypeNumber;
            return cell;
            
        }
            break;
        case 2:
        {
            SingleKeyTableViewCell * cell = [SingleKeyTableViewCell initWithTableView:tableView ID:@"SingleKeyTableViewCell"];
            cell.titleString = NSLocalizedString(@"备注", nil);
            cell.detailString = self.memo;
            cell.rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            cell.rightButton.backgroundColor = [UIColor clearColor];
            [cell.rightButton setImage:IMAGE(@"bos_icon_fuzhi_default") forState:UIControlStateNormal];
            [cell.rightButton setTitle:NSLocalizedString(@" 复制", nil) forState:UIControlStateNormal];
            [cell.rightButton setTitleColor:COLOR(@"#A2AAB6") forState:UIControlStateNormal];
            cell.textview.editable = YES;
            cell.block = ^(NSString * _Nonnull title, NSString * _Nonnull detail) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = detail;
                [XWHUDManager showTipHUD:NSLocalizedString(@"复制成功", nil)];
            };
            return cell;
        }
            break;
        case 3:
        {
            TextTableViewCell * cell = [TextTableViewCell initWithTableView:tableView ID:@"TextTableViewCell"];
            NSAttributedString * title = [BOSTools attributString:NSLocalizedString(@"转账提示\n", nil) color:COLOR(@"#E65062") font:FONTNAME(@"HelveticaNeue", 14) Spac:3 textAligment:NSTextAlignmentLeft attribute:nil];
              NSAttributedString * detail = [BOSTools attributString:NSLocalizedString(@"转账时须加上备注，同时确认收款地址", nil) color:COLOR(@"#968585") font:FONTNAME(@"HelveticaNeue", 12) Spac:3 textAligment:NSTextAlignmentLeft attribute:nil];
            NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
            [att appendAttributedString:title];
            [att appendAttributedString:detail];
            cell.attMessage = att;
            return cell;
        }
            break;
        case 4:
        {
            return self.bottomCell;
            
        }
            break;
        default:
            return [[UITableViewCell alloc] init];
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        case 1:
        {
            return BOS_H(90);
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
        case 4:
        {
            return BOS_H(130);
        }
            break;
        default:
            return UITableViewAutomaticDimension;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"FFFFFF") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:BOS_H(100) superView:nil];
    }
    return _tableview;
}
-(UITableViewCell *)bottomCell {
    if (!_bottomCell) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton * button = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:COLOR(@"#CE2344") target:self action:@selector(sureClick) text:NSLocalizedString(@"创建账户", nil) image:nil cornerRadius:3 superView:cell];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(cell);
            make.width.equalTo(cell).mas_offset( - BOS_W(30));
            make.height.mas_equalTo(BOS_W(43));
        }];
        _bottomCell = cell;
    }
    return _bottomCell;
}

- (NSArray *)accountListArr{
    if (!_accountListArr) {
        _accountListArr = [[BOSWCDBManager sharedManager]BOSSelectedAllObjectFromTable:BOSDBAccountTableName objClass:AccountListModel.class];
    }
    return _accountListArr;
}

- (AccountKeyListAlertView *)chooseAccountView {
    if (!_chooseAccountView) {
        _chooseAccountView = [[AccountKeyListAlertView alloc] init];
        NSMutableArray * nameArr = [NSMutableArray array];
        for (AccountListModel * model in self.accountListArr) {
            [nameArr addObject:model.accountName?:@""];
        }
        _chooseAccountView.dataArr = nameArr;
        _chooseAccountView.titleString = NSLocalizedString(@"选择支付账户", nil);
        _chooseAccountView.sureString = NSLocalizedString(@"确认", nil);
        _chooseAccountView.sureColor = COLOR(@"#BF1E3D");
    }
    return _chooseAccountView;
}
-(PassWorldView *)passView {
    if (!_passView) {
        _passView = [[PassWorldView alloc] init];
    }
    return _passView;
}

@end
