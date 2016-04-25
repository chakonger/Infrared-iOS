//
//  ImageBubbleView.m
//  WeiMi
//
//  Created by hwb on 14-6-30.
//
//

#import "ImageBubbleView.h"
#import "UIColor+ZYHex.h"

#define __CHARTLET_HEIGHT__  40.0f
#define __IMAGE_WIDTH__      90.0f
#define __IMAGE_HEIGHT__     120.0f
//原版
#define __IMAGE_WIDTH_FOR_WIDTHPIC      120.0f
#define __IMAGE_HEIGHT_FOR_WIDTHPIC     90.0f



//#define IMAGE_BUBBLE_BOTTOM_MARGIN     15
#define IMAGE_BUBBLE_BOTTOM_MARGIN      0
#define IMAGE_BUBBLE_BOTTOM_MARGIN_PHOTO    19


@interface ImageBubbleView ()

@property (nonatomic, strong) UIImageView* bubbleImageView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UIActivityIndicatorView* aiv;
@property (nonatomic, strong) UIImageView* resendImageView;

//@property (nonatomic, strong) UILabel* progressLabel;
//@property (nonatomic, strong) UIProgressView* progressView;

@end

@implementation ImageBubbleView

+ (CGFloat)cellHeightForMessage:(UIMessageObject*)message
{
    if (message.msgType == MessageType_Photo)
    {
#if 0
        CGFloat height = 50.0f;
        UIImage* contentImage = [UIImage imageWithContentsOfFile:message.thumbImgPath];
        if (contentImage)
        {
            if (contentImage.size.height >= contentImage.size.width)
            {
                CGFloat _height = contentImage.size.height > __IMAGE_HEIGHT__ ? __IMAGE_HEIGHT__ : contentImage.size.height;
                height = _height + 10.0f;
            }
            else
            {
                CGFloat _height = contentImage.size.width > __IMAGE_WIDTH__ ? __IMAGE_HEIGHT__  * contentImage.size.height / contentImage.size.width  : contentImage.size.height;
                height = _height + 10.0f;
            }
        }
        return height + 10.0f;
#else
        UIImage* contentImage = [UIImage imageWithContentsOfFile:message.thumbImgPath];
        if (contentImage && contentImage.size.width > contentImage.size.height) {
            return __IMAGE_HEIGHT_FOR_WIDTHPIC + IMAGE_BUBBLE_BOTTOM_MARGIN_PHOTO;
        }
        return __IMAGE_HEIGHT__ + IMAGE_BUBBLE_BOTTOM_MARGIN_PHOTO;
#endif
    }
    else if (message.msgType == MessageType_Emotion)
    {
        return __CHARTLET_HEIGHT__ + IMAGE_BUBBLE_BOTTOM_MARGIN;
    }
    return __CHARTLET_HEIGHT__ + IMAGE_BUBBLE_BOTTOM_MARGIN;
}

+ (UIImage*)getChartletImageByKey:(NSString*)key
{
    if (!key) return nil;
    //key emotion image name
    return [UIImage imageNamed:key];
}

- (CGRect)bubbleFrame
{
    if (self.message.msgType == MessageType_Photo)
    {
        UIImage* contentImage = [UIImage imageWithContentsOfFile:self.message.thumbImgPath];
        if (contentImage && contentImage.size.width > contentImage.size.height) {
            return CGRectMake((self.type == BubbleMessageTypeOutgoing ? self.frame.size.width - __IMAGE_WIDTH_FOR_WIDTHPIC - 56.0f : 56.0f), 0.0f, __IMAGE_WIDTH_FOR_WIDTHPIC , __IMAGE_HEIGHT_FOR_WIDTHPIC);
        }
        return CGRectMake((self.type == BubbleMessageTypeOutgoing ? self.frame.size.width - __IMAGE_WIDTH__ - 56.0f : 56.0f), 0.0f, __IMAGE_WIDTH__ , __IMAGE_HEIGHT__);
    }
    else if (self.message.msgType == MessageType_Emotion)
    {
        return CGRectMake((self.type == BubbleMessageTypeOutgoing ? self.frame.size.width - __CHARTLET_HEIGHT__ - 56.0 : 56.0f), 0, __CHARTLET_HEIGHT__, __CHARTLET_HEIGHT__);
    }
    return CGRectZero;
}

