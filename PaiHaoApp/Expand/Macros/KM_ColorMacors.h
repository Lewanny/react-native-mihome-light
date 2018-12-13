//
//  KM_ColorMacors.h
//  PaiHaoApp
//
//  Created by KM on 2017/7/17.
//  Copyright © 2017年 KM. All rights reserved.
//

#ifndef KM_ColorMacors_h
#define KM_ColorMacors_h

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define HEXCOLOR(hex) [UIColor colorWithHexString:hex]

//导航栏字体：   36px苹方中等#ffffff
#define kNavFontColor (HEXCOLOR(@"ffffff"))

//字体纯黑 000000
#define kFontColorBlack (HEXCOLOR(@"000000"))

//字体暗黑 323232
#define kFontColorDark (HEXCOLOR(@"323232"))

//字体深灰 646464
#define kFontColorDarkGray (HEXCOLOR(@"646464"))

//字体灰色 909090
#define kFontColorGray (HEXCOLOR(@"909090"))

//字体浅灰 e1e1e1
#define kFontColorLightGray (HEXCOLOR(@"e1e1e1"))




//主色 28ab9b
#define kMainThemeColor (HEXCOLOR(@"28ab9b"))
//背景色 f5f5f5
#define kBackgroundColor (HEXCOLOR(@"f5f5f5"))
//红色 ff2d2d
#define kAppRedColor (HEXCOLOR(@"ff2d2d"))

#endif /* KM_ColorMacors_h */
