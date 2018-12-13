//
//  KMBusinessUpgradeVM.h
//  PaiHaoApp
//
//  Created by KM on 2017/8/30.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMBaseViewModel.h"

@interface KMBusinessUpgradeVM : KMBaseViewModel
/** 商户全称 */
@property (nonatomic, copy) NSString * fullname;
/** 营业执照号 */
@property (nonatomic, copy) NSString * certificates;
/** 营业执照图片 */
@property (nonatomic, copy) NSString * certificatespicture;
/** 联系人 */
@property (nonatomic, copy) NSString * contacts;
/** 联系人电话 */
@property (nonatomic, copy) NSString * phone;


@property (nonatomic, strong) RACCommand * updateCommand;

-(void)edit:(id)data IndexPath:(NSIndexPath *)indexPath;

-(BOOL)verifyData;

-(NSString *)valueForIndexPath:(NSIndexPath *)indexPath;
-(NSArray *)leftTextArr;
-(NSArray *)placeHolderArr;
@end
