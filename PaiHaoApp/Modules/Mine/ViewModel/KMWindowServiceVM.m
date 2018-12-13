//
//  KMWindowServiceVM.m
//  PaiHaoApp
//
//  Created by KM on 2017/8/29.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMWindowServiceVM.h"

@implementation KMWindowServiceVM

#pragma mark - Private Method -
-(NSAttributedString *)windowNameAttrStrWithInfo:(KMWindowInfo *)info{
    NSMutableAttributedString *s                           = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"窗口名称: %@",info.windowName)];
    [s setFont:kFont32];
    [s setColor:kFontColorDarkGray];
    return s;
}
-(NSAttributedString *)windowInfoAttrStrWithInfo:(KMWindowInfo *)info{
    NSMutableAttributedString *s                           = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"窗口说明: %@",info.reserve)];
    [s setFont:kFont32];
    [s setColor:kFontColorDarkGray];
    return s;
}
-(NSAttributedString *)windowTimeAttrStrWithInfo:(KMWindowInfo *)info{
    NSMutableAttributedString *s                           = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"%@",info.createtime)];
    [s setFont:kFont28];
    [s setColor:kFontColorDarkGray];
    return s;
}
#pragma mark - BaseViewModelInterface -
-(void)km_bindNetWorkRequest{
    @weakify(self)
    _listCommand                                           = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi serviceWindowList] doNext:^(id  _Nullable x) {
            @strongify(self)
    RACTuple *t                                            = x;
    NSArray *entrySet                                      = t.first;
    self.winArr                                            = [NSMutableArray arrayWithArray:[NSArray modelArrayWithClass:[KMWindowInfo class] json: entrySet]];
            [self.reloadSubject sendNext:nil];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    _deleCommand                                           = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [[[KM_NetworkApi deleWindowWithID:input] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
    _addCommand                                            = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
    RACTuple * t                                           = input;
    RACTupleUnpack(NSString * winName, NSString * winInfo) = t;
        return [[[KM_NetworkApi addWindowWithName:winName Info:winInfo] doNext:^(id  _Nullable x) {
            [SVProgressHUD showSuccessWithStatus:@"操作成功" Duration:1];
        }] doError:^(NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"后台服务器错误" Duration:1];
        }];
    }];
}



#pragma mark - Lazy -
-(NSMutableArray *)winArr{
    if (!_winArr) {
    _winArr                                                = [NSMutableArray array];
    }
    return _winArr;
}
@end
