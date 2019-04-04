////  RedPacketOpenViewController.m
//  BOS
//
//  Created by BOS on 2018/12/29.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "RedPacketOpenViewController.h"

@interface RedPacketOpenViewController ()
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) UIView *botomView;

@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *bosLabel;

@property (nonatomic, copy) NSString *fromString;
@property (nonatomic, copy) NSString *totalString;
@property (nonatomic, copy) NSString *messageString;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *bosString;



@end

@implementation RedPacketOpenViewController

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
    self.title = NSLocalizedString(@"红包", nil);
    self.view.backgroundColor = COLOR(@"FFFFFF");
    [self createUI];
    NSArray * action_traces = self.dict[@"processed"][@"action_traces"];
    NSDictionary * action_trace = action_traces.firstObject;
    NSDictionary * new_action_trace = [action_trace[@"inline_traces"] lastObject];
    NSDictionary * act = new_action_trace[@"act"];
    NSDictionary * data = act[@"data"];
    NSString * time = new_action_trace[@"block_time"];
    NSString * memo = data[@"memo"];
    NSString * quantity = data[@"quantity"];
    NSLog(@"%@ %@",data,time);
    self.timeString = time;
   self.messageString = [memo componentsSeparatedByString:@":"].lastObject;
  self.fromString =  [[[[memo componentsSeparatedByString:@":"] firstObject] componentsSeparatedByString:@"from"] lastObject];
    self.totalString = [[quantity componentsSeparatedByString:@" "] firstObject];
    self.bosString = self.totalString;
    
}
- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)myRedPacket{
    RedPacketCreateHistoryViewController * VC = [[RedPacketCreateHistoryViewController alloc] init];
    VC.accountName = self.reciverModel.accountName;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)createUI{
    [self.view addSubview:self.headView];
    [self.view addSubview:self.botomView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.rightButton];
    
    [self.botomView addSubview:self.fromLabel];
    [self.botomView addSubview:self.totalLabel];
    [self.botomView addSubview:self.messageLabel];
    [self.botomView addSubview:self.timeLabel];
    [self.botomView addSubview:self.bosLabel];
    
    WeakSelf(weakSelf);
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).mas_offset(BOS_W(10));
        make.top.equalTo(weakSelf.view).mas_offset(BOS_W(28) + Height_Top);
        make.width.height.mas_equalTo(BOS_W(30));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.backButton);
    }];
    CGSize size = [self.rightButton.titleLabel sizeThatFits:CGSizeMake(300, 40)];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
           make.centerY.equalTo(weakSelf.backButton);
        make.right.equalTo(weakSelf.view).mas_offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(30));
        make.width.mas_equalTo(size.width + BOS_W(10));
    }];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_W(222));
    }];
    [self.botomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.headView.mas_bottom);
        make.height.mas_equalTo(BOS_H(226));
    }];
    [self.fromLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.botomView).mas_offset(BOS_H(15));
        make.centerX.equalTo(weakSelf.botomView);
        make.height.mas_equalTo(BOS_H(19));
    }];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.fromLabel.mas_bottom).mas_offset(BOS_H(10));
        make.centerX.equalTo(weakSelf.botomView);
        make.height.mas_equalTo(BOS_H(26));
    }];
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.totalLabel.mas_bottom).mas_offset(BOS_H(10));
        make.centerX.equalTo(weakSelf.botomView);
        make.height.mas_equalTo(BOS_H(19));
    }];
    [self.bosLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.messageLabel.mas_bottom).mas_offset(BOS_H(27.5));
        make.centerX.equalTo(weakSelf.botomView);
        make.height.mas_equalTo(BOS_H(30));
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bosLabel.mas_bottom).mas_offset(BOS_H(50.5));
        make.left.equalTo(weakSelf.botomView).mas_offset(BOS_W(15));
        make.height.mas_equalTo(BOS_H(18.5));
    }];
    
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:self action:@selector(backClick) text:nil image:IMAGE(@"icon_back") cornerRadius:0 superView:nil];
    }
    return _backButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:COLOR(@"FFFFFF") alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"红包", nil) superView:nil];
    }
    return _titleLabel;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(14) textColor:COLOR(@"FFFFFF") backColor:nil target:self action:@selector(myRedPacket) text:NSLocalizedString(@"我塞的红包", nil) image:nil cornerRadius:0 superView:nil];
    }
    return _rightButton;
}

