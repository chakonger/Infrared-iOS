//
//  ImageDataPickerViewController.h
//  Control
//
//  Created by kucababy on 15/2/27.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageDataPickerViewControllerDelegate;

@interface ImageDataPickerViewController : UIAlertController{
    UIPickerView    *_dataPicker;
    UIToolbar       *_toolbar;
}

@property (nonatomic, retain) UIPickerView      *dataPicker;
@property (nonatomic, retain) UIToolbar         *toolbar;
@property (nonatomic, retain) NSArray           *dataArray;
@property (nonatomic, assign) NSInteger         tag;
@property (nonatomic, assign) id<ImageDataPickerViewControllerDelegate>  delegate;


@end

@protocol ImageDataPickerViewControllerDelegate <NSObject>

@optional
- (void)pickViewDidSelectRowData:(NSInteger)index withTag:(NSInteger)tag;

@end

