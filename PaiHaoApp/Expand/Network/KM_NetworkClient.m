//
//  KM_NetworkClient.m
//  PaiHaoApp
//
//  Created by KM on 2017/7/21.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KM_NetworkClient.h"
#import "KM_NetworkCache.h"
//暂时未封装数据库缓存 以后会加进来


@implementation KM_NetworkClient
/** 默认 Manager */
+(AFHTTPSessionManager *)defaultManager{
    AFHTTPSessionManager *manager                                         = [AFHTTPSessionManager manager];
    manager.requestSerializer                                             = [AFJSONRequestSerializer serializer];
    manager.responseSerializer                                            = [AFJSONResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    [manager.requestSerializer setValue:@"application/json; charset       = utf-8"
                     forHTTPHeaderField:@"Content-Type"];
    
    return manager;
}
/** 修改设置的 Manager */
+(AFHTTPSessionManager *)changeManager{
    static AFHTTPSessionManager * changeManager                           = nil;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
    changeManager                                                         = [[AFHTTPSessionManager alloc]init];
    });
    changeManager.requestSerializer                                       = [AFJSONRequestSerializer serializer];
    changeManager.responseSerializer                                      = [AFJSONResponseSerializer serializer];
    [changeManager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json",@"text/javascript",@"text/html",@"text/css",@"text/plain", nil]];
    [changeManager.requestSerializer setValue:@"application/json; charset = utf-8" forHTTPHeaderField:@"Content-Type"];
    return changeManager;
}


/** 大部分请求都是同一个URL */
+(RACSignal *)requestParams:(id)params{
    KM_NetworkConfig *networkConfig                                       = [KM_NetworkConfig hideHUDCofig];
    networkConfig.cache                                                   = NO;
    return [self requestWithURLString:nil Params:params];
}
/** 基本请求 可配置网络缓存 */
+(RACSignal *)requestParams:(id)params Cache:(BOOL)cache{
    KM_NetworkConfig *networkConfig                                       = [KM_NetworkConfig hideHUDCofig];
    networkConfig.cache                                                   = cache;
    return [self requestWithURLString:nil Params:params];
}
/** 使用默认 AFHTTPSessionManager 和 NetworkConfig */
+(RACSignal *)requestWithURLString:(NSString *)url
                            Params:(id)params{
    return [self requestWithNetworkConfig:nil
                                URLString:url
                                   Params:params];
}

/** 使用默认 AFHTTPSessionManager 发起请求 */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                             URLString:(NSString *)url
                                Params:(id)params{
    return [self requestWithNetworkConfig:config
                                URLString:url
                                   Params:params
                                 Progress:nil];
}

/** 使用默认 AFHTTPSessionManager 发起请求 带进度回调 */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                             URLString:(NSString *)url
                                Params:(id)params
                              Progress:(KM_Progress)progress{
    return [self requestWithNetworkConfig:config
                         AFManagerSetting:nil URLString:url
                                   Params:params
                                 Progress:progress];
}



/** 修改 AFHTTPSessionManager 和 默认 NetworkConfig  */
+(RACSignal *)requestWithAFManagerSetting:(AFManagerSetting)setting
                                URLString:(NSString *)url
                                   Params:(id)params{
    return [self requestWithNetworkConfig:nil
                         AFManagerSetting:setting
                                URLString:url
                                   Params:params];
}

