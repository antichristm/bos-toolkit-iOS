////  WkScriptDelegate.m
//  BOS
//
//  Created by BOS on 2018/12/13.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "WKScriptDelegate.h"

@implementation WKScriptDelegate
-(instancetype)initWithDelegate:(id)messageHandler{
    self = [super init];
    if (self) {
        self.messageHandler = messageHandler;
    }
    return self;
}
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(BOSUserContentController:didReceiveScriptMessage:)]) {
        [self.delegate BOSUserContentController:userContentController didReceiveScriptMessage:message];
    }
}
@end
