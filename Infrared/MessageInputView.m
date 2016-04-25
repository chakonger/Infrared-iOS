    //
    //  MessageInputView.m
    //  WeiMi
    //
    //
    #define UnifiedOutletUrl   @"http://118.192.76.159:80/web/infratypeability"
    //

    #import "MessageInputView.h"



    #import "AirView.h"
    #import "UniversalView.h"


    #import "CommonUtils.h"
    #import "UIColor+ZYHex.h"
    #import "ZYHttpTool.h"


    #define AirIconWidth 92

@interface MessageInputView () {
    AirView         *_airView;
    UniversalView  *_universalView;
    BOOL            _isChat;//如果

    CGFloat Hight;
    CGFloat selfHight;
}



@property (nonatomic, strong) UIView *lineV;




@property (nonatomic, strong)ViewListItemVO *ItemVO;
@property (nonatomic,strong)NSString *DevID;
@property (nonatomic,strong)NSString *itemvobigType;





@end

@implementation MessageInputView

    - (id)initWithFrame:(CGRect)frame withBigType:(ViewListItemVO *)bigType withIsChat:(BOOL)isChat
    {
   
      self = [super initWithFrame:frame];
       
    if(self) {
        _isChat = isChat;
       
      
        [self setup:bigType];
       
        self.backgroundColor = [UIColor whiteColor];
       
        
        UIView *l = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 0.5f)];
        l.backgroundColor = [UIColor colorForHex:@"bebfc2"];
        [self addSubview:l];

    }
    return self;
    }

- (void)layoutSubviews
{
    
    
    
}

- (void)dealloc
    {

}

