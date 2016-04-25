//
//  messageKit.h
//  WeiMi
//
//  Created by hwb on 14-7-1.
//
//

#ifndef WeiMi_messageKit_h
#define WeiMi_messageKit_h

typedef NS_OPTIONS(NSUInteger, MessageType) {
    MessageType_Text1        = 0,
    MessageType_Text        = 1,
    MessageType_Photo       = 3,
    MessageType_Emotion     = 2,
    MessageType_Voice       = 4,
    
    MessageType_Tips        = 100001,
};

typedef NS_OPTIONS(NSUInteger, MessageStatus) {
    MessageStatus_Done = 0,
    
    //sending message process
    MessageStatus_Sending,
    MessageStatus_Sent,
    MessageStatus_SentFailed,
    
    //image message, photo thumbnail downloading process
    MessageStatus_DownloadingThumb,
    MessageStatus_DownloadThumbFailed,
    MessageStatus_DownloadThumbSuccessfully,
    
    //image message, photo uploading process
    MessageStatus_UploadingPhoto,
    MessageStatus_UploadPhotoFailed,
    MessageStatus_UploadPhotoSuccessfully,
    
    //P2P message is received by remote
    MessageStatus_Arrived,
};

typedef NS_OPTIONS(NSUInteger, MessageReceiveType) {
    MessageReceiveType_Receive  = 0,
    MessageReceiveType_Send     = 1,
};


#endif
