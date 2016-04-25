//
//  DataPickerViewController.m
//  YSApp
//
//  Created by lvjianxiong on 15/1/11.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//




#import "DataPickerViewController.h"


@interface DataPickerViewController ()<UIPickerViewDelegate>

@end

@implementation DataPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, AppFrameWidth-16, 44)];
    _toolbar.barStyle = UIBarStyleBlack;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        _toolbar.frame =CGRectMake(0, 0, AppFrameWidth-20, 44);
    }
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"完成  "
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(done)];
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:nil
                                                                                 action:nil];
    
    UIBarButtonItem *leftButton  = [[UIBarButtonItem alloc] initWithTitle:@"  取消"
                                                                    style:UIBarButtonItemStyleBordered
                                                                   target:self
                                                                   action:@selector(docancel)];
    
    NSArray *array = [[NSArray alloc] initWithObjects:leftButton,spaceButton,rightButton,nil];
    [_toolbar setItems: array];
    
    
    [self.view addSubview:_toolbar];
    
    /*
    UIPickerView *tDatePicker = [[UIDatePicker alloc] init];
    tDatePicker.frame =CGRectMake(0, 44, AppFrameWidth, 235.0f);
    self.datePicker = tDatePicker;
    self.datePicker.datePickerMode = _pickerMode;
    [self.datePicker addTarget:self action:nil forControlEvents:UIControlEventValueChanged];
    [self.datePicker setMinuteInterval:5];
    NSDate *currentDate = [NSDate date];
    [self.datePicker setMaximumDate:_maxDate==nil?currentDate:_maxDate];
    [self.datePicker setDate:_defaultDate==nil?currentDate:_defaultDate animated:YES];
    if (_minDate) {
        [self.datePicker setMinimumDate:_minDate];
    }
    [self.view addSubview:self.datePicker];
    */
    
    _dataPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_toolbar.frame), AppFrameWidth-16, 235.0f)];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        _dataPicker.frame =CGRectMake(0, CGRectGetMaxY(_toolbar.frame), AppFrameWidth-20,  235.0f);
    }
    _dataPicker.delegate = self;
    _dataPicker.showsSelectionIndicator = YES;
    [self.view addSubview:_dataPicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark- Picker DataSource Methods
//返回显示的列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
//返回当前列显示的行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
   //zy LOG(@"\n\n count=%d \n\n",[_dataArray count]);
    return [_dataArray count];
}

#pragma mark Picker Delegate Methods
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44.0f;
}

//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上 当用户选择某个row时,picker view调用此函数
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = [_dataArray objectAtIndex:row];
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    pickerView.tag = row;
}


#pragma mark- Private

-(void)done{
//    [self.delegate pickViewDidSelectRowData:_dataPicker.tag withTag:_tag];
//    - (NSInteger)selectedRowInComponent:(NSInteger)component

   //zy LOG(@"\n 选中的tag=%d \n",_dataPicker.tag);
    [self.delegate pickViewDidSelectRowData:_dataPicker.tag withDataTag:_tag];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)docancel
{
    //    [self dismissWithClickedButtonIndex:0 animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
