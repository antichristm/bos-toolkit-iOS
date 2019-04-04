//
//  BOSTools.h
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BOSTools : NSObject

+ (CGFloat)ScaleHeight:(CGFloat)Height;

+ (CGFloat)ScaleWidth:(CGFloat)Width;

+ (UIImage *)CreateImageWithColor:(UIColor *)color;

+ (NSAttributedString *)attributString:(NSString *)string color:(nullable UIColor *)color font:(UIFont *)font Spac:(float) spac textAligment:(NSTextAlignment)textAligment attribute:(nullable NSDictionary *)dic;

+(NSAttributedString *)setLineSpace:(CGFloat)lineSpace ParagraphSpacing:(CGFloat)paragraphSpace  kern:(CGFloat)kern string:(NSString *)string font:(UIFont * )font color:(UIColor *)color;

+ (NSString *)stringCutWhitespaceAndNewline:(NSString *)str;

+ (UIView *)viewWithFrame:(CGRect)rect color:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius superView:(nullable UIView *)superView;

//建button
+ (UIButton *)buttonWithFrame:(CGRect)rect font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor backColor:(nullable UIColor *)backColor target:(nullable id)target action:(nullable SEL)action text:(nullable NSString *)text image:(nullable UIImage *)image cornerRadius:(CGFloat)cornerRadius superView:(nullable UIView *)superView;

//建label
+ (UILabel *)labelWithFrame:(CGRect)rect font:(nullable UIFont *)font color:(nullable UIColor *)color alpha:(float)alpha textAlignment:(NSTextAlignment)alignment text:(nullable NSString *)text superView:(nullable UIView *)superView;

+ (UITableView *)tableviewFrame:(CGRect)rect backColor:(nullable UIColor *)backColor delegate:(nullable id<UITableViewDelegate>)delegate dataSource:(nullable id<UITableViewDataSource>)dataSource rowHeight:(CGFloat)rowHeight estimateRowHeight:(CGFloat)estiHeight superView:(nullable UIView *)superView;

+ (UITableView *)tableviewFrame:(CGRect)rect style:(UITableViewStyle)style backColor:(nullable UIColor *)backColor delegate:(nullable id<UITableViewDelegate>)delegate dataSource:(nullable id<UITableViewDataSource>)dataSource rowHeight:(CGFloat)rowHeight estimateRowHeight:(CGFloat)estiHeight superView:(nullable UIView *)superView;

//建图片
+ (UIImageView *)imageViewWithFrame:(CGRect)rect image:(nullable UIImage*)image superView:(nullable UIView *)superView;

+ (CGSize)boundsWithString:(NSAttributedString *)sttributeString superSize:(CGSize)superSize;

+ (void)RestoreRootViewController:(UIViewController *)Controller;

+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString;

+(NSString *)jsonStringFromDictionary:(NSDictionary *)dict;
/**
 获取当前时间
 */
+(NSString *)getNowTimeTimestamp;

/**
 格式化时间

 @param strDate 时间戳字符串
 @param format 格式
 @return 结果
 */
+(NSString *)transformDate:(NSString *)strDate format:(NSString *)format;
/**获取设备型号*/
+(NSString*)getDeviceVersion;

/**
 判断空字符串
 */
+ (BOOL)isBlankString:(NSString *)str;

+(NSDecimalNumber *)doubleToDecimal:(double)value length:(int)length mode:(NSRoundingMode)mode;

+(NSString *)timeT:(double)time stringFormatter:(NSString *)str;

@end

NS_ASSUME_NONNULL_END