/** 修改 AFHTTPSessionManager */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                      AFManagerSetting:(AFManagerSetting)setting
                             URLString:(NSString *)url
                                Params:(id)params{
    return [self requestWithNetworkConfig:config
                         AFManagerSetting:setting
                                URLString:url
                                   Params:params
                                 Progress:nil];
}
/** 修改 AFHTTPSessionManager 带进度回调 */
+(RACSignal *)requestWithNetworkConfig:(NetworkConfig)config
                      AFManagerSetting:(AFManagerSetting)setting
                             URLString:(NSString *)url
                                Params:(id)params
                              Progress:(KM_Progress)progress{
    //获取 NetworkConfig
    KM_NetworkConfig *networkConfig                                       = nil;
    if (config) {
    networkConfig                                                         = config([KM_NetworkConfig changeConfig]);
    }else{
    networkConfig                                                         = [KM_NetworkConfig hideHUDCofig];
    }

    //获取 AFHTTPSessionManager
    AFHTTPSessionManager *manager                                         = nil;
    if (setting) {
    manager                                                               = setting([self changeManager]);
    }else{
    manager                                                               = [self defaultManager];
    }
    //使用默认URL
    if (url == nil) {
    url                                                                   = KM_NetworkApi.hostUrl;
    }

    switch (networkConfig.HttpMethod) {
        case KM_GET:
            return [self GET:url
                     Manager:manager
                      Params:params
                    Progress:progress
               NetworkConfig:networkConfig];
            break;
        case KM_POST:
            return [self POST:url
                      Manager:manager
                       Params:params
                     Progress:progress
                NetworkConfig:networkConfig];
            break;
        case KM_PUT:
            return [self PUT:url
                     Manager:manager
                      Params:params
                    Progress:progress
               NetworkConfig:networkConfig];
            break;
        case KM_DELETE:
            return [self DELETE:url
                        Manager:manager
                         Params:params
                       Progress:progress
                  NetworkConfig:networkConfig];
            break;
        default:
            return [self GET:url
                     Manager:manager
                      Params:params
                    Progress:progress
               NetworkConfig:networkConfig];
            break;
    }
}

