////  TextTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface TextTableViewCell :BaseTableViewCell

@property (nonatomic, copy) NSString *message;
@property (nonatomic, strong) NSAttributedString *attMessage;

@end

NS_ASSUME_NONNULL_END
