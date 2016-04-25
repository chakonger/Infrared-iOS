//
//  CommonUtils.m
//  QuickPay
//
//  Created by lvjianxiong on 14-2-27.
//  Copyright (c) 2014年 lvjianxiong. All rights reserved.
//

#import "CommonUtils.h"
//#import "Constant.h"
#import <CommonCrypto/CommonDigest.h>
//#import "CJSONSerializer.h"
#import "UIColor+ZYHex.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <math.h>
//#import "QHDataRequest.h"
//#import "NSDate+Utilities.h"

#define CONST_MAXSALTLEN 128

unsigned int anSaltList[CONST_MAXSALTLEN+1]=\
{21, 32, 43, 54, 235, 226, 17, 28, 49, 110, 211, 112, 213, 114, 15, 216, 117, 18, 219, 120, \
    221, 222, 23, 124, 225, 126, 227, 128, 129, 130, 231, 232,212, 217, 143, 54, 35, 26, 117, 128, \
    149, 10, 21, 132, 243, 141, 151, 213, 173, 181,23, 124, 213, 39, 112, 51, 211, 77, 27, 18, \
    29, 138, 233, 23,2121, 3332, 1243, 254, 2235, 2261, 1712, 2118, 4129, 1110, 6211, 1112, 2134, 1114, 1215, 27716,\
    12117, 1218, 2119, 1200, 2121, 8222, 823, 9124, 1225, 11126, 2227, 3128, 4129, 1530, 4231, 1232,2212, 7217, 8143, 5477,\
    3665, 2886, 1717, 1288, 1469, 6510, 5521, 1532, 5243, 1341, 9151, 5213, 1473, 1481,2453, 14524, 4213, 44539, 6112, 7451,\
    3211, 7777, 3327, 18, 329, 1338, 2333, 323};


@implementation CommonUtils

+ (BOOL)createDirectorysAtPath:(NSString *)path{
    @synchronized(self){
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSError *error = nil;
            if (![manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
                return NO;
            }
        }
    }
    return YES;
}


//+ (void)requestImageByPost : (UIImageView *)imageView withUrl:(NSString *)urlStr{
//    
//    NSData *imageData = [CommonUtils getLocalImage:urlStr];
//    UIImage *image;
//    if (nil!=imageData) {
//        image = [UIImage imageWithData:imageData];
//        imageView.image = image;
//        return;
//    }
//    NSURL *url = [NSURL URLWithString:urlStr];
//    dispatch_queue_t queue =dispatch_queue_create("loadImage",NULL);
//    dispatch_async(queue, ^{
//        NSData *resultData = [NSData dataWithContentsOfURL:url];
//        UIImage *img = [UIImage imageWithData:resultData];
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            imageView.image = img;
//            [CommonUtils setLocalImage:resultData photoUrl:urlStr];
//        });
//        
//    });
//}

//+ (NSData *)getLocalImage:(NSString *)photoUrl{
////    NSData *imageData = nil;
//    
//    if ([[NSNull null] isEqual:photoUrl]) {
//        UIImage *image = [UIImage imageNamed:@"quickpay_head"];
//        NSData *imageData = UIImageJPEGRepresentation(image,1.0);
//        return imageData;//此处修改未default页面
//
//    }
//    NSArray *resultArray = [photoUrl componentsSeparatedByString:@"/"];
//    NSString *name = [resultArray objectAtIndex:([resultArray count]-1)];//图片名称
//    
//    NSFileManager *fileManage = [NSFileManager defaultManager];
//    NSString *myDirectory = [CommonUtils diskPath];
//    BOOL isDir;
//    if ([fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
//        if (FALSE==isDir){
//            return nil;
//        }
//    } else {
//        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
//    }
//    
//    [fileManage changeCurrentDirectoryPath:myDirectory];
//    //判断文件存在
//    if ([fileManage fileExistsAtPath:name]) {
//        NSData *data = [fileManage contentsAtPath:name];
//        return data;
//    } else {
//        return nil;
//    }
//    
//}
//
//+ (void)setLocalImage:(NSData *)imageData photoUrl:(NSString *)photoUrl{
//    if (nil==imageData||Nil==photoUrl) {
//        return;
//    }
//    NSArray *resultArray = [photoUrl componentsSeparatedByString:@"/"];
//    NSString *name = [resultArray objectAtIndex:([resultArray count]-1)];//图片名称
//    
//    NSString *myDirectory = [CommonUtils diskPath];
//    NSFileManager *fileManage = [NSFileManager defaultManager];
//    BOOL isDir;
//    if ([fileManage fileExistsAtPath:myDirectory isDirectory:&isDir]) {
//        if (FALSE==isDir){
//            return;
//        }
//    } else {
//        [fileManage createDirectoryAtPath:myDirectory withIntermediateDirectories:TRUE attributes:nil error:nil];
//    }
//    
//    [fileManage changeCurrentDirectoryPath:myDirectory];
//    if (FALSE==[fileManage fileExistsAtPath:name]) {
//        if (IsOSVersionAtLeastiOS8()) {
//            NSString *path = [myDirectory stringByAppendingPathComponent:name];
//            [fileManage createFileAtPath:path contents:imageData attributes:nil];
//        }else{
//            [fileManage createFileAtPath:name contents:imageData attributes:nil];
//        }
//    }
//}
//

