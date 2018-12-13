//
//  KMCitySelectTool.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMCitySelectTool.h"
#import "KMCitySelectVC.h"
#define kCityData @"KMCharacterArr"
#define kSectionData @"KMSectionArr"
#define kCityDataPlist @"CityDataPlist"

@interface KMCitySelectTool (){
    /** 存处理过以后的数组 */
    NSMutableArray * _sectionMutableArray;
    /** 字母索引 */
    NSMutableArray * _characterMutableArray;

}

@property (nonatomic, strong) NSArray * arrayRoot;

@property (nonatomic, strong) NSMutableArray * cityArr;;

@property (nonatomic, copy) LoadCityData cityData;



@end

@implementation KMCitySelectTool

+ (instancetype)shareInstance{
    static id tool                     = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    tool                               = [[KMCitySelectTool alloc]init];
    });
    return tool;
}

+(void)loadCityData:(LoadCityData)cityData{
    KMCitySelectTool * tool            = [KMCitySelectTool shareInstance];
    tool.cityData                      = cityData;
    [tool km_loadCityData];
}

+(void)loadAreaData:(NSString *)cityName CallBack:(AreaDataBlock)callBack{
    KMCitySelectTool * tool            = [KMCitySelectTool shareInstance];
    [tool km_loadAreaData:cityName CallBack:callBack];
}
+(void)searchCityData:(NSString *)cityName CallBack:(RelustBlock)callBack{
    KMCitySelectTool * tool            = [KMCitySelectTool shareInstance];
    [tool km_searchCityData:cityName CallBack:callBack];
}


+(void)didSelectCity:(NSString *)cityName{
    [NSUserDefaults setObject:cityName forKey:kCurrentCity];
}

+(void)presentCitySelectVC{
    KMCitySelectVC *vc                 = [[KMCitySelectVC alloc] init];
    KMBaseNavigationController *nav    = BaseNavigationWithRootVC(vc);
    [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:nav animated:YES completion:nil];
}

- (instancetype)init
{
    self                               = [super init];
    if (self) {
        [self initCityData];
    }
    return self;
}


-(void)initCityData{
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //市
    NSMutableArray *citys              = [NSMutableArray arrayWithArray:obj[@"citylist"]];
        [citys enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.cityArr addObject:cityDict[@"cityName"]];
        }];
    }];
//    KMLog(@"%@\n\n%ld",self.cityArr,self.cityArr.count);
}

-(void)km_loadCityData{
    //在子线程中异步执行汉字转拼音再转汉字耗时操作
    dispatch_queue_t serialQueue       = dispatch_queue_create("com.kmcity.www", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        [self sortCharacterData:^{
        self.cityData ? self.cityData(_characterMutableArray, _sectionMutableArray.firstObject) : nil;
        }];
    });
}

-(void)km_searchCityData:(NSString *)cityName CallBack:(RelustBlock)callBack{
    NSPredicate * predicate            = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", cityName];
    NSArray * relustArr                = [self.cityArr filteredArrayUsingPredicate:predicate];
    if (relustArr.count == 0) {
    relustArr                          = @[@"抱歉, 未搜索到相关数据,可尝试修改后重试!"];
    }
    callBack ? callBack(relustArr) : nil;
}

-(void)km_loadAreaData:(NSString *)cityName CallBack:(AreaDataBlock)callBack{
    @weakify(self)
    [self performAsynchronous:^{
        @strongify(self)
    NSMutableArray *arrM               = [NSMutableArray array];
    __block NSInteger provinceIndex    = -1;
    __block NSInteger cityIndex        = -1;
        [self.arrayRoot enumerateObjectsUsingBlock:^(id  _Nonnull province, NSUInteger pIdx, BOOL * _Nonnull stop) {
    NSArray *cityList                  = province[@"citylist"];
            [cityList enumerateObjectsUsingBlock:^(id  _Nonnull city, NSUInteger cIdx, BOOL * _Nonnull stop) {
    NSString *cName                    = city[@"cityName"];
                if ([cityName containsString:cName] || [cName containsString:cityName]){
    provinceIndex                      = pIdx;
    cityIndex                          = cIdx;
                    //找到 城市名称
    *stop                              = YES;
                }else{
    NSArray *arealist                  = city[@"arealist"];
                    [arealist enumerateObjectsUsingBlock:^(id  _Nonnull area, NSUInteger aIdx, BOOL * _Nonnull stop) {
                        if ([cityName containsString:area[@"areaName"]] || [area[@"areaName"] containsString:cityName]) {
    provinceIndex                      = pIdx;
    cityIndex                          = cIdx;
                            //找到 区县名称
    *stop                              = YES;
                        }
                    }];
                    //已经找到了 停止循环
    if (cityIndex != -1) {  *stop      = YES; }
                }
            }];
            //已经找到了 停止循环
    if (provinceIndex != -1) {  *stop  = YES; }
        }];

        //省下标 和 市下标
        if (provinceIndex != -1 && cityIndex != -1) {
    NSDictionary *provinceDict         = [self.arrayRoot objectAtIndex:provinceIndex];
    NSArray *cityList                  = provinceDict[@"citylist"];
    NSDictionary *cityDict             = [cityList objectAtIndex:cityIndex];
    NSArray *areaList                  = cityDict[@"arealist"];
            [areaList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrM addObject:obj[@"areaName"]];
            }];
        }
        //找到了 再回调
        if (arrM.count){
            [self performOnMainThread:^{
                callBack ? callBack(arrM) : nil;
            } wait:NO];
        }
    }];
}

