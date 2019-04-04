////  VerifySecritQuestionViewController.m
//  BOS
//
//  Created by BOS on 2019/1/5.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "VerifySecritQuestionViewController.h"

@interface VerifySecritQuestionViewController ()

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *questionArr;
@property (nonatomic, strong) UITableViewCell *bottomCell;
@property (nonatomic, strong) NSMutableArray *cellArr;
@property (nonatomic, copy) NSString *enCodeString;
@property (nonatomic, strong) AlertView *alertView;

@end

@implementation VerifySecritQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self createUI];
}

- (void)sureClick {
    BOOL isContinue = YES;
    NSMutableArray * keyArray = [NSMutableArray array];
    NSMutableArray * valueArray = [NSMutableArray array];
    for (SecretQuestionTableViewCell * cell in self.cellArr) {
        NSString * inputStr = [BOSTools stringCutWhitespaceAndNewline:cell.field.text];
        if (inputStr.length > 0 ) {
            [keyArray addObject:cell.titleString];
            [valueArray addObject:inputStr];
        }else{
            NSString * message = [NSString stringWithFormat:NSLocalizedString(@"请回答%@", nil),cell.titleString];
            [XWHUDManager showTipHUD:message];
            isContinue = NO;
            break;
        }
    }
    if (isContinue) {
          NSString * answerString = [valueArray componentsJoinedByString:@"^"];
        NSString * password = [[EOSTools shared] DecryptWith:self.enCodeString password:answerString];
          //回答正确
        if (password.length > 0) {
            if (!self.isForget) {
                ChangePswViewController * VC = [[ChangePswViewController alloc] init];
                VC.questionAnswers = answerString;
                [self.navigationController pushViewController:VC animated:YES];
            } else {
               //弹框显示
                self.alertView.detailStr = password;
                [self.alertView ShowView];
            }
            
        } else {
            [XWHUDManager showTipHUD:NSLocalizedString(@"答案错误", nil)];
        }
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return [BOSTools viewWithFrame:CGRectZero color:COLOR(@"F5F5F5") cornerRadius:0 superView:nil];
        }
            break;
        case 1:
            
        case 2:
            
        default:
            return [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return BOS_H(10) ;
        }
            break;
        case 1:
        {
            return 0.1f;
        }
            break;
        case 2:
        {
            return BOS_H(65) ;
            
        }
            break;
            
        default:
            return 10;
            break;
    }
    
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section) {
        return 1;
    }else{
        return self.questionArr.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            NSString * ID = [NSString stringWithFormat:@"%d %d",(int)indexPath.section ,(int)indexPath.row];
            SecretQuestionTableViewCell * cell = [SecretQuestionTableViewCell initWithTableView:tableView ID:ID];
            cell.cellIndex = indexPath.row;
            cell.questionArr = self.questionArr[indexPath.row];
            cell.placeString = NSLocalizedString(@"请输入答案", nil);
            cell.rightBtn.hidden = YES;
            cell.field.maxLength = 30;
            [self.cellArr addObject:cell];
            return cell;
            
        }
            break;
        case 1:
        {
            TextTableViewCell * cell = [[TextTableViewCell alloc] init];
            cell.attMessage = [BOSTools attributString:NSLocalizedString(@"*密保将用于修改密码，请认真填写！", nil) color:COLOR(@"#E65062") font:FONT(12) Spac:3 textAligment:0 attribute:nil];
            return cell;
            
        }
            break;
        case 2:
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
    switch (indexPath.section) {
        case 0:
        {
            return BOS_H(92.5);
        }
            break;
        case 1:
        {
            return  UITableViewAutomaticDimension;
        }
            break;
        case 2:
        {
            return BOS_H(45);
        }
            break;
            
        default:
            return 45;
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)createUI {
    if (self.isForget) {
         self.title = NSLocalizedString(@"忘记密码", nil);
    } else {
        self.title = NSLocalizedString(@"验证密保", nil);
    }
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
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"FFFFFF") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:50 superView:nil];
    }
    return _tableview;
}

- (NSArray *)questionArr{
    /*
     */
    
    if (!_questionArr) {
        NSString * questionString = [PassWordTool readSecuritQuestion];
//        if (!questionString) {
//            SecretQuestionViewController * VC = [[SecretQuestionViewController alloc] init];
//            [self.navigationController pushViewController:VC animated:YES];
//            return @[@[@""],@[@""],@[@""]];
//        }
        NSArray * array = [questionString componentsSeparatedByString:@"^"];
        if (array.count == 3) {
            _questionArr = @[
                             @[array[0]],
                             @[array[1]],
                             @[array[2]]
                             ];
            self.enCodeString = [PassWordTool readPassWord];
        }else {
            _questionArr = @[@[@""],@[@""],@[@""]];
        }
    }
    return _questionArr;
}

- (UITableViewCell *)bottomCell {
    if (!_bottomCell) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton * button = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(sureClick) text:NSLocalizedString(@"验证密保", nil) image:nil cornerRadius:3 superView:cell];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.height.equalTo(cell);
            make.width.equalTo(cell).mas_offset( - BOS_W(30));
        }];
        _bottomCell = cell;
    }
    return _bottomCell;
}

- (NSMutableArray *)cellArr {
    if (!_cellArr) {
        _cellArr = [NSMutableArray array];
    }
    return _cellArr;
}

- (AlertView *)alertView {
    if (!_alertView) {
        _alertView = [[AlertView alloc] init];
        _alertView.titleStr = NSLocalizedString(@"密码", nil);
        _alertView.sureTitle = NSLocalizedString(@"确定", nil);
        [_alertView justHaveSure];
        WeakSelf(weakSelf);
        _alertView.block = ^(NSInteger index) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    }
    return _alertView;
}

@end
