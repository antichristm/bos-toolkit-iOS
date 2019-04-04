////  ThirdAppPullViewController.m
//  BOS
//
//  Created by BOS on 2018/12/19.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ThirdAppPullViewController.h"

@interface ThirdAppPullViewController ()<
UITableViewDelegate,
UITableViewDataSource,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *improtButton;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *selectDic;
@end

@implementation ThirdAppPullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
- (void)closeClick {
    NSString * scheme = self.param[@"callback"];
    [BOSOtherCallManager exportToAppWith:nil scheme:scheme completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)improtClick{
}
-(void)exportWithAccount:(AccountListModel *)account{
    WeakSelf(weakSelf);
    [BOSExportManager exportToAppWithAccount:account appInfo:self.param completion:^(BOOL result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    ThirdTableviewCell * cell = [ThirdTableviewCell initWithTableView:tableView ID:@"ThirdTableviewCell"];
    cell.model = accountModel;
    cell.selectStatusButton.hidden = YES;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(100);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    BOOL result = [accountModel verificationKeyWithType:BOS_ACTIVE_KEY];
    if (!result){
        [XWHUDManager showTipHUD:NSLocalizedString(@"当前账户没有active权限", nil)];
    }else{
        [self exportWithAccount:accountModel];
    }
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return NullImage;
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return - BOS_H(100);
}
//允许滑动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return YES;
}
- (void)createUI {
    self.view.backgroundColor = COLOR(@"FFFFFF");
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableview];
    WeakSelf(weakSelf);
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(71) + Height_Top);
    }];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.bottom.equalTo(weakSelf.view);
    }];
}
- (UIView *)headView {
    if (!_headView) {
        UIView  *backView  = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        _headView = backView;
        UILabel * label = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"Bos Toolkit", nil) superView:_headView];
        UIButton * closeBtn = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:self action:@selector(closeClick) text:nil image:IMAGE(@"icon_laqi") cornerRadius:0 superView:_headView];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backView).mas_offset(-BOS_H(21));
            make.left.equalTo(backView).mas_offset(BOS_W(15));
        }];
        
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.right.equalTo(backView).mas_offset(-BOS_W(15));
            make.width.height.mas_equalTo(BOS_W(30));
        }];
    }
    return _headView;
}
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"FFFFFF") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:50 superView:nil];
        _tableview.emptyDataSetSource = self;
        _tableview.emptyDataSetDelegate = self;
    }
    return _tableview;
}
- (UIButton *)improtButton {
    if (!_improtButton) {
        _improtButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(improtClick) text:NSLocalizedString(@"确认导入", nil) image:nil cornerRadius:0 superView:nil];
    }
    return _improtButton;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray * locAccounts = [[BOSWCDBManager sharedManager]BOSSelectAccountWhereCreatTimestampAsc:NO];
        [_dataArray addObjectsFromArray:locAccounts];
    }
    return _dataArray;
}
- (NSMutableDictionary *)selectDic {
    if (!_selectDic) {
        _selectDic = [NSMutableDictionary dictionary];
    }
    return _selectDic;
}
@end
