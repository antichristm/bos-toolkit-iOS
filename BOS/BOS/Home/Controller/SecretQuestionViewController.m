////  SecretQuestionViewController.m
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "SecretQuestionViewController.h"

@interface SecretQuestionViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *questionArr;
@property (nonatomic, strong) UITableViewCell *bottomCell;
@property (nonatomic, strong) NSMutableArray *cellArr;


@end

@implementation SecretQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)sureClick {
    BOOL isContinue = YES;
    NSMutableArray * keyArray = [NSMutableArray array];
    NSMutableArray * valueArray = [NSMutableArray array];
    NSMutableDictionary * answerDic = [NSMutableDictionary dictionary];
    for (SecretQuestionTableViewCell * cell in self.cellArr) {
        NSString * inputStr = [BOSTools stringCutWhitespaceAndNewline:cell.field.text];
        if (inputStr.length > 1 ) {
            [keyArray addObject:cell.titleString];
            [valueArray addObject:inputStr];
            [answerDic setObject:@"" forKey:inputStr];
        }else{
            if (inputStr.length>0) {
                [XWHUDManager showTipHUD:NSLocalizedString(@"答案至少两个字符", nil)];
            }else{
                NSString * message = [NSString stringWithFormat:NSLocalizedString(@"请回答%@", nil),cell.titleString];
                [XWHUDManager showTipHUD:message];
            }
            isContinue = NO;
            break;
        }
    }
    if (isContinue && answerDic.count == self.cellArr.count) {
        if (self.creatAccountModel.remark.length > 0 && self.creatAccountModel.remark) {
            UserDefaultSetObjectForKey(self.creatAccountModel.remark, BOSPassHint);
        }
        NSString * keyString = [keyArray componentsJoinedByString:@"^"];
        NSString * answerString = [valueArray componentsJoinedByString:@"^"];
    
        NSString * enPass = [[EOSTools shared] EncryptWith:self.creatAccountModel.psd2 password:answerString];
        NSString * Substitute = [[EOSTools shared]EncryptWith:BOSPassSubstitute password:self.creatAccountModel.psd2];

        BOOL verifyResult = [PassWordTool saveSecuritVerify:Substitute];
        BOOL passResult = [PassWordTool savePassWord:enPass];
        BOOL QuestionResult = [PassWordTool saveSecuritQuestion:keyString];
        
        if (!passResult || ! QuestionResult || !verifyResult) {
            [XWHUDManager showTipHUD:NSLocalizedString(@"设置失败", nil)];
            return;
        }
        WeakSelf(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            switch (weakSelf.addType) {
                case BOSAddAccountImport:{
                    AccountImportViewController * vc = [[AccountImportViewController alloc]init];
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
                    
                    break;
                    
                case BOSAddAccountRedPacketCreate:{
                    RedPacketCreateAccountViewController * VC = [[RedPacketCreateAccountViewController alloc] init];
                    VC.isFrist = YES;
                    [weakSelf.navigationController pushViewController:VC animated:YES];
                }
                    
                    break;
                    
                default:
                    break;
            }
        });
    }else if ( isContinue ) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"密保答案不能相同", nil)];
        return;
    }else {
        return;
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
            cell.field.maxLength = 30;
            [self.cellArr addObject:cell];
            return cell;
            
        }
            break;
        case 1:
        {
            TextTableViewCell * cell = [[TextTableViewCell alloc] init];
            cell.attMessage = [BOSTools attributString:NSLocalizedString(@"*密保将用于导出或修改私钥、修改密码，请认真填写！", nil) color:COLOR(@"#E65062") font:FONT(12) Spac:3 textAligment:0 attribute:nil];
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
    self.title = NSLocalizedString(@"设置密保", nil);
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
        _questionArr = @[
                         @[NSLocalizedString(@"您母亲的名字", nil),NSLocalizedString(@"您父亲的名字", nil),NSLocalizedString(@"您爱人的名字", nil),NSLocalizedString(@"您最好的朋友的名字", nil),NSLocalizedString(@"您第一个孩子的名字", nil),NSLocalizedString(@"您的小名（昵称）", nil),NSLocalizedString(@"您的宠物叫什么名字", nil),NSLocalizedString(@"您毕业的学校", nil),NSLocalizedString(@"您出生的地方", nil),NSLocalizedString(@"您母亲出生的地方", nil)],
                         @[NSLocalizedString(@"您母亲的生日", nil),NSLocalizedString(@"您父亲的生日", nil),NSLocalizedString(@"您爱人的生日", nil),NSLocalizedString(@"您最好的朋友的生日", nil),NSLocalizedString(@"您第一个孩子的生日", nil),NSLocalizedString(@"您第二个孩子的生日", nil),NSLocalizedString(@"您的生日", nil),NSLocalizedString(@"您最难忘的日子", nil),NSLocalizedString(@"您第一次离家远行的日子", nil),NSLocalizedString(@"您结婚的日子", nil)],
                         @[NSLocalizedString(@"您最喜欢吃的水果", nil),NSLocalizedString(@"您最讨厌的食物", nil),NSLocalizedString(@"您最喜欢做的事", nil),NSLocalizedString(@"您最讨厌做的事", nil),NSLocalizedString(@"您最喜欢的颜色", nil),NSLocalizedString(@"您最喜欢的运动", nil),NSLocalizedString(@"您最热爱的城市", nil),NSLocalizedString(@"您最想去旅游的地方", nil),NSLocalizedString(@"您最讨厌的人", nil)]
                         ];
    }
    return _questionArr;
}

- (UITableViewCell *)bottomCell {
    if (!_bottomCell) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton * button = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(sureClick) text:NSLocalizedString(@"创建账号", nil) image:nil cornerRadius:3 superView:cell];
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

@end
