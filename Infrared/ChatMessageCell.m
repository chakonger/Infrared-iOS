//
//  ChatMessageCell.m
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import "ChatMessageCell.h"
#import "UIMessageObject.h"
#import "TextBubbleView.h"
#import "ImageBubbleView.h"
#import "UIColor+ZYHex.h"
#import "SystemMessageBubbleView.h"

#define TIMESTAMP_LABEL_HEIGHT 13.0f

#define TIMESTAMP_FONT_SIZE    12


#define TIMESTAMP_TOP_BOTTOM_MARGIN             12


@interface ChatMessageCell () <BubbleViewEditDelegate>
{
    CGSize _timestampSize;
}

@property (strong, nonatomic) UILabel* timestampLabel;
//@property (strong, nonatomic) UIView *timesBgView;

@property (assign, nonatomic) BubbleMessageType bubbleMessageType;
@property (assign, nonatomic) BOOL hasTimestamp;

@end

@implementation ChatMessageCell

+ (CGFloat)neededHeightForMessage:(id)message messageCellType:(ChatMessageCellType)type timestamp:(BOOL)hasTimestamp
{
    CGFloat timestampHeight = (hasTimestamp) ? TIMESTAMP_LABEL_HEIGHT + TIMESTAMP_TOP_BOTTOM_MARGIN * 2 : 0.0f;
    UIMessageObject* _message = (UIMessageObject*)message;
    
    switch (type) {
        case ChatMessageCellTypeText:
        {
            if (_message.content)
                return [TextBubbleView cellHeightForText:_message.content andMessage:_message] + timestampHeight;
            break;
        }
        case ChatMessageCellTypePhoto:
        case ChatMessageCellTypeEmotion:
            return [ImageBubbleView cellHeightForMessage:_message] + timestampHeight;
            break;
        case ChatMessageCellTypeSystemMessage:
            return [SystemMessageBubbleView cellHeightForText:_message.content] + timestampHeight;
            break;
        default:
            break;
    }
    return timestampHeight;
}

+ (ChatMessageCellType)messageCellTypeForMessage:(id)message
{
    NSAssert([message isKindOfClass:[UIMessageObject class]], @"Error: message is not support!!");
    ChatMessageCellType cellType = ChatMessageCellTypeText;
    UIMessageObject* _message = (UIMessageObject*)message;
    if (_message && _message.msgType == MessageType_Text)
        cellType = ChatMessageCellTypeText;
    else if (_message && _message.msgType == MessageType_Emotion)
        cellType = ChatMessageCellTypeEmotion;
    else if (_message && _message.msgType == MessageType_Photo)
        cellType = ChatMessageCellTypePhoto;
    else if (_message && (_message.msgType == MessageType_Tips /*|| _message.msgType == MessageType_Voice*/))
        cellType = ChatMessageCellTypeSystemMessage;
    
    
    return cellType;
}

- (void)dealloc
{
    self.message = nil;
    self.timestampLabel = nil;
    //self.timesBgView = nil;
}

- (id)initWithBubbleMessageType:(BubbleMessageType)bubbleMessageType
                   hasTimestamp:(BOOL)hasTimestamp
                 bubbleViewType:(ChatMessageCellType)bubbleViewType
                       delegate:(id<ChatMessageCellDelegate>) delegate
                reuseIdentifier:(NSString*)reuseIdentifier;
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        self.bubbleMessageType = bubbleMessageType;
        self.hasTimestamp = hasTimestamp;
        self.bubbleViewType = bubbleViewType;
        self.delegate = delegate;

        [self setup];
        
        if (self.hasTimestamp){
            [self configureTimestampLabel];
        }
        
        switch (self.bubbleViewType) {
            case ChatMessageCellTypeText:
                self.bubbleView = [[TextBubbleView alloc] initWithFrame:CGRectZero bubbleType:self.bubbleMessageType];
                _bubbleView.editDelegate = self;
                break;
            case ChatMessageCellTypePhoto:
            case ChatMessageCellTypeEmotion:
                self.bubbleView = [[ImageBubbleView alloc] initWithFrame:CGRectZero bubbleType:self.bubbleMessageType];
                _bubbleView.editDelegate = self;
                break;
            case ChatMessageCellTypeSystemMessage:
                self.bubbleView = [[SystemMessageBubbleView alloc] initWithFrame:CGRectZero bubbleType:self.bubbleMessageType];
                break;
            default: // TODO: add more bubble view type
                self.bubbleView = [[BubbleView alloc] initWithFrame:CGRectZero bubbleType:self.bubbleMessageType];
                break;
        }
    
        [self.contentView addSubview:self.bubbleView];
        [self.contentView sendSubviewToBack:self.bubbleView];
        
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor clearColor];
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
}


