//
//  ChatMessageCell.h
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import "BaseTableViewCell.h"
#import "BubbleView.h"

typedef enum {
    
    ChatMessageCellTypeText = 0,
    ChatMessageCellTypePhoto,
    ChatMessageCellTypeEmotion,
    ChatMessageCellTypeSystemMessage
    
} ChatMessageCellType;


@protocol ChatMessageCellDelegate;

@interface ChatMessageCell : BaseTableViewCell

@property (strong, nonatomic) BubbleView* bubbleView;
@property (nonatomic, strong) id message;
@property (nonatomic, weak) id <ChatMessageCellDelegate> delegate;
@property (assign, nonatomic) ChatMessageCellType bubbleViewType;

+ (CGFloat)neededHeightForMessage:(id)message messageCellType:(ChatMessageCellType)type timestamp:(BOOL)hasTimestamp;
+ (ChatMessageCellType)messageCellTypeForMessage:(id)message;

- (id)initWithBubbleMessageType:(BubbleMessageType)bubbleMessageType
                   hasTimestamp:(BOOL)hasTimestamp
                 bubbleViewType:(ChatMessageCellType)bubbleViewType
                       delegate:(id<ChatMessageCellDelegate>) delegate
                reuseIdentifier:(NSString*)reuseIdentifier;

- (void)setTimestamp:(NSString*)date;
- (void)setAvatar:(UIImage *)aImage;

@end

@protocol ChatMessageCellDelegate <NSObject>

@optional
- (void)cellCanBeEdited:(ChatMessageCell *)cell withObject:(id)object;

@end
