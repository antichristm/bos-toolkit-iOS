////  exportKeyViewController.m
//  BOS
//
//  Created by BOS on 2018/12/14.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ExportKeyViewController.h"

@interface ExportKeyViewController ()

@property (nonatomic, strong) TYLimitedTextView *textView;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) UIImageView *leftImage;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ExportKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)createUI {
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self.view addSubview:self.textView];
    [self.view addSubview:self.leftImage];
    [self.view addSubview:self.alertLabel];
    [self.view addSubview:self.button];
    WeakSelf(weakSelf);
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(BOS_W(15));
        make.right.equalTo(weakSelf.view).mas_offset(- BOS_W(15));
        make.height.mas_equalTo(BOS_H(100));
        make.top.equalTo(weakSelf.view).mas_offset(BOS_W(20));
    }];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(BOS_W(50));
        make.right.equalTo(weakSelf.view).mas_offset(- BOS_W(15));
        make.top.equalTo(weakSelf.textView.mas_bottom).mas_offset(BOS_W(20));
    }];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.alertLabel);
        make.left.equalTo(weakSelf.view).mas_offset(BOS_W(15));
        make.width.height.mas_offset(BOS_W(30));
    }];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.alertLabel.mas_bottom).mas_offset(BOS_H(65));
        make.height.mas_equalTo(BOS_H(43));
        make.width.equalTo(weakSelf.view).mas_offset( - BOS_W(30));
    }];
}

- (void)copyClick {
    //复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [BOSTools stringCutWhitespaceAndNewline:self.textView.text];
    [XWHUDManager showTipHUD:NSLocalizedString(@"复制成功", nil)];
}

- (void)setKeyStr:(NSString *)keyStr{
    _keyStr = keyStr;
    self.textView.text = keyStr;
}

- (TYLimitedTextView *)textView {
    if (!_textView) {
        _textView = [[TYLimitedTextView alloc] init];
        _textView.textColor = TEXTCOLOR;
        _textView.layer.borderColor = [COLOR(@"999999") colorWithAlphaComponent:0.2].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.layer.cornerRadius = 4;
        _textView.editable = NO;
    }
    return _textView;
}
- (UIImageView *)leftImage {
    if (!_leftImage) {
        _leftImage = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"zhuyi_icon_zhu_default") superView:nil];
    }
    return _leftImage;
}

- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(12) color:COLOR(@"#E65062") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
        if (self.isPrivate) {
             _alertLabel.attributedText = [BOSTools attributString:NSLocalizedString(@"请妥善保存好你的私钥，请勿复制粘贴，千万不能丢失，我们不存储密码，也无法帮你找回", nil) color:COLOR(@"E65062") font:FONT(12) Spac:3 textAligment:0 attribute:nil];
        } else {
             _alertLabel.attributedText = [BOSTools attributString:NSLocalizedString(@"请妥善保存好你的Keystore，请勿复制粘贴，千万不能丢失，我们不存储密码，也无法帮你找回", nil) color:COLOR(@"E65062") font:FONT(12) Spac:3 textAligment:0 attribute:nil];
        }
       
    }
    return _alertLabel;
}

-(UIButton *)button{
    if (!_button) {
        _button =  [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"#FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(copyClick) text:NSLocalizedString(@"复制", nil) image:nil cornerRadius:4 superView:nil];
    }
    return _button;
}

@end
