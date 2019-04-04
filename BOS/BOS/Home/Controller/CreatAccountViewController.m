////  CreatAccountViewController.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "CreatAccountViewController.h"
#import "CreatAccountModel.h"
@interface CreatAccountViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)CreatAccountFooterView * footerView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)CreatAccountModel * creatAccountModel;
@end
static NSString * CreatAccountCellID = @"CreatAccountCellID";
@implementation CreatAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[BOSTools CreateImageWithColor:[SUBJECTCOLOR colorWithAlphaComponent:1]] forBarMetrics:UIBarMetricsDefault];
    [self initSubViews];
}
#pragma mark -- System Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreatAccountTextCell * cell = [CreatAccountTextCell initWithTableView:tableView ID:CreatAccountCellID];
    cell.tag = indexPath.row + 100;
    NSDictionary * info = self.dataArray[indexPath.row];
    [cell configModel:info];
    WeakSelf(weakSelf);
    [cell setCreatAccountTextBlock:^(CreatAccountTextCell * _Nonnull view, NSString * _Nonnull text) {
        [weakSelf setParams:view text:text];
    }];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(100);
}
#pragma mark -- Private method
-(void)setParams:(CreatAccountTextCell *)cell text:(NSString *)text{
    switch (cell.tag - 100) {
        case 0:
            self.creatAccountModel.psd1 = text;
            break;
            
        case 1:
            self.creatAccountModel.psd2 = text;
            break;
            
        case 2:
            self.creatAccountModel.remark = text;
            break;
            
        default:
            break;
    }
}
-(void)creatAccount{
    if (!self.creatAccountModel.psd1 || self.creatAccountModel.psd1.length == 0) {
           [XWHUDManager showWarningTipHUD:NSLocalizedString(@"请输入密码", nil)];
        return;
    }else if (self.creatAccountModel.psd1.length <8){
        [XWHUDManager showWarningTipHUD:NSLocalizedString(@"密码长度不能小于8位", nil)];
        return;
    }else if (!self.creatAccountModel.psd2 || self.creatAccountModel.psd2.length == 0){
        [XWHUDManager showWarningTipHUD:NSLocalizedString(@"请再次输入密码", nil)];
        return;
    }else if (self.creatAccountModel.psd2.length <8){
        [XWHUDManager showWarningTipHUD:NSLocalizedString(@"密码长度不能小于8位", nil)];
        return;
    }else if(![self.creatAccountModel.psd1 isEqualToString:self.creatAccountModel.psd2]){
        [XWHUDManager showWarningTipHUD:NSLocalizedString(@"两次密码不一致", nil)];
        return;
    }
    
    SecretQuestionViewController * VC = [[SecretQuestionViewController alloc] init];
    VC.creatAccountModel = self.creatAccountModel;
    VC.addType = self.addType;
    [self.navigationController pushViewController:VC animated:YES];
    
}
#pragma mark -- Lazy loading
-(UITableView *)tableView
{
    if (!_tableView) {
        UITableView * tableView  = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource =self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.clipsToBounds = NO;
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            tableView.scrollIndicatorInsets = tableView.contentInset;
        }
        _tableView = tableView;
    }
    return _tableView;
}
-(CreatAccountFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[CreatAccountFooterView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, BOS_H(275))];
        WeakSelf(weakSelf);
        [_footerView setCreatAccountFooterNextBlock:^(UIButton * _Nonnull button) {
            [weakSelf creatAccount];
        }];
    }
    return _footerView;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray * temp = @[
                           @{
                               @"title" : NSLocalizedString(@"密码", nil),
                               @"placeHolder" : NSLocalizedString(@"请输入8-16位密码",nil),
                               @"type" : @"1"
                               },
                           @{
                               @"title" : NSLocalizedString(@"确认密码",nil),
                               @"placeHolder" : NSLocalizedString(@"请再次输入密码",nil),
                               @"type" : @"1"
                               },
                           @{
                               @"title" : NSLocalizedString(@"密码提示",nil),
                               @"placeHolder" : NSLocalizedString(@"选填",nil),
                               @"type" : @"2"
                               }
                           ];
        [_dataArray addObjectsFromArray:temp];
    }
    return _dataArray;
}
-(CreatAccountModel *)creatAccountModel{
    if (!_creatAccountModel) {
        _creatAccountModel = [[CreatAccountModel alloc]init];
    }
    return _creatAccountModel;
}
-(void)initSubViews{
    self.view.backgroundColor = BACKGROUNDCOLOR;

    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footerView;
    WeakSelf(weakSelf);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(BOS_H(10));
        make.leading.trailing.bottom.equalTo(weakSelf.view);
    }];
    
}
@end
