//
//  KMUserDetailViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/27.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMUserDetailModel.h"
@interface KMUserDetailViewModel : KMBaseViewModel
/** 用户详情 */
@property (nonatomic, strong) KMUserDetailModel * userDetail;

/** 获取详情 */
@property (nonatomic, strong) RACCommand * userDetailCommand;
/** 用户名是否已被使用 */
@property (nonatomic, strong) RACCommand * checkUserName;
/** 更改用户名 */
@property (nonatomic, strong) RACCommand * editUserName;
/** 更改地址 */
@property (nonatomic, strong) RACCommand * editAddr;
/** 更改手机号 */
@property (nonatomic, strong) RACCommand * editPhone;
/** 更改邮箱 */
@property (nonatomic, strong) RACCommand * editMail;
/** 上传完成后编辑头像 */
@property (nonatomic, strong) RACCommand * editHeadPortrait;

/** 左标题 */
-(NSArray *)leftTextArr;
/** 标题 */
-(NSArray *)titles;
/** 要更改的文字 */
-(NSString *)needCompeleTextWithIndexPath:(NSIndexPath *)indexPath;
/** 键盘类型 */
-(UIKeyboardType)keyboardTypeWithIndexPath:(NSIndexPath *)indexPath;
/** 发起网络请求更改 */
-(void)compeleText:(NSString *)text IndexPath:(NSIndexPath *)indexPath CallBack:(void(^)(void))callBack;
@end
