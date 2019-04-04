////  RedPacketUseViewController.m
//  BOS
//
//  Created by BOS on 2019/1/3.
//  Copyright © 2019年 BOS. All rights reserved.
//

#import "RedPacketUseViewController.h"

@interface RedPacketUseViewController ()
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UIImageView *pinkImage;
@property (nonatomic, strong) UIImageView *redImage;
@property (nonatomic, strong) TYLimitedTextView *inputText;
@property (nonatomic, strong) UILabel *palceLabel;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) AccountKeyListAlertView *chooseAccountView;
@property (nonatomic, strong) NSArray *accountListArr;
@property (nonatomic, strong) AccountListModel *selectAccount;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) CGFloat bottomWidth;

@end

@implementation RedPacketUseViewController
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

- (void)jumpToCreateAccount {
    RedPacketCreateAccountViewController * VC = [[RedPacketCreateAccountViewController alloc] init];
    VC.isFrist = self.isFrist;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)jumpToBosCreateAccount {
    RedPacketBosCreateAccountViewController * VC = [[RedPacketBosCreateAccountViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)jumpToSendRedPacket {
    RedPacketCreateViewController * VC = [[RedPacketCreateViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - textview的代理
- (void)limitedTextViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length < 1) {
        self.palceLabel.hidden = NO;
    } else {
        self.palceLabel.hidden = YES;
    }
}

- (void)limitedTextViewDidBeginEditing:(UITextView *)textView{
    self.palceLabel.hidden = YES;
}

- (void)sureClick{
    NSString * string = [BOSTools stringCutWhitespaceAndNewline:self.inputText.text];
    NSData * data = string.dataFromBase58;
   NSString * redString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray * array = [redString componentsSeparatedByString:@"^"];
    if (array.count >= 3 && ([array[0] intValue] > 0 &&[array[0] intValue] <4)) {
        RedPacketType redType = [array[0] intValue];
        if (redType == RedPacketTypeCreateAccount) {
            NSLog(@"跳账号创建");
            RedPacketCreateAccountViewController * VC = [[RedPacketCreateAccountViewController alloc] init];
            VC.redString = string;
            VC.isFrist = self.isFrist;
            [self.navigationController pushViewController:VC animated:YES];
            return;
        } else {
            WeakSelf(weakSelf);
            self.chooseAccountView.Block = ^(NSArray * _Nonnull selectArray) {
                NSInteger index = [selectArray.firstObject integerValue];
                weakSelf.selectAccount = weakSelf.accountListArr[index];
                 [weakSelf getRedPacket:array];
            };
            [self.chooseAccountView showView];
            
           
        }
    }else if (redString.length < 1 ){
         [XWHUDManager showTipHUD:NSLocalizedString(@"请输入红包串", nil)];
    }else{
        [XWHUDManager showTipHUD:NSLocalizedString(@"格式错误", nil)];
    }
}

-(void)getRedPacket:(NSArray *)array {
    
   
    
    NSString * receiver =self.selectAccount.accountName;
    [XWHUDManager showHUDMessage:NSLocalizedString(@"领取中", nil)];
    WeakSelf(weakSelf);
    [RedPacketTool GetRedPacketWithRedID:array[1] redPacketPrivateKey:array[2] receiver:receiver success:^(id  _Nonnull responseObject) {
        [XWHUDManager hideInWindow];
        RedPacketOpenViewController * VC = [[RedPacketOpenViewController alloc] init];
//        VC.reciverModel = weakSelf.selectAccount;
//        VC.redString = [BOSTools stringCutWhitespaceAndNewline:weakSelf.inputText.text];
        VC.dict = responseObject;
        VC.reciverModel = weakSelf.selectAccount;
        [weakSelf.navigationController pushViewController:VC animated:YES];
    } failure:^(id  _Nonnull failure, id  _Nonnull message) {
        [XWHUDManager hideInWindow];
        NSError * error = (NSError *)message;
        [XWHUDManager showTipHUD:error.localizedDescription];
    }];
}

- (void)setRedPacketString:(NSString *)redPacketString{
    _redPacketString = redPacketString;
    self.palceLabel.hidden = YES;
    self.inputText.text = redPacketString;
}

- (void)createUI{
    [self.navigationController changeNavigationBarBackgroundImage:COLOR(@"#CE2344")];
    self.title = NSLocalizedString(@"红包", nil);
    self.view.backgroundColor = COLOR(@"FFFFFF");
    [self.view addSubview:self.backImage];
    [self.view addSubview:self.pinkImage];
    [self.view addSubview:self.redImage];
    [self.view addSubview:self.inputText];
    [self.view addSubview:self.sureButton];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.palceLabel];
    WeakSelf(weakSelf);
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.mas_equalTo(BOS_H(421));
    }];
    [self.pinkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(weakSelf.view).mas_offset(BOS_W(15));
        make.right.equalTo(weakSelf.view).mas_offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(280));
    }];
    [self.redImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).mas_offset(BOS_H(184));
    }];
    [self.inputText mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.equalTo(weakSelf.view).mas_offset(BOS_W(25));
         make.right.equalTo(weakSelf.view).mas_offset(-BOS_W(25));
          make.height.mas_equalTo(BOS_H(122));
    }];
    [self.palceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.top.equalTo(weakSelf.inputText).mas_offset(BOS_W(15));
    make.right.equalTo(weakSelf.inputText).mas_offset(-BOS_W(15));
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.inputText.mas_bottom).mas_offset(BOS_H(20));
        make.height.mas_equalTo(BOS_H(34));
        make.width.mas_equalTo(BOS_H(105));
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view).mas_offset(-BOS_H(27) - Height_Bottom);
        make.height.mas_equalTo(BOS_H(30));
        make.width.mas_equalTo(weakSelf.bottomWidth);
    }];
}

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"envelope_img_bigbg_default") superView:nil];
    }
    return _backImage;
}

