//
//  ZYHttpTool.h
//  JYLX
//
//  Created by ToTank on 16/1/29.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYHttpTool : NSObject

/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

/**
 *  发送一个GET请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

///*!
//   字典转成字符串
// */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
//
///*!
// 字符串转成字典
// */
+(NSDictionary*)dictionaryWithJsonString:(NSString *)jsonString;
//
//


@end
