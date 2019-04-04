////  RedPacketCreateViewController.m
//  BOS
//
//  Created by BOS on 2019/1/2.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketCreateViewController.h"

@interface RedPacketCreateViewController ()<NaviSelectViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NaviSelectView *headerView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITableViewCell *bottomCell;
@property (nonatomic, strong) AccountListModel *selectAccount;
@property (nonatomic, strong) NSMutableDictionary *cellDic;
@property (nonatomic, strong) NSArray *keyArr;
@property (nonatomic, strong) PassWorldView *passView;
@property (nonatomic, strong) AccountKeyListAlertView *chooseAccountView;
@property (nonatomic, strong) NSArray *accountListArr;
@property (nonatomic, assign) RedPacketType redType;
@end

@implementation RedPacketCreateViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:COLOR(@"#CE2344")];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:SUBJECTCOLOR];
}
- (void)viewDidLoad {
    self.view.backgroundColor = COLOR(@"f5f5f5");
    [super viewDidLoad];
    [self createUI];
    
}

- (void)rightClick{
    if (self.selectAccount.accountName.length > 0) {
        //直接跳转
        [self jumpToHistoryVC];
    } else {
        WeakSelf(weakSelf);
        self.chooseAccountView.Block = ^(NSArray * _Nonnull selectArray) {
            NSInteger index = [selectArray.firstObject integerValue];
            weakSelf.selectAccount = weakSelf.accountListArr[index];
            [weakSelf.tableview reloadData];
            [weakSelf jumpToHistoryVC];
        };
        [self.chooseAccountView showView];
    }
}
- (void)jumpToHistoryVC {
    RedPacketCreateHistoryViewController * VC = [[RedPacketCreateHistoryViewController alloc] init];
    VC.accountName = self.selectAccount.accountName;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)sureClick {
    RedPacketInputTableViewCell * bosCell = self.cellDic[self.keyArr[1]];
    NSString * bos = bosCell.inputTF.text;
    RedPacketInputTableViewCell * countCell = self.cellDic[self.keyArr[2]];
    NSString * count = countCell.inputTF.text;
    RedPacketWishTableViewCell * wishCell = self.cellDic[self.keyArr[3]];
    NSString * wish = wishCell.textView.text.length < 1 ? NSLocalizedString(@"恭喜发财，大吉大利", nil):wishCell.textView.text;
    if (! self.selectAccount) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请选择支付账户", nil)];
        return;
    }else if (bos.doubleValue < 0.1) {
         [XWHUDManager showTipHUD:NSLocalizedString(@"至少0.1BOS", nil)];
        return;
    }else if (count.intValue > 100 || count.intValue < 1){
         [XWHUDManager showTipHUD:NSLocalizedString(@"最多100个红包最少1个", nil)];
        return;
    }
    
    //出弹框
    WeakSelf(weakSelf);
    NSDictionary * permissionDic = [self permission];
    if (permissionDic) {
        self.passView.passwordBlock = ^(NSString * _Nonnull password) {
            NSString *private = [[EOSTools shared] DecryptWith:permissionDic[@"private"] password:password];
            if (private.length > 0) {
                [weakSelf CreateRedPacketWithType:weakSelf.redType Bos:bos count:count.intValue wish:wish permission:permissionDic[@"permission"] selfPrivate:private];
            }else {
                [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
            }
        };
        [self.passView showView];
    } else {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请导入active权限再进行操作", nil)];
    }
    
   
}
-(void)CreateRedPacketWithType:(RedPacketType)redType Bos:(NSString *)bos count:(int)count wish:(NSString *)wish permission:(NSString *)permission selfPrivate:(NSString *)selfPrivate{
    [XWHUDManager showHUDMessage:NSLocalizedString(@"红包创建中", nil)];
    EOSKeyModel * keyModel = [[EOSTools shared] getEOSKey];
    NSString * redID = [NSString stringWithFormat:@"%lld",(long long)([NSDate date].timeIntervalSince1970 * 100000 + arc4random_uniform(100))];
    WeakSelf(weakSelf);
    [RedPacketTool CreateRedPacketWithRedType:redType ID:redID count:count publicKey:keyModel.publicKey greetings:wish selfAccountName:self.selectAccount.accountName selfPrivateKey:selfPrivate currentPermission:permission amount:bos success:^(id  _Nonnull responseObject) {
        [XWHUDManager hideInWindow];
        [XWHUDManager showTipHUD:NSLocalizedString(@"红包创建成功", nil)];
        NSString * message = [NSString stringWithFormat:@"%d^%@^%@",(int)redType,redID,keyModel.privateKey];
        RedPacketShareViewController * VC = [[RedPacketShareViewController alloc] init];
        VC.selectModel = weakSelf.selectAccount;
        VC.message = message;
        [weakSelf.navigationController pushViewController:VC animated:YES];
    } failure:^(id  _Nonnull failure, id  _Nonnull message) {
        [XWHUDManager hideInWindow];
        NSError * error = (NSError *)message;
        [XWHUDManager showTipHUD:error.localizedDescription];
        
    }];
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

#pragma mark - head的点击代理
- (void)selected:(NSString *)title Index:(NSIndexPath *)index navi:(UIView*)navi{
    RedPacketType redType ;
    switch (index.row) {
        case 0:
        {
            redType = RedPacketTypeCreateAccount;
        }
            break;
        case 1:
        {
            redType = RedPacketTypeNormal;
        }
            break;
        case 2:
        {
            redType = RedPacketTypeRandom;
        }
            break;
            
        default:
            redType = RedPacketTypeNormal;
            break;
    }
    self.redType = redType;
    [self.tableview reloadData];
}

#pragma mark - tableview的代理
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 5) {
       return BOS_H(80);
    } else {
       return BOS_H(10) ;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            RedPacketAccountChooseTableViewCell * cell = [RedPacketAccountChooseTableViewCell initWithTableView:tableView ID:@"RedPacketAccountChooseTableViewCell"];
            cell.title = NSLocalizedString(@"支付账户", nil);
            [self.cellDic setObject:cell forKey:self.keyArr[indexPath.section]];
            if (self.selectAccount) {
                cell.rightViewTitle = self.selectAccount.accountName;
            }
            return cell;
            
        }
            break;
        case 1:
        {
            if (self.redType == RedPacketTypeRandom) {
                RedPacketRandomInputTableViewCell * cell = [RedPacketRandomInputTableViewCell initWithTableView:tableView ID:@"RedPacketRandomInputTableViewCell"];
                cell.title = NSLocalizedString(@"红包总金额", nil);
                cell.unit =  @"BOS";
                cell.placeString = NSLocalizedString(@"最少0.1", nil);
                cell.inputTF.limitedType = TYLimitedTextFieldTypeNumber;
                cell.inputTF.maxLength = 15;
                [self.cellDic setObject:cell forKey:self.keyArr[indexPath.section]];
                return cell;
            } else {
                RedPacketInputTableViewCell * cell = [RedPacketInputTableViewCell initWithTableView:tableView ID:@"RedPacketInputTableViewCell"];
                cell.title = NSLocalizedString(@"红包总金额", nil);
                cell.unit =  @"BOS";
                cell.placeString = NSLocalizedString(@"最少0.1", nil);
                cell.inputTF.limitedType = TYLimitedTextFieldTypeNumber;
                cell.inputTF.maxLength = 15;
                [self.cellDic setObject:cell forKey:self.keyArr[indexPath.section]];
                return cell;
            }
            
            
        }
            break;
        case 2:
        {
            RedPacketInputTableViewCell * cell = [RedPacketInputTableViewCell initWithTableView:tableView ID:@"RedPacketInputTableViewCell"];
            cell.title = NSLocalizedString(@"红包个数", nil);
            cell.unit =  NSLocalizedString(@"个", nil);
            cell.placeString = NSLocalizedString(@"最多100", nil);
            cell.inputTF.limitedType = TYLimitedTextFieldTypeNum;
            cell.inputTF.maxLength = 3;
             [self.cellDic setObject:cell forKey:self.keyArr[indexPath.section]];
            return cell;
        }
            break;
        case 3:
        {
            RedPacketWishTableViewCell * cell = [RedPacketWishTableViewCell initWithTableView:tableView ID:@"RedPacketWishTableViewCell"];
             [self.cellDic setObject:cell forKey:self.keyArr[indexPath.section]];
            return cell;
        }
            break;
        case 4:
        {
            RedPacketAlertTableViewCell * cell = [RedPacketAlertTableViewCell initWithTableView:tableView ID:@"RedPacketAlertTableViewCell"];
            cell.block = ^{
                NSLog(@"跳介绍");
            };
            return cell;
        }
            break;
        case 5:
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
    if (indexPath.section == 3) {
        return BOS_H(124);
    }else if (indexPath.section == 4){
        return BOS_H(35);
    }else if (indexPath.section == 5){
        return BOS_H(75);
    }else{
        return BOS_H(60);
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        //第一组 选择账户
        WeakSelf(weakSelf);
        self.chooseAccountView.Block = ^(NSArray * _Nonnull selectArray) {
            NSInteger index = [selectArray.firstObject integerValue];
            weakSelf.selectAccount = weakSelf.accountListArr[index];
            [weakSelf.tableview reloadData];
        };
        [self.chooseAccountView showView];
    }
}

