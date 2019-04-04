//
//  PersonViewController.m
//  BOS
//
//  Created by Donkey on 2018/12/11.
//  Copyright © 2018年 lingling. All rights reserved.
//

#import "PersonViewController.h"
#import "RedPacketTool.h"

@interface PersonViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController changeCurrentStatusBarStyle:1];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc] init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BOS_H(10) ;
}
#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonTableViewCell * cell = [PersonTableViewCell initWithTableView:tableView ID:@"PersonTableViewCell"];
    cell.titleString = self.titleArray[indexPath.row];
    cell.imageString = self.imageArray[indexPath.row];
    cell.line.hidden = indexPath.row + 1 == self.titleArray.count;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_H(50);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            CloudManagerViewController * vc = [[CloudManagerViewController alloc]init];
            vc.navigationItem.title = NSLocalizedString(@"云端同步", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            //使用帮助
            RedPacketUseViewController *VC = [[RedPacketUseViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 2:
        {
            NSString * secrit = [PassWordTool readSecuritQuestion];
            if (secrit) {
                //修改密码
                VerifySecritQuestionViewController *VC = [[VerifySecritQuestionViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            } else {
                CreatAccountViewController * VC = [[CreatAccountViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            
            
        }
            break;
        case 3:
        {
            NSString * secrit = [PassWordTool readSecuritQuestion];
            if (secrit) {
                //修改密码
                VerifySecritQuestionViewController *VC = [[VerifySecritQuestionViewController alloc] init];
                VC.isForget = YES;
                [self.navigationController pushViewController:VC animated:YES];
            } else {
                CreatAccountViewController * VC = [[CreatAccountViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            
            
        }
            break;
        case 4:
        {
            //语言设置
            LanguageSetViewController *VC = [[LanguageSetViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 5:
        {
            //关于我们
            WebViewController *VC = [[WebViewController alloc] init];
            VC.title = NSLocalizedString(@"关于我们", nil);
            VC.url = @"https://www.boscore.io/tool.html";
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
        case 6:
        {
            //使用帮助
            WebViewController *VC = [[WebViewController alloc] init];
            VC.url = @"https://www.boscore.io/tool.html";
            VC.title = NSLocalizedString(@"使用帮助", nil);
            [self.navigationController pushViewController:VC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isHomePage = [viewController isKindOfClass:[self class]] || [viewController isKindOfClass:[RedPacketOpenViewController class]];
    [self.navigationController setNavigationBarHidden:isHomePage animated:YES];
}

#pragma mark - UI
- (void)createUI {
    self.navigationController.delegate = self;
    self.view.backgroundColor = COLOR(@"F6F6F9");
    [self.view addSubview:self.tableview];
    [self.headerView addSubview:self.iconView];
    [self.headerView addSubview:self.titleLabel];
    [self.headerView addSubview:self.detailLabel];
    WeakSelf(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).mas_offset(-Height_StatusBar);
    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.headerView);
        make.top.equalTo(weakSelf.headerView).mas_offset(BOS_H(10) + Height_NavBar);
        make.width.height.mas_equalTo(BOS_W(65));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.iconView);
        make.top.equalTo(weakSelf.iconView.mas_bottom).mas_offset(BOS_H(12));
        make.height.mas_equalTo(BOS_H(21));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).mas_offset(BOS_H(5));
        make.height.mas_equalTo(BOS_H(20));
    }];
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, BOS_H(158) + Height_NavBar);
    self.tableview.tableHeaderView = self.headerView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"hed_img_bg_default") superView:nil];
    }
    return _headerView;
}
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"me_icon_touxiang_default") superView:nil];
        _iconView.layer.cornerRadius = BOS_W(32.5);
    }
    return _iconView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(18) color:COLOR(@"FFFFFF") alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"BOS Toolkit", nil) superView:nil];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"FFFFFF") alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"更可能的链，为DApp而生", nil) superView:nil];
        _detailLabel.alpha = 0.7;
    }
    return _detailLabel;
}
- (UITableView *)tableview{
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:COLOR(@"F6F6F9") delegate:self dataSource:self rowHeight:UITableViewAutomaticDimension estimateRowHeight:50 superView:nil];
        _tableview.scrollEnabled = NO;
    }
    return _tableview;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[NSLocalizedString(@"云端同步", nil),NSLocalizedString(@"红包中心", nil),NSLocalizedString(@"修改密码", nil),NSLocalizedString(@"忘记密码", nil),NSLocalizedString(@"语言设置", nil),NSLocalizedString(@"关于我们", nil),NSLocalizedString(@"使用帮助", nil)];
    }
    return _titleArray;
}

- (NSArray *)imageArray{
    if (!_imageArray) {
        _imageArray = @[@"me_icon_cloud_default",@"me_icon_hongbao_default",@"me_icon_mima_default",@"me_icon_password",@"me_icon_yuyan_default",@"me_icon_aboutme_default",@"me_icon_shiyong_default"];
    }
    return _imageArray;
}

@end