//+ (NSString *)diskPath{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *myDirectory = [documentsDirectory stringByAppendingPathComponent:_YS_PHOTO];
//    return myDirectory;
//}

+ (NSString *)md5ForString:(NSString *)strToEncode {
    
    const char *cStr = [strToEncode UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    
    NSString *r =  [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
//            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];

    return r;
}


+ (NSString *)sortHeadParam:(NSDictionary *)param{
    NSArray *keys = [param allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *str = [NSMutableString string];
    for (NSString *s in sortedArray) {
        [str appendString:[s stringByAppendingFormat:@"=%@",[param objectForKey:s]]];
    }
    return str;
}

+ (NSString *)sortBodyParam:(NSDictionary *)param{
    NSArray *keys = [param allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableString *str = [NSMutableString string];
    for (int i=0;i<[sortedArray count];i++) {
        if (i>0) {
            [str appendString:@"&"];
        }
        NSString *s = [sortedArray objectAtIndex:i];
        [str appendString:[s stringByAppendingFormat:@"=%@",[param objectForKey:s]]];
    }
    return str;
}

+ (void)drawLine:(UIImageView *)imageView withSize:(CGSize )size withIsVirtual:(BOOL)isvirtual{
    CGFloat lengths[] = {4,2};
    UIGraphicsBeginImageContext(size);
    [imageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);  //是否有圆角
    CGContextSetLineWidth(context, size.width);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSetRGBStrokeColor(context, 0.8, 0.8, 0.8, 1.0);
    CGContextBeginPath(context);
    if (isvirtual) {
        CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    }
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, AppFrameWidth, 0);
    CGContextStrokePath(context);
    imageView.image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

+(NSString *) formatDate:(NSString *)format date:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:format];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT+8"]];
//    [formatter setDateFormat:format];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)transDate:(NSString *)format dateString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)distance:(NSString *)meter{
    float m = [meter floatValue];
    m = m/1000;
    NSString *result = [NSString stringWithFormat:@"%.2fKM",m];
    return result;
}

+ (CGSize )fontSize:(NSString *)str withFont:(UIFont *)font withSize:(CGSize)size{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize s = CGSizeZero;
    if ([[NSNull null] isEqual:str]) {
        return s;
    }
    CGRect r = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    s = r.size;
    
    return s;
}

+(NSString *)caculateTime : (NSString *)minute{
    NSString *time = @"";
    if (minute) {
        NSDate *tmpDate = [NSDate date];
        int n = [tmpDate timeIntervalSince1970];
        int m = minute.intValue;
        m = (n-m)/60;
        if (m<0) {
            time = @"0分钟前";
        }else if (minute>=0 && m<60){
            time = [[NSString stringWithFormat:@"%d",m] stringByAppendingString:@"分钟前"];
        }else if (m>=60 && m<(60*24) ) {
            m/=60;
            time = [[NSString stringWithFormat:@"%d",m] stringByAppendingString:@"小时前"];
        }else{
            m /=1440;
            time = [[NSString stringWithFormat:@"%d",m>3?3:m] stringByAppendingString:@"天前"];
        }
    }
    return time;
}

+ (double)calculateAccuracy:(long) txPower rssi:(double) rssi{
    if (rssi == 0 || txPower == 0) {
        return -1.0; // if we cannot determine accuracy, return -1.
    }
    double ratio = rssi*1.0/txPower;
    if (ratio < 1.0) {
        return  pow(ratio,10);
    }
    else {
        double accuracy =  (0.89976)*pow(ratio,7.7095) + 0.111;
        return accuracy;
    }
}

+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


+ (float)imageName:(NSString *)imagestr fixedWidth:(float)width
{
    if (imagestr == nil) {
        return 0;
    }
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagestr]]];
    
    float height= img.size.height/img.size.width * width;
    

    
    return height;
}

