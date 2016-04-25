//
//  LoadingView.m
//  ouser
//
//  Created by Liu Pingchuan on 13-3-29.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import "LoadingView.h"
#import "CommonUtils.h"

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView * activityView = [[UIView alloc] initWithFrame:CGRectMake(110.0f, 150.0f, 100.0f, 100.0f)];
        [[activityView layer] setCornerRadius:5.0f];
        _activityView = activityView;
        _activityView.backgroundColor = [UIColor blackColor];
        _activityView.alpha = 0.6;
        [self addSubview:_activityView];
        
        
        UILabel * activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100,22)];
        activityLabel.backgroundColor = [UIColor clearColor];
        activityLabel.text = @"";
        activityLabel.font = [UIFont systemFontOfSize:13];
        activityLabel.textAlignment = NSTextAlignmentCenter;
        activityLabel.textColor = [UIColor whiteColor];
        _activityLabel = activityLabel;
        [_activityView addSubview:_activityLabel];
        
        UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = CGRectMake(40, 40, 20, 20);//15, 30,
        _activityIndicator = activityIndicator;
        [_activityView addSubview:activityIndicator];
        
        _activityIndicator.center = CGPointMake(50,50);
        
        
    }
    return self;
}

/**在页面中显示**/
- (void)showInView:(UIView *) view withMessage:(NSString *)msg
{
    float width = view.frame.size.width;
    float height = view.frame.size.height;
    float y = 0;
    if (![view isKindOfClass:UIWindow.class]) {
        y = 32;
    }
    self.frame = CGRectMake(0.0f, 0.0f, width, height);
    
    CGSize nameSize = [self fontSize:msg withFont:[UIFont systemFontOfSize:13] withSize:CGSizeMake(200, 22)];
    if (nameSize.width < 100.0f) {
        nameSize.width = 100.0f;
    }
    
    //110,190,100
    _activityView.frame = CGRectMake((width-nameSize.width)/2.0f, (height-100.0f)/2.0f-y, nameSize.width, 100.0f);
    _activityIndicator.frame = CGRectMake((nameSize.width-20.0f)/2.0f, 40.0f, 20.0f, 20.0f);
    
    _activityLabel.frame = CGRectMake(5.0f, 60.0f, nameSize.width, 22.0f);
    if (msg) {
        _activityLabel.text = msg;
    }
    //self.activityView.center = view.center;
    if (![self superview]) {
        [view addSubview:self];
    }
    [_activityIndicator startAnimating];
}

-(CGSize )fontSize:(NSString *)str withFont:(UIFont *)font withSize:(CGSize)size{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize s = CGSizeZero;
    if ([[NSNull null] isEqual:str]) {
        return s;
    }
    CGRect r = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    s = r.size;
    
    return s;
}

/**从view上面移走**/
- (void)removeSelfFromSuperView:(id)sender
{
    if ([self superview]) {
        [self performSelectorOnMainThread:@selector(removeFromSuperview) withObject:Nil waitUntilDone:TRUE];
    }
    [_activityIndicator stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
