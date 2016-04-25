//
//  ViewController.m
//  Infrared
//
//  Created by ToTank on 16/2/24.
//  Copyright © 2016年 史志勇. All rights reserved.
//

#import "ViewController.h"
#import "DeviceViewController.h"
#import "ViewListItem.h"
#import "ChatViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *listView;
@property(nonatomic,strong)ViewListItemDB *ListDB;
@property (nonatomic,strong)NSMutableArray *listArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.title = @"设备列表";
    self.navigationController.navigationBar.layer.backgroundColor = [UIColor blueColor].CGColor;
    self.listArray = [NSMutableArray array];
    [self setupAddButton];
    
    _listView = [[UITableView alloc]initWithFrame:self.view.frame];
    _listView.delegate = self;
    _listView.dataSource = self;
    [self.view addSubview:_listView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(ViewListItemDB*)ListDB
{
    if (!_ListDB) {
        _ListDB = [[ViewListItemDB alloc]init];
        [_ListDB initManagedObjectContext];
    }

    return _ListDB;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.listArray = [self.ListDB getAllDeviceAction];
    [self.listView reloadData];
  
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.listArray.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ViewListItemVO *itemVO = self.listArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %@ -- %@",itemVO.devType,  itemVO.brand ,itemVO.typeName];
    return cell;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = @"";
    if(self.listArray.count==0)
        
    {
      string = @"点击右上角, 快去添加吧";
    }
    else
    {
      string = @"电器 -- 品牌 -- 红外类型";
    }
    
    
    return string;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    ChatViewController * chatView = [[ChatViewController alloc]init];
    chatView.listItemVO = self.listArray[indexPath.row];
    [self.navigationController pushViewController:chatView animated:YES];


}


- (void)setupAddButton
{
    UIImage *backNormalImage = [UIImage imageNamed:@"add_normal"];
    UIImage *backSelectedImage = [UIImage imageNamed:@"add_selected"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(-10, 0, backNormalImage.size.width, backNormalImage.size.height);
    [leftButton setImage:backNormalImage forState:UIControlStateNormal];
    [leftButton setImage:backSelectedImage forState:UIControlStateHighlighted];
    [leftButton setImage:backSelectedImage forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(addDevices) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItems = @[leftItem];
}

-(void)addDevices
{
    DeviceViewController *devView = [[DeviceViewController alloc]init];
    [self.navigationController pushViewController:devView animated:YES];


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