+(UIImage*) imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageWithName:(NSString *)name type:(NSString *)type{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:type];
    UIImage  *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

+ (UIBarButtonItem *)setNavigationButtonItemStyle:(id)target withAction:(SEL)action
                                        withTitle:(NSString *)title normalImage:(UIImage *)normalImage clickImage:(UIImage *)clickImage size:(CGRect)size
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = size;
    if (normalImage==nil) {
        normalImage = [CommonUtils imageWithName:@"back_botton_bg" type:@"png"];
    }
    if (clickImage==nil) {
        clickImage = [CommonUtils imageWithName:@"back_botton_bg_press" type:@"png"];
    }
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:clickImage forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[UIFont fontWithName:@"STHeitiK-Light" size:14]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

+ (void)setNavigationTitleColor:(UINavigationController *)nav{
    
    [nav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorForHex:@"ffffff"],
                                                NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"Arial-Bold" size: 50.0],
                                                NSFontAttributeName,nil]];
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize

{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
    
}


+ (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(NSString *)platform{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

+(NSString *)resolution{
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    //屏幕尺寸的宽高与scale的乘积就是相应的分辨率值。
    NSString *result = [NSString stringWithFormat:@"%.0f*%.0f",size_screen.width*scale_screen,size_screen.height*scale_screen];
    return result;
}


//+ (NSString *)transformDictToJson:(id)param{
//    NSString *result = @"{}";
//    if ([param isKindOfClass:NSDictionary.class]) {
//        result = [[CJSONSerializer serializer] serializeDictionary:param];
//    }
//    if ([param isKindOfClass:NSArray.class]) {
//        result = [[CJSONSerializer serializer] serializeArray:param];
//    }
//    return result;
//}

//+ (void)getDeviceMessage{
//     NSString *userId = [USER_DEFAULT valueForKey:kUserIdentifity];
//    NSMutableDictionary *messageDict = [NSMutableDictionary dictionary];
//    [messageDict setValue:@"A0A0" forKey:@"CMD"];
//    [messageDict setValue:@"" forKey:@"wifiMAC"];
//    [messageDict setValue:userId forKey:@"sender"];
//    [messageDict setValue:@"" forKey:@"IMGroup"];
//    [messageDict setValue:userId forKey:@"userID"];
//    
//    [ControlGetMsgAction requestWithParameters:messageDict withIndicatorView:nil withCancelSubject:@"" onRequestStart:^(QHBaseDataRequest *request) {
//        
//    } onRequestFinished:^(QHBaseDataRequest *request) {
//        NSDictionary *result = request.resultDic;
//        LOG(@"msgkey=%@,result=%d",[result valueForKey:kResultMsgKey],[[result valueForKey:kResultMsgKey] hasSuffix:kResultSuccess]);
//        if ([[result valueForKey:kResultMsgKey] hasSuffix:kResultSuccess]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
//        }
//    } onRequestCanceled:^(QHBaseDataRequest *request) {
//        
//    } onRequestFailed:^(QHBaseDataRequest *request, NSError *error) {
//        
//    }];
//}

+ (NSDate *)exeTime:(NSString *)time{
    
    NSDate *tmp = [NSDate date];
    int n = [tmp timeIntervalSince1970];
    
    NSString *tmpformat = [NSString stringWithFormat:@"yyyyMMdd%@00",time];
    NSString *t = [CommonUtils formatDate:tmpformat date:tmp];
    NSDate *tmpTime = [CommonUtils transDate:@"yyyyMMddHHmmss" dateString:t];
    int m = [tmpTime timeIntervalSince1970];
    
    NSDate *resultDate = nil;
    if (n-m>600) {
        //第二天
        m += 60*60*24;
        resultDate = [NSDate dateWithTimeInterval:60*60*24 sinceDate:tmpTime];
    }else{
        //当天
        resultDate = tmpTime;
    }
    
    return resultDate;
}

+ (NSString *)formatExeTime : (NSString *)time{
    NSString *pre = [time substringToIndex:2];
    NSString *suf = [time substringWithRange:NSMakeRange(2, time.length-2)];
    NSString *result = [NSString stringWithFormat:@"%@:%@",pre,suf];
    return result;
}


+(NSDate*) convertDateFromString:(NSString*)uiDate withFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:format];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;//@"yyyyMMddHHmmss"
}

