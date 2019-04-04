////  AccountKeyListAlertView.m
//  BOS
//
//  Created by BOS on 2018/12/27.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountKeyListAlertView.h"
@class accountKeyListAlertCell;

@interface AccountKeyListAlertView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *sureButton;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableDictionary *selectDic;

@end

@implementation AccountKeyListAlertView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}
- (void)showView {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [KeyWindow addSubview:self];
        [self creatShowAnimation];
    });
}

- (void)creatShowAnimation{
    WeakSelf(weakSelf);
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        weakSelf.backgroundColor =  [UIColor colorWithWhite:0.2 alpha:0.5];
    }];
}

-(void)sureClick{
    if (self.selectDic.count < 1) {
        [XWHUDManager showTipHUD:NSLocalizedString(@"请选择条目", nil)];
        return;
    }
    NSLog(@"选择了");
    if (self.Block) {
        self.Block(self.selectDic.allKeys);
    }
     [self hiddenView];
}

- (void)hiddenClick{
    [self hiddenView];
}

- (void)hiddenView {
    WeakSelf(weakSelf);
    self.backgroundColor =  [UIColor clearColor];
    [UIView animateWithDuration:0.35 animations:^{
        weakSelf.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [weakSelf endEditing:YES];
        [weakSelf removeFromSuperview];
    }];
}


- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.sureButton];
    [self.backView addSubview:self.tableview];
    WeakSelf(weakSelf);
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(BOS_H(285));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.backView);
        make.top.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.height.mas_equalTo(BOS_H(52));
        
    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.backView).mas_offset(-BOS_W(7.5));
        make.centerY.equalTo(weakSelf.titleLabel);
        make.width.height.mas_offset(BOS_W(30));
    }];
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.backView).mas_offset(BOS_W(15));
        make.right.equalTo(weakSelf.backView).mas_offset(- BOS_W(15));
        make.bottom.equalTo(weakSelf.backView).mas_offset(- BOS_W(18));
        make.height.mas_equalTo(BOS_W(43));
    }];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.backView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.bottom.equalTo(weakSelf.sureButton.mas_top).mas_offset(-BOS_W(40));
    }];
    UIView * line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:self.backView];
    line.alpha = 0.2;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf.backView);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
//    line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:self.backView];
//    line.alpha = 0.2;
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(weakSelf.backView);
//        make.bottom.equalTo(weakSelf.tableview.mas_bottom);
//        make.height.mas_equalTo(0.5);
//    }];
   
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"FFFFFF") cornerRadius:0 superView:nil];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, BOS_H(285)) byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame =CGRectMake(0, 0, ScreenWidth, BOS_H(140));
        maskLayer.path = maskPath.CGPath;
        _backView.layer.mask = maskLayer;
    }
    return _backView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(16) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"导出私钥", nil) superView:nil];
    }
    return _titleLabel;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:self action:@selector(hiddenClick) text:nil image:IMAGE(@"icon_close_default") cornerRadius:0 superView:nil];
    }
    return _closeBtn;
}
-(UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [BOSTools buttonWithFrame:CGRectZero font:FONT(18) textColor:COLOR(@"FFFFFF") backColor:SUBJECTCOLOR target:self action:@selector(sureClick) text:NSLocalizedString(@"确认导出", nil) image:nil cornerRadius:0 superView:nil];
        _sureButton.layer.cornerRadius = 3;
        _sureButton.clipsToBounds = YES;
    }
    return _sureButton;
}

-(UITableView *)tableview{
    if (!_tableview) {
        _tableview = [BOSTools tableviewFrame:CGRectZero backColor:[UIColor whiteColor] delegate:self dataSource:self rowHeight:BOS_W(50) estimateRowHeight:BOS_W(50) superView:nil];
    }
    return _tableview;
}

