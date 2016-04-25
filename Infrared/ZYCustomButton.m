//
//  ZYCustomButton.m
//  Control
//
//  Created by ToTank on 15/10/28.
//  Copyright © 2015年 lvjianxiong. All rights reserved.
//
#define ZYButtonImageRatio 0.5
#define AirIconWidth 92
#import "ZYCustomButton.h"
#import "UIButton+WebCache.h"
#import "UIColor+ZYHex.h"


@implementation ZYCustomButton

+(instancetype)ButtoninitWithStr:(NSString *)str WithkeyCol:(NSInteger)keyCol AndDict:(NSDictionary*)dict WithUrl:(NSString *)url
{
   
    CGFloat btnX = ([[str substringWithRange:NSMakeRange(1, 1)] integerValue]-1) * (AppFrameWidth-AirIconWidth)/keyCol;
    CGFloat btnY = ([[str substringWithRange:NSMakeRange(0, 1)] integerValue]-1)*KCustomButtonHight;
    
    CGFloat btnW = (AppFrameWidth-AirIconWidth)/keyCol;
    CGFloat btnH = KCustomButtonHight;
    CGRect frame = CGRectMake(btnX,btnY,btnW,btnH);
    ZYCustomButton *customBtn = [[ZYCustomButton alloc]initWithFrame:frame withDict:dict WithUrl:(NSString *)url];
    return  customBtn;
}

-(id)initWithFrame:(CGRect)frame withDict:(NSDictionary *)dict WithUrl:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.inst = [[dict objectForKey:@"inst"] firstObject];
        self.type = [dict objectForKey:@"type"];
        if ([self.type isEqualToString:@"url"]) {
            self.UrlStr = [dict objectForKey:@"url"];
        }
        NSString *URLstr = [NSString stringWithFormat:@"http://180.150.187.99/%@%@",url,[dict objectForKey:@"img"]];
        
       
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:[[dict objectForKey:@"text"] firstObject] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        

        dispatch_async(dispatch_get_main_queue(), ^{
            [self sd_setImageWithURL:[NSURL URLWithString: URLstr ] forState:UIControlStateNormal placeholderImage:_IMAGE(@"model_normal") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];

      });
        
        self.layer.masksToBounds = YES;
        //设置边框及边框颜色
        self.layer.borderWidth = 0.5;
        self.layer.borderColor =[[UIColor colorForHex:@"dddddd"] CGColor];
    }

    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.width;
   // CGFloat imageH = contentRect.size.height *ZYButtonImageRatio;
    
    return CGRectMake(imageW/2-10, 15, 20, 20);
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height *ZYButtonImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = contentRect.size.height -titleY;
    
    
    return CGRectMake(0, titleY, titleW, titleH);
}


@end