//+ (NSString *)transExeTime:(NSString *)time{
//    
//    NSString *resultTime = @"";
//    NSDate * date = [NSDate convertStringToDate:time];
//    
//    if([date isToday]){
//        resultTime = @"今天";
//    }else if([date isTomorrow]){
//        resultTime = @"明天";
//    }else{
//        resultTime = @"后天";
//    }
//    //
//    //    NSDate *d = [self convertDateFromString:time withFormat:@"yyyyMMddHHmmss"];
//    //    NSDate *tmp = [NSDate date];
//    //
//    //    NSInteger m = [self getHourTime:d];
//    //    NSInteger n = [self getHourTime:tmp];
//    //
//    //    [self isTomorrow:d];
//    //
//    //    if (m>n) {
//    //        resultTime = @"今天";
//    //    }else if(m==n){
//    //        resultTime = @"今天";
//    //    }else{
//    //        resultTime = @"明天";
//    //    }
//    //    /*
//    //     switch (result) {
//    //     case NSOrderedDescending:
//    //     //晚（当前时间大于传入时间）即：明天
//    //     resultTime = @"明天";
//    //     break;
//    //     case NSOrderedAscending:
//    //     //早（当前时间小于传入时间） 即：今天
//    //     resultTime = @"今天";
//    //     break;
//    //     case NSOrderedSame:
//    //     //今天
//    //     resultTime = @"今天";
//    //     break;
//    //     default:
//    //     break;
//    //     }
//    //     */
////    NSString *tmpTime = [self formatDate:@"HH:mm" date:date];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"CMT-8"]];
//    [formatter setDateFormat:@"HH:mm"];
//    NSString *dateString = [formatter stringFromDate:date];
//    
//    
//    resultTime  = [resultTime stringByAppendingString:dateString];
//    return resultTime;
//}

