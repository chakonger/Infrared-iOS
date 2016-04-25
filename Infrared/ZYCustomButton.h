//
//  ZYCustomButton.h
//  Control
//
//  Created by ToTank on 15/10/28.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYCustomButton : UIButton

@property(nonatomic, copy)NSString *inst;
@property(nonatomic, copy)NSString *type;
@property(nonatomic, copy)NSString *UrlStr;


+(instancetype)ButtoninitWithStr:(NSString *)str WithkeyCol:(NSInteger)keyCol AndDict:(NSDictionary*)dict WithUrl:(NSString *)url;

@end
