//
//  KM_FontMacors.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#ifndef KM_FontMacors_h
#define KM_FontMacors_h

//字体大小：     最大36px,最小22px;36 32  30  28  26  24  22px


//#define CHINESE_FONT_NAME  @"PingFangSC"
#define CHINESE_SYSTEM(x) [UIFont systemFontOfSize:x] 
//[UIFont fontWithName:CHINESE_FONT_NAME size:x]

//不同屏幕尺寸适配（750.0 , 1334.0 是因为效果图为IPHONE6 如果不是则根据实际情况修改）1136.0 640.0
#define kScreenWidthRatio  (KScreenWidth  / 750.0)
#define kScreenHeightRatio (KScreenHeight / 1334.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio) 
#define AdaptedHeight(x) ceilf((x) * kScreenWidthRatio)//ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)     CHINESE_SYSTEM((R))

#define AdaptedFontSizePx(px) AdaptedFontSize(floor(AdaptedWidth(px) / 1.0))  //96.0f * 72.0f

//导航栏字体：   36px苹方中等#ffffff;
#define kNavFont (AdaptedFontSizePx(36))

#define kFont36 (AdaptedFontSizePx(36))

#define kFont32 (AdaptedFontSizePx(32))

#define kFont30 (AdaptedFontSizePx(30))

#define kFont28 (AdaptedFontSizePx(28))

#define kFont26 (AdaptedFontSizePx(26))

#define kFont24 (AdaptedFontSizePx(24))

#define kFont22 (AdaptedFontSizePx(22))


#endif /* KM_FontMacors_h */
