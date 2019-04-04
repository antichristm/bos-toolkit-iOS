////  OneDriveManager.m
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import "OneDriveManager.h"
#define rootID @"root"
#define approotID @"approot"
#define backupFolderName @"backup"
#define fileSuffix @"zip"
#define bosBaseRequestUrl @"https://graph.microsoft.com/v1.0/me/"

@interface OneDriveManager()
@property(nonatomic,strong,readwrite)ODClient * client;
@end
@implementation OneDriveManager
+(instancetype)sharedManager{
    static OneDriveManager * obj;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[OneDriveManager alloc]init];
    });
    return obj;
}

-(void)login:(void(^)(BOOL result))completion{
    if (!_client) {
        [ODClient authenticatedClientWithCompletion:^(ODClient *client, NSError *error) {
            if (!error) {
                self.client = client;
                self.client.baseURL = [NSURL URLWithString:bosBaseRequestUrl];
                if (completion) {
                    completion(YES);
                }
            }else{
                NSLog(@"认证失败--->%@",error);
                if (completion) {
                    completion(NO);
                }
            }
        }];
    }else{
        if (completion) {
            completion(YES);
        }
    }
}
-(void)logout:(void(^)(NSInteger result))completion{
    if (self.client) {
        [self.client signOutWithCompletion:^(NSError *error) {
            if (!error) {
                if (completion) {
                    completion(1);
                }
                self.client = nil;
            }else{
                if (completion) {
                    completion(0);
                }
            }
        }];
    }else{
        if (completion) {
            completion(2);
        }
    }
}
-(void)getItemWithId:(NSString *)itemId completion:(void(^)(ODCollection * response,NSError * error))completion{
    if (!itemId || itemId.length == 0) {
        itemId = approotID;
    }
    ODChildrenCollectionRequest *childrenRequest = [[[[self.client drive] items:itemId] children] request];
    [childrenRequest getWithCompletion:^(ODCollection *response, ODChildrenCollectionRequest *nextRequest, NSError *error) {
        if (completion) {
            completion(response,error);
        }
    }];
}
-(void)getItemWithSpecial:(NSString *)special completion:(void(^)(ODItem * response,NSError * error))completion{
    if (!special || special.length == 0) {
        special = approotID;
    }
    ODItemRequest * request = [[[self.client drive] special:special] request];
    [request getWithCompletion:^(ODItem *response, NSError *error) {
        if (completion) {
            completion(response,error);
        }
    }];
}
-(void)getFilepathWithId:(ODItem *)item completion:(void(^)(NSString * filePath,NSError * error))completion{
    ODURLSessionDownloadTask *task = [[[[self.client drive] items:item.id] contentRequest] downloadWithCompletion:^(NSURL *filePath, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
            NSString *newFilePath = [documentPath stringByAppendingPathComponent:item.name];
            [[NSFileManager defaultManager] moveItemAtURL:filePath toURL:[NSURL fileURLWithPath:newFilePath] error:nil];
            if (completion) {
                completion(newFilePath,error);
            }
        }else{
            if (completion) {
                completion(nil,error);
            }
        }
    }];
    NSLog(@"%@",task);
}
-(void)createNewFolderWithParentId:(NSString *)parentId folderName:(NSString *)folderName completion:(ODItemCompletionHandler)completion{
    if (!parentId || parentId.length == 0) {
        parentId = rootID;
    }
    ODItem *newFolder = [[ODItem alloc] initWithDictionary:@{[ODNameConflict rename].key : [ODNameConflict rename].value}];
    newFolder.name = folderName;
    newFolder.folder = [[ODFolder alloc] init];
    [[[[[self.client drive] items:parentId] children] request] addItem:newFolder withCompletion:completion];
}
-(void)createNewFileWithParent:(ODItem *)parentItem fileName:(NSString *)fileName completion:(void(^)(ODItem *response, NSError *error))completion{
    if (![[fileName pathExtension] isEqualToString:fileSuffix]){
        fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@".%@",fileSuffix]];
    }
    NSString *documentDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSData *textFile = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:fileName];
    
    [textFile writeToFile:filePath atomically:YES];
    [self saveFileWithContent:@"" filePath:filePath parentItem:parentItem item:nil completion:^(ODItem * _Nonnull response, NSError * _Nonnull error) {
        if (completion) {
            completion(response,error);
        }
    }];
}
-(void)deleteItem:(ODItem *)item completion:(void(^)(NSError * error))completion{
    [[[[self.client drive] items:item.id] requestWithOptions:@[[ODIfMatch entityTags:item.eTag]]] deleteWithCompletion:completion];
}
-(void)uploadFileWithItem:(ODItem *)item fileURL:(NSURL*)fileURL completion:(ODItemUploadCompletionHandler)completion{
    ODItemContentRequest * contentRequest = [[[self.client drive] items:item.id] contentRequestWithOptions:@[[ODIfMatch entityTags:item.cTag]]];
    [contentRequest uploadFromFile:fileURL completion:completion];
}
-(void)renameItem:(ODItem *)item newName:(NSString *)newName completion:(void(^)(ODItem *response, NSError *error))completion{
    ODItem *updatedItem= [[ODItem alloc] init];
    updatedItem.name = newName;
    [[[[self.client drive] items:item.id] request] update:updatedItem withCompletion:completion];
}
-(void)saveFileWithContent:(NSString *)content filePath:(NSString *)filePath parentItem:(ODItem *)parentItem item:(ODItem *)item completion:(void(^)(ODItem *response, NSError *error))completion{
    if (![[filePath pathExtension] isEqualToString:fileSuffix]){
        NSError * error = [[NSError alloc]initWithDomain:NSMachErrorDomain code:0 userInfo:@{@"reason" : @"Invalid format"}];
        if (completion) {
            completion(nil,error);
        }
    }else{
        NSError *error = nil;
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!error) {
            ODURLSessionUploadTask * task;
            if (parentItem && !item){
                ODItemContentRequest *contentRequest = [[[[self.client drive] items:parentItem.id] itemByPath:[filePath lastPathComponent]] contentRequest];
                task = [contentRequest uploadFromFile:[NSURL fileURLWithPath:filePath] completion:^(ODItem *item, NSError *error){
                    if (completion) {
                        completion(item,error);
                    }
                }];
                
            }else if (item){
                ODItemContentRequest *contentRequest = [[[[self.client drive] items:item.id] contentRequest] ifMatch:item.cTag];
                task = [contentRequest uploadFromFile:[NSURL fileURLWithPath:filePath] completion:^(ODItem *item, NSError *error){
                    if (completion) {
                        completion(item,error);
                    }
                }];
            }else{
                NSError * error = [[NSError alloc]initWithDomain:NSMachErrorDomain code:0 userInfo:@{@"reason" : @"Parameter error"}];
                if (completion) {
                    completion(nil,error);
                }
            }
            NSLog(@"%@",task);
        }
    }
}