/// 汉字转拼音再转成汉字
-(void)sortCharacterData:(Block_Void)callBack{
    /** 存字母索引下标数组 */
    NSMutableArray * indexMutableArray = [NSMutableArray array];
    /** 存处理过以后的数组 */
    _sectionMutableArray               = [NSMutableArray array];
    /** 字母索引 */
    _characterMutableArray             = [NSMutableArray array];


    if ([NSUserDefaults arcObjectForKey:kCityData]) {
    _characterMutableArray             = [NSUserDefaults arcObjectForKey:kCityData];
    _sectionMutableArray               = [NSUserDefaults arcObjectForKey:kSectionData];
    }else{
    for (int i                         = 0; i < _cityArr.count; i ++) {
    NSString *str                      = _cityArr[i];//一开始的内容
            if (str.length) {  //下面那2个转换的方法一个都不能少
    NSMutableString *ms                = [[NSMutableString alloc] initWithString:str];
                //汉字转拼音
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
                }
                //拼音转英文
                if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                    //字符串截取第一位，并转换成大写字母
    NSString *firstStr                 = [[ms substringToIndex:1] uppercaseString];
                    //如果不是字母开头的，转为＃
    BOOL isLetter                      = [self matchLetter:firstStr];
                    if (!isLetter)
    firstStr                           = @"#";

                    //如果还没有索引
                    if (indexMutableArray.count <= 0) {
                        //保存当前这个做索引
                        [indexMutableArray addObject:firstStr];
                        //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
    NSMutableArray *array              = [NSMutableArray arrayWithObject:str];
    NSMutableDictionary *dic           = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
                        [_sectionMutableArray addObject:dic];
                    }else{
                        //如果索引里面包含了当前这个字母，直接保存数据
                        if ([indexMutableArray containsObject:firstStr]) {
                            //取索引对应的数组，保存当前标题到数组里面
    NSMutableArray *array              = _sectionMutableArray.firstObject[firstStr];
                            [array addObject:str];
                            //重新保存数据
    NSMutableDictionary *dic           = [NSMutableDictionary dictionaryWithObjectsAndKeys:array,firstStr, nil];
    NSMutableDictionary *dictM         = [NSMutableDictionary dictionaryWithDictionary:_sectionMutableArray.firstObject];
                            [dictM addEntriesFromDictionary:dic];
                            [_sectionMutableArray replaceObjectAtIndex:0 withObject:dictM];
                        }else{
                            //如果没有包含，说明是新的索引
                            [indexMutableArray addObject:firstStr];
                            //用这个字母做字典的key，将当前的标题保存到key对应的数组里面去
    NSMutableArray *array              = [NSMutableArray arrayWithObject:str];
    NSMutableDictionary *dic           = _sectionMutableArray.firstObject;
                            [dic setObject:array forKey:firstStr];
    NSMutableDictionary *dictM         = [NSMutableDictionary dictionaryWithDictionary:_sectionMutableArray.firstObject];
                            [dictM addEntriesFromDictionary:dic];
                            [_sectionMutableArray replaceObjectAtIndex:0 withObject:dictM];
                        }
                    }
                }
            }
        }

        //将字母排序
    NSArray *compareArray              = [[_sectionMutableArray.firstObject allKeys] sortedArrayUsingSelector:@selector(compare:)];
    indexMutableArray                  = [NSMutableArray arrayWithArray:compareArray];

        //判断第一个是不是字母，如果不是放到最后一个
    BOOL isLetter                      = [self matchLetter:indexMutableArray.firstObject];
        if (!isLetter) {
            //获取数组的第一个元素
    NSString *firstStr                 = [indexMutableArray firstObject];
            //移除第一项元素
            [indexMutableArray removeObjectAtIndex:0];
            //插入到最后一个位置
            [indexMutableArray insertObject:firstStr atIndex:indexMutableArray.count];
        }

        [_characterMutableArray addObjectsFromArray:indexMutableArray];

        //拼音转换太耗时，这里把第一次转换结果存到单例中
        [NSUserDefaults setArcObject:_characterMutableArray forKey:@"KMCharacterArr"];
        [NSUserDefaults setArcObject:_sectionMutableArray forKey:@"KMSectionArr"];
    }
    callBack ? callBack() : nil;
}
#pragma mark - 匹配是不是字母开头 -
- (BOOL)matchLetter:(NSString *)str {
    //判断是否以字母开头
    NSString *ZIMU                     = @"^[A-Za-z]+$";
    NSPredicate *regextestA            = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];

    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}

#pragma mark - Lazy -

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
    id cache                           = [NSUserDefaults arcObjectForKey:kCityDataPlist];
        if (cache) {
    _arrayRoot                         = cache;
        }else{
    NSString *path                     = [[NSBundle mainBundle] pathForResource:@"citydata" ofType:@"plist"];
    _arrayRoot                         = [[NSArray alloc]initWithContentsOfFile:path];
            [NSUserDefaults setArcObject:_arrayRoot forKey:kCityDataPlist];
        }
    }
    return _arrayRoot;
}
-(NSMutableArray *)cityArr{
    if (!_cityArr) {
    _cityArr                           = [NSMutableArray array];
    }
    return _cityArr;
}
@end