- (void)imageViewSingleTap:(UITapGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateEnded || self.message.msgType != MessageType_Photo)
        return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bubbleView:showBigImage:)])
        [self.delegate bubbleView:self showBigImage:self.message];
}

- (id)initWithFrame:(CGRect)rect bubbleType:(BubbleMessageType)bubbleType 
{
    self = [super initWithFrame:rect bubbleType:bubbleType];
    if (self)
    {
        self.bubbleImageView = [[UIImageView alloc] init];
        [self addSubview:self.bubbleImageView];
        
        self.imageView = [[UIImageView alloc] init];
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewSingleTap:)];
        singleRecognizer.numberOfTapsRequired = 1;
        //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageView addGestureRecognizer:singleRecognizer];
        [self addSubview:self.imageView];
        [self sendSubviewToBack:self.imageView];
        
        self.aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.aiv.hidesWhenStopped = YES;
        [self addSubview:self.aiv];
        
        self.resendImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_sendfail.png"]];
        [self.resendImageView setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickRetry)];
        [self.resendImageView addGestureRecognizer:singleTap];

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

- (void)setMessage:(UIMessageObject*)message
{
    [super setMessage:message];
//    [self.progressLabel removeFromSuperview];
//    [self.progressView removeFromSuperview];
 
    [self setNeedsLayout];
}

- (void)setType:(BubbleMessageType)newType
{
    [super setType:newType];
    [self setNeedsLayout];
}

- (UIImage*)generatePicMask:(UIView*)view
{
    CGSize size;
    size.width = view.bounds.size.width;
    size.height = view.bounds.size.height;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage*)generatePic:(UIImage*)img AndMask:(UIImage*)img_mask WeatherBlackMask:(BOOL)b_black_mask
{
    CGSize size;
    size.width = img_mask.size.width * img_mask.scale;
    size.height = img_mask.size.height * img_mask.scale;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextClipToMask(context, rect, img_mask.CGImage);
    CGContextDrawImage(context, rect, img.CGImage);
    
    if (b_black_mask) {
        CGContextSetRGBFillColor(context, 0, 0, 0, 0.4);
        CGContextFillRect(context, rect);
    }

    
    CGImageRef image = CGBitmapContextCreateImage(context);
    UIImage* img_to_save = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    UIGraphicsEndImageContext();
    
    return img_to_save;
}

