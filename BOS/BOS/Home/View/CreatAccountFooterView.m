////  CreatAccountFooterView.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "CreatAccountFooterView.h"
#define nextSelectedColor COLOR(@"#526AF6")
#define nextNormalColor COLOR(@"#CFCFD1")
@interface CreatAccountFooterView()
@property(nonatomic,strong)UIButton * selelctedButton;
@property(nonatomic,strong)UIButton * nextButton;
@property(nonatomic,strong)YYLabel  * hintLabel;
@end
@implementation CreatAccountFooterView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(void)nextAction:(UIButton *)button{
    if (self.CreatAccountFooterNextBlock) {
        self.CreatAccountFooterNextBlock(button);
    }
    NSLog(@"下一步");
}
-(void)selectAction:(UIButton *)button{
    button.selected = !button.selected;
    NSLog(@"选择--%d",button.selected);
    self.nextButton.userInteractionEnabled = button.selected;
    self.nextButton.alpha = button.selected ?  1 : 0.5;
}
-(UIButton *)selelctedButton{
    if (!_selelctedButton) {
        _selelctedButton = [[UIButton alloc]init];
        [_selelctedButton setImage:IMAGE(@"bos_icon_gouxuan_default") forState:UIControlStateNormal];
        [_selelctedButton setImage:IMAGE(@"bos_icon_gouxuan_xuanzhong") forState:UIControlStateSelected];
        [_selelctedButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selelctedButton;
}
-(UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [[UIButton alloc]init];
        _nextButton.backgroundColor = SUBJECTCOLOR;
        _nextButton.alpha = 0.5;
        _nextButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [_nextButton setTitleColor:COLOR(@"FFFFFF") forState:UIControlStateNormal];
        _nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _nextButton.layer.cornerRadius = 3;
        [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.userInteractionEnabled = NO;
    }
    return _nextButton;
}
-(YYLabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = [[YYLabel alloc]init];
        _hintLabel.textColor = COLOR(@"#666666");
        _hintLabel.numberOfLines = 0;
        NSString * prefix = NSLocalizedString(@"我已仔细阅读并同意", nil);
        NSString * suffix = NSLocalizedString(@"《服务隐私条款》", nil);
        NSString * hint = [NSString stringWithFormat:@"%@%@",prefix,suffix];
        NSMutableAttributedString * text = [[NSMutableAttributedString alloc]initWithString:hint];
        
        NSRange range = [hint rangeOfString:suffix];
        
        [text yy_setTextHighlightRange:range color:COLOR(@"#526AF6") backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            NSLog(@"点我");
            //使用帮助
//            WebViewController *VC = [[WebViewController alloc] init];
//            VC.url = @"https://www.boscore.io/tool.html";
//            VC.title = NSLocalizedString(@"使用帮助", nil);
//            [self.navigationController pushViewController:VC animated:YES];
        }];
        
        
        _hintLabel.attributedText = text;
    }
    return _hintLabel;
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.hintLabel];
    [self addSubview:self.selelctedButton];
    [self addSubview:self.nextButton];
    self.hintLabel.hidden = YES;
    [self.nextButton setTitle:NSLocalizedString(@"下一步", nil) forState:UIControlStateNormal];
    

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    
    [self.selelctedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.top.equalTo(weakSelf).offset(BOS_H(15));
        make.width.height.mas_equalTo(BOS_W(17));
    }];
    [self.selelctedButton setEnlargeEdgeWithTop:10 right:100 bottom:10 left:10];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.selelctedButton);
        make.leading.equalTo(weakSelf.selelctedButton.mas_trailing).offset(BOS_W(8));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
        make.top.equalTo(weakSelf.hintLabel.mas_bottom).offset(BOS_H(80));
        make.height.mas_equalTo(BOS_H(42.5));
    }];
}

@end