+(RACSignal *)GET:(NSString *)url
          Manager:(AFHTTPSessionManager *)manager
           Params:(id)params
         Progress:(void (^)(NSProgress * _Nonnull))progress
    NetworkConfig:(KM_NetworkConfig *)networkConfig{
    @weakify(self,  manager);
    RACSignal *sig                                                        = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self, manager);

        if (!networkConfig.isCtrlHub) {//由这次网络请求控制
            [SVProgressHUD show];
        }
        //如果打开了缓存
        if (networkConfig.cache) {
            //取出之前的缓存
    id responseObject                                                     = [KM_NetworkCache httpCacheForURL:url parameters:params];
            if (responseObject) {
    NSArray  * entrySet                                                   = [responseObject objectForKey:kEntrySet];
    NSArray  * paramsSet                                                  = [responseObject objectForKey:kParamsSet];
    NSString * actionName                                                 = [responseObject objectForKey:kActionName];
    NSNumber * status                                                     = [responseObject objectForKey:kStatus];
    NSNumber * timeStamp                                                  = [responseObject objectForKey:kTimeStamp];
    NSString * token                                                      = [responseObject objectForKey:kToken];
    RACTuple * tuple                                                      = RACTuplePack(entrySet, paramsSet, actionName, status, timeStamp, token);
                [subscriber sendNext:tuple];
            }
        }
        
    NSURLSessionDataTask *op                                              = [manager GET:url parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSNumber *status                                                      = [responseObject objectForKey:kStatus];
           KMLog(@"URL ----- %@   \n%@",task.currentRequest.URL.absoluteString, responseObject);

           if (!networkConfig.isCtrlHub) {
               [SVProgressHUD dismiss];
           }

            if ([status intValue] && [status intValue] != 3) {//请求返回错误
    NSError *error                                                        = [self errorWithDataTask:task Response:responseObject];

                if (!networkConfig.isCtrlHub) {
                    [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:kErrmsg]];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
                [subscriber sendError:error];
            }else{
                //缓存打开
                if (networkConfig.cache) {
                    [KM_NetworkCache setHttpCache:responseObject URL:url parameters:params];
                }

    NSArray  * entrySet                                                   = [responseObject objectForKey:kEntrySet];
    NSArray  * paramsSet                                                  = [responseObject objectForKey:kParamsSet];
    NSString * actionName                                                 = [responseObject objectForKey:kActionName];
    NSNumber * status                                                     = [responseObject objectForKey:kStatus];
    NSNumber * timeStamp                                                  = [responseObject objectForKey:kTimeStamp];
    NSString * token                                                      = [responseObject objectForKey:kToken];
    RACTuple * tuple                                                      = RACTuplePack(entrySet, paramsSet, actionName, status, timeStamp, token);
                [subscriber sendNext:tuple];
            }
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            KMLog(@"error ------ %@",error);
            [subscriber sendError:error];
        }];

        return [RACDisposable disposableWithBlock:^{ //取消网络请求
            KMLog(@"请求已完成 或 网络请求已取消");
            [op cancel];
        }];
    }];
    return sig;
}
+(RACSignal *)POST:(NSString *)url
           Manager:(AFHTTPSessionManager *)manager
            Params:(id)params
           Progress:(void (^)(NSProgress * _Nonnull))progress
     NetworkConfig:(KM_NetworkConfig *)networkConfig{
    @weakify(manager, self)
    RACSignal *sig                                                        = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(manager, self)

        if (!networkConfig.isCtrlHub) {//由这次网络请求控制
            [SVProgressHUD show];
        }
        //如果打开了缓存
        if (networkConfig.cache) {
            //取出之前的缓存
    id responseObject                                                     = [KM_NetworkCache httpCacheForURL:url parameters:params];
            if (responseObject) {
    NSArray  * entrySet                                                   = [responseObject objectForKey:kEntrySet];
    NSArray  * paramsSet                                                  = [responseObject objectForKey:kParamsSet];
    NSString * actionName                                                 = [responseObject objectForKey:kActionName];
    NSNumber * status                                                     = [responseObject objectForKey:kStatus];
    NSNumber * timeStamp                                                  = [responseObject objectForKey:kTimeStamp];
    NSString * token                                                      = [responseObject objectForKey:kToken];
    RACTuple * tuple                                                      = RACTuplePack(entrySet, paramsSet, actionName, status, timeStamp, token);
                [subscriber sendNext:tuple];
            }
        }

    NSURLSessionDataTask *op                                              = [manager POST:url parameters:params progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSNumber *status                                                      = [responseObject objectForKey:kStatus];
            KMLog(@"URL ----- %@   \n%@",task.currentRequest.URL.absoluteString, responseObject);

            if (!networkConfig.isCtrlHub) {
                [SVProgressHUD dismiss];
            }

            if ([status intValue]) {//请求返回错误
    NSError *error                                                        = [self errorWithDataTask:task Response:responseObject];

                if (!networkConfig.isCtrlHub) {
                    [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:kErrmsg]];
                    [SVProgressHUD dismissWithDelay:1.5];
                }

                [subscriber sendError:error];
            }else{
                //缓存打开
                if (networkConfig.cache) {
                    [KM_NetworkCache setHttpCache:responseObject URL:url parameters:params];
                }
    NSArray  * entrySet                                                   = [responseObject objectForKey:kEntrySet];
    NSArray  * paramsSet                                                  = [responseObject objectForKey:kParamsSet];
    NSString * actionName                                                 = [responseObject objectForKey:kActionName];
    NSNumber * status                                                     = [responseObject objectForKey:kStatus];
    NSNumber * timeStamp                                                  = [responseObject objectForKey:kTimeStamp];
    NSString * token                                                      = [responseObject objectForKey:kToken];
    RACTuple * tuple                                                      = RACTuplePack(entrySet, paramsSet, actionName, status, timeStamp, token);
                [subscriber sendNext:tuple];
            }
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            KMLog(@"error ------ %@",error);
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{ //取消网络请求
            [op cancel];
        }];
    }];
    return sig;
}
+(RACSignal *)PUT:(NSString *)url
          Manager:(AFHTTPSessionManager *)manager
           Params:(id)params
         Progress:(void (^)(NSProgress * _Nonnull))progress
    NetworkConfig:(KM_NetworkConfig *)networkConfig{
    @weakify(manager, self)
    RACSignal *sig                                                        = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(manager, self)

        if (!networkConfig.isCtrlHub) {//由这次网络请求控制
            [SVProgressHUD show];
        }

    NSURLSessionDataTask *op                                              = [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSNumber *status                                                      = [responseObject objectForKey:kStatus];
            KMLog(@"URL ----- %@   \n%@",task.currentRequest.URL.absoluteString, responseObject);

            if (!networkConfig.isCtrlHub) {
                [SVProgressHUD dismiss];
            }

            if ([status intValue]) {//请求返回错误
    NSError *error                                                        = [self errorWithDataTask:task Response:responseObject];

                if (!networkConfig.isCtrlHub) {
                    [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:kErrmsg]];
                    [SVProgressHUD dismissWithDelay:1.5];
                }
                [subscriber sendError:error];
            }else{
    NSArray  * entrySet                                                   = [responseObject objectForKey:kEntrySet];
    NSArray  * paramsSet                                                  = [responseObject objectForKey:kParamsSet];
    NSString * actionName                                                 = [responseObject objectForKey:kActionName];
    NSNumber * status                                                     = [responseObject objectForKey:kStatus];
    NSNumber * timeStamp                                                  = [responseObject objectForKey:kTimeStamp];
    NSString * token                                                      = [responseObject objectForKey:kToken];
    RACTuple * tuple                                                      = RACTuplePack(entrySet, paramsSet, actionName, status, timeStamp, token);
                [subscriber sendNext:tuple];
            }
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            KMLog(@"error ------ %@",error);
//            [SVProgressHUD dismiss];
            [subscriber sendError:error];
        }];

        return [RACDisposable disposableWithBlock:^{ //取消网络请求
//            [SVProgressHUD dismiss];
            [op cancel];
        }];
    }];
    return sig;
}
+(RACSignal *)DELETE:(NSString *)url
             Manager:(AFHTTPSessionManager *)manager
              Params:(id)params
            Progress:(void (^)(NSProgress * _Nonnull))progress
       NetworkConfig:(KM_NetworkConfig *)networkConfig{
    @weakify(manager, self)
    RACSignal *sig                                                        = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(manager, self)
        if (!networkConfig.isCtrlHub) {//由这次网络请求控制
            [SVProgressHUD show];
        }

    NSURLSessionDataTask *op                                              = [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSNumber *status                                                      = [responseObject objectForKey:kStatus];
            KMLog(@"URL ----- %@   \n%@",task.currentRequest.URL.absoluteString, responseObject);

            if (!networkConfig.isCtrlHub) {
                [SVProgressHUD dismiss];
            }

            if ([status intValue]) {//请求返回错误
    NSError *error                                                        = [self errorWithDataTask:task Response:responseObject];

                if (!networkConfig.isCtrlHub) {
                    [SVProgressHUD showErrorWithStatus:[error.userInfo objectForKey:kErrmsg]];
                    [SVProgressHUD dismissWithDelay:1.5];
                }

                [subscriber sendError:error];
            }else{
    NSArray  * entrySet                                                   = [responseObject objectForKey:kEntrySet];
    NSArray  * paramsSet                                                  = [responseObject objectForKey:kParamsSet];
    NSString * actionName                                                 = [responseObject objectForKey:kActionName];
    NSNumber * status                                                     = [responseObject objectForKey:kStatus];
    NSNumber * timeStamp                                                  = [responseObject objectForKey:kTimeStamp];
    NSString * token                                                      = [responseObject objectForKey:kToken];
    RACTuple * tuple                                                      = RACTuplePack(entrySet, paramsSet, actionName, status, timeStamp, token);
                [subscriber sendNext:tuple];
            }
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            KMLog(@"error ------ %@",error);
//            [SVProgressHUD dismiss];
            [subscriber sendError:error];
        }];

        return [RACDisposable disposableWithBlock:^{ //取消网络请求
//            [SVProgressHUD dismiss];
            [op cancel];
        }];
    }];
    return sig;
}
+(NSString *)MethodStringWithHttpMethod:(KM_HTTPMethod)httpMethod{
    switch (httpMethod) {
        case KM_GET:
            return @"GET";
            break;
        case KM_POST:
            return @"POST";
            break;
        case KM_PUT:
            return @"PUT";
            break;
        case KM_DELETE:
            return @"DELETE";
            break;
        default:
            NSCAssert(NO, @"无效的HTTPMethod");
            break;
    }
}

