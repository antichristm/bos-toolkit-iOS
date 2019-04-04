////  RedPacketCreateAccountViewController.m
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018 BOS. All rights reserved.
//

#import "RedPacketCreateAccountViewController.h"

@interface RedPacketCreateAccountViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate,CreatWalletTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *creatBtn;
@property (nonatomic, strong) NSMutableDictionary *submitDict;
@property (nonatomic, strong) NSArray *historyArray;
@property (nonatomic, strong) AlertView *alertView;
@property (nonatomic, strong) PassWorldView *passView;
@property (nonatomic, copy) NSString *password;
/**
 要注册的账号名在本地的记录
 */
@property (nonatomic, strong) NSMutableArray *localArr;
@end

@implementation RedPacketCreateAccountViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:COLOR(@"#CE2344")];
    self.historyArray = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:SUBJECTCOLOR];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(@"FFFFFF");
    self.title = NSLocalizedString(@"创建账户", nil);
    [self.navigationController changeNavigationBarBackgroundImage:COLOR(@"#CE2344")];
    [self creatUI];
}


- (void)creatUI{
    UIButton * button = [BOSTools buttonWithFrame:CGRectMake(0, 0, 60, 30) font:FONT(14) textColor:COLOR(@"FFFFFF") backColor:nil target:self action:@selector(rightClick) text:NSLocalizedString(@"创建历史", nil) image:nil cornerRadius:0 superView:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIButton * backBtn = [BOSTools buttonWithFrame:CGRectMake(0, 0, 30, 30) font:FONT(14) textColor:COLOR(@"FFFFFF") backColor:nil target:self action:@selector(backClick) text:nil image:IMAGE(@"icon_back") cornerRadius:0 superView:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.submitDict = [NSMutableDictionary  dictionary];
    self.tableData = [NSMutableArray array];
    NSArray *arr = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"账户",nil),@"titleStr",NSLocalizedString(@" 复制",nil),@"btnTitle",@"bos_icon_fuzhi_default",@"btnImage",NSLocalizedString(@"请输入账户名",nil),@"placeholder",NSLocalizedString(@"*12位字符，由字母a-z与数字1-5组成",nil),@"tips",@"E65062",@"tipsColor",@115,@"cellHeight", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"红包串（选填）",nil),@"titleStr",@"",@"btnTitle",@"",@"btnImage",NSLocalizedString(@"请输入红包串",nil),@"placeholder",@"",@"tips",self.redString?:@"",@"contentStr",@"",@"tipsColor",@150,@"cellHeight", nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:NSLocalizedString(@"创建提示",nil),@"titleStr",@"",@"btnTitle",@"",@"btnImage",NSLocalizedString(@"请输入红包串",nil),@"placeholder",NSLocalizedString(@"创建账号会扣除部分BOS,剩余部分会转入账号内",nil),@"tips",@"968585",@"tipsColor",@0,@"cellHeight", nil],
                    nil];
    for (NSDictionary *dict in arr) {
        CreatWalletModel *model = [CreatWalletModel mj_objectWithKeyValues:dict];
        [self.tableData addObject:model];
    }
    [self.view addSubview:self.tableView];
    WeakSelf(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).offset(Height_Bottom);
    }];
    
    [self.footerView addSubview:self.creatBtn];
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatWalletModel *model = self.tableData[indexPath.row];
    model.btnTag = indexPath.row;
    if (indexPath.row > 1) {
        NSString *CellIdentifier = @"tipsTableViewCell";
        TipsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[TipsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        [cell setCellWithModel:model];
        return cell;
    }else{
        if (indexPath.row == 0) {
            FieldTableViewCell * cell = [FieldTableViewCell initWithTableView:tableView ID:@"FieldTableViewCell"];
            cell.rightButton.hidden = NO;
            cell.titleString = NSLocalizedString(@"账户", nil);
            cell.placeString = NSLocalizedString(@"请输入账户名", nil);
            cell.tipsString = NSLocalizedString(@"*12位字符，由字母a-z与数字1-5组成", nil);
            cell.field.limitedType = TYLimitedTextFieldTypeEOS;
            cell.field.maxLength = 12;
            return cell;
        }else{
            SingleKeyTableViewCell * cell = [SingleKeyTableViewCell initWithTableView:tableView ID:@"SingleKeyTableViewCell"];
            cell.rightButton.hidden = YES;
            cell.textview.editable = YES;
            cell.placeString = NSLocalizedString(@"请输入红包串", nil);
            cell.titleString = NSLocalizedString(@"红包串（选填）", nil);
            //            NSString *CellIdentifier = @"creatWalletTableViewCell";
            //            CreatWalletTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            //            if (!cell) {
            //                cell = [[CreatWalletTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            //            }
            //            cell.selectionStyle = UITableViewCellSeparatorStyleNone;
            //            [cell setCellWithModel:model];
            //            cell.delegate = self;
            if (cell.textview.text.length < 1) {
                cell.detailString = self.redString;
            }
            return cell;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreatWalletModel *model = self.tableData[indexPath.row];
    if (model.cellHeight.doubleValue > 0) {
        return BOS_H(model.cellHeight.doubleValue);
    }
    return UITableViewAutomaticDimension;
}


#pragma mark lazyloading

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = COLOR(@"FFFFFF");
        [_tableView registerClass:[CreatWalletTableViewCell class] forCellReuseIdentifier:@"creatWalletTableViewCell"];
        [_tableView registerClass:[TipsTableViewCell class] forCellReuseIdentifier:@"tipsTableViewCell"];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _tableView.tableHeaderView = [BOSTools viewWithFrame:CGRectMake(0, 0, ScreenWidth, 10) color:COLOR(@"f5f5f5") cornerRadius:0 superView:nil];
        _tableView.estimatedRowHeight = 10;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, BOS_H(150))];
        _footerView.backgroundColor = COLOR(@"FFFFFF");
    }
    return _footerView;
}

