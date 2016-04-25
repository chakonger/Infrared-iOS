//
//  BubbleView.h
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import <UIKit/UIKit.h>
#import "UIMessageObject.h"

typedef enum {
    BubbleMessageTypeIncoming = 0,
    BubbleMessageTypeOutgoing
} BubbleMessageType;


@class BubbleView;

@protocol BubbleViewDelagete <NSObject>

@optional

- (void)bubbleView:(BubbleView*)bubbleView showBigImage:(UIMessageObject*)message;
- (void)retry:(BubbleView*)bubbleView;

@end

@protocol BubbleViewEditDelegate <NSObject>

@optional
- (void)bubbleViewCanBeEdited:(BubbleView *)bubbleView;

@end


@interface BubbleView : UIView

@property (weak, nonatomic) id<BubbleViewDelagete> delegate;
@property (nonatomic, strong) UIMessageObject* message;
@property (assign, nonatomic) BubbleMessageType type;
//@property (nonatomic, strong) UILabel* displayNameLabel;
@property (assign, nonatomic) BOOL bubbleHighlighted;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, weak) id<BubbleViewEditDelegate> editDelegate;

- (WM_INSTANCETYPE)initWithFrame:(CGRect)rect bubbleType:(BubbleMessageType)bubbleType;

- (UIImage*)bubbleImage;
- (UIImage*)bubbleImageHighlighted;
- (CGRect)resendImageRect;
- (id)content;
- (UIView *)contentView;

@end
