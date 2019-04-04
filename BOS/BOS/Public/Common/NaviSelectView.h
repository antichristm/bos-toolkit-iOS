
//  Created by Mac2 on 2017/7/18.
//  Copyright © 2017年 梁唐. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelelctItem;

@protocol NaviSelectViewDelegate <NSObject>
-(void)selected:(NSString *)title Index:(NSIndexPath *)index navi:(UIView*)navi;
@end

@interface NaviSelectView : UIView
/**数据源*/
@property(nonatomic,strong)NSArray * TitleArray;
/**数据源图片*/
@property(nonatomic,strong)NSArray * ImageArray;
/**当前选中下标*/
@property (nonatomic, assign) NSInteger SelectedSegmentIndex;
/**默认选中下标*/
@property (nonatomic, strong) NSIndexPath * DefaultSelectIndexPath;
/**字体颜色*/
@property(nonatomic,strong)UIColor * TextColor;
/**选中字体颜色*/
@property(nonatomic,strong)UIColor * SelectTextColor;
/**item背景色*/
@property(nonatomic,strong)UIColor * ItemBGColor;
/**字体样式*/
@property(nonatomic,strong)UIFont * Font;
/**字体样式*/
@property(nonatomic,strong)UIFont * SelectFont;
/**是否显示底部动画条*/
@property(nonatomic,assign)BOOL ShowAnimationView;
/**底部选中标识条动画 默认YES*/
@property(nonatomic,assign)BOOL AnimationViewIsAnimation;
/**底部动画条宽度  默认和按钮同宽*/
@property(nonatomic,assign)CGFloat AnimationViewWidth;
/**item布局属性*/
@property(nonatomic,strong)UICollectionViewFlowLayout * layout;
/**代理*/
@property(nonatomic,weak)id<NaviSelectViewDelegate>  delegate;

+(instancetype)initWithFrame:(CGRect)rect showCount:(NSInteger)count;
@end
/***********************************************************V_OrderFormNaviCell******************************************************************/

@interface SelelctItem : UICollectionViewCell
@property(nonatomic,copy)NSString * title;
@property(nonatomic,strong)UIColor * textColor;
@property(nonatomic,strong)UIColor * selectTextColor;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,copy)NSString * imageName;
@property(nonatomic,strong)UIImageView * markImageView;
@property(nonatomic,strong)UIFont * Font;
@property(nonatomic,strong)UIFont * SelectFont;
+(instancetype)initWithCollectionView:(UICollectionView *)collectionView ID:(NSString *)ID indexPath:(NSIndexPath *)indexPath;
@end