- (UIButton *)creatBtn{
    if (!_creatBtn) {
        _creatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _creatBtn.frame = CGRectMake(15, BOS_H(55), ScreenWidth - 30, BOS_H(42.5));
        _creatBtn.layer.cornerRadius = 4;
        _creatBtn.titleLabel.font = FONTNAME(@"HelveticaNeue-Medium", 18);
        [_creatBtn setTitle:NSLocalizedString(@"创建账户", nil) forState:UIControlStateNormal];
        [_creatBtn setTitleColor:COLOR(@"FFFFFF") forState:UIControlStateNormal];
        _creatBtn.backgroundColor = COLOR(@"#CE2344");
        [_creatBtn addTarget:self action:@selector(createClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _creatBtn;
}

#pragma mark Action and Delegate
- (void)backClick {
//    if (self.isFrist) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)rightClick {
    RedPacketCreateAccountHistoryViewController * VC = [[RedPacketCreateAccountHistoryViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)createClick{
    FieldTableViewCell * accountNameCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    SingleKeyTableViewCell * redStringCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString * accountName = accountNameCell.field.text;
    NSString * redString = redStringCell.textview.text;
    
    if (accountName.length != 12) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"用户名不正确", nil)];
        return;
    }
    WeakSelf(weakSelf);
    [XWHUDManager showHUDMessage:NSLocalizedString(@"验证账户名", nil)];
    EOS_API_get_account(@{@"account_name":accountName}, ^(id  _Nonnull responseObject) {
        [XWHUDManager hideInWindow];
        NSMutableArray * localArr = [NSMutableArray array];
        for (HistoryAccountModel * model in weakSelf.historyArray) {
            if ([model.accountName isEqualToString:accountName]) {
                [localArr addObject:model];
            }
        }
        if (localArr.count > 0) {
            weakSelf.localArr = localArr;
            //提示本地有记录
            [weakSelf.alertView ShowView];
        }else{
            [XWHUDManager showTipHUD:NSLocalizedString(@"账户名已存在", nil)];
        }
        return ;
    }, ^(id  _Nonnull failure, id  _Nonnull message) {
        [XWHUDManager hideInWindow];
        //开始注册流程
        if (redString.length < 1){
            [self createAccountWithBosWithName:accountName];
            return;
        }
        NSData * data = redString.dataFromBase58;
        NSString * newRed = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray * array = [newRed componentsSeparatedByString:@"^"];
        if (array.count >= 3) {
            RedPacketType redType = [array[0] intValue];
            if (redType == RedPacketTypeCreateAccount) {
                [self createAccountWithHB:array name:accountName];
            } else {
                [XWHUDManager showTipHUD:NSLocalizedString(@"红包类型错误", nil)];
                return;
            }
        }else{
            [XWHUDManager showTipHUD:NSLocalizedString(@"格式错误", nil)];
            return;
        }
    });
    
}

- (void)createAccountWithBosWithName:(NSString *)name{
    RedPacketBosCreateAccountViewController * VC = [[RedPacketBosCreateAccountViewController alloc] init];
    EOSKeyModel * keys = [[EOSTools shared] getEOSKey];
    [self insertAccountWithName:name privatekey:keys.privateKey publicKey:keys.publicKey];
    NSString * memo = [NSString stringWithFormat:@"act^%@^%@^%@",name,keys.publicKey,keys.publicKey];
    VC.privateKey = keys.privateKey;
    VC.memo = memo;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)createAccountWithHB:(NSArray *)array name:(NSString *)name {
    WeakSelf(weakSelf);
    self.passView.passwordBlock = ^(NSString * _Nonnull password) {
        BOOL isSuccess = [PassWordTool verifyPassword:password];
        if (isSuccess) {
            weakSelf.password = password;
            NSString * ID = array[1];
            NSString * pri = array[2];
            EOSKeyModel * keys = [[EOSTools shared] getEOSKey];
            [XWHUDManager showHUDMessage:NSLocalizedString(@"账号创建中", nil)];
            [RedPacketTool CreatAccountWithRedID:ID redPacketPriKey:pri newAccountName:name accoountOwnerPublicKey:keys.publicKey accountActivePublicKey:keys.publicKey success:^(id  _Nonnull responseObject) {
                [XWHUDManager hideInWindow];
                [weakSelf insertAccountWithName:name privatekey:keys.privateKey publicKey:keys.publicKey];
                [weakSelf localSaveAccountWithName:name privateKey:keys.privateKey pubKey:keys.publicKey];
                
            } failure:^(id  _Nonnull failure, id  _Nonnull message) {
                [XWHUDManager hideInWindow];
                NSError * error = (NSError *)message;
                [XWHUDManager showTipHUD:error.localizedDescription];
            }];
        }else{
            [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
        }
    };
    [self.passView showView];
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
            //TODO
            [BOSImportManager importWithType:BOSImportTypePrivate info:@{@"content":privateKey} locPass:weakSelf.password completion:^(NSDictionary * _Nonnull info) {
                if ([info[@"code"] integerValue] == 10000 || [info[@"code"] integerValue] == 10004) {
                    if (weakSelf.isFrist) {
                         [BOSTools RestoreRootViewController:[[BaseTabBarController alloc]init]];
                    } else {
                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }
                    
                }else{
                    [XWHUDManager showTipHUD:NSLocalizedString(@"数据库插入失败", nil)];
                }
            }];
        }
    }, ^(id  _Nonnull failure, id  _Nonnull message) {
        [XWHUDManager hideInWindow];
        [XWHUDManager showTipHUD:NSLocalizedString(@"账户暂未查询到，请稍后从历史记录中导入", nil)];
    });
}

