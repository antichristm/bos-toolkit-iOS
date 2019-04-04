////  ChangePswViewController.m
//  BOS
//
//  Created by BOS on 2018/12/11.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ChangePswViewController.h"

@interface ChangePswViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeStringArray;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableDictionary *cellDict;
@property (nonatomic, strong) UITableViewCell *bottomCell;//底部的cell
@end

@implementation ChangePswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
//【待完善】
- (void)sureChange {
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //提取输入参数
    for (NSString *key in self.cellDict) {
        FieldTableViewCell *cell = self.cellDict[key];
        NSString * inputString = cell.field.text;
        if (inputString.length > 0) {
            [param setObject:inputString forKey:key];
        }
    }
    if (!param[@"oldPsw"]) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请输入原密码", nil)];
    } else if (!param[@"newPsw"]) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请输入新密码", nil)];
    } else if ([param[@"newPsw"] length] < 8) {
         [XWHUDManager showTipHUD:NSLocalizedString(@"至少输入8位密码", nil)];
    } else if ([param[@"newPsw"] isEqualToString:param[@"oldPsw"]]) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"新密码不能与旧密码相同", nil)];
    } else if (!param[@"rePsw"]) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请再次输入新密码", nil)];
    } else if (![param[@"newPsw"] isEqualToString:param[@"rePsw"]]) {
         [XWHUDManager showTipHUD:NSLocalizedString(@"两次密码不一致", nil)];
    } else if (![PassWordTool verifyPassword:param[@"oldPsw"]]) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
    } else {
        //待完善 (密保问题加密密码)
        NSString * newPassword = param[@"newPsw"];
        NSString * oldPasswprd = param[@"oldPsw"];
        //修改完密码本地数据需用新密码重新加密        
        BOOL result = [[BOSWCDBManager sharedManager]BOSResetLocAccountsEncrypWith:oldPasswprd newPass:newPassword];
        if (result) {
           
            NSString * enPass = [[EOSTools shared] EncryptWith:newPassword password:self.questionAnswers];
             NSString * Substitute = [[EOSTools shared]EncryptWith:BOSPassSubstitute password:newPassword];
            BOOL verifyResult = [PassWordTool saveSecuritVerify:Substitute];
            BOOL passResult = [PassWordTool savePassWord:enPass];
            
            if (param[@"pswReminder"]) {
                UserDefaultSetObjectForKey(param[@"pswReminder"], BOSPassHint);
            } else {
                UserDefaultRemoveObjectForKey(BOSPassHint);
            }
            if (verifyResult && passResult) {
                [XWHUDManager showSuccessTipHUD:NSLocalizedString(@"修改成功", nil)];
                NSLog(@"修改成功");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [XWHUDManager showTipHUD:NSLocalizedString(@"设置失败", nil)];
            }
           
        }else{
            [XWHUDManager showErrorTipHUD:NSLocalizedString(@"修改失败", nil)];
            NSLog(@"修改失败");
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return BOS_H(95);
    }else{
        return BOS_H(10);
    }
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        return 1;
    } else {
        return self.titleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return self.bottomCell;
    } else {
        NSString * ID = [NSString stringWithFormat:@"%d %d",(int)indexPath.section ,(int)indexPath.row];
        FieldTableViewCell * cell = [FieldTableViewCell initWithTableView:tableView ID:ID];
        cell.titleString = self.titleArray[indexPath.row];
        cell.placeString = self.placeStringArray[indexPath.row];
        cell.field.limitedType = indexPath.row + 1 == self.titleArray.count ? TYLimitedTextFieldTypeNomal : TYLimitedTextFieldTypePassword;
        cell.field.secureTextEntry = indexPath.row + 1 != self.titleArray.count;
        cell.field.maxLength = 30;
        [self.cellDict setObject:cell forKey:self.keyArray[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section) {
        return BOS_W(45);
    } else {
        return indexPath.row + 1 == self.titleArray.count ? BOS_H(105) : BOS_H(92.5);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(void)createUI {
    self.title = NSLocalizedString(@"修改密码", nil);
    self.view.backgroundColor = COLOR(@"F6F6F9");
    [self.view addSubview:self.tableview];
    WeakSelf(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(weakSelf.view);
    }];
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"F6F6F9") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:50 superView:nil];
        _tableview.scrollEnabled = NO;
    }
    return _tableview;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[NSLocalizedString(@"原密码", nil),NSLocalizedString(@"新密码", nil),NSLocalizedString(@"重复新密码", nil),NSLocalizedString(@"密码提示", nil)];
    }
    return _titleArray;
}

- (NSArray *)placeStringArray {
    if (!_placeStringArray) {
        _placeStringArray = @[NSLocalizedString(@"请输入原密码", nil),NSLocalizedString(@"请输入新密码", nil),NSLocalizedString(@"请再次输入新密码", nil),NSLocalizedString(@"选填", nil)];
    }
    return _placeStringArray;
}

- (NSArray *)keyArray {
    if (!_keyArray) {
        _keyArray = @[@"oldPsw",@"newPsw",@"rePsw",@"pswReminder"];
    }
    return _keyArray;
}

-(NSMutableDictionary *)cellDict {
    if (!_cellDict) {
        _cellDict = [NSMutableDictionary dictionary];
    }
    return _cellDict;
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

@end
