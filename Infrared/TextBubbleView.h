//
//  TextBubbleView.h
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import <UIKit/UIKit.h>
#import "BubbleView.h"


@interface TextBubbleView : BubbleView

+ (CGFloat)cellHeightForText:(NSString*)txt andMessage:(UIMessageObject*)message;

@end
