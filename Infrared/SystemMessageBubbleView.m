//
//  SystemMessageBubbleView.m
//  WeiMi
//
//  Created by hwb on 14-7-1.
//
//

#import "SystemMessageBubbleView.h"
#import "UIColor+ZYHex.h"

#define __MAX_WIDTH__          200.0f
#define __MAX_HEIGHT__         80.0f

#define __TIPS_LABEL_SIZE__    12

@interface SystemMessageBubbleView ()
{
    CGSize _labelSize;
}

@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) UIView *tipsBgView;
@end

@implementation SystemMessageBubbleView

+ (CGFloat)cellHeightForText:(NSString*)text;
{
    return [SystemMessageBubbleView sizeForText:text].height + 13.0;
}

+ (CGSize) sizeForText:(NSString *)text
{
    CGSize size = CGSizeZero;
    UIFont *font = [UIFont systemFontOfSize:__TIPS_LABEL_SIZE__];

    NSDictionary *attribute = @{NSFontAttributeName: font};
    size = [text boundingRectWithSize:CGSizeMake(__MAX_WIDTH__, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}

- (id)initWithFrame:(CGRect)rect bubbleType:(BubbleMessageType)bubbleType
{
    self = [super initWithFrame:rect bubbleType:bubbleType];
    if (self) {
        
//        self.tipsBgView = [[UIView alloc] init];
//        self.tipsBgView.backgroundColor = [UIColor lightGrayColor];
//        self.tipsBgView.layer.cornerRadius=5;
//        self.tipsBgView.layer.masksToBounds=YES;
//        [self addSubview:self.tipsBgView];
        
        self.tipsLabel = [[UILabel alloc] init];
        self.tipsLabel.textAlignment = NSTextAlignmentCenter;
        self.tipsLabel.font = [UIFont systemFontOfSize:__TIPS_LABEL_SIZE__];
        self.tipsLabel.numberOfLines = 0;
        self.tipsLabel.backgroundColor = [UIColor clearColor];
        self.tipsLabel.textColor = [UIColor colorForHex:@"666666"];
        [self addSubview:self.tipsLabel];
    }
    return self;
}

- (void)setMessage:(UIMessageObject*)message
{
    [super setMessage:message];
    
    self.tipsLabel.text = message.content;
    
    [self setNeedsDisplay];
}

- (CGRect)bubbleFrame
{
    CGSize size = [SystemMessageBubbleView sizeForText:self.message.content];
    CGSize bubbleSize = size;
    return CGRectMake((self.frame.size.width - bubbleSize.width - 20.0f) / 2.0 , 0.0f,
                      bubbleSize.width + 20.0f, /*[SystemMessageBubbleView cellHeightForText:self.message.content]*/[SystemMessageBubbleView sizeForText:self.message.content].height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bubbleFrame = [self bubbleFrame];
    self.tipsBgView.frame = bubbleFrame;
    self.tipsLabel.frame = bubbleFrame;
}
@end
