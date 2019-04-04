////  RedPacketShareViewController.m
//  BOS
//
//  Created by BOS on 2019/1/3.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketShareViewController.h"

@interface RedPacketShareViewController ()
@property (nonatomic, strong) UIView  *headView;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UILabel *messagelabel;
@property (nonatomic, strong) UIButton *botomButton;

@end

@implementation RedPacketShareViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:COLOR(@"#CE2344")];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController changeNavigationBarBackgroundImage:SUBJECTCOLOR];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)copyClick {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.messagelabel.text;
    [XWHUDManager showTipHUD:NSLocalizedString(@"复制成功", nil)];
}

- (void)myCreateRedPacket {
    RedPacketCreateHistoryViewController * VC =  [[RedPacketCreateHistoryViewController alloc] init];
    VC.accountName = self.selectModel.accountName;
    [self.navigationController pushViewController:VC animated:YES];

}

-(void)setMessage:(NSString *)message{
    NSData * data = [message dataUsingEncoding:NSUTF8StringEncoding];
    _message = data.base58String;
    self.messagelabel.text = _message;
}

- (void)createUI {
    self.title = NSLocalizedString(@"EOS红包", nil);
    self.view.backgroundColor = COLOR(@"FFFFFF");
    [self.view addSubview:self.headView];
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.botomButton];
    WeakSelf(weakSelf);
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.top.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(67));
    }];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.centerX.width.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(160));
    }];
    CGSize size = [self.botomButton.titleLabel sizeThatFits:CGSizeMake(300, 30)];
    [self.botomButton mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(weakSelf.centerView.mas_bottom).mas_offset(BOS_H(10));
         make.right.equalTo(weakSelf.view).mas_offset(-BOS_W(10));
         make.height.mas_equalTo(BOS_H(30));
         make.width.mas_equalTo(size.width + BOS_W(10));
    }];
}

- (UIView *)headView {
    if (!_headView) {
        UIView * backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        UILabel * titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"333333") alpha:1 textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"红包串", nil) superView:backView];
        UIButton * copyButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:SUBJECTCOLOR backColor:nil target:self action:@selector(copyClick) text:NSLocalizedString(@"复制", nil) image:nil cornerRadius:0 superView:backView];
        UILabel * detailLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(12) color:COLOR(@"#968585") alpha:1 textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"通过IM工具将红包串发送给你的朋友", nil) superView:backView];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).mas_offset(BOS_W(15));
            make.top.equalTo(backView).mas_offset(BOS_H(10));
            make.height.mas_equalTo(BOS_H(20));
        }];
        [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
             make.right.equalTo(backView).mas_offset(-BOS_W(15));
        }];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(BOS_H(10));
            make.height.mas_equalTo(BOS_H(17));
        }];
        _headView = backView;
    }
    return _headView;
}

- (UIView *)centerView {
    if (!_centerView) {
        UIView * backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        UIView * yellowView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"#FFFCDE") cornerRadius:2 superView:backView];
        UILabel * label = [BOSTools labelWithFrame:CGRectZero font:FONTNAME(@"PingFangSC-Regular", 12) color:COLOR(@"#7A756E") alpha:1 textAlignment:NSTextAlignmentLeft text:self.message superView:backView];
        [yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backView).mas_offset(BOS_W(15));
            make.top.bottom.equalTo(backView);
            make.right.equalTo(backView).mas_offset(-BOS_W(15));
            
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(yellowView).mas_offset(BOS_W(10));
            make.right.equalTo(yellowView).mas_offset(-BOS_W(10));
            make.height.lessThanOrEqualTo(yellowView).mas_offset(- BOS_H(20));
        }];
        _centerView = backView;
        self.messagelabel = label;
    }
    return _centerView;
}

- (UIButton *)botomButton {
    if (!_botomButton) {
        _botomButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:SUBJECTCOLOR backColor:nil target:self action:@selector(myCreateRedPacket) text:NSLocalizedString(@"我塞的红包", nil) image:nil cornerRadius:0 superView:nil];
    }
    return _botomButton;
}


@end
