//
//  KMAddressPicker.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/22.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMAddressPicker.h"

#define kHistoryKey @"KMAddressPicker"
#define kCityDataPlist @"CityDataPlist"
@interface KMAddressPicker ()<ActionSheetCustomPickerDelegate>

@property (nonatomic, strong) ActionSheetCustomPicker * addressPicker;

@property (nonatomic, copy) AddressCallBack callBack;

@property (nonatomic, assign, getter = isSaveHistory) BOOL  saveHistory;

/** 1.数据源数组 */
@property (nonatomic, strong, nullable)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arrayArea;
/** 5.当前选中数组 */
@property (nonatomic, strong, nullable)NSMutableArray *arraySelected;

/** 6.省份 */
@property (nonatomic, strong, nullable)NSString *province;
/** 7.城市 */
@property (nonatomic, strong, nullable)NSString *city;
/** 8.地区 */
@property (nonatomic, strong, nullable)NSString *area;

@end

@implementation KMAddressPicker

- (instancetype)init
{
self                                 = [super init];
    if (self) {
        //初始化城市数据
        [self initCityData];
        //初始化PickerView
        [self initAddressPicker];
    }
    return self;
}
/** 初始化城市数据 */
-(void)initCityData{
    // 1.获取数据
    //省
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayProvince addObject:obj[@"provinceName"]];
    }];
    //市
NSMutableArray *citys                = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"citylist"]];
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCity addObject:obj[@"cityName"]];
    }];
    //区、县
NSMutableArray *areas                = [citys firstObject][@"arealist"];
    [areas enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayArea addObject:obj[@"areaName"]];
    }];

self.province                        = self.arrayProvince[0];
self.city                            = self.arrayCity[0];
    if (self.arrayArea.count != 0) {
self.area                            = self.arrayArea[0];
    }else{
self.area                            = @"";
    }
}
/** 初始化PickerView */
-(void)initAddressPicker{
_addressPicker                       = [[ActionSheetCustomPicker alloc]initWithTitle:@"选择地址" delegate:self showCancelButton:YES origin:[[AppDelegate shareAppDelegate] getCurrentUIVC].view];
}

-(void)show{
    [_addressPicker showActionSheetPicker];
}

+(void)showWithCallBack:(AddressCallBack)callBack{
KMAddressPicker *adress              = [[KMAddressPicker alloc]init];
adress.callBack                      = callBack;
    [adress show];
}


#pragma mark - ActionSheetCustomPickerDelegate

-(void)actionSheetPicker:(AbstractActionSheetPicker *)actionSheetPicker configurePickerView:(UIPickerView *)pickerView{
self.saveHistory                     = YES;
}


-(void)actionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin{

    if (self.isSaveHistory) {
NSDictionary *dicHistory             = @{@"province":self.province, @"city":self.city, @"area":self.area};
        [[NSUserDefaults standardUserDefaults] setObject:dicHistory forKey:kHistoryKey];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kHistoryKey];
    }

    _callBack ? _callBack(_province, _city, _area) : nil;
}


#pragma mark - --- delegate 视图委托 ---

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arrayProvince.count;
    }else if (component == 1) {
        return self.arrayCity.count;
    }else{
        return self.arrayArea.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        //省
self.arraySelected                   = self.arrayRoot[row][@"citylist"];

        //市
        [self.arrayCity removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"cityName"]];
        }];
        //区
        [self.arrayArea removeAllObjects];
        [[self.arraySelected firstObject][@"arealist"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayArea addObject:obj[@"areaName"]];
        }];

        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
self.arraySelected                   = [self.arrayRoot firstObject][@"citylist"];
        }
        //区
        [self.arrayArea removeAllObjects];
        [[self.arraySelected objectAtIndex:row][@"arealist"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayArea addObject:obj[@"areaName"]];
        }];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];

    }else{
    }

    [self reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{

    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
obj.backgroundColor                  = [UIColor lightGrayColor];
        }
    }];


    NSString *text;
    if (component == 0) {
text                                 = self.arrayProvince[row];
    }else if (component == 1){
text                                 = self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0) {
text                                 = self.arrayArea[row];
        }else{
text                                 = @"";
        }
    }

