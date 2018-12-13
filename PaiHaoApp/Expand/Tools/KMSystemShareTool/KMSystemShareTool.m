//
//  KMSystemShareTool.m
//  PaiHaoApp
//
//  Created by KM on 2017/9/16.
//  Copyright © 2017年 KM. All rights reserved.
//

#import "KMSystemShareTool.h"

@implementation KMSystemShareTool
+(void)shareWithURL:(NSURL *)url Text:(NSString *)text Image:(UIImage *)image{
    //文字
    NSString *textToShare = text ? text : @"";
    //图片
    UIImage *imageToShare = image ? image : IMAGE_NAMED(@"1024x1024Px");
    //URL
    NSURL *urlToShare = url ? url : [NSURL URLWithString:@"http://www.paihao123.com/"];
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
    
    UIActivityViewController *activity = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不想展示的
    activity.excludedActivityTypes = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypeCopyToPasteboard,
                                       UIActivityTypeAssignToContact,
                                       UIActivityTypeSaveToCameraRoll
                                       ];
    [[[AppDelegate shareAppDelegate] getCurrentUIVC] presentViewController:activity animated:YES completion:nil];
}
@end
