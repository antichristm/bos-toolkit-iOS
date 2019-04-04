
//
//  Created by Mac2 on 2017/7/18.
//  Copyright © 2017年 梁唐. All rights reserved.
//

#import "NaviSelectView.h"

#define aniViewCenterX ScreenWidth / (self.showCount * 2)
@interface NaviSelectView()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property(nonatomic,strong)UICollectionView * v_collection;
@property(nonatomic,strong)UIView * v_animation;
@property(nonatomic,assign)CGFloat itemW;
@property(nonatomic,strong)UICollectionViewCell * selectItem;
/**每页显示个数 默认为2*/
@property (nonatomic, assign) NSInteger showCount;
@end

static NSString * const V_OrderFormNaviItemID = @"V_OrderFormNaviItemID";

@implementation NaviSelectView
+(instancetype)initWithFrame:(CGRect)rect showCount:(NSInteger)count{
    NaviSelectView * navi = [[NaviSelectView alloc]initWithFrame:rect];
    navi.showCount = count;
    
    [navi loadDefaultsSetting];
    [navi initSubViews];
    return navi;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    return self;
}
-(void)setTitleArray:(NSArray *)TitleArray{
    _TitleArray = TitleArray;
    [self.v_collection reloadData];
    WeakSelf(weakself);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakself.TitleArray.count > 0 && weakself.DefaultSelectIndexPath.row < weakself.TitleArray.count) {
            [weakself.v_collection selectItemAtIndexPath:weakself.DefaultSelectIndexPath animated:true scrollPosition:UICollectionViewScrollPositionNone];
            self.selectItem  = [weakself.v_collection cellForItemAtIndexPath:weakself.DefaultSelectIndexPath];
            [self SetAnimationViewOffset];
        }
    });
}
-(void)setSelectTextColor:(UIColor *)SelectTextColor{
    _SelectTextColor = SelectTextColor;
    self.v_animation.backgroundColor = SelectTextColor;
}
-(void)setShowAnimationView:(BOOL)ShowAnimationView{
    _ShowAnimationView  = ShowAnimationView;
    self.v_animation.hidden = !ShowAnimationView;
}

#pragma mark --> 🐷 system delegate 🐷
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.TitleArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelelctItem * item = [collectionView dequeueReusableCellWithReuseIdentifier:V_OrderFormNaviItemID forIndexPath:indexPath];
    item.Font = self.Font;
    item.SelectFont = self.SelectFont;
    item.textColor = self.TextColor;
    item.selectTextColor = self.SelectTextColor;
    item.contentView.backgroundColor = self.ItemBGColor;
    item.title = self.TitleArray[indexPath.row];
    
    if (self.ImageArray) {
        item.imageName = self.ImageArray[indexPath.row];
    }
    
    return item;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.selectItem  = [collectionView dequeueReusableCellWithReuseIdentifier:V_OrderFormNaviItemID forIndexPath:indexPath];
    [self SetAnimationViewOffset];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selected:Index:navi:)]) {
        [self.delegate selected:self.TitleArray[indexPath.row] Index:indexPath navi:self];
    }
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
/**当前选中下标*/
-(void)setSelectedSegmentIndex:(NSInteger)SelectedSegmentIndex{
    _SelectedSegmentIndex  = SelectedSegmentIndex;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_SelectedSegmentIndex inSection:0];
    
    self.selectItem = [self.v_collection dequeueReusableCellWithReuseIdentifier:V_OrderFormNaviItemID forIndexPath:indexPath];
    //    self.selectItem  = [self.v_collection cellForItemAtIndexPath:indexPath];
    
    [self SetAnimationViewOffset];
    
    [self.v_collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self.v_collection scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}
