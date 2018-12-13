//
//  KMMerchantTypeModel.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/31.
//  Copyright © 2017年 KM. All rights reserved.
//

#import <Foundation/Foundation.h>
/** 行业分类 */
@interface KMMerchantTypeModel : NSObject
/** 类型ID */
@property (nonatomic, copy) NSString *ID;
/** 类型名称 */
@property (nonatomic, copy) NSString *typeName;
/** 备注 */
@property (nonatomic, copy) NSString *reserve;
/** 图片路径 */
@property (nonatomic, copy) NSString *imgpath;
@end
