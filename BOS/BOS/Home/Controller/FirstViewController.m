////  FirstViewController.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()
<
UINavigationControllerDelegate
>
@property(nonatomic,strong)UIImageView * backGroundImageView;
@property(nonatomic,strong)FirstItemView * creatView;
@property(nonatomic,strong)FirstItemView * importView;
@property(nonatomic,strong)FirstTitleView * titleView;
@property(nonatomic,strong)UIButton * languageButton;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}
#pragma mark 🐷System Delegate 🐷
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    BOOL isHomePage = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isHomePage animated:YES];
}
-(void)languageAction:(UIButton *)button{
    NSLog(@"切换语言 ");
    NSString *  language = [DAConfig userLanguage];
    
    if ([language isEqualToString:@"zh-Hans"]) {
        //切换英文
        [self setlaguageWithString:@"en"];
        self.languageButton.selected = YES;
    }else{
        [self setlaguageWithString:@"zh-Hans"];
        self.languageButton.selected = NO;
    }
}
- (void)setlaguageWithString:(NSString *)language{
    [DAConfig setUserLanguage:language];
    BaseNavigationController * first = [[BaseNavigationController alloc]initWithRootViewController:[[FirstViewController alloc]init]];
    [BOSTools RestoreRootViewController:first];
}
#pragma mark  🐷 Lazy loading 🐷
-(UIImageView *)backGroundImageView{
    if (!_backGroundImageView) {
        _backGroundImageView = [[UIImageView alloc]init];
        _backGroundImageView.image = IMAGE(@"home_img_bg_default");
    }
    return _backGroundImageView;
}
-(FirstTitleView *)titleView{
    if (!_titleView) {
        _titleView = [[FirstTitleView alloc]init];
    }
    return _titleView;
}
-(FirstItemView *)importView{
    if (!_importView) {
        _importView = [[FirstItemView alloc]init];
        _importView.titleLabel.text = NSLocalizedString(@"导入账户", nil);
        _importView.leftImageView.image = IMAGE(@"bos_icon_daoru_default");
        WeakSelf(weakSelf);
        [_importView setFirstItemTapBlock:^(FirstItemView * _Nonnull view) {
            if ([PassWordTool isExist]) {
                AccountImportViewController * vc = [[AccountImportViewController alloc]init];
                vc.navigationItem.title = NSLocalizedString(@"导入账户", nil);
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                CreatAccountViewController * vc = [[CreatAccountViewController alloc]init];
                vc.navigationItem.title = NSLocalizedString(@"设置密码", nil);
                vc.addType = BOSAddAccountImport;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _importView;
}
-(FirstItemView *)creatView{
    if (!_creatView) {
        _creatView = [[FirstItemView alloc]init];
        _creatView.titleLabel.text = NSLocalizedString(@"创建账户", nil);
        _creatView.leftImageView.image = IMAGE(@"bos_icon_chuangjian_default");
        
        WeakSelf(weakSelf);
        [_creatView setFirstItemTapBlock:^(FirstItemView * _Nonnull view) {
            if ([PassWordTool isExist]) {
                RedPacketCreateAccountViewController * vc = [[RedPacketCreateAccountViewController alloc]init];
                vc.isFrist = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                CreatAccountViewController * vc = [[CreatAccountViewController alloc]init];
                vc.navigationItem.title = NSLocalizedString(@"设置密码", nil);
                vc.addType = BOSAddAccountRedPacketCreate;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return _creatView;
}
-(UIButton *)languageButton{
    if (!_languageButton) {
        _languageButton = [[UIButton alloc]init];
        _languageButton.mj_size = CGSizeMake(BOS_W(63), BOS_H(22));
        [_languageButton addTarget:self action:@selector(languageAction:) forControlEvents:UIControlEventTouchUpInside];
        [_languageButton setImage:IMAGE(@"home_icon_switch_default") forState:UIControlStateNormal];
        [_languageButton setTitle:NSLocalizedString(@"English", nil) forState:UIControlStateNormal];
        [_languageButton setTitle:NSLocalizedString(@"中文", nil) forState:UIControlStateSelected];
        _languageButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [_languageButton setTitleColor:COLOR(@"#FFFFFF") forState:UIControlStateNormal];
        _languageButton.layer.borderColor = [COLOR(@"#FFFFFF") colorWithAlphaComponent:0.6].CGColor;
        _languageButton.layer.borderWidth = 0.5;
        _languageButton.layer.cornerRadius = 3;
        [_languageButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    }
    return _languageButton;
}
-(void)loadDefaultsSetting{
    self.navigationController.delegate = self;
    
    [self changeStatusBarStyle:1];
    
    [self.navigationController changeCurrentStatusBarStyle:1];
    
    NSString *  language = [DAConfig userLanguage];
    self.languageButton.selected = ![language isEqualToString:@"zh-Hans"];

}
-(void)initSubViews{
    [self.view addSubview:self.backGroundImageView];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.creatView];
    [self.view addSubview:self.importView];
    [self.view addSubview:self.languageButton];
    
    WeakSelf(weakSelf);
    
    [self.backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(weakSelf.view);
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).offset(BOS_H(90));
        make.width.mas_equalTo(BOS_W(150));
        make.height.mas_equalTo(BOS_H(100));
    }];
    
    [self.creatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf.view).offset(BOS_W(18));
        make.trailing.equalTo(weakSelf.view).offset(-BOS_W(18));
        make.centerY.equalTo(weakSelf.view).offset(BOS_H(15));
        make.height.mas_equalTo(BOS_H(64));
    }];
    
    [self.importView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.height.equalTo(weakSelf.creatView);
        make.top.equalTo(weakSelf.creatView.mas_bottom).offset(BOS_H(30));
    }];
    
    [self.languageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.view).offset(-BOS_W(15));
        if (IS_IPHONE_X) {
            make.top.equalTo(weakSelf.view).offset(BOS_H(30+15));
        }else{
            make.top.equalTo(weakSelf.view).offset(BOS_H(30));
        }
        make.height.mas_equalTo(BOS_H(22));
        make.width.mas_equalTo(63);
    }];
    
}
@end

@implementation FirstTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        UILabel * label = [[UILabel alloc]init];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR(@"#FFFFFF");
        _titleLabel = label;
    }
    return _titleLabel;
}
-(YYLabel *)descLabel{
    if (!_descLabel) {
        YYLabel * label = [[YYLabel alloc]init];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = COLOR(@"#FFFFFF");
        _descLabel = label;
    }
    return _descLabel;
}
-(UIImageView *)titleImageView{
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc]init];
    }
    return _titleImageView;
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.titleLabel];
    [self addSubview:self.descLabel];
    [self addSubview:self.titleImageView];
    
    self.titleImageView.image = IMAGE(@"bos_iicon_home_default");
    self.titleLabel.text = NSLocalizedString(@"BOS Wallet", nil);
    self.descLabel.text = NSLocalizedString(@"Born for DApps. Born for Usability", nil);
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    WeakSelf(weakSelf);
    
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.width.height.mas_equalTo(BOS_W(32.5));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf);
        make.top.equalTo(weakSelf.titleImageView.mas_bottom).offset(11.5);
    }];
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(9);
    }];
    
}

@end

