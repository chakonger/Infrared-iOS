//
//  DeviceViewController.m
//  Infrared
//
//  Created by ToTank on 16/2/24.
//  Copyright © 2016年 史志勇. All rights reserved.
//


#import "DeviceViewController.h"
#import "ZYHttpTool.h"
#import "DeviceItem.h"
#import "LoadingView.h"
#import "ViewListItem.h"
@interface DeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
{
   LoadingView                     *_loadingView;
}
@property(nonatomic,strong)DeviceItemDB *ItemDB;
@property(nonatomic,strong)ViewListItemDB *ListDB;
@property(nonatomic,strong)NSMutableArray *listArray;
@property(nonatomic,strong)UITableView *listView;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"红外类型列表";
    self.listArray = [NSMutableArray array];
    
    self.listView = [[UITableView alloc]initWithFrame:self.view.frame];
    self.listView.delegate = self;
    self.listView.dataSource = self;
    [self.view addSubview:self.listView];
    [self setupRefreshButton];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.listArray = [self.ItemDB getAllDeviceAction];
    if (self.listArray.count == 0) {
        [self hostGetHttpDevid];
    }else
    {
      // 直接刷新列表
        [self.listView reloadData];
    
    }


}


-(DeviceItemDB *)ItemDB

{
    if (!_ItemDB) {
        _ItemDB = [[DeviceItemDB alloc]init];
        [_ItemDB initManagedObjectContext];
    }

    return _ItemDB;
}
-(ViewListItemDB *)ListDB
{

    if (!_ListDB) {
        _ListDB = [[ViewListItemDB alloc ]init];
        [_ListDB initManagedObjectContext];
    }
    return _ListDB;
}

-(void)hostGetHttpDevid
{
    [self showLoadView:@""];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:Token forKey:@"TOKEN"];
    [params setValue:@"IBA0" forKey:@"CMD"];
    [ZYHttpTool postWithURL:DevidUrl params:params success:^(id json) {
        
        NSMutableArray *devArry = [NSMutableArray array];
        for (NSDictionary *dict in [json objectForKey:@"IRDASET"]) {
            DeviceItemVO *itemVo = [[DeviceItemVO alloc]init];
            itemVo.bigType = [dict objectForKey:@"bigType"];
            itemVo.model = [dict objectForKey:@"model"];
            itemVo.XHBG = [dict objectForKey:@"XHBG"];
            itemVo.brand = [dict objectForKey:@"brand"];
            itemVo.idID = [dict objectForKey:@"id"];
            itemVo.fixTypeID = [dict objectForKey:@"fixTypeID"];
            itemVo.devTypeID = [dict objectForKey:@"devTypeID"];
            itemVo.visible = [dict objectForKey:@"visible"];
            itemVo.trans2eLevel = [dict objectForKey:@"trans2eLevel"];
            itemVo.panelType = [dict objectForKey:@"panelType"];
            itemVo.sorting = [NSString stringWithFormat:@"%@",[dict objectForKey:@"sorting"]];
            itemVo.status = [ NSString stringWithFormat:@"%@", [dict objectForKey:@"status"] ];
            itemVo.devType = [dict objectForKey:@"devType"];
            itemVo.typeName = [dict objectForKey:@"typeName"];
            [devArry addObject:itemVo];
            
        }
        [self.ItemDB saveDeviceAction:devArry];
        self.listArray = [self.ItemDB getAllDeviceAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self closeLoadView];
            [self.listView reloadData];

        });
        
        
    } failure:^(NSError *error) {
      
    }];



}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  
    return self.listArray.count;


}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static  NSString *identifier = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (self.listArray.count>0) {
        
    
    DeviceItemVO *itemVO = self.listArray[indexPath.row];
        
    cell.textLabel.text = [NSString stringWithFormat:@"%@ -- %@ -- %@",itemVO.devType,  itemVO.brand ,itemVO.typeName];
        
    }
    
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *string = @"";
    if(self.listArray.count==0)
        
    {
        string = @"点击右上角, 快去刷新吧";
    }
    else
    {
        string = @"电器 -- 品牌 -- 红外类型";
    }
    
    
    return string;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DeviceItemVO *itemVO = self.listArray[indexPath.row];
    ViewListItemVO *vo = [[ViewListItemVO alloc]init];
    vo.bigType = itemVO.bigType;
    vo.brand = itemVO.brand;
    vo.devType = itemVO.devType;
    vo.typeName = itemVO.typeName;
    vo.idID = itemVO.idID;
    
    if([self.ListDB getDeviceAction:vo.idID])
    {
       //所选的已经在列表了了
        
    }
    else{
    
    [self.ListDB saveDeviceAction:vo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadView:(NSString *)text{
    if (nil==text) {
        text = @"";
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (Nil==_loadingView ) {
            _loadingView = [[LoadingView alloc] init];
        }
        [_loadingView showInView:self.view withMessage:text];
    });
}


- (void)closeLoadView{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (nil!=_loadingView) {
            [_loadingView removeFromSuperview];
        }
    });
}

- (void)setupRefreshButton
{
    UIImage *backNormalImage = [UIImage imageNamed:@"Copy"];
    UIImage *backSelectedImage = [UIImage imageNamed:@"Copy"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(-10, 0, backNormalImage.size.width, backNormalImage.size.height);
    [leftButton setImage:backNormalImage forState:UIControlStateNormal];
    [leftButton setImage:backSelectedImage forState:UIControlStateHighlighted];
    [leftButton setImage:backSelectedImage forState:UIControlStateSelected];
    [leftButton addTarget:self action:@selector(RefreshDived) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.rightBarButtonItems = @[leftItem];
}

-(void)RefreshDived
{
    [self.listArray removeAllObjects];
    [self.listView reloadData];
    [self.ItemDB removeAllDeviceAction];
    
    
    [self hostGetHttpDevid];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
