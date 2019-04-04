////  ImportCloudListViewController.m
//  BOS
//
//  Created by BOS on 2018/12/19.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ImportCloudListViewController.h"

@interface ImportCloudListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property(nonatomic,strong)UIButton * importButton;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)UIButton * editButton;
@property(nonatomic,assign)BOOL isBatch;
@property(nonatomic,strong)ImportCloudListTitleView * titleView;
@property(nonatomic,strong)NSMutableArray * selectedArray;
@end
static NSString * ImportCloudListCellID = @"ImportCloudListCellID";
@implementation ImportCloudListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}
#pragma mark -- System Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    ImportCloudListCell * cell = [ImportCloudListCell initWithTableView:tableView cellID:ImportCloudListCellID];
    cell.model = accountModel;
    cell.selectedButton.hidden = !self.isBatch;
    cell.selectedButton.selected = [self.selectedArray containsObject:accountModel];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AccountListModel * accountModel = self.dataArray[indexPath.row];
    if (!_isBatch) {
        [self.selectedArray removeAllObjects];
        [self.selectedArray addObject:accountModel];
        [self batchImport];
    }else{
        if (![self.selectedArray containsObject:accountModel]) {
            [self.selectedArray addObject:accountModel];
        }else{
            [self.selectedArray removeObject:accountModel];
        }
        [self.tableView reloadData];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(80);
}
#pragma mark  🐷 Private method 🐷
-(void)reloadTableView{
    [self.tableView reloadData];
}
-(void)batchImport{
    if (self.selectedArray.count == 0) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请选中需要导入的账户", nil)];
        return;
    }
    WeakSelf(weakSelf);
    [XWHUDManager showHUDMessage:NSLocalizedString(@"导入中......", nil)];
    [BOSImportManager synchronizationFromCloudAccounts:self.selectedArray completion:^(NSDictionary * _Nonnull info) {
        [XWHUDManager hide];
        NSString * code = info[@"code"];
        [BOSImportManager showFailMessage:code.integerValue message:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (code.integerValue == 10000) {
                UIViewController * rootVC = weakSelf.navigationController.childViewControllers[0];
                if ([rootVC isKindOfClass:[FirstViewController class]]) {
                    [BOSTools RestoreRootViewController:[[BaseTabBarController alloc]init]];
                }else{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        });
    }];
}
#pragma mark  🐷 Event response 🐷
-(void)importAction:(UIButton *)button{
    NSLog(@"确认导入");
    [self batchImport];
}
-(void)editAction:(UIButton *)button{
    [self.selectedArray removeAllObjects];
    self.isBatch = button.selected;
    if (button.selected) {
        [self edittingLayout];
    }else{
        [self defaultLayout];
    }
    [self reloadTableView];
}
#pragma mark  🐷 Lazyloading 🐷
-(UITableView *)tableView{
    if (!_tableView) {
        UITableView * tableView  = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 11.0, *)) {
            tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            tableView.scrollIndicatorInsets = tableView.contentInset;
        }
        _tableView = tableView;
    }
    return _tableView;
}
-(UIButton *)importButton{
    if (!_importButton) {
        _importButton = [[UIButton alloc]init];
        _importButton.backgroundColor = COLOR(@"#526AF6");
        _importButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [_importButton setTitleColor:COLOR(@"#FFFFFF") forState:UIControlStateNormal];
        [_importButton setTitle:NSLocalizedString(@"确认导入", nil) forState:UIControlStateNormal];
        [_importButton addTarget:self action:@selector(importAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importButton;
}
-(ImportCloudListTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[ImportCloudListTitleView alloc]init];
        _titleView.hintLabel.text = NSLocalizedString(@"批量导入（同一密码加密账户可多选批量导入）", nil);
        WeakSelf(weakSelf);
        [_titleView setBatchImportBlock:^(UIButton * _Nonnull button) {
            [weakSelf editAction:button];
        }];
    }
    return _titleView;
}

-(NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}
-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    
    for (AccountListModel * cloudAccount in _dataArray) {
        NSArray * locs = [[BOSWCDBManager sharedManager]BOSSelectAccountWhereAccountName:cloudAccount.accountName];
        if (locs.count > 0) {
            cloudAccount.locExsit = NSLocalizedString(@"已导入", nil);
        }
    }
}
-(void)loadDefaultsSetting{
    self.view.backgroundColor = COLOR(@"#FFFFFF");
}
-(void)initSubViews{
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.importButton];
    [self defaultLayout];
    
}
-(void)defaultLayout{
    self.importButton.hidden = YES;
    WeakSelf(weakSelf);
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(35));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.titleView.mas_bottom);
    }];
}
-(void)edittingLayout{
    WeakSelf(weakSelf);
    self.importButton.hidden = NO;
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(35));
    }];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.titleView.mas_bottom);
        make.bottom.equalTo(weakSelf.importButton.mas_top).offset(-BOS_H(8));
        make.leading.trailing.equalTo(weakSelf.view);
    }];
    
    [self.importButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(42.5));
        make.bottom.equalTo(weakSelf.view).offset(-Height_Bottom);
    }];
}

@end


@implementation ImportCloudListTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(void)batchImport:(UIButton *)button{
    button.selected = !button.selected;
    if (self.batchImportBlock) {
        self.batchImportBlock(button);
    }
}
-(void)tapAction:(UITapGestureRecognizer *)tap{
    [self batchImport:self.selelctButton];
}
-(UILabel*)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc]init];
        _hintLabel.textColor = COLOR(@"#999999");
        _hintLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    }
    return _hintLabel;
}
-(UIButton *)selelctButton{
    if (!_selelctButton) {
        _selelctButton = [[UIButton alloc]init];
        [_selelctButton setImage:IMAGE(@"account_icon_check_ladel") forState:UIControlStateNormal];
        [_selelctButton setImage:IMAGE(@"account_icon_check_default") forState:UIControlStateSelected];
        _selelctButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_selelctButton addTarget:self action:@selector(batchImport:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selelctButton;
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.hintLabel];
    [self addSubview:self.selelctButton];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    [self.selelctButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.centerY.equalTo(weakSelf);
        make.width.height.mas_equalTo(BOS_W(20));
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.leading.equalTo(weakSelf.selelctButton.mas_trailing).offset(BOS_W(8));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
    }];
}

@end