//+ (NSString *)transOrder:(NSString *)order withDevType:(NSString *)devType{
//    NSString *result = @"";
//    
//    if (order.length==6) {
//        //        NSInteger      openIndex;
//        //        NSInteger      modelIndex;
//        //        NSInteger      temperatureIndex;
//        //        NSInteger      speedIndex;
//        //        NSInteger      directionIndex;
//        
//        // 指令里面出现FF表示不做处理
//        /*********************************/
//        NSString *opendStr = [order substringToIndex:1];
//        if ([@"0" isEqualToString:opendStr]) {
//            result = [result stringByAppendingFormat:@"%@", @"关闭空调"];
//        }else if([@"1" isEqualToString:opendStr]){
//            NSString *temp = @"打开空调,";
//            result = [result stringByAppendingString:temp];
//            
//            NSString *modelStr = [order substringWithRange:NSMakeRange(1, 1)];
//            if([kModelKeyArray containsObject:modelStr]){
//                result = [result stringByAppendingFormat:@"模式设置为%@", [kModelValueArray objectAtIndex: [kModelKeyArray indexOfObject:modelStr]]];
//            }
//            
//            NSString *temperStr = [order substringWithRange:NSMakeRange(2, 2)];
//            if([kTemperatureKeyArray containsObject:temperStr]){
//                result = [result stringByAppendingFormat:@",温度设置为%@℃", [kTemperatureValueArray objectAtIndex:[kTemperatureKeyArray indexOfObject:temperStr]]];
//            }
//            
//            NSString *speedStr = [order substringWithRange:NSMakeRange(4, 1)];
//            if([kSpeedKeyArray containsObject:speedStr]){
//                result = [result stringByAppendingFormat:@",风速设置为%@", [kSpeedValueArray objectAtIndex:[kSpeedKeyArray indexOfObject:speedStr]]];
//            }
//            
//            NSString *direcStr = [order substringWithRange:NSMakeRange(5, 1)];
//            if ([kDirectionKeyArray containsObject:direcStr]) {
//                result = [result stringByAppendingFormat:@",风向设置为%@", [kDirectionValueArray objectAtIndex:[kDirectionKeyArray indexOfObject:direcStr]]];
//            }
//        }else{
//           // NSLog(@"%@", @"I am sorry , i can not handle it!");
//        }
//        
//        
//        /********************************/
//        //        openIndex  = [[order substringToIndex:1] intValue];
//        //        modelIndex = [[order substringWithRange:NSMakeRange(1, 1)] intValue];
//        //        temperatureIndex = [[order substringWithRange:NSMakeRange(2, 2)] intValue];
//        //        speedIndex = [[order substringWithRange:NSMakeRange(4, 1)] intValue];
//        //        directionIndex = [[order substringWithRange:NSMakeRange(5, 1)] intValue];
//        //
//        //        modelIndex = [kModelValueArray count]<modelIndex?0:modelIndex;
//        //        temperatureIndex = [kTemperatureValueArray count]<temperatureIndex?8:temperatureIndex;
//        //        speedIndex = [kSpeedValueArray count]<speedIndex?0:speedIndex;
//        //        directionIndex = [kDirectionValueArray count]<directionIndex?0:directionIndex;
//        //
//        //
//        //        if (![devType isEqualToString:@"空调"]) {
//        //            devType = @"空调";
//        //        }
//        //        NSString *open = @"打开";
//        //        if(openIndex==0){
//        //            result = [NSString stringWithFormat:@"关闭%@",devType];
//        //        }else{
//        //            result = [NSString stringWithFormat:@"%@%@,%@模式设置为%@,温度为%@℃,风速为%@,风向为%@",open,devType,devType,[kModelValueArray objectAtIndex:modelIndex],[kTemperatureValueArray objectAtIndex:temperatureIndex],[kSpeedValueArray objectAtIndex:speedIndex],[kDirectionValueArray objectAtIndex:directionIndex]];
//        //        }
//        //此处需要处理
//    }else if(order.length==3&&order.intValue!=0){
//       
//        result = kInstDict[order];
//    }else if(order.length==1&&order.intValue>0)
//    {
//     result = [NSString stringWithFormat:@"打开电源"];
//    }else if (order.length == 1&&order.intValue == 0)
//    {
//     result = [NSString stringWithFormat:@"关闭电源"];
//    }
//    
//    else{
//        
//        return order;
//        
//    }
//    
//    return result;
//}

+ (NSString *)transDurationTime:(NSString *)duration{
    NSMutableString *time = [[NSMutableString alloc] init];
    if (duration&&duration.length>0) {
        NSInteger t = duration.integerValue;
        NSInteger hour = t/(60*60);
        NSInteger minute = (t%(60*60))/60;
        NSInteger second = (t%(60*60))%60;
        
        if (hour > 0) {
            [time appendFormat:@"延迟%ld小时",(long)hour];
        }
        if (minute > 0) {
            if(hour<=0)
               [time appendString:@"延迟"];
            [time appendFormat:@"%ld分钟",(long)minute];
        }
        if (second > 0) {
            [time appendFormat:@"%ld秒",(long)second];
        }
        
    }
    return time;
}