#pragma mark -- 🐷 业务方法 🐷
-(void)getBackupAccountModelsWithPassWord:(NSString * __nullable)password completion:(void(^)(NSArray<NSDictionary *> * origin,NSArray<AccountListModel *> * models ,NSError *  error))completion{
    [[OneDriveManager sharedManager]getLastBackupAccountsCompletion:^(NSArray * _Nonnull result, NSError * _Nonnull error) {
        if (result && !error) {
            @try {
                NSMutableArray * temp = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary * dict in result) {
                    NSDictionary * analysisData = [[OneDriveManager sharedManager]analysisCloudData:dict password:password];
                    NSArray * blockAcciounts = analysisData[@"accounts"];
                    NSError * blockError = analysisData[@"error"];
                    if (blockAcciounts && blockAcciounts.count > 0 && !blockError) {
                        [temp addObjectsFromArray:blockAcciounts];
                    }else{
                        if (completion) {
                            completion(result,nil,blockError);
                        }
                        return ;
                    }
                }
                if (completion) {
                    completion(result,temp,nil);
                }
            } @catch (NSException *exception) {
                NSString * desc = NSLocalizedString(@"解析失败", nil);
                NSDictionary * userInfo = @{NSLocalizedDescriptionKey : desc};
                NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:-10002 userInfo:userInfo];
                if (completion) {
                    completion(nil,nil,error);
                }
            } @finally {}
        }else{
            if (completion) {
                completion(nil,nil,error);
            }
        }
    }];
}
-(NSDictionary *)analysisCloudData:(NSDictionary * )data password:(NSString *)password{
    NSMutableArray <AccountListModel *>* temp = [NSMutableArray array];
    NSString * enContent = data[@"content"];
    NSString * pass = password;
    NSDictionary * result;
    BOOL ver = [PassWordTool verifyPassword:password];
    NSString * deContent = [[EOSTools shared]DecryptWith:enContent password:pass];
    NSDictionary * info = deContent.mj_JSONObject;
    if ((!deContent  || deContent.length == 0) && enContent && !ver) {
        NSString * desc = NSLocalizedString(@"密码错误", nil);
        NSDictionary * userInfo = @{NSLocalizedDescriptionKey : desc};
        NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:-10005 userInfo:userInfo];
        result = @{
                   @"accounts" : @[],
                   @"error" : error
                   };
        return result;
    }
    NSArray * accountList = info[@"accountList"];
    for (NSDictionary * account in accountList) {
        NSDictionary * originKeys = account[@"keys"];
        NSString * accountName = account[@"accountName"];
        NSMutableDictionary * keys = [NSMutableDictionary dictionaryWithCapacity:originKeys.count];
        for (NSString * key in originKeys) {
            NSString * permission = [key componentsSeparatedByString:@"_"].lastObject;
            NSString * pri = originKeys[key];
            NSString * enPri = [[EOSTools shared]EncryptWith:pri password:password];
            if (!enPri || !permission) {break;}
            NSDictionary * keyInfo = @{
                                       @"permission" : permission,
                                       @"private" : enPri
                                       };
            [keys setObject:keyInfo forKey:key];
        }
        NSString * enKeysString = keys.mj_JSONString;
        NSDictionary * accountInfo = @{
                                       @"accountName" : accountName,
                                       @"keys" : enKeysString
                                       };
        AccountListModel * model = [AccountListModel initModelWithObject:accountInfo];
        [temp addObject:model];
    }
    result = @{
               @"accounts" : temp,
               };
    return result;
}
-(void)getBackupAccountsCompletion:(void(^)(NSArray * result, NSError * error))completion{
    [[OneDriveManager sharedManager]getItemWithSpecial:@"" completion:^(ODItem * _Nonnull response, NSError * _Nonnull error) {
        if (error && !response) {
            if (completion) {
                completion(nil,error);
            }
            return ;
        }
        
        [[OneDriveManager sharedManager]getItemWithId:response.id completion:^(ODCollection * _Nonnull response, NSError * _Nonnull error) {
            ODItem * backUpFolder;
            for (ODItem * i in response.value) {
                if ([i.name isEqualToString:backupFolderName]) {
                    backUpFolder = i;
                }
            }
            if (!backUpFolder) {
                if (completion) {
                    completion(nil,error);
                }
            }else{
                [[OneDriveManager sharedManager]getItemWithId:backUpFolder.id completion:^(ODCollection * _Nonnull response, NSError * _Nonnull error) {
                    [[OneDriveManager sharedManager]getFileContentWithItems:response.value completion:completion];
                }];
            }
        }];
    }];
}
-(void)getLastBackupAccountsCompletion:(void(^)(NSArray * result, NSError * error))completion{
    [[OneDriveManager sharedManager]getItemWithSpecial:@"" completion:^(ODItem * _Nonnull item, NSError * _Nonnull error) {
        if (error && !item) {
            if (completion) {
                completion(nil,error);
            }
            return ;
        }
        
        [[OneDriveManager sharedManager]getItemWithId:item.id completion:^(ODCollection * _Nonnull response, NSError * _Nonnull error) {
            ODItem * backUpFolder;
            for (ODItem * i in response.value) {
                if ([i.name isEqualToString:backupFolderName]) {
                    backUpFolder = i;
                }
            }
            
            if (!backUpFolder) {
                if (completion) {
                    completion(nil,error);
                }
            }else{
                [[OneDriveManager sharedManager]getItemWithId:backUpFolder.id completion:^(ODCollection * _Nonnull response, NSError * _Nonnull error) {
                    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDateTime" ascending:YES];
                    NSArray * sortResult = [response.value sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
                    ODItem * lastItem = sortResult.lastObject;
                    if (lastItem.file) {
                        [[OneDriveManager sharedManager]getFileContentWithItems:@[lastItem] completion:completion];
                    }else{
                        if (completion) {
                            completion(nil,error);
                        }
                    }
                }];
            }
        }];
    }];
}
-(void)getFileContentWithItems:(NSArray <ODItem *> *)items completion:(void(^)(NSArray <NSDictionary *>* result, NSError * error))completion{
    NSMutableArray * temp = [NSMutableArray arrayWithCapacity:items.count];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    for (ODItem * item in items) {
        if (item.file) {
            [[OneDriveManager sharedManager]getFilepathWithId:item completion:^(NSString * _Nonnull filePath, NSError * _Nonnull error) {
                if (error && !filePath) {
                    dispatch_semaphore_signal(semaphore);
                }else{
                    NSError * contentError;
                    NSString * content =  [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:filePath] encoding:NSUTF8StringEncoding error:&contentError];
                    if (!contentError) {
                        NSDictionary * account = @{
                                                   @"fileName" : item.name?:@"",
                                                   @"content" : content?:@""
                                                   };
                        [temp addObject:account];
                    }
                    dispatch_semaphore_signal(semaphore);
                }
            }];
        }
    }
    dispatch_group_notify(group, queue, ^{
        for(NSInteger index = 0; index < items.count; index++) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) {
                completion(temp,nil);
            }
        });
    });
}
-(void)backupAccounts:(NSArray <AccountListModel *>*)accounts password:(NSString *)password completion:(void(^)(NSError * error))completion{
    NSString * device = [BOSTools getDeviceVersion]?:@"";
    NSString * timestamp = [BOSTools getNowTimeTimestamp];
    NSString * formatTime = [BOSTools transformDate:timestamp format:@"yyyy-MM-dd HH-mm-ss"];
    NSMutableArray * accountList = [NSMutableArray array];
    if (![PassWordTool verifyPassword:password]) {
        NSString * desc = NSLocalizedString(@"密码错误", nil);
        NSDictionary * userInfo = @{NSLocalizedDescriptionKey : desc};
        NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:-10005 userInfo:userInfo];
        if (completion) {
            completion(error);
        }
        return;
    }
    @try {
        NSArray * locAccounts = accounts;
        for (AccountListModel * locModel in locAccounts) {
            NSDictionary * originKeys = locModel.keys.mj_JSONObject;
            NSMutableDictionary * keys = [NSMutableDictionary dictionaryWithCapacity:originKeys.count];
            
            for (NSString * key in originKeys.allKeys) {
                NSDictionary * info = originKeys[key];
                NSString * enPri = info[@"private"];
                NSString * deValue = [[EOSTools shared]DecryptWith:enPri password:password];
                [keys setObject:deValue forKey:key];
            }
            
            NSDictionary * info = @{
                                    @"accountName" : locModel.accountName,
                                    @"keys" : keys
                                    };
            
            [accountList addObject:info];
        }
        
        NSDictionary * backups = @{
                                   @"timestamp" : timestamp,
                                   @"device" : device,
                                   @"accountList" : accountList,
                                   @"passHint" : @""
                                   };
        
        NSString * fileName = [NSString stringWithFormat:@"%@%@",backupFolderName,formatTime];
        NSString * originContent = [BOSTools jsonStringFromDictionary:backups];
        NSString * content = [[EOSTools shared]EncryptWith:originContent password:password];
        [[OneDriveManager sharedManager]getItemWithSpecial:@"" completion:^(ODItem * _Nonnull item, NSError * _Nonnull error) {
            if (error && !item) {
                if (completion) {
                    completion(error);
                }
                return ;
            }
            [[OneDriveManager sharedManager]getItemWithId:item.id completion:^(ODCollection * _Nonnull response, NSError * _Nonnull error) {
                if (error) {
                    if (completion) {
                        completion(error);
                    }
                    return ;
                }
                
                ODItem * backUpFolder;
                for (ODItem * i in response.value) {
                    if ([i.name isEqualToString:backupFolderName]) {
                        backUpFolder = i;
                    }
                }
                if (!backUpFolder) {
                    [[OneDriveManager sharedManager]createNewFolderWithParentId:item.id folderName:backupFolderName completion:^(ODItem *response, NSError *error) {
                        NSLog(@"创建文件夹%@",error);
                        if (error && !response) {
                            if (completion) {
                                completion(error);
                            }
                        }
                        [[OneDriveManager sharedManager]createNewFileAndSaveWithParent:response fileName:fileName content:content completion:completion];
                    }];
                }else{
                    [[OneDriveManager sharedManager]createNewFileAndSaveWithParent:backUpFolder fileName:fileName content:content completion:completion];
                }
            }];
        }];
    } @catch (NSException *exception) {
        NSString * desc = NSLocalizedString(@"参数错误", nil);
        NSDictionary * userInfo = @{NSLocalizedDescriptionKey : desc};
        NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:-10001 userInfo:userInfo];
        if (completion) {
            completion(error);
        }
    } @finally {}
}
-(void)backupAccount:(AccountListModel *)model completion:(void(^)(NSError * error))completion DEPRECATED_MSG_ATTRIBUTE("Please use [[OneDriveManager sharedManager]backupAccounts: completion:]"){
    NSDictionary * info;
    NSString * timestamp = [BOSTools getNowTimeTimestamp];
    @try {
        info = @{
                 @"accountName" : model.accountName,
                 @"keys" : model.keys,
                 @"creatTimestamp" : timestamp
                 };
    } @catch (NSException *exception) {
        NSString * desc = NSLocalizedString(@"账户模型无效", nil);
        NSDictionary * userInfo = @{NSLocalizedDescriptionKey : desc};
        NSError * error = [NSError errorWithDomain:NSCocoaErrorDomain code:-10001 userInfo:userInfo];
        if (completion) {
            completion(error);
        }
        NSLog(@"--->%@",exception);
        return;
    } @finally {}
    
    NSString * fileName = model.accountName;
    
    NSString * content = [BOSTools jsonStringFromDictionary:info];
    [[OneDriveManager sharedManager]getItemWithId:@"" completion:^(ODCollection * _Nonnull response, NSError * _Nonnull error) {
        if (error && !response) {
            if (completion) {
                completion(error);
            }
            return ;
        }
        ODItem * bosFolder;
        for (ODItem * item in response.value) {
            if ([item.name isEqualToString:@"BOS文件夹"] && item.folder) {
                bosFolder = item;
            }
        }
        if (!bosFolder) {
            [[OneDriveManager sharedManager]createNewFolderWithParentId:nil folderName:@"BOS文件夹" completion:^(ODItem *response, NSError *error) {
                NSLog(@"创建文件夹%@",error);
                if (error && !response) {
                    [[OneDriveManager sharedManager]showHudMessage:@"备份失败" type:2];
                    if (completion) {
                        completion(error);
                    }
                    return ;
                }
                [[OneDriveManager sharedManager]createNewFileAndSaveWithParent:response fileName:fileName content:content completion:completion];
            }];
        }else{
            [[OneDriveManager sharedManager]getItemWithId:bosFolder.id completion:^(ODCollection * _Nonnull response, NSError * _Nonnull error) {
                ODItem * accountFile;
                for (ODItem * item in response.value) {
                    NSLog(@"%@---%@",item.name,item.file);
                    if ([item.name isEqualToString:fileName] && item.file) {
                        accountFile = item;
                    }
                }
                
                if (!accountFile) {
                    [[OneDriveManager sharedManager]createNewFileAndSaveWithParent:bosFolder fileName:fileName content:content completion:completion];
                }else{
                    [[OneDriveManager sharedManager]getFilepathWithId:accountFile completion:^(NSString * _Nonnull filePath, NSError * _Nonnull error) {
                        NSLog(@"获取文件路径%@",error);
                        if (error && !filePath) {
                            if (completion) {
                                completion(error);
                            }
                            return ;
                        }
                        [[OneDriveManager sharedManager]saveFileWithContent:content filePath:filePath parentItem:nil item:accountFile completion:^(ODItem * _Nonnull response, NSError * _Nonnull error) {
                            if (error && !response) {
                                if (completion) {
                                    completion(error);
                                }
                                return ;
                            }else{
                                if (completion) {
                                    completion(nil);
                                }
                            }
                        }];
                    }];
                }
            }];
        }
    }];
}
-(void)createNewFileAndSaveWithParent:(ODItem *)parent fileName:(NSString *)fileName content:(NSString *)content completion:(void(^)(NSError * error))completion{
    [[OneDriveManager sharedManager]createNewFileWithParent:parent fileName:fileName completion:^(ODItem * _Nonnull response, NSError * _Nonnull error) {
        if (error && !response) {
            if (completion) {
                completion(error);
            }
            return ;
        }
        [[OneDriveManager sharedManager]getFilepathWithId:response completion:^(NSString * _Nonnull filePath, NSError * _Nonnull error) {
            if (error && !filePath) {
                if (completion) {
                    completion(error);
                }
                return ;
            }
            [[OneDriveManager sharedManager]saveFileWithContent:content filePath:filePath parentItem:nil item:response completion:^(ODItem * _Nonnull response, NSError * _Nonnull error) {
                if (error && !response) {
                    if (completion) {
                        completion(error);
                    }
                    return ;
                }else{
                    if (completion) {
                        completion(nil);
                    }
                }
            }];
        }];
    }];
}
-(void)showHudMessage:(NSString *)message type:(NSInteger)type{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [XWHUDManager hide];
        switch (type) {
            case 0:
                [XWHUDManager showSuccessTipHUD:message];
                break;
                
            case 1:
                [XWHUDManager showWarningTipHUD:message];
                break;
                
            case 2:
                [XWHUDManager showErrorTipHUD:message];
                break;
                
            case 3:
                [XWHUDManager showHUDMessage:message];
                break;
                
            default:
                [XWHUDManager showSuccessTipHUD:message];
                break;
        }
    });
}
@end
