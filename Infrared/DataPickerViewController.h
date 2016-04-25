//
//  DataPickerViewController.h
//  YSApp
//
//  Created by lvjianxiong on 15/1/11.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DataPickerViewControllerDelegate;
@interface DataPickerViewController : UIAlertController{
    UIPickerView    *_dataPicker;
    UIToolbar       *_toolbar;
}

@property (nonatomic, retain) UIPickerView      *dataPicker;
@property (nonatomic, retain) UIToolbar         *toolbar;
@property (nonatomic, retain) NSArray           *dataArray;
@property (nonatomic, assign) NSInteger         tag;
@property (nonatomic, assign) id<DataPickerViewControllerDelegate>  delegate;


@end

@protocol DataPickerViewControllerDelegate <NSObject>

@optional
- (void)pickViewDidSelectRowData:(NSInteger)selectedIndex withDataTag:(NSInteger)tag;

@end