-(NSMutableDictionary *)selectDic{
    if (!_selectDic) {
        _selectDic = [NSMutableDictionary dictionary];
    }
    return _selectDic;
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    NSMutableArray * infos = [NSMutableArray arrayWithCapacity:_dataArr.count];
    for (NSString * key in _dataArr) {
        NSArray * segment = [key componentsSeparatedByString:@"_"];
        NSString * prefix = segment.firstObject;
        NSString * suffix = segment.lastObject;
        CGFloat w = [segment.lastObject boundingRectWithSize:CGSizeMake(ScreenWidth, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.width + 8;
        NSDictionary * info = @{
                                @"key" : prefix?:@"",
                                @"permision" : [prefix isEqualToString:suffix] ? @"" : suffix?:@"",
                                @"width" : [NSNumber numberWithDouble:w]
                                };
        [infos addObject:info];
    }
    _dataArr = infos;
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    self.titleLabel.text = titleString;
}
- (void)setSureString:(NSString *)sureString {
    _sureString = sureString;
    [self.sureButton setTitle:sureString forState:UIControlStateNormal];
}
- (void)setSureColor:(UIColor *)sureColor {
    _sureColor = sureColor;
    self.sureButton.backgroundColor = sureColor;
}

#pragma mark - tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    accountKeyListAlertCell * cell = [accountKeyListAlertCell initWithTableView:tableView ID:@"accountKeyListAlertCell"];
    NSDictionary * info = self.dataArr[indexPath.row];
    cell.permissionWidth = info[@"width"];
    cell.title = info[@"key"];
    cell.permission = info[@"permision"];
    cell.rightBtn.hidden = self.selectDic[@(indexPath.row)] ? NO : YES;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BOS_W(44);
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isMutable) {
        [self.selectDic removeAllObjects];
    }
    [self.selectDic setObject:@"1" forKey:@(indexPath.row)];
    [self.tableview reloadData];
}


@end


@interface accountKeyListAlertCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *permissionLabel;
@end
@implementation accountKeyListAlertCell
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}
-(void)setPermission:(NSString *)permission{
    _permission = permission;
    if (!_permission || _permission.length == 0) {
        self.permissionLabel.hidden = YES;
    }
    self.permissionLabel.text = _permission;
}
- (void)creatUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.permissionLabel];
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.line];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.left.equalTo(weakSelf).mas_offset(BOS_W(15));
        make.width.mas_equalTo(BOS_W(180));
    }];
    
    [self.permissionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.titleLabel.mas_trailing).offset(8);
        make.centerY.equalTo(weakSelf.titleLabel);
        
        make.height.mas_offset(BOS_H(16));
        make.width.mas_equalTo(weakSelf.permissionWidth.doubleValue);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf);
        make.right.equalTo(weakSelf).mas_offset(-BOS_W(15));
        make.width.height.mas_equalTo(BOS_W(15));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(0.5);
    }];
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [BOSTools labelWithFrame:CGRectZero font:FONT(12) color:TEXTCOLOR alpha:1 textAlignment:NSTextAlignmentLeft text:nil superView:nil];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}
-(UILabel *)permissionLabel{
    if (!_permissionLabel) {
        _permissionLabel = [BOSTools labelWithFrame:CGRectZero font:[UIFont systemFontOfSize:11] color:SUBJECTCOLOR alpha:1 textAlignment:NSTextAlignmentCenter text:nil superView:nil];
        _permissionLabel.layer.borderWidth = 0.5;
        _permissionLabel.layer.borderColor = SUBJECTCOLOR.CGColor;
        _permissionLabel.layer.cornerRadius = BOS_H(8);
        _permissionLabel.layer.masksToBounds = YES;
    }
    return _permissionLabel;
}
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [BOSTools buttonWithFrame:CGRectZero font:nil textColor:nil backColor:nil target:nil action:nil text:nil image:IMAGE(@"icon_choose_selected") cornerRadius:0 superView:nil];
        _rightBtn.userInteractionEnabled = NO;
    }
    return _rightBtn;
}
- (UIView *)line{
    if (!_line) {
        _line = [BOSTools viewWithFrame:CGRectZero color:COLOR(@"999999") cornerRadius:0 superView:nil];
        _line.alpha = 0.2;
    }
    return _line;
}


@end
