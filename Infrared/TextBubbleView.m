//
//  TextBubbleView.m
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import "TextBubbleView.h"
#import "UIColor+ZYHex.h"

#define BUBBLE_TEXT_VIEW_FONT_SIZE 16.f
#define DEFAULT_TEXT_HEIGHT        30.0
#define MAX_BUBBLE_WIDTH            233.f
#define TEXT_LABEL_WIDTH           (MAX_BUBBLE_WIDTH-31.f)

#define TEXT_BUBBLE_MARGIN_BOTTOM  19

@interface TextBubbleView ()

@property (nonatomic, strong) UIImageView* resendImageView;
@property (nonatomic, strong) UIImage* resendImage;
@property (nonatomic, strong) UIImageView* bubbleImageView;
//@property (nonatomic, strong) UIActivityIndicatorView* loading;

@property (nonatomic, strong) UILabel* textView;

@property (nonatomic, strong) NSArray* urlArray;

@end


@implementation TextBubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect bubbleType:(BubbleMessageType)bubbleType
{
    self = [super initWithFrame:rect bubbleType:bubbleType];
    if(self) {
        self.userInteractionEnabled = YES;
        
        self.urlArray = [NSArray array];
        
        self.bubbleImageView = [[UIImageView alloc] init];
        [self addSubview:self.bubbleImageView];

        self.textView = [[UILabel alloc] init];
        self.textView.font = [TextBubbleView font];
        if (bubbleType == BubbleMessageTypeIncoming) {
            self.textView.textColor = [UIColor colorForHex:FONT_COLOR_T1];
        }
        else{
            self.textView.textColor = [UIColor whiteColor];
        }
        
        self.textView.numberOfLines = 0;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.userInteractionEnabled = YES;
        self.textView.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:self.textView];
        
        UITapGestureRecognizer *t1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstLabelClicked)];
        t1.numberOfTapsRequired = 1;
        t1.numberOfTouchesRequired = 1;
        
        UITapGestureRecognizer *t2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondLabelClicked)];
        t2.numberOfTapsRequired = 1;
        t2.numberOfTouchesRequired = 1;
        
        self.resendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_sendfail.png"]];
        self.resendImageView.hidden = YES;
        [self.resendImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickRetry)];
        [self.resendImageView addGestureRecognizer:singleTap];
        [self addSubview:self.resendImageView];
        
        /*
        self.loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self.loading setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        self.loading.hidden = YES;
        [self addSubview:self.loading];
         */
        self.avatarView = [UIImageView new];
        [self addSubview:self.avatarView];
    }
    return self;
}

- (void)onClickRetry
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(retry:)]) {
        [self.delegate retry:self];
    }
}

- (void)setMessage:(id)message
{
    [super setMessage:message];

    NSString *msg = self.message.content;
    [self separateMsgAction:msg];

    if (self.message.msgStatus == MessageStatus_UploadPhotoFailed || self.message.msgStatus == MessageStatus_SentFailed)
    {
        [self addSubview:self.resendImageView];
        self.resendImageView.hidden = NO;
    }
    else{
        //[self.resendImageView removeFromSuperview];
        self.resendImageView.hidden = YES;
    }
    /*
    if (self.message.msgStatus == MessageStatus_Sending) {
        self.loading.hidden = NO;
        [self.loading startAnimating];
    }
    else
    {
        self.loading.hidden = YES;
        [self.loading stopAnimating];
    }
    */
    [self setNeedsLayout];
}

