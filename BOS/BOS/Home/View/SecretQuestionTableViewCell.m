////  SecretQuestionTableViewCell.m
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "SecretQuestionTableViewCell.h"

@interface SecretQuestionTableViewCell()


@property (nonatomic, assign) NSInteger currentQuestionIndex;

@end

@implementation SecretQuestionTableViewCell

- (void)creatUI {
    [super creatUI];
    WeakSelf(weakSelf);
    [self.contentView  addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.titleLabel);
        make.right.equalTo(weakSelf).mas_offset(- BOS_W(15));
        make.height.mas_equalTo(BOS_H(30));
        make.width.mas_equalTo(BOS_W(50));
    }];
}


- (void)ChangeAction{
    //更换密保咯
   
    if (self.questionArr.count>0) {
        self.currentQuestionIndex ++ ;
      NSInteger index = self.currentQuestionIndex % self.questionArr.count;
        self.titleString = self.questionArr[index];
        self.titleLabel.text = [NSString stringWithFormat:@"%d.%@",(int)self.cellIndex + 1 , self.questionArr[index]];
    }
    
}
-(void)setQuestionArr:(NSArray *)questionArr{
    _questionArr = questionArr;
    self.titleString = questionArr.firstObject;
     self.titleLabel.text = [NSString stringWithFormat:@"%d.%@",(int)self.cellIndex + 1 , questionArr.firstObject];
}

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [BOSTools buttonWithFrame:CGRectZero font:FONT(10) textColor:COLOR(@"#A2AAB6") backColor:nil target:self action:@selector(ChangeAction) text:NSLocalizedString(@" 换一个", nil) image:IMAGE(@"bos_icon_shuaxin_default") cornerRadius:0 superView:nil];
    }
    return _rightBtn;
}

@end