UILabel *label                       = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:17]];
    [label setText:text];
    return label;
}

#pragma mark - Private Method
- (void)reloadData
{
UIPickerView *pickerView             = (UIPickerView *)self.addressPicker.pickerView;
NSInteger index0                     = [pickerView selectedRowInComponent:0];
NSInteger index1                     = [pickerView selectedRowInComponent:1];
NSInteger index2                     = [pickerView selectedRowInComponent:2];
self.province                        = self.arrayProvince[index0];
self.city                            = self.arrayCity[index1];
    if (self.arrayArea.count != 0) {
self.area                            = self.arrayArea[index2];
    }else{
self.area                            = @"";
    }

//    NSString *title = [NSString stringWithFormat:@"%@ %@ %@", self.province, self.city, self.area];
//
//    for (UIBarButtonItem *item in _addressPicker.toolbar.items) {
//        if ([item.customView isKindOfClass:[UILabel class]]) {
//            UILabel *label = (UILabel *)item.customView;
//            [label setText:title];
//            [label setAdjustsFontSizeToFitWidth:YES];
//            [label sizeToFit];
//        }
//    }
}

#pragma mark - --- setters 属性 ---

- (void)setSaveHistory:(BOOL)saveHistory{
_saveHistory                         = saveHistory;

    if (saveHistory) {
NSDictionary *dicHistory             = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kHistoryKey];
__block NSUInteger numberProvince    = 0;
__block NSUInteger numberCity        = 0;
__block NSUInteger numberArea        = 0;

        if (dicHistory) {
NSString *province                   = [NSString stringWithFormat:@"%@", dicHistory[@"province"]];
NSString *city                       = [NSString stringWithFormat:@"%@", dicHistory[@"city"]];
NSString *area                       = [NSString stringWithFormat:@"%@", dicHistory[@"area"]];

            [self.arrayProvince enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:province]) {
numberProvince                       = idx;
                }
            }];

self.arraySelected                   = self.arrayRoot[numberProvince][@"citylist"];

            //市
            [self.arrayCity removeAllObjects];
            [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayCity addObject:obj[@"cityName"]];
            }];
            [self.arrayCity enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:city]) {
numberCity                           = idx;
                }
            }];

            //区
            [self.arrayArea removeAllObjects];
            [[self.arraySelected objectAtIndex:numberCity][@"arealist"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.arrayArea addObject:obj[@"areaName"]];
            }];
            [self.arrayArea enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isEqualToString:area]) {
numberArea                           = idx;
                }
            }];

UIPickerView *pickerView             = (UIPickerView *)_addressPicker.pickerView;

            [pickerView selectRow:numberProvince inComponent:0 animated:NO];
            [pickerView selectRow:numberCity inComponent:1 animated:NO];
            [pickerView selectRow:numberArea inComponent:2 animated:NO];
            [pickerView reloadAllComponents];
            [self reloadData];
        }
    }
}


#pragma mark - Lazy

- (NSArray *)arrayRoot
{
    if (!_arrayRoot) {
id cache                             = [NSUserDefaults arcObjectForKey:kCityDataPlist];
        if (cache) {
_arrayRoot                           = cache;
        }else{
NSString *path                       = [[NSBundle mainBundle] pathForResource:@"citydata" ofType:@"plist"];
_arrayRoot                           = [[NSArray alloc]initWithContentsOfFile:path];
            [NSUserDefaults setArcObject:_arrayRoot forKey:kCityDataPlist];
        }
    }
    return _arrayRoot;
}

- (NSMutableArray *)arrayProvince
{
    if (!_arrayProvince) {
_arrayProvince                       = @[].mutableCopy;
    }
    return _arrayProvince;
}

- (NSMutableArray *)arrayCity
{
    if (!_arrayCity) {
_arrayCity                           = @[].mutableCopy;
    }
    return _arrayCity;
}

- (NSMutableArray *)arrayArea
{
    if (!_arrayArea) {
_arrayArea                           = @[].mutableCopy;
    }
    return _arrayArea;
}

- (NSMutableArray *)arraySelected
{
    if (!_arraySelected) {
_arraySelected                       = @[].mutableCopy;
    }
    return _arraySelected;
}

@end
