////  ImportItem.m
//  BOS
//
//  Created by BOS on 2018/12/18.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "ImportItem.h"
@interface ImportItem()
@property(nonatomic,assign)ImportType type;
@end
@implementation ImportItem
+(instancetype)initWithImportType:(ImportType)ImportType{
    ImportItem * item;
    switch (ImportType) {
        case ImportTypeKeyStore:{
            item = [[ImportItemKeystore alloc]init];
            
        }
            
            break;
            
        case ImportTypePrivate:{
            item = [[ImportItemPrivate alloc]init];
            
        }
            
            break;
            
        case ImportTypeCloud:{
            item = [[ImportItemCloud alloc]init];
        }
            
            break;
            
        default:{
             item = [[ImportItemKeystore alloc]init];
        }
            break;
    }
    
    item.type = ImportType;
    return item;
}
-(void)importAction:(UIButton *)button{

}
-(void)importHintAction:(UIButton *)button{
    if (self.importHintButton) {
        self.importHintBlock(self.type, button);
    }
}
-(UIButton *)importButton{
    if (!_importButton) {
        _importButton = [[UIButton alloc]init];
        _importButton.backgroundColor = SUBJECTCOLOR;
        [_importButton setTitleColor:COLOR(@"#FFFFFF") forState:UIControlStateNormal];
        _importButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [_importButton setTitle:NSLocalizedString(@"导入账户", nil) forState:UIControlStateNormal];
        [_importButton addTarget:self action:@selector(importAction:) forControlEvents:UIControlEventTouchUpInside];
        _importButton.layer.cornerRadius = 5;
    }
    return _importButton;
}
-(UIButton *)importHintButton{
    if (!_importHintButton) {
        _importHintButton = [[UIButton alloc]init];
        [_importHintButton setTitleColor:SUBJECTCOLOR forState:UIControlStateNormal];
        _importHintButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [_importHintButton setTitle:NSLocalizedString(@"导入帮助", nil) forState:UIControlStateNormal];
        [_importHintButton addTarget:self action:@selector(importHintAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _importHintButton;
}
-(YYTextView *)contentField{
    if (!_contentField) {
        _contentField = [[YYTextView alloc]init];
        _contentField.contentInset = UIEdgeInsetsMake(10, 15, 10, 15);
        _contentField.placeholderTextColor = COLOR(@"#999999");
        _contentField.textColor = TEXTCOLOR;
        _contentField.placeholderFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _contentField.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _contentField.layer.borderColor = [COLOR(@"#999999") colorWithAlphaComponent:0.35].CGColor;
        _contentField.layer.borderWidth = 0.7;
        _contentField.layer.cornerRadius = 3;
        _contentField.showsHorizontalScrollIndicator = NO;
    }
    return _contentField;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{

    

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
 
}
@end


/***************************************************************************************************************/


@implementation ImportItemKeystore

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(void)importAction:(UIButton *)button{
    if (self.importBlock) {
        NSString * content = [self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSString * pass = [self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        pass = [pass stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        pass = [pass stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSDictionary * dict = @{
                                @"content" : content,
                                @"password" : self.passField.text
                                };
        if (content.length == 0 || !content) {
            [XWHUDManager showTipHUD:NSLocalizedString(@"请输入Keystore", nil)];
            return;
        }
        if (!pass || pass.length == 0) {
            [XWHUDManager showTipHUD:NSLocalizedString(@"请输入密码", nil)];
            return;
        }
        self.importBlock(dict, self.type, button);
    }
}
-(TYLimitedTextField *)passField{
    if (!_passField) {
        _passField = [[TYLimitedTextField alloc]init];
        _passField.limitedType = TYLimitedTextFieldTypePassword;
        _passField.secureTextEntry = YES;
        _passField.placeholderColor = COLOR(@"#999999");
        _passField.placeholderFont = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _passField.textColor = TEXTCOLOR;
        _passField.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        _passField.leftPadding = 15;
        _passField.layer.cornerRadius = 3;
        _passField.layer.borderColor = [COLOR(@"#999999") colorWithAlphaComponent:0.35].CGColor;
        _passField.layer.borderWidth = 0.7;
        _passField.placeholder = NSLocalizedString(@"请输入KeyStore密码", nil);
    }
    return _passField;
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.contentField];
    [self addSubview:self.importButton];
    [self addSubview:self.importHintButton];
    [self addSubview:self.passField];
    
    self.contentField.placeholderText = NSLocalizedString(@"请输入Keystore", nil);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(BOS_H(10));
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(108));
    }];
    
    [self.passField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.contentField);
        make.top.equalTo(weakSelf.contentField.mas_bottom).offset(BOS_H(15));
        make.height.mas_equalTo(BOS_H(52.5));
    }];
    
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.contentField);
        make.height.mas_equalTo(BOS_H(42.5));
        make.top.equalTo(weakSelf.passField.mas_bottom).offset(BOS_H(85));
    }];
    
    [self.importHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.importButton);
        make.top.equalTo(weakSelf.importButton.mas_bottom).offset(BOS_H(20));
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(30);
    }];
}

