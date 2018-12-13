//
//  KMLocationManager.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/24.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMLocationManager.h"


@interface KMLocationManager ()<CLLocationManagerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, copy) KSystemLocationBlock kSystemLocationBlock;

@end

@implementation KMLocationManager
+ (instancetype)shareInstance{
    static id helper                             = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    helper                                       = [[KMLocationManager alloc]  init];
    });
    return helper;
}

/** 苹果系统自带地图定位 */
- (void)startSystemLocationWithRes:(KSystemLocationBlock)systemLocationBlock{
    self.kSystemLocationBlock                    = systemLocationBlock;

    if(!self.locationManager){
        self.locationManager =[[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy         = kCLLocationAccuracyBest;
        //        self.locationManager.distanceFilter=10;
        if ([UIDevice currentDevice].systemVersion.floatValue >=8) {
            [self.locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
    }
    self.locationManager.delegate                = self;
    [self.locationManager startUpdatingLocation];//开启定位
}
/** 定位成功 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation * currLocation                    = [locations lastObject];
    [KMLocationManager shareInstance].myLocation = currLocation;
    self.locationManager.delegate                = nil;
    [self.locationManager stopUpdatingLocation];

    self.kSystemLocationBlock ? self.kSystemLocationBlock(currLocation, nil) : nil;
}
/** 定位失败 */
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        [SVProgressHUD showErrorWithStatus:@"访问地理位置被拒绝" Duration:2];
        KMLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        [SVProgressHUD showErrorWithStatus:@"无法获取位置信息" Duration:2];
        KMLog(@"无法获取位置信息");
    }
    self.locationManager.delegate                = nil;
    [self.locationManager stopUpdatingLocation];
    self.kSystemLocationBlock ? self.kSystemLocationBlock(nil, error) : nil;
}
/** 目标定位地址 到 我的定位地址距离 */
+(NSString *)distanceWithTargetLocation:(CLLocation *)targetLocation{
    NSString *distance                           = @"";
    CLLocation *location                         = [[KMLocationManager shareInstance] myLocation];
    if (location) {
    CLLocationDistance kilometers                = [location distanceFromLocation:targetLocation]/1000.0;
    distance                                     = NSStringFormat(@"%.0fkm",kilometers);
        if (kilometers < 1) {
    distance                                     = NSStringFormat(@"%.0fm",kilometers * 1000);
        }
    }
    return distance;
}
+(CGFloat)distanceWithLocation:(CLLocation *)location{
    CGFloat distance                             = 0;
    CLLocation *mylocation                       = [[KMLocationManager shareInstance] myLocation];
    if (location) {
    CLLocationDistance meters                    = [location distanceFromLocation:mylocation];
    distance                                     = meters;
    }
    return distance;
}
#pragma mark - 导航方法
+(NSArray *)getInstalledMapAppWithEndLocation:(CLLocationCoordinate2D)endLocation
                                   TargetName:(NSString *)targetName{
    NSMutableArray *maps                         = [NSMutableArray array];

    NSDictionary *infoDictionary                 = [[NSBundle mainBundle] infoDictionary];

    NSString *appName                            = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    NSString *uslScheme                          = @"paihao";

    //苹果地图
    NSMutableDictionary *iosMapDic               = [NSMutableDictionary dictionary];
    iosMapDic[@"title"]                          = @"苹果地图";
    iosMapDic[@"lat"]                            = [NSNumber numberWithFloat:endLocation.latitude];
    iosMapDic[@"lng"]                            = [NSNumber numberWithFloat:endLocation.longitude];
    iosMapDic[@"name"]                           = targetName.length ? targetName : @"未知位置";
    [maps addObject:iosMapDic];

    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
    NSMutableDictionary *baiduMapDic             = [NSMutableDictionary dictionary];
    baiduMapDic[@"title"]                        = @"百度地图";
    NSString *urlString                          = [[NSString stringWithFormat:@"baidumap://map/direction?origin={{我的位置}}&destination=latlng:%f,%f|name=%@&mode=driving&coord_type=gcj02",endLocation.latitude,endLocation.longitude, targetName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    baiduMapDic[@"url"]                          = urlString;
        [maps addObject:baiduMapDic];
    }

    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
    NSMutableDictionary *gaodeMapDic             = [NSMutableDictionary dictionary];
    gaodeMapDic[@"title"]                        = @"高德地图";
    NSString *urlString                          = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=%@&lat=%f&lon=%f&dev=0&style=2",appName,uslScheme,endLocation.latitude,endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    gaodeMapDic[@"url"]                          = urlString;
        [maps addObject:gaodeMapDic];
    }

    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
    NSMutableDictionary *googleMapDic            = [NSMutableDictionary dictionary];
    googleMapDic[@"title"]                       = @"谷歌地图";
    NSString *urlString                          = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%@&x-success=%@&saddr=&daddr=%f,%f&directionsmode=driving",appName,uslScheme,endLocation.latitude, endLocation.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    googleMapDic[@"url"]                         = urlString;
        [maps addObject:googleMapDic];
    }

    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
    NSMutableDictionary *qqMapDic                = [NSMutableDictionary dictionary];
    qqMapDic[@"title"]                           = @"腾讯地图";
    NSString *urlString                          = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=drive&tocoord=%f,%f&to=%@&coord_type=1&policy=0",endLocation.latitude, endLocation.longitude, targetName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    qqMapDic[@"url"]                             = urlString;
        [maps addObject:qqMapDic];
    }
    return maps;
}

+(void)showActionSheetWithMaps:(NSArray *)maps{

    UIAlertController *alert                     = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSDictionary *mapInfo in maps) {
    NSString *title                              = mapInfo[@"title"];
    NSString *urlString                          = mapInfo[@"url"];

        if ([title isEqualToString:@"苹果地图"]) {
    NSString *name                               = [mapInfo objectForKey:@"name"];
    alert.title                                  = [@"导航到" stringByAppendingString:name.length ? name : @"未知"];
    UIAlertAction *action                        = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMapWithDict:mapInfo];
            }];
            [alert addAction:action];
        }else{
    UIAlertAction *action                        = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }];
            [alert addAction:action];
        }
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];

    [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:alert animated:YES completion:nil];
}


//苹果地图
+ (void)navAppleMapWithDict:(NSDictionary *)dict
{
    CGFloat lat                                  = [dict[@"lat"] floatValue];
    CGFloat lng                                  = [dict[@"lng"] floatValue];
    NSString *name                               = dict[@"name"];
    CLLocationCoordinate2D coor                  = CLLocationCoordinate2DMake(lat, lng);
    MKMapItem *currentLoc                        = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation                        = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:coor addressDictionary:nil]];
    toLocation.name                              = name;
    NSArray *items                               = @[currentLoc,toLocation];
    NSDictionary *dic                            = @{
                          MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                          MKLaunchOptionsShowsTrafficKey : @(YES)
                          };

    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

@end