#pragma mark --> 🐷 Private Methods 🐷
/**底部指示条偏移*/
-(void)SetAnimationViewOffset{
    WeakSelf(weakself);
    if (self.AnimationViewIsAnimation == YES) {
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint center = weakself.v_animation.center;
            center.x = weakself.selectItem.center.x;
            weakself.v_animation.center = center;
        }];
    }else{
        CGPoint center = self.v_animation.center;
        center.x = self.selectItem.center.x;
        self.v_animation.center = center;
    }
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    self.backgroundColor =  [UIColor whiteColor];

    self.AnimationViewIsAnimation = YES;
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    [self addSubview:self.v_collection];
}
#pragma mark --> 🐷 lazy loading 🐷
-(UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        UICollectionViewFlowLayout * layout  = [[UICollectionViewFlowLayout alloc]init];
        self.itemW =ScreenWidth / self.showCount;
        self.AnimationViewWidth = self.itemW;
        layout.itemSize = CGSizeMake(self.itemW, self.bounds.size.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout = layout;
    }
    return _layout;
}
-(UICollectionView * )v_collection{
    if (!_v_collection) {
        UICollectionView * v_collection = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:self.layout];
        [ v_collection registerClass:[SelelctItem class] forCellWithReuseIdentifier:V_OrderFormNaviItemID];
        v_collection.delegate = self;
        v_collection.dataSource = self;
//        v_collection.pagingEnabled = YES;
        v_collection.backgroundColor = self.ItemBGColor;
        v_collection.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            v_collection.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            v_collection.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            v_collection.scrollIndicatorInsets = v_collection.contentInset;
        }
     
        [self addSubview:v_collection];
        _v_collection = v_collection;
        [_v_collection addSubview:self.v_animation];
    }
    return _v_collection;
}
-(UIView *)v_animation{
    if (!_v_animation) {
        _v_animation = [[UIView alloc]init];
        _v_animation.backgroundColor = COLOR(@"#3594D8");
    }
    return _v_animation;
}
#pragma mark --> 🐷 重新布局 🐷
-(void)layoutSubviews{
    [super layoutSubviews];
    
    WeakSelf(weakself);
    if(self.v_collection){
        self.v_collection.frame =self.bounds;
        self.v_animation.frame = CGRectMake(0, 4, self.AnimationViewWidth,3);
        CGPoint center = CGPointMake(aniViewCenterX, self.bounds.size.height-1.5);
        self.v_animation.center = center;
    }
    if (self.selectItem) {
            CGPoint center = weakself.v_animation.center;
            center.x = weakself.selectItem.center.x;
            weakself.v_animation.center = center;
    }
}
-(void)dealloc{
    NSLog(@"NaviSelectView 号机自爆完成 !>_<!");
}
@end
/***********************************************************V_OrderFormNaviCell******************************************************************/
@implementation SelelctItem
+(instancetype)initWithCollectionView:(UICollectionView *)collectionView ID:(NSString *)ID indexPath:(NSIndexPath *)indexPath{
    SelelctItem * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[SelelctItem alloc]init];
    }
    return cell;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self loadDefaultsSetting];
    [self initSubViews];
    return self;
}
-(void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    if (imageName && imageName.length > 0) {
        self.markImageView  = [[UIImageView alloc]init];
        self.markImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.markImageView.image = IMAGE(imageName);
        [self.contentView addSubview:self.markImageView];
    }
}
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}
-(void)setSelected:(BOOL)selected{
    if (selected == YES) {
        self.titleLabel.textColor = self.selectTextColor;
        self.titleLabel.font = self.SelectFont ? self.SelectFont : self.Font;
    }else{
        self.titleLabel.font = self.Font;
        self.titleLabel.textColor = self.textColor;
    }
}
-(void)setFont:(UIFont *)Font{
    _Font = Font;
    self.titleLabel.font = _Font;
}
#pragma mark >_<! --> 加载默认设置
-(void)loadDefaultsSetting{
    self.contentView.backgroundColor =  [UIColor whiteColor];
}
#pragma mark >_<! --> 初始化子视图
-(void)initSubViews{
    
    self.titleLabel = [self InitlabelWithTextColor:nil font:[UIFont fontWithName:@"HelveticaNeue" size:14] bgColor:nil Alignment:NSTextAlignmentCenter];
    [self.contentView addSubview:self.titleLabel];
    
}
-(UILabel *)InitlabelWithTextColor:(NSString * __nullable)str_color font:(UIFont *)font bgColor:(NSString * __nullable)str_bgColor Alignment:(NSTextAlignment)alignment{
    UILabel * label = [[UILabel alloc]init];
    label.textColor = COLOR(str_color);
    label.font = font;
    label.textAlignment = alignment;
    if (str_bgColor) {
        label.backgroundColor = COLOR(str_bgColor);
    }
    
    return label;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.titleLabel.textColor = self.textColor;
    self.titleLabel.frame = self.bounds;
    if (self.markImageView) {
        self.markImageView.frame = CGRectMake(50, 20, 13, 13);
    }
}
@end