- (void)createUI{
    self.title = NSLocalizedString(@"EOS红包", nil);
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableview];
    [self.navigationController changeNavigationBarBackgroundImage:COLOR(@"#CE2344")];
    UIButton * button = [BOSTools buttonWithFrame:CGRectMake(0, 0, 60, 30) font:FONT(14) textColor:COLOR(@"FFFFFF") backColor:nil target:self action:@selector(rightClick) text:NSLocalizedString(@"我塞的红包", nil) image:nil cornerRadius:0 superView:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    WeakSelf(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
    }];
    
    
}
- (NaviSelectView *)headerView{
    if (!_headerView) {
        _headerView = [NaviSelectView initWithFrame:CGRectMake(0, 0, ScreenWidth , BOS_H(44)) showCount:3];
        _headerView.DefaultSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _headerView.Font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _headerView.TextColor = COLOR(@"#999999");
        _headerView.SelectTextColor = COLOR(@"#CE2344");
        _headerView.TitleArray = @[NSLocalizedString(@"账号红包", nil),NSLocalizedString(@"普通红包", nil),NSLocalizedString(@"随机红包", nil)];
        _headerView.AnimationViewWidth = BOS_W(55);
        _headerView.delegate = self;
        _headerView.ItemBGColor = COLOR(@"#FFFFFF");
        _headerView.backgroundColor = COLOR(@"#FFFFFF");
        _headerView.AnimationViewIsAnimation = NO;
        self.redType = RedPacketTypeCreateAccount;
        
    }
    return  _headerView;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"#F5F5F5") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:BOS_H(60) superView:nil];
    }
    return _tableview;
}

