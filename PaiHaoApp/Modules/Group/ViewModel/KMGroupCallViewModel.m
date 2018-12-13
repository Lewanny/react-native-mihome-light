//
//  KMGroupCallViewModel.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/3.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMGroupCallViewModel.h"

#define kShortPause     @"、、"
#define kMiddlePause    @"、、、、"
#define kLongPause      @"、、、、、、"
@implementation KMGroupCallViewModel
/** 有没有人排队 */
-(BOOL)checkQueueExist{
    if (self.queueArr.count == 0) {
        [UIAlertView alertWithCallBackBlock:nil
                                      title:@"提示"
                                    message:@"当前还没有人排队"
                           cancelButtonName:@"知道了"
                          otherButtonTitles:nil, nil];
        return NO;
    }
    return YES;
}

#pragma mark - BaseViewModelInterface
-(void)km_bindNetWorkRequest{
    @weakify(self)
    
    //为他人进行 套餐排队
    _packageQueueCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        KMQueueDataModel *qModel = input;
        return [[[KM_NetworkApi joinQueueWithPackageID:qModel.packageId UserID:qModel.userid] doNext:^(id  _Nullable x) {
//            [SVProgressHUD showSuccessWithStatus:@"套餐排队成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"套餐排队失败" Duration:1];
        }];
    }];
    
    //请求排队信息
    _requestQueueData = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi queueDataByGroupID:self.groupID WinID:self.selectWindowID] doNext:^(id  _Nullable x) {
            @strongify(self)
            
            RACTuple *tuple = (RACTuple *)x;
            NSArray *entrySet = tuple.first;
            self.queueArr = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMQueueDataModel class] json:entrySet]];
            
            //更改排队状态,更新排队信息
//            [self.batchQueueDataCommand execute:nil];
            if (self.singleNumber == 0) {
                [self.detailCommand execute:nil];
            }
//            [self.detailCommand execute:nil];
            if (self.queueArr.count > 0) {
                [self.editQueueStateCommand execute:nil];
            }else {
                return ;
            }
            NSNumber *status = input;
            switch (status.integerValue) {
                case QueueReloadStatusNoCall:{
                    
                }
                    break;
                case QueueReloadStatusCallCurrent:{
                    [self callCurrentSpeak];
                }
                    break;
                case QueueReloadStatusCallNext:{
                    [self callNextSpeak];
                }
                    break;
                case QueueReloadStatusCallPass:{
                    [self callPassSpeak];
                }
                    break;
                default:
                    break;
            }
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 获取排队信息失败" Duration:1];
        }];
    }];
    //请求队列详情
    _detailCommand                                       = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi groupDetailInfoWithID:self.groupID] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *tuple                                      = (RACTuple *)x;
    NSArray *entrySet                                    = tuple.first;
    self.detailInfo                                      = [KMGroupDetailInfo modelWithJSON:entrySet.firstObject];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //过号
    _expireCommand                                       = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    RACTupleUnpack(NSString *queueID, NSString *groupID) = input;
        return [[[KM_NetworkApi singleExpireWithQueueID:queueID GroupID:groupID] doNext:^(id  _Nullable x) {

        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 过号失败" Duration:1];
        }];
    }];
    //呼叫当前
    _callCommand                                         = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
       return [[[KM_NetworkApi callCurrentWithQueueID:input] doNext:^(id  _Nullable x) {
           //播放语音
           @strongify(self)
           self.singleNumber == 0 ? [self callCurrentSpeak] : [self callCurrentBatch];
           [SVProgressHUD showSuccessWithStatus:@"呼叫成功" Duration:1];
       }] doError:^(NSError * _Nonnull error) {
           [SVProgressHUD showErrorWithStatus:@"后台服务器错误,呼叫失败" Duration:1];
       }];
    }];
    //下一位
    _nextCommand                                         = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    RACTupleUnpack(NSString *queueID, NSString *groupID) = input;
        return [[[KM_NetworkApi callNextWithQueueID:queueID GroupID:groupID] doNext:^(id  _Nullable x) {
            @strongify(self)
            //刷新排队列表
            [self.requestQueueData execute:@(QueueReloadStatusCallNext)];

        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 操作失败" Duration:1];
        }];
    }];
    //暂停
    _pauseCommand                                        = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi suspendWithQueueID:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"暂停成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 操作失败" Duration:1];
        }];
    }];
    //解散
    _dissolveCommand                                     = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi disbandWithGroupID:input] doNext:^(id  _Nullable x) {

            [SVProgressHUD showSuccessWithStatus:@"解散成功" Duration:1];

        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 操作失败" Duration:1];
        }];
    }];

    //现场排号
    _sceneQueueCommand                                   = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi sceneQueueWithGrouoID:self.groupID UserID:[KM_NetworkParams getTimeStamp]] doNext:^(id  _Nullable x) {
    RACTuple *t                                          = x;
    NSNumber *status                                     = t.third;
            if (status.integerValue == 0) {
                @strongify(self)
    NSArray *paramsSet                                   = t.second;
    NSString *bespeakSort                                = [KMTool valueForName:@"ReturnValue" InArr:paramsSet];
                [SVProgressHUD showWithStatus:@"正在获取票据信息..."];
                [self.billInfoCommand execute:bespeakSort];
            }else{
                [SVProgressHUD showErrorWithStatus:@"操作失败" Duration:1];
            }
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 操作失败" Duration:1];
        }];
    }];
    //获取票据信息
    _billInfoCommand                                     = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        return [[[KM_NetworkApi billInfoWithGroupID:self.groupID BespeakSort:input] doNext:^(id  _Nullable x) {
    RACTuple *t                                          = x;
    NSArray *entrySet                                    = t.first;
    KMTicketInfo *info                                   = [KMTicketInfo modelWithJSON:entrySet.firstObject];
            if (info) {
                @strongify(self)
                [SVProgressHUD showSuccessWithStatus:@"获取票据信息成功" Duration:1];
                [self.printSubject sendNext:info];
            }else{
               [SVProgressHUD showErrorWithStatus:@"获取票据信息失败" Duration:1];
            }
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 操作失败" Duration:1];
        }];
    }];
    //获取当前队列已经绑定的窗口列表
    _bindedWinCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi bindedWindowWithGroupID:input] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *tuple       = (RACTuple *)x;
            NSArray *entrySet     = tuple.first;
