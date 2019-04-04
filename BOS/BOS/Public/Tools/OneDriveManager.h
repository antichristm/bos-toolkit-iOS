////  OneDriveManager.h
//  BOS
//
//  Created by BOS on 2018/12/17.
//  Copyright © 2018年 BOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OneDriveSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface OneDriveManager : NSObject
@property(nonatomic,strong,readonly)ODClient * client;
+(instancetype)sharedManager;

/**
 登录

 @param completion 回调
 */
-(void)login:(void(^)(BOOL result))completion;

/**
 退出e登录

 @param completion 回调 0 退出失败 1 退出成功 2 尚未登录
 */
-(void)logout:(void(^)(NSInteger result))completion;
/**
 通过id获取文件

 @param itemId 父级id
 @param completion 回调
 */
-(void)getItemWithId:(NSString *)itemId completion:(void(^)(ODCollection * response,NSError * error))completion;

/**
 通过special 获取文件

 @param special special
 @param completion 回调
 */
-(void)getItemWithSpecial:(NSString *)special completion:(void(^)(ODItem * response,NSError * error))completion;

/**
 获取文件路径

 @param item 文件id
 @param completion 回调
 */
-(void)getFilepathWithId:(ODItem *)item completion:(void(^)(NSString * filePath,NSError * error))completion;

/**
 新建文件夹

 @param parentId 上级目录id
 @param folderName 名称
 @param completion 回调
 */
-(void)createNewFolderWithParentId:(NSString * _Nullable)parentId folderName:(NSString * )folderName completion:(ODItemCompletionHandler)completion;

/**
 新建文件

 @param parentItem 上级文件夹
 @param fileName 文件名
 @param completion 回调
 */
-(void)createNewFileWithParent:(ODItem *)parentItem fileName:(NSString *)fileName completion:(void(^)(ODItem *response, NSError *error))completion;

/**
 删除

 @param item 需要删除的文件
 @param completion 回调
 */
-(void)deleteItem:(ODItem *)item completion:(void(^)(NSError * error))completion;

/**
 更新文件

 @param item 新文件
 @param fileURL 文件路径
 @param completion 回调
 */
-(void)uploadFileWithItem:(ODItem *)item fileURL:(NSURL*)fileURL completion:(ODItemUploadCompletionHandler)completion;

/**
 重命名

 @param item 需要重命名的文件
 @param newName 新名字
 @param completion 回调
 */
-(void)renameItem:(ODItem *)item newName:(NSString *)newName completion:(void(^)(ODItem *response, NSError *error))completion;

/**
 保存文件内容

 @param content 内容
 @param filePath 文件路径
 @param parentItem 上级文件
 @param item 当前文件 不能和parentItem同时为空
 @param completion 回调
 
 */
-(void)saveFileWithContent:(NSString *)content filePath:(NSString *)filePath parentItem:(ODItem * _Nullable)parentItem item:(ODItem * _Nullable)item completion:(void(^)(ODItem *response, NSError *error))completion;




/*****************************************************************************业务方法**************************************************************************************************/

/**
 备份账户数组

 @param accounts 账户数组
 @param completion 回调
 @param password 本地密码
 */
-(void)backupAccounts:(NSArray <AccountListModel *>*)accounts password:(NSString *)password completion:(void(^)(NSError * error))completion;

/**
 备份账户 （弃用）

 @param model 需要备份的账户模型
 @param completion 回调
 */
-(void)backupAccount:(AccountListModel *)model completion:(void(^)(NSError * error))completion DEPRECATED_MSG_ATTRIBUTE("Please use [[OneDriveManager sharedManager]backupAccounts: completion:]");

/**
 获取备份账户

 @param completion 回调
 */
-(void)getBackupAccountsCompletion:(void(^)(NSArray * result, NSError * error))completion;


/**
 获取最后一次备份

 @param completion 回调
 */
-(void)getLastBackupAccountsCompletion:(void(^)(NSArray * result, NSError * error))completion;

/**
 获取文件内容

 @param items 文件对象
 @param completion 回调
 */
-(void)getFileContentWithItems:(NSArray <ODItem *> *)items completion:(void(^)(NSArray <NSDictionary *>* result, NSError * error))completion;

/**
 获取备份账户模型数组
 @param password 云端数据加密密码
 @param completion 回调
 */
-(void)getBackupAccountModelsWithPassWord:(NSString * __nullable)password completion:(void(^)(NSArray<NSDictionary *> * origin,NSArray<AccountListModel *> * models ,NSError *  error))completion;

/**
 解析云端加密数据

 @param data 云端加密数据
 @param password 云端密码
 @return 结果 
 */
-(NSDictionary *)analysisCloudData:(NSDictionary * )data password:(NSString *)password;

/**
 创建文件并保存

 @param parent 父级对象
 @param fileName 文件名
 @param content 文件b内容
 @param completion 回调
 */
-(void)createNewFileAndSaveWithParent:(ODItem *)parent fileName:(NSString *)fileName content:(NSString *)content completion:(void(^)(NSError * error))completion;

/**
 提示信息

 @param message 提示内容  有默认值可不传
 @param type 0 成功 1 警告 2 失败 3 无状态
 */
-(void)showHudMessage:(NSString *)message type:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
