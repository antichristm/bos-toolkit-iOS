////  WkScriptDelegate.h
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
NS_ASSUME_NONNULL_BEGIN
@protocol ScriptMessageHandler<NSObject>
- (void)BOSUserContentController:(WKUserContentController *)userContentController
        didReceiveScriptMessage:(WKScriptMessage *)message;
@end
@interface WKScriptDelegate : NSObject<WKScriptMessageHandler>
/**处理者*/
@property(nonatomic,weak)id  messageHandler;
/**回调代理*/
@property(nonatomic,weak)id<ScriptMessageHandler>  delegate;
-(instancetype)initWithDelegate:(id)messageHandler;
@end

NS_ASSUME_NONNULL_END