//            NSArray *paramsSet = tuple.second;
//            if (paramsSet.count) {
//                self.selectWindowID = [KMTool valueForName:@"windowId" InArr:paramsSet];
//            }
            self.bindedWinArr  = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMWindowInfo class] json:entrySet]];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //设置当前呼叫窗口
    _bindCallWindow = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi bindCallWindowWithWindowID:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"窗口绑定成功" Duration:1];
        }]doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"窗口绑定失败" Duration:1];
        }];
    }];
    
    
    //批量叫号 排队列表信息  batchQueueDataWithGroupID
    _batchQueueDataCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi batchQueueDataWithGroupID:self.groupID Number:self.singleNumber WindowID:self.selectWindowID] doNext:^(id  _Nullable x) {
            @strongify(self)
            RACTuple *t                                     = (RACTuple *)x;
            NSArray *entrySet                                    = t.first;
            NSArray *paramsSet = t.second;
            //等待时间
            self.waitingTime = [KMTool valueForName:@"waitingTime" InArr:paramsSet];
            //等待人数
            self.waitingCount = [KMTool valueForName:@"waitingCount" InArr:paramsSet];
            //当前办理
            self.currentHandle = [KMTool valueForName:@"currentNo" InArr:paramsSet];
            //排队列表
            self.queueArr = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMQueueDataModel class] json:entrySet]];
            
            BOOL ret = [(NSNumber *)input boolValue];
            (ret && self.queueArr.count != 0) ? (self.singleNumber == 0 ? [self callNextSpeak] : [self callNextBatch]) : nil;

            //更改排队状态
            entrySet.count ? [self.editQueueStateCommand execute:nil] : nil;
            //刷新UI
            [self.reloadSubject sendNext:nil];
        }]doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    
    //结束上一批
    _batchEndLastCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi batchEndLastWithQueueIDs:input GroupID:self.groupID] doNext:^(id  _Nullable x) {
            @strongify(self)
            [self.batchQueueDataCommand execute:@(YES)];
            //加载下一批
//            [self.detailCommand execute:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    //批量暂停
    _batchSuspendCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi batchSuspendWithQueueIDs:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"暂停成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误, 操作失败" Duration:1];
        }];
    }];
    //更改排队状态
    _editQueueStateCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self)
        NSString *idsString = @"";
        if (self.singleNumber == 0) {
            KMQueueDataModel * q = self.queueArr.firstObject;
            idsString = q.Id;
        }else{
            NSArray *ids = [[self.queueArr.rac_sequence map:^id _Nullable(KMQueueDataModel * q) {
                return q.Id;
            }] array];
            idsString = [ids componentsJoinedByString:@"###"];
        }
        return [[[KM_NetworkApi editQueueStateWithQueueIDs:idsString WinID:self.selectWindowID] doNext:^(id  _Nullable x) {
            
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}

-(void)km_bindOtherEvent {
    //讯飞科大SDK设置
    {
        //获取语音合成单例
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        //设置协议委托对象
        _iFlySpeechSynthesizer.delegate = self;
        //设置合成参数
        //设置在线工作方式
        [_iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD]
                                      forKey:[IFlySpeechConstant ENGINE_TYPE]];
        //设置音量，取值范围 0~100
        [_iFlySpeechSynthesizer setParameter:@"100"
                                      forKey: [IFlySpeechConstant VOLUME]];
        
        //设置语速
        [_iFlySpeechSynthesizer setParameter:@"0.5" forKey:[IFlySpeechConstant SPEED]];
        
        //发音人，默认为”xiaoyan”，可以设置的参数列表可参考“合成发音人列表”
        [_iFlySpeechSynthesizer setParameter:@" xiaoyan "
                                      forKey: [IFlySpeechConstant VOICE_NAME]];
        //保存合成文件名，如不再需要，设置为nil或者为空表示取消，默认目录位于library/cache下
        [_iFlySpeechSynthesizer setParameter:nil
                                      forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
    }
}

#pragma mark  启动合成语音
//呼叫当前
-(void)callCurrentSpeak{
    
    //启动合成会话
    
    KMQueueDataModel *model = self.queueArr.firstObject;
    NSString *windowName = [model.windowName isEqualToString:@"办理中"] ? @"" : model.windowName;
    NSMutableString *call1 = [[NSMutableString alloc]init];
    [call1 appendString:@" 请"];
    [call1 appendString:kShortPause];
    [call1 appendString:NSStringFormat(@" %@",model.bespeakSort)];
    [call1 appendString:kShortPause];
    [call1 appendString:@" 到"];
    [call1 appendString:kShortPause];
    [call1 appendString:NSStringFormat(@" %@",windowName)];
    
    
    NSMutableString *call2 = [[NSMutableString alloc]init];
    [call2 appendString:@" 请"];
    [call2 appendString:kShortPause];
    [call2 appendString:NSStringFormat(@" %@",model.bespeakSort)];

    NSString *callString = windowName.length ? call1 : call2;

    [_iFlySpeechSynthesizer startSpeaking: callString];
    

}
//呼叫下一位
-(void)callNextSpeak{
    //启动合成会话
    
    KMQueueDataModel *model = self.queueArr.firstObject;
    NSString *windowName = [model.windowName isEqualToString:@"办理中"] ? @"" : model.windowName;
    NSMutableString *call1 = [[NSMutableString alloc]init];
    
    for (int i = 0; i < 2; i ++) {
        if (i == 1) {
            [call1 appendString:kLongPause];
        }
        [call1 appendString:@" 请"];
        [call1 appendString:kShortPause];
        [call1 appendString:NSStringFormat(@" %@",model.bespeakSort)];
        [call1 appendString:kShortPause];
        [call1 appendString:@" 到 "];
        [call1 appendString:kShortPause];
        [call1 appendString:NSStringFormat(@" %@",windowName)];
    }
    
    
    NSMutableString *call2 = [[NSMutableString alloc]init];
    
    for (int i = 0; i < 2; i ++) {
        if (i == 1) {
            [call1 appendString:kLongPause];
        }
        [call2 appendString:@"、、、、 请、 "];
        [call2 appendString:kShortPause];
        [call2 appendString:NSStringFormat(@" %@",model.bespeakSort)];
    }
    
    NSString *callString = windowName.length ? call1 : call2;
    
    [_iFlySpeechSynthesizer startSpeaking: callString];
}
//呼叫过号
-(void)callPassSpeak{
    //启动合成会话
    
    KMQueueDataModel *model = self.queueArr.firstObject;
    NSString *windowName = [model.windowName isEqualToString:@"办理中"] ? @"" : model.windowName;
    NSMutableString *call1 = [[NSMutableString alloc]init];
    
    for (int i = 0; i < 2; i ++) {
        if (i == 1) {
            [call1 appendString:kLongPause];
        }
        [call1 appendString:@" 请"];
        [call1 appendString:kShortPause];
        [call1 appendString:NSStringFormat(@" %@",model.bespeakSort)];
        [call1 appendString:kShortPause];
        [call1 appendString:@"到 "];
        [call1 appendString:kShortPause];
        [call1 appendString:NSStringFormat(@" %@",windowName)];
    }
    
    
    NSMutableString *call2 = [[NSMutableString alloc]init];
    
    for (int i = 0; i < 2; i ++) {
        if (i == 1) {
            [call1 appendString:kLongPause];
        }
        [call2 appendString:@"  请"];
        [call2 appendString:kShortPause];
        [call2 appendString:NSStringFormat(@" %@",model.bespeakSort)];
    }
    
    NSString *callString =windowName.length ? call1 : call2;
    
    [_iFlySpeechSynthesizer startSpeaking: callString];
}

//呼叫当前批次
-(void)callCurrentBatch {
    
    KMQueueDataModel *model1 = self.queueArr.firstObject;
    KMQueueDataModel *model2 = self.queueArr.lastObject;
    NSString *windowName = [model1.windowName isEqualToString:@"办理中"] ? @"" : model1.windowName;
    NSString *num1 = model1.bespeakSort;
    NSString *num2 = model2.bespeakSort;
    
    
    NSMutableString *call1 = [[NSMutableString alloc]init];
    [call1 appendString:num1];
    [call1 appendString:@"、 到 、"];
    [call1 appendString:num2];
    [call1 appendString:kShortPause];
    [call1 appendString:@" 请到"];
    [call1 appendString:kShortPause];
    [call1 appendString:NSStringFormat(@" %@",windowName)];
    
    
    NSMutableString *call2 = [[NSMutableString alloc]init];
    [call2 appendString:@" 请"];
    [call2 appendString:kShortPause];
    [call2 appendString:num1];
    [call2 appendString:@"、 到 、"];
    [call2 appendString:num2];
    [call2 appendString:@"号"];
    
    NSString *callString = windowName.length ? call1 : call2;
    
    [_iFlySpeechSynthesizer startSpeaking: callString];
}
//呼叫下一批次
-(void)callNextBatch {
    KMQueueDataModel *model1 = self.queueArr.firstObject;
    KMQueueDataModel *model2 = self.queueArr.lastObject;
    NSString *windowName = [model1.windowName isEqualToString:@"办理中"] ? @"" : model1.windowName;
    
    NSString *num1 = model1.bespeakSort;
    NSString *num2 = model2.bespeakSort;
    
    NSMutableString *call1 = [[NSMutableString alloc]init];
    
    for (int i = 0; i < 2; i ++) {
        if (i == 1) {
            [call1 appendString:kLongPause];
        }
        [call1 appendString:num1];
        [call1 appendString:@"、 到 、"];
        [call1 appendString:num2];
        [call1 appendString:kShortPause];
        [call1 appendString:@" 请到"];
        [call1 appendString:kShortPause];
        [call1 appendString:NSStringFormat(@" %@",windowName)];
    }
    
    
    NSMutableString *call2 = [[NSMutableString alloc]init];
    
    for (int i = 0; i < 2; i ++) {
        if (i == 1) {
            [call1 appendString:kLongPause];
        }
        [call2 appendString:@"、、、、 请、 "];
        [call2 appendString:kShortPause];
        [call2 appendString:num1];
        [call2 appendString:@"、 到、 "];
        [call2 appendString:num2];
        [call2 appendString:@"号"];
    }
    
    NSString *callString = windowName.length ? call1 : call2;
    
    [_iFlySpeechSynthesizer startSpeaking: callString];
}

#pragma mark - IFlySpeechSynthesizerDelegate协议实现 -
//合成结束
- (void) onCompleted:(IFlySpeechError *) error {}
//合成开始
- (void) onSpeakBegin {}
//合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg {}
//合成播放进度
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos {}
#pragma mark - Lazy
-(NSMutableArray *)queueArr{
    if (!_queueArr) {
        _queueArr = [NSMutableArray array];
    }
    return _queueArr;
}
-(NSMutableArray *)bindedWinArr{
    if (!_bindedWinArr) {
        _bindedWinArr  = [NSMutableArray array];
    }
    return _bindedWinArr;
}

-(RACSubject *)printSubject{
    if (!_printSubject) {
        _printSubject = [RACSubject subject];
    }
    return _printSubject;
}
@end