-(UITableViewCell *)bottomCell {
    if (!_bottomCell) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton * button = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:COLOR(@"#CE2344") target:self action:@selector(sureClick) text:NSLocalizedString(@"塞钱进红包", nil) image:nil cornerRadius:3 superView:cell];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.top.equalTo(cell);
            make.width.equalTo(cell).mas_offset( - BOS_W(30));
            make.height.mas_equalTo(BOS_H(42));
        }];
        UILabel * label = [BOSTools labelWithFrame:CGRectZero font:FONTNAME(@"PingFangSC-Regular", 12) color:COLOR(@"999999") alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"未领取的红包，将于转账成功24小时后发起退款", nil) superView:cell];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(button.mas_bottom).mas_offset(BOS_H(15));
             make.centerX.equalTo(cell);
            make.width.lessThanOrEqualTo(cell).mas_offset(-BOS_W(30));
        }];
        
        _bottomCell = cell;
    }
    return _bottomCell;
}

- (NSMutableDictionary *)cellDic {
    if (!_cellDic) {
        _cellDic = [NSMutableDictionary dictionary];
    }
    return _cellDic;
}
-(NSArray *)keyArr{
    if (!_keyArr) {
        _keyArr = @[@"account",@"bos",@"count",@"wish"];
    }
    return _keyArr;
}

-(PassWorldView *)passView {
    if (!_passView) {
        _passView = [[PassWorldView alloc] init];
    }
    return _passView;
}
//-(AccountListModel *)selectAccount{
//    if (!_selectAccount) {
//
//
//        _selectAccount = locAccounts[2];
//    }
//    return _selectAccount;
//}
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

@end
