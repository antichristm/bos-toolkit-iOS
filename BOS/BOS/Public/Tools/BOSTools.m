//
//  BOSTools.m
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import "BOSTools.h"
#import <sys/utsname.h>
#import "AppDelegate.h"
@implementation BOSTools
+ (CGFloat)ScaleHeight:(CGFloat )Height
{
    CGFloat scale = Height / 667;
    CGFloat sss = ScreenHeight * scale;
    if (IS_IPHONE_X == YES) {
        sss = 667 * scale;
    }
    return sss;
}

+ (CGFloat)ScaleWidth:(CGFloat)Width
{
    CGFloat scale = Width / 375;
    CGFloat sss = ScreenWidth * scale;
    return sss;
}
+ (UIImage *)CreateImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
+(NSAttributedString *)setLineSpace:(CGFloat)lineSpace ParagraphSpacing:(CGFloat)paragraphSpace  kern:(CGFloat)kern string:(NSString *)string font:(UIFont * )font color:(UIColor *)color{
    if (string.length == 0 || !string) {
        return nil;
    }
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = lineSpace;
    [style setParagraphSpacing:paragraphSpace];
    NSDictionary * dict = @{NSParagraphStyleAttributeName : style,NSKernAttributeName : @(kern),NSFontAttributeName : font,NSForegroundColorAttributeName : color};
    NSMutableAttributedString * att = [[NSMutableAttributedString alloc]initWithString:string attributes:dict];
    
    return att;
}
+ (NSAttributedString *)attributString:(NSString *)string color:(nullable UIColor *)color font:(UIFont *)font Spac:(float) spac textAligment:(NSTextAlignment)textAligment attribute:(nullable NSDictionary *)dic {
    if (!string ) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    NSMutableDictionary * newDic = [NSMutableDictionary dictionary];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = textAligment;
    [newDic setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    if (spac > 0) {
       [paragraphStyle setLineSpacing:spac];
        
    }
    if (color) {
        [newDic setObject:color forKey:NSForegroundColorAttributeName];
    }
    if (font) {
        [newDic setObject:font forKey:NSFontAttributeName];
    }
    if (dic) {
        [newDic setValuesForKeysWithDictionary:dic];
        
    }
    dic = [NSDictionary dictionaryWithDictionary:newDic];
    
    return  [[NSAttributedString alloc] initWithString:string?:@"" attributes:dic];
}

+ (NSString *)stringCutWhitespaceAndNewline:(NSString *)str {
    if (![str isKindOfClass:[NSString class]]) {
        return @"";
    }else{
        return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
}

+ (UIView *)viewWithFrame:(CGRect)rect color:(nullable UIColor *)color cornerRadius:(CGFloat)cornerRadius superView:(nullable UIView *)superView {
    UIView * View = [[UIView alloc] initWithFrame:rect];
    if (color) {
        View.backgroundColor = color;
    }
    if (cornerRadius > 0.0) {
        View.layer.cornerRadius = cornerRadius;
    }
    if (superView) {
        [superView addSubview:View];
    }
    return  View;
}

+ (UIButton *)buttonWithFrame:(CGRect)rect font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor backColor:(nullable UIColor *)backColor target:(nullable id)target action:(nullable SEL)action text:(nullable NSString *)text image:(nullable UIImage *)image cornerRadius:(CGFloat)cornerRadius superView:(nullable UIView *)superView {
    UIButton * button = [[UIButton alloc] initWithFrame:rect];
    if (font) {
        button.titleLabel.font = font;
    }
    if (textColor) {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
    if (backColor) {
        button.backgroundColor = backColor;
    }
    if (target && action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (text) {
        [button setTitle:text forState:UIControlStateNormal];
    }
    if (image) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (cornerRadius > 0.0) {
        button.layer.cornerRadius = cornerRadius;
        button.clipsToBounds = YES;
    }
    if (superView) {
        [superView addSubview:button];
    }
    
    return button;
}

+ (UILabel *)labelWithFrame:(CGRect)rect font:(nullable UIFont *)font color:(nullable UIColor *)color alpha:(float)alpha textAlignment:(NSTextAlignment)alignment text:(nullable NSString *)text superView:(nullable UIView *)superView {
    UILabel * label = [[UILabel alloc] initWithFrame:rect];
    label.numberOfLines = 0;
    if (font) {
        label.font = font;
    }
    if (alignment) {
        label.textAlignment = alignment;
    }
    if (color) {
        label.textColor = color;
    }
    if (alpha) {
        label.alpha = alpha;
    }
    if (text) {
        label.text = text;
    }
    if (superView) {
        [superView addSubview:label];
    }
    return label;
}

+ (UILabel *)labelWithSubClass:(Class)classname Frame:(CGRect)rect font:(UIFont *)font color:(UIColor *)color alpha:(float)alpha textAlignment:(NSTextAlignment)alignment text:(NSString *)text superView:(UIView *)superView {
    UILabel * label = [[classname alloc] initWithFrame:rect];
    label.numberOfLines = 0;
    if (font) {
        label.font = font;
    }
    if (alignment) {
        label.textAlignment = alignment;
    }
    if (color) {
        label.textColor = color;
    }
    if (alpha) {
        label.alpha = alpha;
    }
    if (text) {
        label.text = text;
    }
    if (superView) {
        [superView addSubview:label];
    }
    return label;
}

+ (UITableView *)tableviewFrame:(CGRect)rect backColor:(nullable UIColor *)backColor delegate:(nullable id<UITableViewDelegate>)delegate dataSource:(nullable id<UITableViewDataSource>)dataSource rowHeight:(CGFloat)rowHeight estimateRowHeight:(CGFloat)estiHeight superView:(nullable UIView *)superView {
    UITableView * tableview;
    tableview = [[UITableView alloc] initWithFrame:rect];
    if ([superView isKindOfClass:[UIView class]]) {
        [superView addSubview:tableview];
    }
    if (backColor) {
        tableview.backgroundColor = backColor;
    }
    
    tableview.delegate = delegate;
    tableview.dataSource = dataSource;
    tableview.separatorStyle = 0;
    tableview.rowHeight = rowHeight;
    tableview.estimatedRowHeight = estiHeight;
    tableview.showsHorizontalScrollIndicator = NO;
    tableview.showsVerticalScrollIndicator = NO;
    return tableview;
}

+ (UITableView *)tableviewFrame:(CGRect)rect style:(UITableViewStyle)style backColor:(nullable UIColor *)backColor delegate:(nullable id<UITableViewDelegate>)delegate dataSource:(nullable id<UITableViewDataSource>)dataSource rowHeight:(CGFloat)rowHeight estimateRowHeight:(CGFloat)estiHeight superView:(nullable UIView *)superView {
    UITableView * tableview;
    tableview = [[UITableView alloc] initWithFrame:rect style:style];
    if ([superView isKindOfClass:[UIView class]]) {
        [superView addSubview:tableview];
    }
    if (backColor) {
        tableview.backgroundColor = backColor;
    }
    
    tableview.delegate = delegate;
    tableview.dataSource = dataSource;
    tableview.separatorStyle = 0;
    tableview.rowHeight = rowHeight;
    tableview.estimatedRowHeight = estiHeight;
    tableview.showsHorizontalScrollIndicator = NO;
    tableview.showsVerticalScrollIndicator = NO;
    return tableview;
}

+ (UIImageView *)imageViewWithFrame:(CGRect)rect image:(nullable UIImage*)image superView:(nullable UIView *)superView {
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:rect];
    if (image) {
        imgView.image = image;
    }
    if (superView) {
        [superView addSubview:imgView];
    }
    return imgView;
}
+(NSString*)getDeviceVersion{
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString * platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if([platform isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    
    if([platform isEqualToString:@"iPhone10,2"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    
    if([platform isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    
    if([platform isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    
    if([platform isEqualToString:@"iPhone11,4"]) return @"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    
    if([platform isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    
    if([platform isEqualToString:@"iPod1,1"]) return @"iPod Touch 1G";
    
    if([platform isEqualToString:@"iPod2,1"]) return @"iPod Touch 2G";
    
    if([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";
    
    if([platform isEqualToString:@"iPad4,7"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,8"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad4,9"]) return @"iPad Mini 3";
    
    if([platform isEqualToString:@"iPad5,1"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,2"]) return @"iPad Mini 4";
    
    if([platform isEqualToString:@"iPad5,3"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad5,4"]) return @"iPad Air 2";
    
    if([platform isEqualToString:@"iPad6,3"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,4"]) return @"iPad Pro 9.7";
    
    if([platform isEqualToString:@"iPad6,7"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"iPad6,8"]) return @"iPad Pro 12.9";
    
    if([platform isEqualToString:@"i386"]) return @"iPhone Simulator";
    
    if([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}

+(NSString *)getNowTimeTimestamp{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}
+(NSString *)transformDate:(NSString *)strDate format:(NSString *)format{
    if (strDate.length == 0 || !strDate) {
        return NSLocalizedString(@"暂无时间", nil);
    }
    NSInteger num = [strDate integerValue];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate * confromTime = [NSDate dateWithTimeIntervalSince1970:num];
    NSString * comfromTimeStr = [formatter stringFromDate:confromTime];
    return comfromTimeStr;
}
+ (CGSize)boundsWithString:(NSAttributedString *)sttributeString superSize:(CGSize)superSize {
    CGRect rect = [sttributeString boundingRectWithSize:superSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size;
}
+ (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+(NSString *)jsonStringFromDictionary:(NSDictionary *)dict{
    NSError *error;
    if (!dict) {
        return @"";
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}
+(void)RestoreRootViewController:(UIViewController *)Controller{
    dispatch_async(dispatch_get_main_queue(), ^{
        typedef void (^Animation)(void);
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        //        Controller.modalPresentationStyle = UIModalPresentationFormSheet;
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        Animation animation = ^{
            
            BOOL oldState = [UIView areAnimationsEnabled];
            [UIView setAnimationsEnabled:NO];
            appDelegate.window.rootViewController = Controller;
            [UIView setAnimationsEnabled:oldState];
        };
        NSLocalizedString(@"ddd", nil);
        [UIView transitionWithView: appDelegate.window
                          duration:0.35f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:animation
                        completion:nil];
    });
}

+ (BOOL)isBlankString:(NSString *)str{
    if (str == nil)   return YES;
    
    if (str == NULL)  return YES;
    
    if ([str isEqualToString:@""])  return YES;
    
    if ([str isKindOfClass:[NSNull class]]) return YES;
    
    if ([[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) return YES;
    
    return NO;
}

+(NSDecimalNumber *)doubleToDecimal:(double)value length:(int)length mode:(NSRoundingMode)mode{
    NSDecimalNumber *E = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",value]];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:mode
                                       scale:length
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *EE = [E decimalNumberByRoundingAccordingToBehavior:roundUp];
    return EE;
}

+(NSString *)timeT:(double)time stringFormatter:(NSString *)str
{
    if (!str || time < 0) {
        return @"";
    }
    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:str];
    NSString * nweTimeStr = [formatter stringFromDate:date];
    return nweTimeStr;
}

@end