- (UIImageView *)pinkImage{
    if (!_pinkImage) {
        _pinkImage = [BOSTools imageViewWithFrame:CGRectZero image:nil superView:nil];
        _pinkImage.backgroundColor = COLOR(@"#FFF4F7");
//        _pinkImage.contentMode = UIViewContentModeScaleToFill;
        _pinkImage.layer.shadowColor = COLOR(@"#E6A4A4").CGColor;
        _pinkImage.layer.cornerRadius = 4;
        _pinkImage.layer.shadowRadius = 8;
        _pinkImage.layer.shadowOffset = CGSizeMake(3, 0);
        _pinkImage.layer.shadowOpacity = 0.5;
    }
    return _pinkImage;
}

- (UIImageView *)redImage {
    if (!_redImage) {
        _redImage = [BOSTools imageViewWithFrame:CGRectZero image:IMAGE(@"envelope_img_shell_default") superView:nil];//167
        _redImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _redImage;
}
- (TYLimitedTextView *)inputText {
    if (!_inputText) {
        _inputText = [[TYLimitedTextView alloc] init];
        _inputText.font = FONT(14);
        _inputText.textColor = COLOR(@"333333");
//        _inputText.text = NSLocalizedString(@"", nil);
        _inputText.textContainerInset = UIEdgeInsetsMake(BOS_W(15), BOS_W(15), BOS_W(15), BOS_W(15));
        _inputText.realDelegate = self;
    }
    return _inputText;
}

-(UILabel *)palceLabel{
    if (!_palceLabel) {
        _palceLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(14) color:COLOR(@"999999") alpha:1 textAlignment:NSTextAlignmentLeft text:NSLocalizedString(@"请输入红包串领取红包", nil) superView:nil];
    }
    return _palceLabel;
}
- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [BOSTools buttonWithFrame:CGRectZero font:FONTNAME(@"HelveticaNeue-Medium", 16) textColor:COLOR(@"FFFFFF") backColor:COLOR(@"#CE2344") target:self action:@selector(sureClick) text:@"GO" image:nil cornerRadius:17 superView:nil];
    }
    return _sureButton;
}
- (NSArray *)accountListArr{
    if (!_accountListArr) {
        _accountListArr = [[BOSWCDBManager sharedManager]BOSSelectedAllObjectFromTable:BOSDBAccountTableName objClass:AccountListModel.class];
    }
    return _accountListArr;
}
- (AccountKeyListAlertView *)chooseAccountView {
    if (!_chooseAccountView) {
        _chooseAccountView = [[AccountKeyListAlertView alloc] init];
        NSMutableArray * nameArr = [NSMutableArray array];
        for (AccountListModel * model in self.accountListArr) {
            [nameArr addObject:model.accountName?:@""];
        }
        _chooseAccountView.dataArr = nameArr;
        _chooseAccountView.titleString = NSLocalizedString(@"选择接收账户", nil);
        _chooseAccountView.sureString = NSLocalizedString(@"确认", nil);
        _chooseAccountView.sureColor = COLOR(@"#BF1E3D");
    }
    return _chooseAccountView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        UIView * bacckView = [BOSTools viewWithFrame:CGRectZero color:[UIColor clearColor] cornerRadius:0 superView:nil];
        UIButton * hbCreate = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:[COLOR(@"#EDD9C5") colorWithAlphaComponent:0.7] backColor:nil target:self action:@selector(jumpToCreateAccount) text:NSLocalizedString(@"创建账号", nil) image:nil cornerRadius:0 superView:bacckView];