-(void)insertAccountWithName:(NSString *)name privatekey:(NSString *)privateKey publicKey:(NSString *)publicKey{
    HistoryAccountModel * model = [[HistoryAccountModel alloc] init];
    model.accountName = name;
    model.privateKey = privateKey;
    model.publicKey = publicKey;
    model.accountId = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
    [[BOSWCDBManager sharedManager] BOSInsertObjectToTable:BOSDBHistoryAccountTableName model:model];
}

- (IBAction)creatAction:(id)sender{
    [XWHUDManager showTipHUD:@"submit"];
}

- (void)clickRightBtn:(UIButton *)btn{
    switch (btn.tag) {
        case 0:
        {
            [XWHUDManager showTipHUD:@"copy"];
            CreatWalletModel * accountModel = self.tableData[1];
            NSString * accountName = accountModel.contentStr;
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [BOSTools stringCutWhitespaceAndNewline:accountName];
            [XWHUDManager showTipHUD:NSLocalizedString(@"复制成功", nil)];
            
        }
            break;
            //        case 1:
            //        {
            //            [XWHUDManager showTipHUD:@"creat"];
            //           EOSKeyModel * model = [[EOSTools shared] getEOSKey];
            //            CreatWalletModel * pubModel = self.tableData[1];
            //            CreatWalletModel * priModel = self.tableData[2];
            //            pubModel.contentStr = model.publicKey;
            //            priModel.contentStr = model.privateKey;
            //            [self.tableView reloadData];
            //        }
            //            break;
        default:
            break;
    }
}

- (NSArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [[BOSWCDBManager sharedManager] BOSSelectedAllObjectFromTable:BOSDBHistoryAccountTableName objClass:HistoryAccountModel.class];
    }
    return _historyArray;
}

-(AlertView *)alertView {
    if (!_alertView) {
        _alertView = [[AlertView alloc] init];
        _alertView.titleStr = NSLocalizedString(@"提示", nil);
        _alertView.detailStr = NSLocalizedString(@"本地有该账户的创建历史，是否去导入", nil);
        _alertView.cancelTitle = NSLocalizedString(@"不了", nil);
        _alertView.sureTitle = NSLocalizedString(@"去导入", nil);
        WeakSelf(weakSelf);
        _alertView.block = ^(NSInteger index) {
            if (index == 1) {
                RedPacketCreateAccountHistoryViewController * VC = [[RedPacketCreateAccountHistoryViewController alloc] init];
                VC.localArray = weakSelf.localArr;
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