+ (NSMutableArray *)getNearWeakDay{
//    NSDate *currentDate = [NSDate date];
    NSDate *monday  = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*7];
    NSDate *tuesday = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*6];
    NSDate *wednesday   = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*5];
    NSDate *thursday    = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*4];
    NSDate *friday  = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*3];
    NSDate *staturday   = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*2];
    NSDate *sunday  = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*1];//currentDate;
    NSString *mondayStr = [self formatDate:@"MM\\dd" date:monday];
    NSString *tuesdayStr = [self formatDate:@"MM\\dd" date:tuesday];
    NSString *wednesdayStr = [self formatDate:@"MM\\dd" date:wednesday];
    NSString *thursdayStr = [self formatDate:@"MM\\dd" date:thursday];
    NSString *fridayStr = [self formatDate:@"MM\\dd" date:friday];
    NSString *staturdayStr = [self formatDate:@"MM\\dd" date:staturday];
    NSString *sundayStr = [self formatDate:@"MM\\dd" date:sunday];
    NSMutableArray *weekArray = [NSMutableArray arrayWithObjects:mondayStr,tuesdayStr,wednesdayStr,thursdayStr,fridayStr,staturdayStr,sundayStr,nil];
    return weekArray;
}

//+ (NSInteger )getHourTime:(NSDate *)date{
//    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
//    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
//    NSDateComponents *comps  = [calendar components:unitFlags fromDate:date];
////    int year = [comps year];
////    int month = [comps month];
////    int day = [comps day];
//    int hour = [comps hour];
//    int min = [comps minute];
////    int sec = [comps second];
//    NSString *time = [NSString stringWithFormat:@"%20d%20d",hour,min];
//    NSInteger timeInt = time.integerValue;
//    return timeInt;
//    
//}
//
+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    return newimage;
}


/*
NSString *string_content = "I'm jordy";
char *char_content = [string_content cStringUsingEncoding:NSASCIIStringEncoding];

char char_array[1024];
NSString *string_content = [[NSString alloc] initWithCString:(const char*)char_array
                                                    encoding:NSASCIIStringEncoding];
 */

//int encodeWithSeed(char *strIn,char *strOut, int nSeed)

/*!
 
 */
+ (const char *)stringCovChar:(NSString *)str{
    const char *char_content = [str cStringUsingEncoding:NSASCIIStringEncoding];
    return char_content;
}
/*!
 对字符串进行加密
 */
+(NSString *)encodeWithSeed:(const char *)strIn withSeed:(int)nSeed
{
    int i,j=0,k=0,m,nLen;
    int nT1,nAscII,nXorSeed,nSalt,nSaltLen=CONST_MAXSALTLEN;
    char strT[5];
    int anSeedList[2];

    //printf("\n%s %s \n",strIn,strOut);
    anSeedList[0]=(nSeed>>8) & 0xFF;
    anSeedList[1]=nSeed & 0xFF;
    //printf("\n%d %d \n",anSeedList[0],anSeedList[1]);
    nLen=strlen(strIn);
    //printf("\n%d \n",nLen);
    m = nSeed % (nSaltLen);
    char strOut[1024];
    for (i=0;i<nLen;i++){

        nAscII=strIn[i];

        //printf("\n%d \n",nAscII);
        nSalt = anSaltList[m] & 0xFF;

        nXorSeed=anSeedList[j] ^ nSalt;
        //printf("\n%d \n",nXorSeed);
        nT1=nAscII ^ nXorSeed;
        sprintf(strT,"%02x",nT1);
        strOut[k]=strT[0];
        strOut[k+1]=strT[1];
        strOut[k+2]=0;
        k+=2;
        j++;
        if (j>=2) j=0;
        m++;
        if (m>=nSaltLen) m=0;
        //strcat(strOut,strT);
        
    }
    NSString *result = [[NSString alloc] initWithCString:(const char*)strOut
                                                        encoding:NSASCIIStringEncoding];
    return result;
}

/*!
 生存随机数
 */
+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
    
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(newsize);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (NSString *)separateString:(NSString *)aim withMark:(NSString *)mark{
    NSString *from = aim;
    NSRange range = [from rangeOfString:mark];//判断字符串是否包含
    if (range.length>0) {
        from = [[from componentsSeparatedByString:mark] objectAtIndex:0];
    }
    return from;
}