-(UIView *)headView{
    if (!_headView) {
        UIView * backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        UIImageView * backImageView = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"receive_img_bigbg_default") superView:backView];
        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(backView);
            make.top.equalTo(backView);
            make.bottom.equalTo(backView);
        }];
        _headView = backView;
        
    }
    return _headView;
}

- (UIView *)botomView {
    if (!_botomView) {
        UIView * backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        UIImageView * boardView = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"img_successbg") superView:backView];
        UILabel * messagelabel = [BOSTools labelWithFrame:CGRectZero font:FONT(13) color:COLOR(@"#DDDDDD") alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"保存到您的BOS账号", nil) superView:backView];
        [boardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(backView).mas_offset(BOS_H(113));
            make.centerX.equalTo(backView);
            make.height.mas_equalTo(BOS_H(80));
            make.width.mas_equalTo(BOS_H(345));
        }];
        [messagelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(boardView).mas_offset(-BOS_H(12));
            make.centerX.equalTo(backView);
            make.height.mas_equalTo(BOS_H(18.5));
        }];
        _botomView = backView;
        
    }
    return _botomView;
}

- (UILabel *)fromLabel {
    if (!_fromLabel) {
        _fromLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:COLOR(@"#999999") alpha:1 textAlignment:NSTextAlignmentCenter text:nil superView:nil];
    }
    return _fromLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:COLOR(@"#333333") alpha:1 textAlignment:NSTextAlignmentCenter text:nil superView:nil];
    }
    return _totalLabel;
}
- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(13) color:COLOR(@"#8F4600") alpha:1 textAlignment:NSTextAlignmentCenter text:nil superView:nil];
    }
    return _messageLabel;
}
- (UILabel *)bosLabel {
    if (!_bosLabel) {
        _bosLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(13) color:COLOR(@"#333333") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _bosLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(13) color:COLOR(@"#999999") alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
    }
    return _timeLabel;
}

- (void)setFromString:(NSString *)fromString {
    _fromString = fromString;
    self.fromLabel.text = [@"From " stringByAppendingString:fromString?:@""];
}

- (void)setTotalString:(NSString *)totalString {
    _totalString = totalString;
    NSAttributedString * total = [BOSTools attributString:@"total " color:COLOR(@"333333") font:FONT(14) Spac:0 textAligment:NSTextAlignmentLeft attribute:nil];
    NSAttributedString * count = [BOSTools attributString:totalString?:@"0" color:COLOR(@"333333") font:FONT(22) Spac:0 textAligment:NSTextAlignmentLeft attribute:nil];
    NSAttributedString * bos = [BOSTools attributString:@" BOS" color:COLOR(@"333333") font:FONT(14) Spac:0 textAligment:NSTextAlignmentLeft attribute:nil];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    [att appendAttributedString:total];
    [att appendAttributedString:count];
    [att appendAttributedString:bos];
      self.totalLabel.attributedText = att;
}

- (void)setMessageString:(NSString *)messageString {
    _messageString = messageString;
      self.messageLabel.text = messageString;
    
}

- (void)setBosString:(NSString *)bosString {
    _bosString = bosString;
    NSAttributedString * count = [BOSTools attributString:bosString?:@"0" color:COLOR(@"333333") font:FONT(25) Spac:0 textAligment:NSTextAlignmentLeft attribute:nil];
    NSAttributedString * bos = [BOSTools attributString:@" BOS" color:COLOR(@"333333") font:FONT(18) Spac:0 textAligment:NSTextAlignmentLeft attribute:nil];
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc] init];
    [att appendAttributedString:count];
    [att appendAttributedString:bos];
     self.bosLabel.attributedText = att;
}
- (void)setTimeString:(NSString *)timeString {
    _timeString = timeString;
    NSString * time = [BOSTools timeT:[self stringToDate:timeString] stringFormatter:@"yyyy-MM-dd HH:mm:ss"];
    self.timeLabel.text = [NSLocalizedString(@"领取时间: ", nil) stringByAppendingString:time];
}

- (NSTimeInterval)stringToDate:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *ldate = [dateFormatter dateFromString:string];
    return ldate.timeIntervalSince1970;
}





@end