+(NSError *)errorWithDataTask:(NSURLSessionDataTask *)task
                     Response:(id)responseObject{

    NSString *errorStatus                                                 = nil;
    NSInteger errcode                                                     = -1;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
    NSNumber *status                                                      = [responseObject objectForKey:@"status"];
        switch ([status intValue]) {
            case 0:
    errorStatus                                                           = @"请求成功";
                break;
            case 1:
    errorStatus                                                           = @"等待返回结果";
                break;
            case 2:
    errorStatus                                                           = @"操作异常";
                break;
            case 3:
    errorStatus                                                           = @"没有相关记录";
                break;
            case 4:
    errorStatus                                                           = @"参数异常";
                break;
            case 5:
    errorStatus                                                           = @"略(未知错误)";
                break;
            case 6:
    errorStatus                                                           = @"操作方法不存在";
                break;
            default:
    errorStatus                                                           = @"未知错误";
                break;
        }
    }else{
    errorStatus                                                           = @"数据返回格式有误";
    }

    NSDictionary *errInfo                                                 = @{kErrmsg : errorStatus, kErrStatus : [responseObject objectForKey:@"status"]};

    return [NSError errorWithDomain:task.originalRequest.URL.absoluteString code:errcode userInfo:errInfo];
}
+(RACSignal *)uploadImages:(NSArray<UIImage *> *)imageArr
                FieldNames:(NSArray<NSString *> *)fieldNameArr
                       URL:(NSString *)uploadUrl
                  Progress:(KM_Progress)progress{
    RACSignal *sig                                                        = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    AFHTTPSessionManager *manager                                         = [KM_NetworkClient defaultManager];
    manager.requestSerializer                                             = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer                                            = [AFHTTPResponseSerializer serializer];
    NSURLSessionDataTask *op                                              = [manager POST:uploadUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    for (int i                                                            = 0; i < imageArr.count; i ++) {
    UIImage *image                                                        = [imageArr objectAtIndex:i];
    NSString *fieldName                                                   = NSStringFormat(@"image%d.jpg",i);
                 //最佳压缩率
    NSData *uploadData                                                    = UIImageJPEGRepresentation(image, 0.9);
                 [formData appendPartWithFileData:uploadData name:@"fieldName" fileName:fieldName mimeType:@"image/jpeg"];
             }
         } progress:^(NSProgress * _Nonnull uploadProgress) {
             progress ? progress(uploadProgress) : nil;
         } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    NSString *jsonStr                                                     = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
             if ([jsonStr isEqualToString:@"0"]) {
                 //上传失败
    NSDictionary *errInfo                                                 = @{kErrmsg : @"上传图片失败"};
    NSError *error                                                        = [NSError errorWithDomain:task.currentRequest.URL.absoluteString code:-1 userInfo:errInfo];
                 [subscriber sendError:error];
             }else{
                 [subscriber sendNext:jsonStr];
                 [subscriber sendCompleted];
             }
             KMLog(@"上传图片返回 ========  %@", jsonStr);

         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             KMLog(@"%@",error.localizedDescription);
             [subscriber sendError:error];
         }];
         return [RACDisposable disposableWithBlock:^{ //取消网络请求
             [op cancel];
         }];
     }];
    return sig;
}
@end