- (void)setup:(ViewListItemVO *)bigType
    {
    //self.image = [UIImage inputBar];
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
        
    
        
    if (!_isChat) {
        if ([bigType.bigType isEqualToString:@"KGHW"]) {
            _airView = [[AirView alloc] initWithFrame:CGRectMake(AirIconWidth, 0, AppFrameWidth, kDeviceControlHeight)];
            
            if(bigType.lastInst.length !=0)
            {
            [_airView btnLastStateAction:bigType.lastInst];
            }
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AirIconWidth, kDeviceControlHeight)];
            imageView.image = [UIImage imageNamed:@"air_normal"];
            imageView.contentMode = UIViewContentModeCenter;
            [self addSubview:imageView];
            [self addSubview:_airView];

    
        }else {
            //自己做缓存
            NSString *CacheKey = [NSString stringWithFormat:@"%@",bigType.idID];
            NSString * value = [self getCache:CacheKey andID:1];
            if (value == nil) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:Token forKey:@"TOKEN"];
            [params setValue:@"IEA0" forKey:@"CMD"];
            [params setValue:bigType.idID forKey:@"typeID"];
            [ZYHttpTool postWithURL:DevidUrl params:params success:^(id json) {
               // 储存
            NSString *CacheKey = [NSString stringWithFormat:@"%@",bigType.idID];
                [self saveCache:CacheKey andID:1 andString:[ZYHttpTool dictionaryToJson:json]];
                
                
                CGFloat fatH = [[[json objectForKey:@"param"] objectForKey:@"keyRow"] floatValue];
                
                
                                            if (fatH<2) {
                                                fatH = 2;
                                            }
                                             Hight = fatH * KCustomButtonHight;
          dispatch_async(dispatch_get_main_queue(), ^{
            self.frame = CGRectMake(0, AppFrameHeight  - Hight , AppFrameWidth, Hight);
              
              

            
              [self setupUniversalView:[json objectForKey:@"param" ]];
           });
                CGFloat  imageViewY;
                if (Hight>kDeviceControlHeight) {
                    imageViewY = (Hight-kDeviceControlHeight)/2;
                }else
                {
                
                    imageViewY = 0;
                }
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageViewY, AirIconWidth, kDeviceControlHeight)];
                if ([bigType.bigType isEqualToString:@"KGTV"]) {
                    //电视
                    imageView.image = [UIImage imageNamed:@"mydevice_dianshiji_n"];
                }else if([bigType.bigType isEqualToString:@"KGHE"]){
                 //热水器
                    imageView.image = [UIImage imageNamed:@"mydevice_reshuiqi_n"];
                }else if([bigType.bigType isEqualToString:@"KGTO"])
                {
                //玩具
                 imageView.image = [UIImage imageNamed:@"mydevice_wanju_n"];
                }else if([bigType.bigType isEqualToString:@"KGST"])
                {//机顶盒
                    imageView.image = [UIImage imageNamed:@"mydevice_dianshihezi_n"];
                    
                }else if([bigType.bigType isEqualToString:@"KGGE"])
                {//通用
                    imageView.image = [UIImage imageNamed:@"control_blue"];
                    
                }
                
                imageView.contentMode = UIViewContentModeCenter;
                [self addSubview:imageView];

            } failure:^(NSError *error) {
                
            }];
    }else{
            //
        NSDictionary *json = [ZYHttpTool dictionaryWithJsonString:value];
        CGFloat fatH = [[[json objectForKey:@"param"] objectForKey:@"keyRow"] floatValue];
        if (fatH<2) {
            fatH = 2;
        }
        Hight = fatH * KCustomButtonHight;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.frame = CGRectMake(0, AppFrameHeight  - Hight , AppFrameWidth, Hight);
            
            [self setupUniversalView:[json objectForKey:@"param" ]];
            
            CGFloat  imageViewY;
            if (Hight>kDeviceControlHeight) {
                imageViewY = (Hight-kDeviceControlHeight)/2;
            }else
            {
                
                imageViewY = 0;
            }
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageViewY, AirIconWidth, kDeviceControlHeight)];
            if ([bigType.bigType isEqualToString:@"KGTV"]) {
                //电视
                imageView.image = [UIImage imageNamed:@"mydevice_dianshiji_n"];
            }else if([bigType.bigType isEqualToString:@"KGHE"]){
                //热水器
                imageView.image = [UIImage imageNamed:@"mydevice_reshuiqi_n"];
            }else if([bigType.bigType isEqualToString:@"KGTO"])
            {
                //玩具
                imageView.image = [UIImage imageNamed:@"mydevice_wanju_n"];
            }else if([bigType.bigType isEqualToString:@"KGST"])
            {//机顶盒
                imageView.image = [UIImage imageNamed:@"mydevice_dianshihezi_n"];
                
            }else if([bigType.bigType isEqualToString:@"KGGE"])
            {//通用
                imageView.image = [UIImage imageNamed:@"control_blue"];
                
            }
            
            imageView.contentMode = UIViewContentModeCenter;
            [self addSubview:imageView];
            
            
        });
    
        
            }
          
        }
    }
}



    /*空调*/
- (void)setupAirView{
  _airView = [[AirView alloc] initWithFrame:CGRectMake(AirIconWidth, 0, AppFrameWidth, kDeviceControlHeight)];
        
        
    [self addSubview:_airView];
}

       /*通用面板*/
-(void)setupUniversalView:(NSMutableDictionary *)dict
{

    _universalView = [[UniversalView alloc] initWithDict:dict];

    [self addSubview:_universalView];
      
}





- (void)saveCache:(NSString *)parmastring andID:(int)_id andString:(NSString *)str;  {
    NSUserDefaults * setting = [NSUserDefaults  standardUserDefaults];
    NSString * key = [NSString stringWithFormat:@"detail-%@-%d",parmastring, _id];
    [setting setObject:str forKey:key];
    [setting synchronize];
}

- (NSString *)getCache:(NSString *)parmastring andID:(int)_id
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"detail-%@-%d",parmastring, _id];
    
    NSString *value = [settings objectForKey:key];
    return value;
}


@end
