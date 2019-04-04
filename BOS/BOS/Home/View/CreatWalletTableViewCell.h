////  CreatWalletTableViewCell.h
//  BOS
//
//  Created by BOS on 2018/12/18.
//  Copyright © 2018 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CreatWalletTableViewCellDelegate;

@interface CreatWalletTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet id<CreatWalletTableViewCellDelegate> delegate;
@property (nonatomic, strong) CreatWalletModel * model;
- (void)setCellWithModel:(CreatWalletModel *)model;

@end

@protocol CreatWalletTableViewCellDelegate <NSObject>

- (void)clickRightBtn:(UIButton *)btn;

@end
NS_ASSUME_NONNULL_END
