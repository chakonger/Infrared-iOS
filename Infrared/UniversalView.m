//
//  UniversalView.m
//  Control
//
//  Created by ToTank on 15/10/29.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//

#import "UniversalView.h"
#import "ZYCustomButton.h"
#import "UIColor+ZYHex.h"
#define AirIconWidth 92

@implementation UniversalView

- (instancetype)initWithDict:(NSDictionary*)dict{
    
    CGFloat Row = [[dict  objectForKey:@"keyRow"] floatValue];
    CGRect frame;
    if (Row < 2 ) {
         frame = CGRectMake( AirIconWidth , 0, AppFrameWidth-AirIconWidth, 2*KCustomButtonHight);
    }else
    {
      frame = CGRectMake( AirIconWidth , 0, AppFrameWidth-AirIconWidth, Row*KCustomButtonHight);
    }
   
    self = [super initWithFrame:frame];
    if (self) {
        NSInteger keyCol = [[dict objectForKey:@"keyCol"] integerValue];  //每行有几列
        NSArray *array = [[dict objectForKey:@"keysSet"] allKeys];
        for (NSString *str in array) {
            
            NSDictionary *keysSet = [[dict objectForKey:@"keysSet"] objectForKey:str];
            NSString *url = [dict objectForKey:@"dirURL"];
            // key 坐标  keycol列 宽度 [字典] 图片路径
            ZYCustomButton *custombtn = [ZYCustomButton ButtoninitWithStr:str WithkeyCol:keyCol AndDict:keysSet WithUrl:url];
            
            [custombtn addTarget:self action:@selector(postInst:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:custombtn];
            
            
        }
        
        self.layer.masksToBounds = YES;
        //设置边框及边框颜色
        self.layer.borderWidth = 0.5;
        self.layer.borderColor =[[UIColor colorForHex:@"dddddd"] CGColor];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

-(void)postInst:(ZYCustomButton*)btn
{
   // NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:btn.inst,@"inst", nil];
    
    //创建通知
   [[NSNotificationCenter defaultCenter] postNotificationName:KYSShowPustInstUnivelNotification object:btn];
  

}



@end
