//
//  UIColor+ZYHex.m
//  JYLX
//
//  Created by ToTank on 16/2/18.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import "UIColor+ZYHex.h"

@implementation UIColor (ZYHex)

+ (UIColor *)colorForHex:(NSString *)hexColor
{
    // String should be 6 or 7 characters if it includes '#'
    if ([hexColor length]  < 6)
        return ([UIColor redColor]);
    
    // strip # if it appears
    if ([hexColor hasPrefix:@"#"])
        hexColor = [hexColor substringFromIndex:1];
    
    // if the value isn't 6 characters at this point return
    // the color black
    NSUInteger n = [hexColor length];
    if ((n != 6) && (n != 8))
        return ([UIColor redColor]);
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    NSString *strR, *strG, *strB, *strA;
    strR = [hexColor substringWithRange:NSMakeRange(0, 2)];
    strG = [hexColor substringWithRange:NSMakeRange(2, 2)];
    strB = [hexColor substringWithRange:NSMakeRange(4, 2)];
    strA = (n==8) ? [hexColor substringWithRange:NSMakeRange(6, 2)] : nil;
    
    // Scan values
    unsigned r, g, b, a=255.f;
    [[NSScanner scannerWithString:strR] scanHexInt:&r];
    [[NSScanner scannerWithString:strG] scanHexInt:&g];
    [[NSScanner scannerWithString:strB] scanHexInt:&b];
    if (strA)
    {
        [[NSScanner scannerWithString:strA] scanHexInt:&a];
    }
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}




@end