@end


/***************************************************************************************************************/

@implementation ImportItemPrivate

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(void)importAction:(UIButton *)button{
    if (self.importBlock) {
        NSString * content = [self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        content = [content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        
        NSDictionary * dict = @{
                                @"content" : content,
                                @"password" : @""
                                };
        
        if (content.length == 0 || !content) {
            [XWHUDManager showTipHUD:NSLocalizedString(@"请输入明文私钥", nil)];
            return;
        }
        self.importBlock(dict, self.type, button);
    }
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.contentField];
    [self addSubview:self.importButton];
    [self addSubview:self.importHintButton];
    self.contentField.placeholderText = NSLocalizedString(@"请输入明文私钥", nil);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(BOS_H(10));
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(157));
    }];
    
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.contentField);
        make.height.mas_equalTo(BOS_H(42.5));
        make.top.equalTo(weakSelf.contentField.mas_bottom).offset(BOS_H(85));
    }];
    
    [self.importHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.importButton);
        make.top.equalTo(weakSelf.importButton.mas_bottom).offset(BOS_H(20));
    }];
}

@end

/***************************************************************************************************************/

@implementation ImportItemCloud

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self loadDefaultsSetting];
    [self initSubViews];
    
    return self;
    
}
-(void)importAction:(UIButton *)button{
    if (self.importBlock) {
        NSDictionary * dict = @{
                                @"content" : self.contentField.text,
                                @"password" : @""
                                };
        self.importBlock(dict, self.type, button);
    }
}
-(UIImageView *)cloudImageView{
    if (!_cloudImageView) {
        _cloudImageView = [[UIImageView alloc]init];
        _cloudImageView.image = IMAGE(@"bos_icon_yun_default");
        _cloudImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _cloudImageView;
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    
    [self addSubview:self.contentField];
    [self addSubview:self.importButton];
    [self addSubview:self.importHintButton];
    [self addSubview:self.cloudImageView];
    
    self.contentField.layer.borderWidth = 0;
    self.contentField.userInteractionEnabled = NO;
    self.contentField.backgroundColor = [COLOR(@"#D8D8D8") colorWithAlphaComponent:0.35];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakSelf);
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(BOS_H(10));
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
        make.height.mas_equalTo(BOS_H(157));
    }];
    
    [self.importButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.contentField);
        make.height.mas_equalTo(BOS_H(42.5));
        make.top.equalTo(weakSelf.contentField.mas_bottom).offset(BOS_H(85));
    }];
    
    [self.importHintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.importButton);
        make.top.equalTo(weakSelf.importButton.mas_bottom).offset(BOS_H(20));
    }];
    
    [self.cloudImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(weakSelf.contentField);
    }];
}

@end
