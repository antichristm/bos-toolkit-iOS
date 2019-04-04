////  TextTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "TextTableViewCell.h"

@interface TextTableViewCell()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *messageLabel;


@end

@implementation TextTableViewCell



- (void)creatUI{
    self.selectionStyle = 0;
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    [self.backView addSubview:self.messageLabel];
    WeakSelf(weakSelf);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.messageLabel.mas_bottom).mas_offset(BOS_H(15));
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.backView).mas_offset(BOS_H(15));
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(15));
    }];
}

-(void)setMessage:(NSString *)message{
    _message = message;
    self.messageLabel.text = message;
}

-(void)setAttMessage:(NSAttributedString *)attMessage{
    _attMessage = attMessage;
    self.messageLabel.attributedText = attMessage;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(12) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _messageLabel;
}
- (UIView *)backView {
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:[UIColor clearColor] cornerRadius:0 superView:nil];
    }
    return _backView;
}


@end