- (void)layoutSubviews
{
    self.bubbleImageView.image = (self.bubbleHighlighted) ? [self bubbleImageHighlighted] : [self bubbleImage];
    CGRect bubbleFrame = [self bubbleFrame];
    self.bubbleImageView.frame = bubbleFrame;
    self.aiv.center = self.bubbleImageView.center;
    if (self.message.sendOrRecv == MessageReceiveType_Receive) {
        CGRect rt = self.aiv.frame;
        rt.origin.x += 2;
        self.aiv.frame = rt;
    }
    else{
        CGRect rt = self.aiv.frame;
        rt.origin.x -= 2;
        self.aiv.frame = rt;
    }
    
    
    if (self.message.msgType == MessageType_Photo)
    {
        if (self.message.msgStatus == MessageStatus_DownloadingThumb)
        {
            [self.aiv startAnimating];
            self.imageView.image = nil;
        }
        else if(self.message.msgStatus == MessageStatus_DownloadThumbSuccessfully)
        {
            [self.aiv stopAnimating];
            UIImage* contentImage = [UIImage imageWithContentsOfFile:self.message.thumbImgPath];
            if (contentImage)
            {
                self.imageView.image = contentImage;
            }
            else
            {
                self.imageView.image = nil;
              //  NSLog(@"%s Error Thumb File!!!", __FUNCTION__);
            }
        }
        else if (self.message.msgStatus == MessageStatus_DownloadThumbFailed)
        {
            [self.aiv stopAnimating];
            self.imageView.image = [UIImage imageNamed:@"gengdu.png"];
        }
        else if (self.message.msgStatus == MessageStatus_UploadingPhoto || self.message.msgStatus == MessageStatus_Sending)
        {
            [self.aiv startAnimating];
            UIImage* contentImage = [UIImage imageWithContentsOfFile:self.message.thumbImgPath];
            if (contentImage)
            {
                //self.imageView.image = contentImage;
                self.bubbleImageView.hidden = NO;
                UIImage* img_mask = [self generatePicMask:self.bubbleImageView];
                self.imageView.image = [self generatePic:contentImage AndMask:img_mask WeatherBlackMask:YES];
            }
            else
            {
                self.imageView.image = nil;
               // NSLog(@"%s Error Thumb File!!!", __FUNCTION__);
            }
            
            if (self.message.msgStatus == MessageStatus_UploadingPhoto)
            {
                //                self.progressLabel.text = [NSString stringWithFormat:@"%d%%", 0];
                //                [self addSubview:self.progressView];
                //                [self addSubview:self.progressLabel];
            }
        }
        else if (self.message.msgStatus == MessageStatus_UploadPhotoSuccessfully || self.message.msgStatus == MessageStatus_Sent || self.message.msgStatus == MessageStatus_Arrived)
        {
            [self.aiv stopAnimating];
            UIImage* contentImage = [UIImage imageWithContentsOfFile:self.message.thumbImgPath];
            if (contentImage)
            {
                //self.imageView.image = contentImage;
                self.bubbleImageView.hidden = NO;
                UIImage* img_mask = [self generatePicMask:self.bubbleImageView];
                self.imageView.image = [self generatePic:contentImage AndMask:img_mask WeatherBlackMask:NO];
            }
            else
            {
                self.imageView.image = nil;
              //  NSLog(@"%s Error Thumb File!!!", __FUNCTION__);
            }
        }
        else if (self.message.msgStatus == MessageStatus_UploadPhotoFailed || self.message.msgStatus == MessageStatus_SentFailed)
        {
            [self.aiv stopAnimating];
            UIImage* contentImage = [UIImage imageWithContentsOfFile:self.message.thumbImgPath];
            if (contentImage)
            {
                //self.imageView.image = contentImage;
                self.bubbleImageView.hidden = NO;
                UIImage* img_mask = [self generatePicMask:self.bubbleImageView];
                self.imageView.image = [self generatePic:contentImage AndMask:img_mask WeatherBlackMask:NO];
            }
            else
            {
                self.imageView.image = nil;
              //  NSLog(@"%s Error Thumb File!!!", __FUNCTION__);
            }
        }
        else
        {
            [self.aiv stopAnimating];
            self.imageView.image = nil;
          //  NSLog(@"%s Error Unknown state[%d]!!!", __FUNCTION__, self.message.msgStatus);
        }
    }
    else if (self.message.msgType == MessageType_Emotion)
    {
        [self.bubbleImageView removeFromSuperview];
        UIImage* image = [ImageBubbleView getChartletImageByKey:self.message.content];
        self.imageView.image = image;
    }
    
    if (self.message.msgStatus == MessageStatus_UploadPhotoFailed || self.message.msgStatus == MessageStatus_SentFailed)
    {
        [self addSubview:self.resendImageView];
    }
    else
        [self.resendImageView removeFromSuperview];
    
    self.bubbleImageView.hidden = YES;
    
    CGRect imageFrame = CGRectMake(bubbleFrame.origin.x, (self.frame.size.height - bubbleFrame.size.height)/2, bubbleFrame.size.width, bubbleFrame.size.height);
    self.imageView.frame = imageFrame;

    self.avatarView.frame = CGRectMake(self.type == BubbleMessageTypeOutgoing ? self.frame.size.width - 50.f : 10.f,
                                       imageFrame.origin.y + (imageFrame.size.height - 40.f)/2, 40.f, 40.f);
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 20.f;
    self.avatarView.layer.borderWidth = .5f;
    self.avatarView.layer.borderColor = [UIColor colorForHex:@"d9d9d9"].CGColor;

    self.resendImageView.frame = [self resendImageRect];

    [super layoutSubviews];
}

- (id)content
{
    return self.imageView.image;
}

- (UIView *)contentView
{
    return self.imageView;
}

@end
