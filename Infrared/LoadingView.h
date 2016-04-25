//
//  LoadingView.h
//  ouser
//
//  Created by Liu Pingchuan on 13-3-29.
//  Copyright (c) 2013年 Totti.Lv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView{
    UILabel * _activityLabel;
    UIActivityIndicatorView * _activityIndicator;
    UIView * _activityView;
}

/**在页面中显示**/
- (void)showInView:(UIView *) view withMessage:(NSString *)msg;

/**从view上面移走**/
- (void)removeSelfFromSuperView:(id)sender;

@end
