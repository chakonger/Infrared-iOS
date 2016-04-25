//
//  ZYHttpTool.m
//  JYLX
//
//  Created by ToTank on 16/1/29.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import "ZYHttpTool.h"
#import "AFNetworking.h"


@implementation ZYHttpTool

+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    
    //    // 设置超时时间
    //    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    //     mgr.requestSerializer.timeoutInterval = 10.f;
    //    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    //
    
    // 2.发送请求
    [mgr POST:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
             NSLog(@"+++++++%@",responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
    

    
    
    
////
//    NSError *parseError = nil;
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&parseError];
//    NSString *postStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSData *postData = [postStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSURL *urlstr = [NSURL URLWithString:url];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:urlstr cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
//    [request setHTTPBody:postData];//设置参数
//    
//    //第三步，连接服务器
//    
//    
//    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        NSString *jsonstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSString *strUrl = [jsonstr stringByReplacingOccurrencesOfString:@"_id" withString:@"id"];
//        
//    
//        
//        NSData *jsonData = [strUrl dataUsingEncoding:NSUTF8StringEncoding];
//        NSError *err;
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                            options:NSJSONReadingMutableContainers
//                                                              error:&err];
//        if(err) {
//            NSLog(@"json解析失败：%@",err);
//        
//        }
//
//        
//      
//        if (success) {
//            
//            success(dict);
//        }
//        
//        
//    }];



}

+ (void)getWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    
//    // 设置超时时间
//    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//     mgr.requestSerializer.timeoutInterval = 10.f;
//    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//
    
    // 2.发送请求
    [mgr GET:url parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         if (failure) {
             failure(error);
         }
     }];
    
    
//    NSURL *URL = [NSURL URLWithString:url];
//    
//    
//    
//    //第二步，通过URL创建网络请求
//    
//    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
//    
//    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
//    
////    其中缓存协议是个枚举类型包含：
////    
////    NSURLRequestUseProtocolCachePolicy（基础策略）
////    
////    NSURLRequestReloadIgnoringLocalCacheData（忽略本地缓存）
////    
////    NSURLRequestReturnCacheDataElseLoad（首先使用缓存，如果没有本地缓存，才从原地址下载）
////    
////    NSURLRequestReturnCacheDataDontLoad（使用本地缓存，从不下载，如果本地没有缓存，则请求失败，此策略多用于离线操作）
////    
////    NSURLRequestReloadIgnoringLocalAndRemoteCacheData（无视任何缓存策略，无论是本地的还是远程的，总是从原地址重新下载）
////    
////    NSURLRequestReloadRevalidatingCacheData（如果本地缓存是有效的则不下载，其他任何情况都从原地址重新下载）
////    
//    //第三步，连接服务器
//    
//    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    
//    
//    
//    NSString *str = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    
//    
//    
//    NSLog(@"%@",str);
//    
//    if(success)
//    {
//        success(str);
//        str = nil;
//       
//    }
    
    
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
