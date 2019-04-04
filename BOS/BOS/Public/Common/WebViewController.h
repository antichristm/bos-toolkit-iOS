//
//  WebViewController.h
//  BOS
//
//  Created by BOS on 2018/12/12.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface WebViewController : UIViewController
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong) NSString *url;
@end