- (void)configureTimestampLabel
{
    self.timestampLabel = [[UILabel alloc] init];
    self.timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
  //  self.timestampLabel.textColor = [UIColor colorForHex:FONT_COLOR_T4];
    self.timestampLabel.textColor = [UIColor whiteColor];
    self.timestampLabel.font = _FONT(TIMESTAMP_FONT_SIZE);
    [self.contentView addSubview:self.timestampLabel];
}

- (void)setMessage:(id)message
{
    if (message) {
        _message = message;
        self.bubbleView.message = message;
    }
}

- (void)setTimestamp:(NSString*)date
{
    self.timestampLabel.text = date;
    _timestampSize = [self sizeForText:date];
}

- (void)setAvatar:(UIImage *)aImage
{
    self.bubbleView.avatarView.image = aImage;
    [self.bubbleView.avatarView setNeedsLayout];
}

- (CGSize) sizeForText:(NSString *)text
{
    UIFont *font = self.timestampLabel.font;
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(200.0, MAXFLOAT)
                                     options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return size;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.timesBgView.frame = CGRectMake( (self.contentView.frame.size.width - _timestampSize.width - 10) /2.0, 8.0, _timestampSize.width + 20.0, TIMESTAMP_LABEL_HEIGHT);
//    self.timestampLabel.frame = self.timesBgView.bounds;//CGRectMake(0.0f, 3.0f, self.contentView.frame.size.width, TIMESTAMP_LABEL_HEIGHT);
    
    
    switch (self.bubbleViewType) {
        case ChatMessageCellTypeText:
            self.timestampLabel.frame = CGRectMake((self.contentView.frame.size.width - _timestampSize.width - 10) / 2.0,
                                                   TIMESTAMP_TOP_BOTTOM_MARGIN, _timestampSize.width + 20.0, TIMESTAMP_LABEL_HEIGHT);
            self.bubbleView.frame = CGRectMake(0,
                                               self.hasTimestamp ? TIMESTAMP_LABEL_HEIGHT + TIMESTAMP_TOP_BOTTOM_MARGIN * 2 : 0.0f,
                                               self.contentView.frame.size.width,
                                               self.hasTimestamp ? self.contentView.frame.size.height - TIMESTAMP_LABEL_HEIGHT - TIMESTAMP_TOP_BOTTOM_MARGIN * 2 : self.contentView.frame.size.height);
            break;
        case ChatMessageCellTypePhoto:
            self.timestampLabel.frame = CGRectMake((self.contentView.frame.size.width - _timestampSize.width - 10) / 2.0,
                                                   TIMESTAMP_TOP_BOTTOM_MARGIN, _timestampSize.width + 20.0, TIMESTAMP_LABEL_HEIGHT);
            
            self.bubbleView.frame = CGRectMake(0,
                                               self.hasTimestamp ? TIMESTAMP_LABEL_HEIGHT + TIMESTAMP_TOP_BOTTOM_MARGIN * 2 : 0.0f,
                                               self.contentView.frame.size.width,
                                               self.hasTimestamp ? self.contentView.frame.size.height - TIMESTAMP_LABEL_HEIGHT - TIMESTAMP_TOP_BOTTOM_MARGIN * 2 : self.contentView.frame.size.height);
        case ChatMessageCellTypeEmotion:
            self.timestampLabel.frame = CGRectMake((self.contentView.frame.size.width - _timestampSize.width - 10) / 2.0,
                                                   TIMESTAMP_TOP_BOTTOM_MARGIN, _timestampSize.width + 20.0, TIMESTAMP_LABEL_HEIGHT);
            
            self.bubbleView.frame = CGRectMake(0,
                                               self.hasTimestamp ? TIMESTAMP_LABEL_HEIGHT + TIMESTAMP_TOP_BOTTOM_MARGIN * 2 : 0.0f,
                                               self.contentView.frame.size.width,
                                               self.hasTimestamp ? self.contentView.frame.size.height - TIMESTAMP_LABEL_HEIGHT - TIMESTAMP_TOP_BOTTOM_MARGIN * 2 : self.contentView.frame.size.height);
            break;
        case ChatMessageCellTypeSystemMessage:
            self.bubbleView.frame = CGRectMake(0, 0.0f,
                                               self.contentView.frame.size.width,
                                               self.contentView.frame.size.height);
            break;
        default:
            break;
    }
}

- (void)bubbleViewCanBeEdited:(BubbleView *)bubbleView
{
    if ([_delegate respondsToSelector:@selector(cellCanBeEdited:withObject:)]) {
        id object = bubbleView.content;
        [_delegate cellCanBeEdited:self withObject:object];
    }
}

@end
