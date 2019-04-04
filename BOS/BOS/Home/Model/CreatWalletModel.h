////  CreatWalletModel.h
//  BOS
//
//  Created by BOS on 2018/12/18.
//  Copyright © 2018 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CreatWalletModel : NSObject
@property (nonatomic, strong) NSString * titleStr;
@property (nonatomic, strong) NSString * btnTitle;
@property (nonatomic, strong) NSString * btnImage;
@property (nonatomic, strong) NSString * contentStr;
@property (nonatomic, strong) NSString * placeholder;
@property (nonatomic, strong) NSString * tips;
@property (nonatomic, strong) NSString * tipsColor;
@property (nonatomic, strong) NSNumber * cellHeight;
@property (nonatomic, assign) NSInteger  btnTag;
@end

NS_ASSUME_NONNULL_END