//          UIButton * bosCreate = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:[COLOR(@"#EDD9C5") colorWithAlphaComponent:0.7] backColor:nil target:self action:@selector(jumpToBosCreateAccount) text:NSLocalizedString(@"创建BOS账号", nil) image:nil cornerRadius:0 superView:bacckView];
          UIButton * sendRed = [BOSTools buttonWithFrame:CGRectZero font:FONT(12) textColor:[COLOR(@"#EDD9C5") colorWithAlphaComponent:0.7] backColor:nil target:self action:@selector(jumpToSendRedPacket) text:NSLocalizedString(@"发红包", nil) image:nil cornerRadius:0 superView:bacckView];
        CGFloat width = 0;
        CGSize size = [sendRed.titleLabel sizeThatFits:CGSizeMake(120, 40)];
        width += (size.width + BOS_W(20));
        [sendRed mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.height.equalTo(hbCreate);
            make.left.equalTo(bacckView);
            make.width.mas_equalTo(BOS_W(size.width + BOS_W(20)));
        }];
         size = [hbCreate.titleLabel sizeThatFits:CGSizeMake(120, 40)];
        width += (size.width + BOS_W(20));
        [hbCreate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bacckView);
            make.left.equalTo(sendRed.mas_right);
            make.height.mas_equalTo(BOS_H(20));
            make.width.mas_equalTo(BOS_W(size.width + BOS_W(20)));
        }];
//        size = [bosCreate.titleLabel sizeThatFits:CGSizeMake(120, 40)];
//          width += (size.width + BOS_W(20));
//        [bosCreate mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.height.equalTo(hbCreate);
//            make.left.equalTo(hbCreate.mas_right);
//             make.width.mas_equalTo(BOS_W(size.width + BOS_W(20)));
//        }];
        
         UIView * line = [BOSTools viewWithFrame:CGRectZero color:[COLOR(@"#EDD9C5") colorWithAlphaComponent:0.7] cornerRadius:0 superView:bacckView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
             make.centerY.equalTo(hbCreate);
                make.left.equalTo(hbCreate);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(BOS_H(16.5));
        }];
//        line = [BOSTools viewWithFrame:CGRectZero color:[COLOR(@"#EDD9C5") colorWithAlphaComponent:0.7] cornerRadius:0 superView:bacckView];
//        [line mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(hbCreate);
//            make.right.equalTo(hbCreate);
//            make.width.mas_equalTo(0.5);
//            make.height.mas_equalTo(BOS_H(16.5));
//        }];
        self.bottomWidth = width;
        _bottomView = bacckView;
        
    }
    return _bottomView;
}





@end
