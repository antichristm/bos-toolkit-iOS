////  AccountImportViewController.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "AccountImportViewController.h"

@interface AccountImportViewController ()
<
UIScrollViewDelegate,
NaviSelectViewDelegate
>
@property(nonatomic,strong)UIScrollView * scrollview;
@property(nonatomic,strong)NaviSelectView * selectView;
@end

@implementation AccountImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDefaultsSetting];
    [self initSubViews];
}

#pragma mark  🐷System Delegate🐷
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentIndex = scrollView.contentOffset.x / ScreenWidth;
    [self.selectView setSelectedSegmentIndex:currentIndex];
}
#pragma mark  🐷Custom Delegate🐷
-(void)selected:(NSString *)title Index:(NSIndexPath *)index navi:(UIView *)navi{
    [self.view endEditing:YES];
    [self.scrollview setContentOffset:CGPointMake(index.row * self.scrollview.mj_w, self.scrollview.contentOffset.y) animated:YES];
}
#pragma mark  🐷Event  Response🐷
#pragma mark  🐷Private Methods🐷
-(void)verifyPasswordWithType:(ImportType)type info:(NSDictionary *)info{
    PassWorldView * view = [[PassWorldView alloc]init];
    view.title = NSLocalizedString(@"本地密码", nil);
    [view showView];
    [view setPasswordBlock:^(NSString * _Nonnull password) {
        
        if ([PassWordTool verifyPassword:password]) {
            [self importWithType:type info:info password:password];
        }else{
            [XWHUDManager showTipHUD:NSLocalizedString(@"密码错误", nil)];
        }
    }];
}
-(void)importActionWithType:(ImportType)type info:(NSDictionary *)info{
    
    switch (type) {
        case ImportTypeKeyStore:{
            [self verifyPasswordWithType:type info:info];
        }
            
            break;
            
        case ImportTypePrivate:{
            [self verifyPasswordWithType:type info:info];
        }
            
            break;
            
        case ImportTypeCloud:{
            CloudManagerViewController * vc = [[CloudManagerViewController alloc]init];
            vc.navigationItem.title = NSLocalizedString(@"云端同步", nil);
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}
-(void)importWithType:(NSInteger)type info:(NSDictionary *)info password:(NSString *)pasword{
    [XWHUDManager showHUDMessage:NSLocalizedString(@"导入中......", nil)];
    [BOSImportManager importWithType:type info:info locPass:pasword completion:^(NSDictionary * _Nonnull response) {
        [XWHUDManager hide];
        NSString * code = response[@"code"];
        [BOSImportManager showFailMessage:code.integerValue message:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (code.integerValue == 10000) {
                UIViewController * rootVC = self.navigationController.childViewControllers[0];
                if ([rootVC isKindOfClass:[FirstViewController class]]) {
                    [BOSTools RestoreRootViewController:[[BaseTabBarController alloc]init]];
                }else{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
        });
        NSLog(@"---->%@",response);
    }];
}
#pragma mark  🐷Lazy loading🐷
-(UIScrollView *)scrollview{
    if (_scrollview == nil) {
        _scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+1.5, ScreenWidth, ScreenHeight)];
        _scrollview.pagingEnabled = YES;
        _scrollview.delegate = self;
        _scrollview.showsHorizontalScrollIndicator = NO;
        _scrollview.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight);
    }
    return _scrollview;
}
-(NaviSelectView *)selectView{
    if (!_selectView) {
        _selectView = [NaviSelectView initWithFrame:CGRectMake(0, 0, ScreenWidth , BOS_H(44)) showCount:3];
        _selectView.DefaultSelectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        _selectView.Font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _selectView.TextColor = COLOR(@"#A2AAB6");
        _selectView.SelectTextColor = SUBJECTCOLOR;
        _selectView.TitleArray = @[NSLocalizedString(@"KeyStore", nil),NSLocalizedString(@"私钥", nil),NSLocalizedString(@"云端同步", nil)];
        _selectView.AnimationViewWidth = BOS_W(55);
        _selectView.delegate = self;
        _selectView.ItemBGColor = COLOR(@"#FFFFFF");
        _selectView.backgroundColor = COLOR(@"#FFFFFF");
    }
    return    _selectView;
}
#pragma mark  🐷Init SubViews🐷

-(void)loadDefaultsSetting{
    self.view.backgroundColor = BACKGROUNDCOLOR;
}
-(void)initSubViews{
    [self.view addSubview:self.selectView];
    [self.view addSubview:self.scrollview];
    self.selectView.delegate = self;
    
    WeakSelf(weakSelf);
    for (NSInteger index = 0; index < 3; index++) {
        ImportItem * item = [ImportItem initWithImportType:index];
        item.importHintButton.hidden = YES;
        item.backgroundColor = COLOR(@"FFFFFF");
        
        [item setImportBlock:^(NSDictionary * _Nonnull info, ImportType type, UIButton * _Nonnull button) {
            [weakSelf.view endEditing:YES];
            [weakSelf importActionWithType:type info:info];
        }];
        
        item.frame = CGRectMake(index * self.scrollview.mj_w, 0, self.scrollview.mj_w, self.scrollview.mj_h);
        [self.scrollview addSubview:item];
    }
}

@end
