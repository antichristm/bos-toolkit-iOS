//
//  AppDelegate.m
//  BOS
//
//  Created by 梁唐 on 2018/12/11.
//  Copyright © 2018 lingling. All rights reserved.
//

#import "AppDelegate.h"
#define OneDriveID @"3e3a6600-2c3d-445d-8ad3-07940921c25d"
#define OneDriveScopes @"Files.ReadWrite.AppFolder"
@interface AppDelegate ()
@property(nonatomic,strong)UIVisualEffectView * effectView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self firstLaunch];
    [self createDatabase];
    [ODClient setMicrosoftAccountAppId:OneDriveID scopes:@[OneDriveScopes]];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    NSArray * locAccounts = [[BOSWCDBManager sharedManager]BOSSelectedAllObjectFromTable:BOSDBAccountTableName objClass:AccountListModel.class];
    if ([PassWordTool isExist] || locAccounts.count != 0) {
        self.window.rootViewController = [[BaseTabBarController alloc]init];
    }else{
        BaseNavigationController * navi = [[BaseNavigationController alloc]initWithRootViewController:[[FirstViewController alloc]init]];
        self.window.rootViewController = navi;
    }
    [self.window makeKeyAndVisible];    
    return YES;
}

-(void)createDatabase{
    [[BOSWCDBManager sharedManager]BOSCreatTableWithTableName:BOSDBAccountTableName objClass:AccountListModel.class];
    [[BOSWCDBManager sharedManager]BOSCreatTableWithTableName:BOSDBHistoryAccountTableName objClass:HistoryAccountModel.class];
}
- (void)firstLaunch{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [PassWordTool deletePassWord];
        [PassWordTool deleteSecuritQuestion];
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        NSArray  *array = [currentLanguage componentsSeparatedByString:@"-"];
        NSMutableArray *mArr = [NSMutableArray arrayWithArray:array];
        [mArr removeObjectAtIndex:mArr.count-1];
        NSString *language = [mArr componentsJoinedByString:@"-"];
        if ([language isEqualToString:@"en"]) {
            [DAConfig setUserLanguage:@"en"];
        }else if ([language isEqualToString:@"zh-Hans"]){
            [DAConfig setUserLanguage:@"zh-Hans"];
        }else{
            [DAConfig setUserLanguage:@"en"];
        }
    }
}
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    WeakSelf(weakSelf);
    [BOSOtherCallManager paramFormat:url completion:^(NSDictionary * _Nonnull result) {
        NSLog(@"--->%@",result);
        NSString * code = result[@"code"];
        if (code.integerValue == 10000) {
            [BOSOtherCallManager dispenseIncidentWith:result[@"result"] handler:weakSelf.window.rootViewController completion:^(BOOL result) {
                NSLog(@"--->%d",result);
            }];
        }
    }];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [KeyWindow addSubview:self.effectView];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    WeakSelf(weakSelf);
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.effectView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.effectView removeFromSuperview];
        weakSelf.effectView.alpha = 0.99;
    }];
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * string = pasteboard.string;
    if ([string isEqualToString:[RedPacketAlertView share].redString]) {
        return;
    }
    NSData * data = string.dataFromBase58;
    NSString * redString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray * array = [redString componentsSeparatedByString:@"^"];
    if (array.count >= 3 && ([array[0] intValue] > 0 &&[array[0] intValue] <4)) {
       
        if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController * TBVC = (UITabBarController *)self.window.rootViewController;
            UINavigationController * NGVC = TBVC.selectedViewController;
            if ([NGVC isKindOfClass:[UINavigationController class]]) {
                RedPacketAlertView * view = [RedPacketAlertView share];
                view.redString = string;
                view.redPacketBlock = ^{
                    RedPacketUseViewController * VC = [[RedPacketUseViewController alloc] init];
                    VC.redPacketString = string;
                    [NGVC pushViewController:VC animated:YES];
                };
//                pasteboard.string = @"";
                [view ShowView];
            }
        } else if ([self.window.rootViewController isKindOfClass:[UINavigationController class]] && ((NSString *)[PassWordTool readSecuritQuestion]).length > 0){
            UINavigationController * NGVC = (UINavigationController *)self.window.rootViewController;
            RedPacketAlertView * view = [RedPacketAlertView share];
            view.redString = string;
            view.redPacketBlock = ^{
                RedPacketUseViewController * VC = [[RedPacketUseViewController alloc] init];
                VC.redPacketString = string;
                VC.isFrist = YES;
                [NGVC pushViewController:VC animated:YES];
            };
//            pasteboard.string = @"";
            [view ShowView];
        }
    }
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
}
#pragma mark  🐷 Lazy loading 🐷
- (UIVisualEffectView *)effectView{
    if (!_effectView) {
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _effectView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
        _effectView.frame = [UIScreen mainScreen].bounds;
    }
    return _effectView;
}

@end





