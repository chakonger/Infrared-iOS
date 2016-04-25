//
//  BubbleView.m
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import "BubbleView.h"

@interface BubbleView () <UIGestureRecognizerDelegate>


@end

@implementation BubbleView

- (WM_INSTANCETYPE)initWithFrame:(CGRect)rect bubbleType:(BubbleMessageType)bubbleType
{
    self = [super initWithFrame:rect];
    if(self) {
        [self setup];
        self.type = bubbleType;
//        self.displayNameLabel = [[UILabel alloc] init];
//        self.displayNameLabel.backgroundColor = [UIColor clearColor];
//        self.displayNameLabel.font = [UIFont systemFontOfSize:14.0f];
//        self.displayNameLabel.textColor = [UIColor colorForHex:@"#666666"];

        UILongPressGestureRecognizer *editGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongTapped:)];
        editGesture.delegate = self;
        [self addGestureRecognizer:editGesture];
        QH_RELEASE(editGesture);
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

- (void)setMessage:(id)message
{
    NSAssert([message isKindOfClass:[UIMessageObject class]], @"Error: message is not support!!");
    _message = message;
}

- (UIImage*)bubbleImage
{
    switch (self.type) {
        case BubbleMessageTypeIncoming:
            return  [[UIImage imageNamed:@"chat_from_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(21.0f, 21.0f, 21.0f, 21.0f)];
            break;
        case BubbleMessageTypeOutgoing:
            return  [[UIImage imageNamed:@"chat_to_bg_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(21.0f, 21.0f, 21.0f, 21.0f)];
            break;
        default:
            break;
    }
}

- (void)setAvatarView:(UIImageView *)avatarView
{
    if (avatarView != self.avatarView) {
        [_avatarView removeFromSuperview];
        _avatarView = QH_RETAIN(avatarView);
        [self addSubview:_avatarView];
        [self setNeedsLayout];
    }
}

- (UIImage*)bubbleImageHighlighted
{
    switch (self.type) {
        case BubbleMessageTypeIncoming:
            return  [[UIImage imageNamed:@"chat_from_bg_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(21.0f, 21.0f, 21.0f, 21.0f)];
            break;
        case BubbleMessageTypeOutgoing:
            return  [[UIImage imageNamed:@"chat_to_bg_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(21.0f, 21.0f, 21.0f, 21.0f)];
            break;
        default:
            break;
    }
}

- (CGRect)resendImageRect
{
    CGRect bubbleFrame = [self bubbleFrame];
    CGFloat x = 0.0f;
    if (self.type == BubbleMessageTypeOutgoing)
    {
        x = bubbleFrame.origin.x - 25.0f;
    }
    else
    {
        x = bubbleFrame.origin.x + bubbleFrame.size.width + 5.0f;
    }
    return CGRectMake(x, (bubbleFrame.size.height - 22.0f) / 2.0f, 22.0f, 22.0f);
}

- (CGRect)bubbleFrame
{
    return CGRectZero;
}

- (void)onLongTapped:(id)sender
{
    if ([_editDelegate respondsToSelector:@selector(bubbleViewCanBeEdited:)]) {
        [_editDelegate bubbleViewCanBeEdited:self];
    }
}

- (id)content
{
    return nil;
}

- (UIView *)contentView
{
    return nil;
}

@end
