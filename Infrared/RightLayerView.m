//
//  RightLayerView.m
//  Control
//
//  Created by lvjianxiong on 15/1/28.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import "RightLayerView.h"
#import "UIColor+ZYHex.h"

@interface RightLayerView ()<UITableViewDelegate,UITableViewDataSource>{
    CGFloat _triangleHeight;
    UITableView *_rightTableView;
}

@property (retain,nonatomic) UIBezierPath *pathForBorder;
@property (assign,nonatomic) BOOL needUpdatePathForBorder;
@property (nonatomic, strong)UILabel *line;

@end

@implementation RightLayerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _triangleHeight = 12;
        self.backgroundColor = [UIColor clearColor];
        self.needUpdatePathForBorder = TRUE;
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _triangleHeight, ViewFrameWidth(self), ViewFrameHeight(self)-_triangleHeight) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.backgroundColor = [UIColor colorForHex:@"1cafec"];
        [_rightTableView.layer setMasksToBounds:YES];
        [_rightTableView.layer setCornerRadius:4.0f];
        [self addSubview:_rightTableView];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    [self drawTriangle];
    [self drawRectangle];
}

// 绘制三角形
- (void)drawTriangle {
    
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 创建一个新的空图形路径。
    CGContextBeginPath(ctx);
    /**
     *  @brief 在指定点开始一个新的子路径 参数按顺序说明
     *
     *  @param c 当前图形
     *  @param x 指定点的x坐标值
     *  @param y 指定点的y坐标值
     *
     */
    CGContextMoveToPoint(ctx, ViewFrameWidth(self)-16, 0);
    /**
     *  @brief 在当前点追加直线段，参数说明与上面一样
     */
    CGContextAddLineToPoint(ctx, ViewFrameWidth(self)-10, _triangleHeight);
    CGContextAddLineToPoint(ctx, ViewFrameWidth(self)-22, _triangleHeight);
    // 关闭并终止当前路径的子路径，并在当前点和子路径的起点之间追加一条线
    CGContextClosePath(ctx);
    // 设置当前视图填充色
    CGContextSetFillColorWithColor(ctx, [UIColor colorForHex:@"21282B"].CGColor);
    // 绘制当前路径区域
    CGContextFillPath(ctx);
}

// 绘制矩形
- (void)drawRectangle {
    // 定义矩形的rect
//    CGRect rectangle = CGRectMake(0, 12, 100, 176);
    // 获取当前图形，视图推入堆栈的图形，相当于你所要绘制图形的图纸
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    /*
    // 在当前路径下添加一个矩形路径
    CGContextAddRect(ctx, rectangle);
    // 设置试图的当前填充色
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    // 绘制当前路径区域
    CGContextFillPath(ctx);
     */
    CGContextSetFillColorWithColor(ctx, [UIColor colorForHex:@"21282B"].CGColor);
    UIBezierPath *bezierPath=[self bezierPathForBorder];
    [bezierPath fill];
}

-(UIBezierPath*)bezierPathForBorder{
    if (self.needUpdatePathForBorder||!self.pathForBorder) {
        CGFloat halfLineWidthTop=1/2;
        CGFloat halfLineWidthLeft=1/2;
        CGFloat halfLineWidthBottom=1/2;
        CGFloat halfLineWidthRight=1/2;
        UIBezierPath *bezierPath=[UIBezierPath bezierPath];
        
        [bezierPath moveToPoint:CGPointMake(ViewFrameWidth(self)-_radiusTopRight, _triangleHeight)];
        [bezierPath addLineToPoint:CGPointMake(_radiusTopLeft, _triangleHeight)];
        
        [bezierPath addQuadCurveToPoint:CGPointMake(0, _radiusTopLeft+_triangleHeight) controlPoint:CGPointMake(halfLineWidthLeft, halfLineWidthTop+_triangleHeight)];
        
        [bezierPath addLineToPoint:CGPointMake(0, ViewFrameHeight(self)-_radiusBottomLeft)];
        
        [bezierPath addQuadCurveToPoint:CGPointMake(_radiusBottomLeft, ViewFrameHeight(self)) controlPoint:CGPointMake(halfLineWidthLeft, ViewFrameHeight(self)-halfLineWidthBottom)];
        
        [bezierPath moveToPoint:CGPointMake(_radiusBottomLeft, ViewFrameHeight(self))];
        [bezierPath addLineToPoint:CGPointMake(ViewFrameWidth(self)-_radiusBottomRight, ViewFrameHeight(self))];
        
        [bezierPath addQuadCurveToPoint:CGPointMake(ViewFrameWidth(self), ViewFrameHeight(self)-_radiusBottomRight) controlPoint:CGPointMake(ViewFrameWidth(self)-halfLineWidthRight, ViewFrameHeight(self)-halfLineWidthBottom)];
        
        [bezierPath addLineToPoint:CGPointMake(ViewFrameWidth(self), _radiusTopRight+_triangleHeight)];
        
        [bezierPath addQuadCurveToPoint:CGPointMake(ViewFrameWidth(self)-_radiusTopRight, _triangleHeight) controlPoint:CGPointMake(ViewFrameWidth(self)-halfLineWidthRight, halfLineWidthTop+_triangleHeight)];
        self.pathForBorder=bezierPath;
        self.needUpdatePathForBorder=false;
    }
    return self.pathForBorder;
}

-(void)setRadiusTopLeft:(CGFloat)topLeft topRight:(CGFloat)topRight bottomLeft:(CGFloat)bottomLeft bottomRight:(CGFloat)bottomRight{
    self.radiusTopLeft=topLeft;
    self.radiusTopRight=topRight;
    self.radiusBottomLeft=bottomLeft;
    self.radiusBottomRight=bottomRight;
}

-(void)setRadiusBottomLeft:(CGFloat)radiusBottomLeft{
    if (_radiusBottomLeft!=radiusBottomLeft) {
        _radiusBottomLeft=radiusBottomLeft;
        self.needUpdatePathForBorder=true;
    }
}
-(void)setRadiusBottomRight:(CGFloat)radiusBottomRight{
    if (_radiusBottomRight!=radiusBottomRight) {
        _radiusBottomRight=radiusBottomRight;
        self.needUpdatePathForBorder=true;
    }
}
-(void)setRadiusTopLeft:(CGFloat)radiusTopLeft{
    if (_radiusTopLeft!=radiusTopLeft) {
        _radiusTopLeft=radiusTopLeft;
        self.needUpdatePathForBorder=true;
    }
}
-(void)setRadiusTopRight:(CGFloat)radiusTopRight{
    if (_radiusTopRight!=radiusTopRight) {
        _radiusTopRight=radiusTopRight;
        self.needUpdatePathForBorder=true;
    }
}

#pragma mark- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftcell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.textLabel.font = _FONT(14.0f);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor colorForHex:@"21282B"];
    cell.textLabel.textColor = [UIColor whiteColor];
    self.line = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.frame.size.height-1, 130, 1)];
    self.line.backgroundColor = [UIColor blackColor];
    [cell addSubview:self.line];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"删除设备";
            break;
        case 1:
            cell.textLabel.text = @"删除设备";
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate pushAboutViewController:indexPath.row];
}

@end
