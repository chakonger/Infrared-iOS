//
//  MessageInputView.h
//  WeiMi
//
//  
//
//

#import <UIKit/UIKit.h>
#import "ViewListItem.h"

//137
#define EMOTICON_PANEL_HEIGHT        216.0f


@class MessageInputView;

@protocol MessageInputViewDelegate <NSObject>

@optional




@end

@interface MessageInputView : UIView



- (id)initWithFrame:(CGRect)frame withBigType:(ViewListItemVO*)bigType withIsChat:(BOOL)isChat;



@end
