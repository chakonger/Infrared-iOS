//
//  CommonUtils.h
//  QuickPay
//
//  Created by lvjianxiong on 14-2-27.
//  Copyright (c) 2014年 lvjianxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <stdio.h>
#include <string.h>




@interface CommonUtils : NSObject

/*!
 @method
 @abstract 创建文件。
 @param path 文件地址
 @return BOOL 文件是否创建成功
 */
//+ (BOOL)createDirectorysAtPath:(NSString *)path;
//
//+ (void)requestImageByPost : (UIImageView *)imageView withUrl:(NSString *)urlStr;
//
//+ (NSData *)getLocalImage:(NSString *)photoUrl;
//
//+ (void)setLocalImage:(NSData *)imageData photoUrl:(NSString *)photoUrl;
//
//+ (NSString *)diskPath;

/*!
 @method
 @abstract MD5加密
 @param strToEncode 需要加密的字符串
 @return 返回一个MD5加密后字符串
 */
//+ (NSString *)md5ForString:(NSString *)strToEncode ;
//
//+ (NSString *)sortHeadParam:(NSDictionary *)param;
//
//+ (NSString *)sortBodyParam:(NSDictionary *)param;
//
/*!
 @method
 @abstract  绘直线
 @param imageView   目标Imageview
 @param withSize    绘制大小
 @param withIsVirtual   是否虚线
 */
+ (void)drawLine:(UIImageView *)imageView withSize:(CGSize )size withIsVirtual:(BOOL)isvirtual;

/*!
 @discussion    格式化日期
 @property  format
 @property  date
 */
+ (NSString *) formatDate:(NSString *)format date:(NSDate *)date;

/*!
 
 */
//+ (NSDate *)transDate:(NSString *)format dateString:(NSString *)dateString;

/*!
 @discussion    格式化距离
 @property  meter
 */
//+ (NSString *)distance:(NSString *)meter;

/*!
 @discussion    计算字体所占size
 @property  str
 @property  font
 @property  size
 */
//+ (CGSize)fontSize:(NSString *)str withFont:(UIFont *)font withSize:(CGSize)size;

/*!
 @discussion    计算时间
 @property  minute
 */
//+(NSString *)caculateTime : (NSString *)minute;

/*!
 @discussion
 @property  txPower 16进制值
 @property  rssi    信号值
 @return    实际距离
 */
//+ (double)calculateAccuracy:(long) txPower rssi:(double) rssi;

/*!
 @discussion    去掉tabview分割线
 @property  tableView 目标TableView
 */
//+(void)setExtraCellLineHidden: (UITableView *)tableView;

/*!
 @property  imagestr
 @property  width
 @discussion    固定宽度，按比例缩放图片，返回其对应高度
 */
//+ (float)imageName:(NSString *)imagestr fixedWidth:(float)width;

/*!
 @abstract
 */
+(UIImage*) imageWithColor:(UIColor*)color;

/*!
 @abstract 获取图片
 */
//+ (UIImage *)imageWithName:(NSString *)name type:(NSString *)type;

/*!
 @abstract  设置导航条按钮
 */
//+ (UIBarButtonItem *)setNavigationButtonItemStyle:(id)target withAction:(SEL)action
//                                        withTitle:(NSString *)title normalImage:(UIImage *)normalImage clickImage:(UIImage *)clickImage size:(CGRect)size;
//
/*!
 @abstract 设置头部颜色
 @property  nav
 */
//+ (void)setNavigationTitleColor:(UINavigationController *)nav;

/*!
 @abstract  修改图片大小
 @property  目标图片
 @property  图片大小
 @return    修改后的图片
 */
//+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/*!
 @abstract  UIColor转UIImage
 @param color
 */
//+ (UIImage*) createImageWithColor: (UIColor*) color;

/*!
 @abstract  获取分辨率
 */
//+(NSString *)resolution;

/*!
 @abstract  NSDictionary转Json字符串
 @param param   参数
 @return    NSString
 */
//+ (NSString *)transformDictToJson:(id)param;

/*!获取设备信息*/
//+ (void)getDeviceMessage;

/*!
 计算执行时间
 */
//+ (NSDate *)exeTime:(NSString *)time;

/*!
 格式化日期
 */
//+ (NSString *)formatExeTime : (NSString *)time;

/*!
 字符串转换成NSDate
 */
//+(NSDate*) convertDateFromString:(NSString*)uiDate withFormat:(NSString *)format;

/*!
 时间转换
 */
//+ (NSString *)transExeTime:(NSString *)time;

/*!
 转换命令
 */
//+ (NSString *)transOrder:(NSString *)order withDevType:(NSString *)devType;

/*!
 转化时间
 */
//+ (NSString *)transDurationTime:(NSString *)duration;
/*!
 获取一周时间
 */
//+ (NSMutableArray *)getNearWeakDay;

/*!
 获取时分秒
 */
//+ (NSInteger )getHourTime:(NSDate *)date;
//
//+ (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize;
//
//+ (const char *)stringCovChar:(NSString *)str;
///*!
// 加密
// */
//+(NSString *)encodeWithSeed:(const char *)strIn withSeed:(int)nSeed;
//
///*!
// 生成随机数
// */
//+(int)getRandomNumber:(int)from to:(int)to;
//
///*!
// 设置图片大小
// */
//+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize;
//
//+ (NSString *)separateString:(NSString *)aim withMark:(NSString *)mark;
//
///*!
// 验证手机号是否正常
// */
//+ (BOOL)validateMobile:(NSString *)mobileNum;
//
///*!
//  返回秒的计算
// */
//+(NSInteger)timesValueWithInstString:(NSString *)str;
//
///*!
//   字典转成字符串
// */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
//
///*!
// 字符串转成字典
// */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//
//



@end
