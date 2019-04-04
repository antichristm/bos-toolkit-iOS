////  exportAlertViewController.m
//  BOS
//
//  Created by BOS on 2018/12/14.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ExportAlertViewController.h"

@interface ExportAlertViewController ()
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation ExportAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)sureClick {
    ExportKeyViewController * VC = [[ExportKeyViewController alloc] init];
    VC.navigationItem.title = self.navigationItem.title;
    VC.keyStr = self.key;
    VC.isPrivate = self.isprivate;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)createUI {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.titleBtn];
    [self.view addSubview:self.detailLabel];
    [self.view addSubview:self.sureBtn];
    WeakSelf(weakSelf);
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).mas_offset(BOS_H(64));
        make.height.mas_equalTo(BOS_H(30));
        make.width.mas_equalTo(BOS_W(237));
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.titleBtn.mas_bottom).mas_offset(BOS_H(30));
        make.width.mas_equalTo(BOS_W(237));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.detailLabel.mas_bottom).mas_offset(BOS_H(105));
        make.height.mas_equalTo(BOS_H(43));
        make.width.mas_equalTo(BOS_W(245));
    }];
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(21) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
        if (self.isprivate) {
             _detailLabel.attributedText = [BOSTools attributString:NSLocalizedString(@"导出私钥将存在账户安全风险请务必谨慎操作！", nil) color:TEXTCOLOR font:FONT(21) Spac:10 textAligment:NSTextAlignmentCenter attribute:nil];
        } else {
             _detailLabel.attributedText = [BOSTools attributString:NSLocalizedString(@"导出Keystore将存在账户安全风险请务必谨慎操作！", nil) color:TEXTCOLOR font:FONT(21) Spac:10 textAligment:NSTextAlignmentCenter attribute:nil];
        }
       
    }
    return _detailLabel ;
}

- (UIButton *)titleBtn {
    if (!_titleBtn) {
        _titleBtn = [BOSTools buttonWithFrame:CGRectZero font:FONT(21) textColor:COLOR(@"#E65062") backColor:nil target:nil action:nil text:NSLocalizedString(@" 注意", nil) image:IMAGE(@"zhuyi_icon_zhu_default") cornerRadius:0 superView:nil];
    }
    return _titleBtn;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"#FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(sureClick) text:NSLocalizedString(@"确认导出", nil) image:nil cornerRadius:4 superView:nil];
    }
    return _sureBtn;
}

@end
