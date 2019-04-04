////  CreatAccountTextCell.m
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "CreatAccountTextCell.h"
@interface CreatAccountTextCell()
<
TYLimitedTextFieldDelegate
>
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)TYLimitedTextField * contentField;
@end
@implementation CreatAccountTextCell

+(instancetype)initWithTableView:(UITableView *)tableView ID:(NSString *)ID{
    CreatAccountTextCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[CreatAccountTextCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadDefaultsSetting];
        [self initSubViews];
    }
    return self;
}
-(void)configModel:(id)model{
    @try {
        NSDictionary * info = (NSDictionary *)model;
        self.titleLabel.text = info[@"title"];
        self.contentField.placeholder = info[@"placeHolder"];
        
        NSString * type = info[@"type"];
        if (type.integerValue ==1) {
            self.contentField.limitedType = TYLimitedTextFieldTypePassword;
            self.contentField.secureTextEntry = YES;
        }else if(type.integerValue == 2){
            self.contentField.limitedType = TYLimitedTextFieldTypeNomal;
            self.contentField.secureTextEntry = NO;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"error--%@",exception);
    } @finally { }
}
-(void)limitedTextFieldDidChange:(UITextField *)textField{
    if (self.CreatAccountTextBlock) {
        self.CreatAccountTextBlock(self, textField.text);
    }
}
-(void)loadDefaultsSetting{
    
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _titleLabel.textColor = TEXTCOLOR;
    }
    return _titleLabel;
}

-(TYLimitedTextField *)contentField{
    if (!_contentField) {
        _contentField = [[TYLimitedTextField alloc]init];
        _contentField.backgroundColor = COLOR(@"#EFF2F6");
        _contentField.placeholderFont = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _contentField.placeholderColor = COLOR(@"#BEBEBE");
        _contentField.maxLength  =  16;
        _contentField.leftPadding = 10;
        _contentField.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _contentField.textColor = TEXTCOLOR;
        _contentField.layer.cornerRadius = 5;
        _contentField.layer.masksToBounds = YES;
        _contentField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _contentField.realDelegate = self;
    }
    return _contentField;
}
-(void)initSubViews{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentField];
    
    self.titleLabel.text = @"密码";
    self.contentField.placeholder = @"请输入密码";
    
    WeakSelf(weakSelf);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(BOS_H(15));
        make.leading.equalTo(weakSelf).offset(BOS_W(15));
        make.trailing.equalTo(weakSelf).offset(-BOS_W(15));
    }];
    
    [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(weakSelf.titleLabel);
        make.top.equalTo(weakSelf.titleLabel.mas_bottom).offset(BOS_H(10));
        make.height.mas_equalTo(BOS_H(45));
    }];
}
@end