- (void)separateMsgAction:(NSString *)msg{
    
    if ([msg rangeOfString:@"<url>"].length>0) {
        NSArray *components = [msg componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        NSMutableArray *numArray = [NSMutableArray array];
        [numArray addObject:[NSNumber numberWithInt:0]];
        for (int i=0;i<[components count];i++) {
            NSString *s = components[i];
            if ([s hasPrefix:@"【"]) {
                [numArray addObject:[NSNumber numberWithInt:i]];
            }
        }
        [numArray addObject:[NSNumber numberWithInt:components.count-1]];
        
        self.textView.text = [components objectAtIndex:[[numArray objectAtIndex:0] intValue]];
        
        NSError *error;
        NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        NSArray *arrayOfAllMatches = [regex matchesInString:msg options:0 range:NSMakeRange(0, [msg length])];
        
        NSMutableArray *tmpUrlArray = [NSMutableArray arrayWithCapacity:2];
        for (NSTextCheckingResult *match in arrayOfAllMatches)
        {
            NSString* substringForMatch = [msg substringWithRange:match.range];
            [tmpUrlArray addObject:substringForMatch];
        }
        self.urlArray = tmpUrlArray;
    }else{
        self.textView.text = msg;
    }
    
}



- (void)setType:(BubbleMessageType)newType
{
    [super setType:newType];
    [self setNeedsLayout];
}


- (CGRect)bubbleFrame
{
    CGSize size = [TextBubbleView bubbleSizeForText:self.message && self.message.content ? self.message.content : @""];
    int n_len = MIN(MAX(size.width + 31.0f, 40.f), MAX_BUBBLE_WIDTH);
    
    self.textView.frame = CGRectMake(self.type == BubbleMessageTypeOutgoing ? self.frame.size.width - n_len - 39.0f : 70, 11.f, size.width, size.height);
    CGRect frame = CGRectMake((self.type == BubbleMessageTypeOutgoing ? self.frame.size.width - n_len - 50.0f : 50.0f),
                      0,
                      n_len,
                      MAX(size.height + 22.f, DEFAULT_TEXT_HEIGHT + 12.0f));
    return frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bubbleImageView.image = (self.bubbleHighlighted) ? [self bubbleImageHighlighted] : [self bubbleImage];
    CGRect bubbleFrame = [self bubbleFrame];
    self.bubbleImageView.frame = bubbleFrame;

    self.avatarView.frame = CGRectMake(self.type == BubbleMessageTypeOutgoing ? self.frame.size.width - 50.f : 10.f, 0, 40.f, 40.f);
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 20.f;
    self.avatarView.layer.borderWidth = .5f;
    self.avatarView.layer.borderColor = [UIColor colorForHex:@"d9d9d9"].CGColor;
    
    if (!self.resendImageView.isHidden) {
        self.resendImageView.frame = [self rectForAccessoryView:self.resendImageView];
    }
    /*
    if (!self.loading.isHidden) {
        self.loading.frame = [self rectForAccessoryView:(self.loading)];
    }
     */
}

- (CGRect)rectForAccessoryView:(UIView *)view
{
    CGRect bubbleFrame = [self bubbleFrame];
    CGFloat x = 0.0f;
    if (self.type == BubbleMessageTypeOutgoing)
    {
        x = CGRectGetMinX(bubbleFrame) - 8.0f - CGRectGetWidth(view.frame);
    }
    else
    {
        x = CGRectGetMaxX(bubbleFrame) + 8.0f;
    }
    return CGRectMake(x, (CGRectGetHeight(bubbleFrame) - 22.0f) / 2.0f, 22.0f, 22.0f);
}

- (id)content
{
    return self.textView.text;
}

- (UIView *)contentView
{
    return self.textView;
}
/////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)cellHeightForText:(NSString *)txt andMessage:(UIMessageObject*)message
{
    if ([txt rangeOfString:@"<url>"].length>0) {
        NSArray *components = [txt componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        NSMutableArray *numArray = [NSMutableArray array];
        [numArray addObject:[NSNumber numberWithInt:0]];
        for (int i=0;i<[components count];i++) {
            NSString *s = components[i];
            if ([s hasPrefix:@"【"]) {
                [numArray addObject:[NSNumber numberWithInt:i]];
            }
        }
        [numArray addObject:[NSNumber numberWithInteger:components.count-1]];
        
        NSString *textView = [components objectAtIndex:[[numArray objectAtIndex:0] intValue]];
        NSString *first = [components objectAtIndex:[[numArray objectAtIndex:1] intValue]];
        NSString *second = [components objectAtIndex:[[numArray objectAtIndex:2] intValue]];
        NSString *tip = [components objectAtIndex:[[numArray objectAtIndex:3] intValue]];
        
        CGSize textViewSize = [TextBubbleView bubbleSizeForText: textView ? textView : @""];
        CGSize firstSize = [TextBubbleView bubbleSizeForText: first ? first : @""];
        CGSize secondSize = [TextBubbleView bubbleSizeForText: second ? second : @""];
        CGSize tipSize = [TextBubbleView bubbleSizeForText: tip ? tip : @""];

        int n_height = textViewSize.height;
        n_height += firstSize.height;
        n_height += secondSize.height;
        n_height += tipSize.height;
        n_height += (32+TEXT_BUBBLE_MARGIN_BOTTOM);
        return n_height;
    }else{
        CGSize size = [TextBubbleView bubbleSizeForText:txt];
        
        int n_height = MAX(size.height + 22, DEFAULT_TEXT_HEIGHT + 12.0f);
        
        return n_height + TEXT_BUBBLE_MARGIN_BOTTOM;
    }
}

+ (CGSize) bubbleSizeForText:(NSString *)text
{
    CGSize _contentLabelSize;
    UIFont *font = [TextBubbleView font];
        NSDictionary *attribute = @{NSFontAttributeName: font};
        _contentLabelSize = [text boundingRectWithSize:CGSizeMake(TEXT_LABEL_WIDTH, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return _contentLabelSize;
}

+ (UIFont*)font
{
    return [UIFont systemFontOfSize:BUBBLE_TEXT_VIEW_FONT_SIZE];
//    return [UIFont fontWithName:[[UIResources sharedInstance] messageBubbleFontName] size:BUBBLE_TEXT_VIEW_FONT_SIZE];
}
@end
