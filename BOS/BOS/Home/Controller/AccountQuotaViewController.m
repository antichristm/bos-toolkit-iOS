////  AccountQuotaViewController.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountQuotaViewController.h"

@interface AccountQuotaViewController ()<UITableViewDelegate,UITableViewDataSource,TYLimitedTextFieldDelegate>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *placeStringArray;
@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSMutableDictionary *cellDict;
@property (nonatomic, strong) UITableViewCell *bottomCell;//底部的cell

@property (nonatomic, strong) UIButton *sureButton;
@end

@implementation AccountQuotaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)sureChange {
    [self.view endEditing:YES];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    //提取输入参数
    for (NSString *key in self.cellDict) {
        FieldTableViewCell *cell = self.cellDict[key];
        NSString * inputString = cell.field.text;
        if (inputString.length > 0) {
            [param setObject:inputString forKey:key];
        }
    }
    if (!param[@"dailyLimit"]) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请输入日付限制金额", nil)];
    } else if (!param[@"transactionLimit"]){
        [XWHUDManager showTipHUD:NSLocalizedString(@"请输入单笔限制金额", nil)];
    }else{
          NSLog(@"限额配置  参数为%@",param);
    }
}


- (void)limitedTextFieldDidChange:(UITextField *)textField {
    BOOL canNext = YES;
    for (NSString *key in self.cellDict) {
        FieldTableViewCell *cell = self.cellDict[key];
        if ([cell.field.text doubleValue] <= 0) {
            canNext = NO;
        }
    }
    self.sureButton.userInteractionEnabled = canNext;
    self.sureButton.alpha = canNext ? 1 : 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section) {
        return BOS_H(105);
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
        cell.field.limitedType = TYLimitedTextFieldTypeNumber;
        cell.field.realDelegate = self;
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
    self.title = NSLocalizedString(@"限额配置", nil);
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
        _titleArray = @[NSLocalizedString(@"Active Key 日付限额（BOS）", nil),NSLocalizedString(@"Active Key 单笔限额（BOS）", nil)];
    }
    return _titleArray;
}

- (NSArray *)placeStringArray {
    if (!_placeStringArray) {
        _placeStringArray = @[NSLocalizedString(@"请输入金额", nil),NSLocalizedString(@"请输入金额", nil)];
    }
    return _placeStringArray;
}

- (NSArray *)keyArray {
    if (!_keyArray) {
        _keyArray = @[@"dailyLimit",@"transactionLimit"];
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
        UIButton * button = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(sureChange) text:NSLocalizedString(@"确定", nil) image:nil cornerRadius:3 superView:cell];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.height.equalTo(cell);
            make.width.equalTo(cell).mas_offset( - BOS_W(30));
        }];
        button.alpha = 0.5;
        button.userInteractionEnabled = NO;
        self.sureButton = button;
        _bottomCell = cell;
    }
    return _bottomCell;
}

@end