+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(NSInteger)timesValueWithInstString:(NSString *)str
{
    if ([str isEqualToString:@"5分钟"]) {
        return 5*60;
    }else if ([str isEqualToString:@"10分钟"])
    {
        return 10*60;
    }
    else if ([str isEqualToString:@"15分钟"])
    {
        return 15*60;
    }
    else if ([str isEqualToString:@"20分钟"])
    {
        return 20*60;
    }
    else if ([str isEqualToString:@"25分钟"])
    {
        return 25*60;
    }
    else if ([str isEqualToString:@"30分钟"])
    {
        return 30*60;
    }
    else if ([str isEqualToString:@"35分钟"])
    {
        return 36*60;
    }
    else if ([str isEqualToString:@"40分钟"])
    {
        return 40*60;
    }
    else if ([str isEqualToString:@"45分钟"])
    {
        return 45*60;
    }
    else if ([str isEqualToString:@"50分钟"])
    {
        return 50*60;
    }
    else if ([str isEqualToString:@"55分钟"])
    {
        return 55*60;
    }
    else if ([str isEqualToString:@"60分钟"])
    {
        return 60*60;
    }
    else if ([str isEqualToString:@"一个半小时"])
    {
        return 1.5*3600;
    }
    else if ([str isEqualToString:@"两个小时"])
    {
        return 2*3600;
    }
    else if ([str isEqualToString:@"两个半小时"])
    {
        return 2.5*3600;
    }
    else if ([str isEqualToString:@"三个小时"])
    {
        return 3*3600;
    }
    else if ([str isEqualToString:@"三个半小时"])
    {
        return 3.5*3600;
    }else if ([str isEqualToString:@"四个小时"])
    {
        return 4*3600;
    }else if ([str isEqualToString:@"四个半小时"])
    {
        return 4.5*3600;
    }else if ([str isEqualToString:@"五个小时"])
    {
        return 5*3600;
    }else if ([str isEqualToString:@"五个半小时"])
    {
        return 5.5*3600;
    }else if ([str isEqualToString:@"六个小时"])
    {
        return 6*3600;
    }else if ([str isEqualToString:@"六个半小时"])
    {
        return 6.5*3600;
    }else if ([str isEqualToString:@"七个小时"])
    {
        return 7*3600;
    }else if ([str isEqualToString:@"七个半小时"])
    {
        return 7.5*3600;
    }else if ([str isEqualToString:@"八个小时"])
    {
        return 8*3600;
    }else if ([str isEqualToString:@"八个半小时"])
    {
        return 8.5*3600;
    }else if ([str isEqualToString:@"九个小时"])
    {
        return 9*3600;
    }else if ([str isEqualToString:@"九个半小时"])
    {
        return 9.5*3600;
    }else if ([str isEqualToString:@"十个小时"])
    {
        return 10*3600;
    }else if ([str isEqualToString:@"十个半小时"])
    {
        return 10.5*3600;
    }else if ([str isEqualToString:@"十一个小时"])
    {
        return 11*3600;
    }else if ([str isEqualToString:@"十一个半小时"])
    {
        return 11.5*3600;
    }else if ([str isEqualToString:@"十二个小时"])
    {
        return 12*3600;
    }
    else
    {
        return 0;
    }
//[NSMutableArray arrayWithObjects:@"5分钟",@"10分钟",@"15分钟",@"20分钟",@"25分钟",@"30分钟",@"35分钟",@"40分钟",@"45分钟",@"50分钟",@"55分钟",@"60分钟",@"一个半小时",@"两个小时",@"两个半小时",@"三个小时",@"三个半小时",@"四个小时",@"四个半小时",@"五个小时",@"五个半小时",@"六个小时",@"六个半小时",@"七个小时",@"七个半小时",@"八个小时",@"八个半小时",@"九个小时",@"九个半小时",@"十个小时",@"十个半小时",@"十一个小时",@"十一个半小时",@"十二个小时", nil]


}
/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
//把字典转换成字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}





@end
