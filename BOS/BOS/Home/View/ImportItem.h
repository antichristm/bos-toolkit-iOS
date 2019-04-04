////  ImportItem.h
//  BOS
//
//  Created by BOS on 2018/12/18.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <YYText.h>
typedef NS_ENUM(NSUInteger, ImportType) {
    ImportTypeKeyStore,
    ImportTypePrivate,
    ImportTypeCloud,
};
NS_ASSUME_NONNULL_BEGIN

@interface ImportItem : UIView
@property(nonatomic,strong)YYTextView * contentField;
@property(nonatomic,strong)UIButton * importButton;
@property(nonatomic,strong)UIButton * importHintButton;
@property(nonatomic,copy)void(^importBlock)(NSDictionary * info,ImportType type,UIButton * button);
@property(nonatomic,copy)void(^importHintBlock)(ImportType type,UIButton * button);
+(instancetype)initWithImportType:(ImportType)ImportType;
-(void)importAction:(UIButton *)button;
@end



@interface ImportItemKeystore : ImportItem
@property(nonatomic,strong)TYLimitedTextField * passField;
@end

@interface ImportItemPrivate : ImportItem

@end

@interface ImportItemCloud : ImportItem
@property(nonatomic,strong)UIImageView * cloudImageView;
@end

NS_ASSUME_NONNULL_END
