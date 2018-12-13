//
//  KMNewGroupViewModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/1.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"
#import "KMNewGroupCell.h"
#import "KMOriginalGroupInfo.h"
#import "KMNewGroupModel.h"
@interface KMNewGroupViewModel : KMBaseViewModel
/** 号群ID */
@property (nonatomic, copy) NSString * groupID;
/** 原来的号群数据 */
@property (nonatomic, strong) KMOriginalGroupInfo * origin;
/** 新建的号群数据 */
@property (nonatomic, strong) KMNewGroupModel * groupNew;
/** 批量开关 */
@property (nonatomic, assign) BOOL  isBatch;
/** 限定开关 */
@property (nonatomic, assign) BOOL  isLimit;

/** 加载之前的号群信息 */
@property (nonatomic, strong) RACCommand * infoCommand;
/** 新建号群 提交 */
@property (nonatomic, strong) RACCommand * addNewCommand;
/** 修改号群 提交 */
@property (nonatomic, strong) RACCommand * editGroupCommand;


-(instancetype)initWithGroupID:(NSString *)groupID;

/** 判断是否新建号群 */
-(BOOL)isNewBuiltGroup;

#pragma mark - 编辑 -
-(void)editWithData:(id)data IndexPath:(NSIndexPath *)indexPath;
-(void)didSelectIndexPath:(NSIndexPath *)indexPath;

#pragma mark - DataSource -
/** 展示类型 */
-(NewGroupCellStyle)cellStyleWithIndexPath:(NSIndexPath *)indexPath;
/** 右边展示文字 */
-(NSString *)rightTextWithIndexPath:(NSIndexPath *)indexPath;
/** 开关 */
-(BOOL)switchValueWithIndexPath:(NSIndexPath *)indexPath;
/** 键盘类型 */
-(UIKeyboardType)keyboardTypeWithIndexPath:(NSIndexPath *)indexPath;
/** 左边标题 */
-(NSArray *)leftTextArr;
/** 占位文字 */
-(NSArray *)placeHolderArr;

#pragma mark - 提交前验证 -
-(BOOL)verifyNewGroupParams;
-(BOOL)verifyEditGroupParams;
@end
