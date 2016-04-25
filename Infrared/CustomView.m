//
//  CustomView.m
//  Control
//
//  Created by lvjianxiong on 15/1/20.
//  Copyright (c) 2015年 lvjianxiong. All rights reserved.
//

#import "CustomView.h"

@interface CustomView ()

@property (retain,nonatomic) UIBezierPath *pathForBorder;
@property (assign,nonatomic) BOOL needUpdatePathForBorder;

@end

@implementation CustomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)dealloc{
    self.lineColorTop = nil;
    self.lineColorLeft = nil;
    self.lineColorBottom = nil;
    self.lineColorRight = nil;
    self.pathForBorder = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidthTop = 0.5;
        self.lineWidthLeft = 0.5;
        self.lineWidthBottom = 0.5;
        self.lineWidthRight = 0.5;
        self.needLineTop = TRUE;
        self.needLineLeft = TRUE;
        self.needLineBottom = TRUE;
        self.needLineRight = TRUE;
        
        self.needUpdatePathForBorder = TRUE;
        
        //        [self setUserInteractionEnabled:FALSE];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    //    CGFloat startX=0;
    //    CGFloat endX=self.frame.size.width;
    //    CGFloat startY=0;
    //    CGFloat endY=self.frame.size.height;
    
    CGFloat halfLineWidthTop=_lineWidthTop/2;
    CGFloat halfLineWidthLeft=_lineWidthLeft/2;
    CGFloat halfLineWidthBottom=_lineWidthBottom/2;
    CGFloat halfLineWidthRight=_lineWidthRight/2;
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, self.bounds);
    
    //填充背景
    if (_fillColor) {
        CGContextSetFillColorWithColor(context, _fillColor.CGColor);
        UIBezierPath *bezierPath=[self bezierPathForBorder];
        [bezierPath fill];
    }
    //画线
    if (_needLineTop) {
        CGContextSetLineWidth(context, _lineWidthTop);
        CGContextSetStrokeColorWithColor(context, (_lineColorTop?_lineColorTop:[UIColor blackColor]).CGColor);
        CGContextAddArc(context, self.frame.size.width-_radiusTopRight, _radiusTopRight, _radiusTopRight-halfLineWidthTop, -M_PI_4+(_needLineRight?0:M_PI_4), -M_PI_2, 1);
        CGContextMoveToPoint(context, self.frame.size.width-_radiusTopRight, halfLineWidthTop);
        CGContextAddLineToPoint(context, _radiusTopLeft, halfLineWidthTop);
        CGContextAddArc(context, _radiusTopLeft, _radiusTopLeft, _radiusTopLeft-halfLineWidthTop, -M_PI_2, -M_PI_2-M_PI_4-(_needLineLeft?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    if (_needLineLeft) {
        CGContextSetLineWidth(context, _lineWidthLeft);
        CGContextSetStrokeColorWithColor(context, (_lineColorLeft?_lineColorLeft:[UIColor blackColor]).CGColor);
        CGContextAddArc(context, _radiusTopLeft, _radiusTopLeft, _radiusTopLeft-halfLineWidthLeft, -M_PI, -M_PI_2-M_PI_4+(_needLineTop?0:M_PI_4), 0);
        CGContextMoveToPoint(context, halfLineWidthLeft, _radiusTopLeft);
        CGContextAddLineToPoint(context, halfLineWidthLeft, self.frame.size.height-_radiusBottomLeft);
        CGContextAddArc(context, _radiusBottomLeft, self.frame.size.height-_radiusBottomLeft, _radiusBottomLeft-halfLineWidthLeft, M_PI, M_PI-M_PI_4-(_needLineBottom?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    if (_needLineBottom) {
        CGContextSetLineWidth(context, _lineWidthBottom);
        CGContextSetStrokeColorWithColor(context, (_lineColorBottom?_lineColorBottom:[UIColor blackColor]).CGColor);
        CGContextAddArc(context, _radiusBottomLeft, self.frame.size.height-_radiusBottomLeft, _radiusBottomLeft-halfLineWidthBottom, M_PI-M_PI_4+(_needLineLeft?0:M_PI_4), M_PI_2, 1);
        CGContextMoveToPoint(context, _radiusBottomLeft, self.frame.size.height-halfLineWidthBottom);
        CGContextAddLineToPoint(context, self.frame.size.width-_radiusBottomRight, self.frame.size.height-halfLineWidthBottom);
        CGContextAddArc(context, self.frame.size.width-_radiusBottomRight, self.frame.size.height-_radiusBottomRight, _radiusBottomRight-halfLineWidthBottom, M_PI_2, M_PI_4-(_needLineRight?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    if (_needLineRight) {
        CGContextSetLineWidth(context, _lineWidthRight);
        CGContextSetStrokeColorWithColor(context, (_lineColorRight?_lineColorRight:[UIColor blackColor]).CGColor);
        CGContextAddArc(context, self.frame.size.width-_radiusBottomRight, self.frame.size.height-_radiusBottomRight, _radiusBottomRight-halfLineWidthRight, M_PI_4+(_needLineBottom?0:M_PI_4), 0, 1);
        CGContextMoveToPoint(context, self.frame.size.width-halfLineWidthRight, self.frame.size.height-_radiusBottomRight);
        CGContextAddLineToPoint(context, self.frame.size.width-halfLineWidthRight, _radiusTopRight);
        CGContextAddArc(context, self.frame.size.width-_radiusTopRight, _radiusTopRight, _radiusTopRight-halfLineWidthRight, 0, -M_PI_4-(_needLineTop?0:M_PI_4), 1);
        CGContextStrokePath(context);
    }
    CGContextStrokePath(context);
}

-(UIBezierPath*)bezierPathForBorder{
    if (self.needUpdatePathForBorder||!self.pathForBorder) {
        CGFloat halfLineWidthTop=_lineWidthTop/2;
        CGFloat halfLineWidthLeft=_lineWidthLeft/2;
        CGFloat halfLineWidthBottom=_lineWidthBottom/2;
        CGFloat halfLineWidthRight=_lineWidthRight/2;
        UIBezierPath *bezierPath=[UIBezierPath bezierPath];
        [bezierPath moveToPoint:CGPointMake(self.frame.size.width-_radiusTopRight, 0)];
        [bezierPath addLineToPoint:CGPointMake(_radiusTopLeft, 0)];
        [bezierPath addQuadCurveToPoint:CGPointMake(0, _radiusTopLeft) controlPoint:CGPointMake(halfLineWidthLeft, halfLineWidthTop)];
        [bezierPath addLineToPoint:CGPointMake(0, self.frame.size.height-_radiusBottomLeft)];
        [bezierPath addQuadCurveToPoint:CGPointMake(_radiusBottomLeft, self.frame.size.height) controlPoint:CGPointMake(halfLineWidthLeft, self.frame.size.height-halfLineWidthBottom)];
        [bezierPath moveToPoint:CGPointMake(_radiusBottomLeft, self.frame.size.height)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width-_radiusBottomRight, self.frame.size.height)];
        [bezierPath addQuadCurveToPoint:CGPointMake(self.frame.size.width, self.frame.size.height-_radiusBottomRight) controlPoint:CGPointMake(self.frame.size.width-halfLineWidthRight, self.frame.size.height-halfLineWidthBottom)];
        [bezierPath addLineToPoint:CGPointMake(self.frame.size.width, _radiusTopRight)];
        [bezierPath addQuadCurveToPoint:CGPointMake(self.frame.size.width-_radiusTopRight, 0) controlPoint:CGPointMake(self.frame.size.width-halfLineWidthRight, halfLineWidthTop)];
        self.pathForBorder=bezierPath;
        self.needUpdatePathForBorder=false;
    }
    return self.pathForBorder;
}

/*
 在一个子视图将要被添加到另一个视图的时候发送此消息
 */
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if ([self clipsToBoundsWithBorder]) {
        UIBezierPath *bezierPath=[self bezierPathForBorder];
        CAShapeLayer* maskLayer = [CAShapeLayer new];
        maskLayer.frame = self.bounds;
        maskLayer.path = bezierPath.CGPath;
        self.layer.mask = maskLayer;
    }
}

-(void)setFrame:(CGRect)frame{
    if (!CGRectEqualToRect(self.frame, frame)) {
        self.needUpdatePathForBorder=true;
    }
    [super setFrame:frame];
}

-(void)setNeedLineTop:(BOOL)needTop left:(BOOL)needLeft bottom:(BOOL)needBottom right:(BOOL)needRight{
    self.needLineTop=needTop;
    self.needLineLeft=needLeft;
    self.needLineRight=needRight;
    self.needLineBottom=needBottom;
}
-(void)setLineColorTop:(UIColor *)colorTop left:(UIColor *)colorLeft bottom:(UIColor *)colorBottom right:(UIColor *)colorRight{
    self.lineColorTop=colorTop;
    self.lineColorLeft=colorLeft;
    self.lineColorBottom=colorBottom;
    self.lineColorRight=colorRight;
}
-(void)setLineWidthTop:(CGFloat)widthTop left:(CGFloat)widthLeft bottom:(CGFloat)widthBottom right:(CGFloat)widthRight{
    self.lineWidthTop=widthTop;
    self.lineWidthLeft=widthLeft;
    self.lineWidthBottom=widthBottom;
    self.lineWidthRight=widthRight;
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
-(void)setLineWidthBottom:(CGFloat)lineWidthBottom{
    if (_lineWidthBottom!=lineWidthBottom) {
        _lineWidthBottom=lineWidthBottom;
        self.needUpdatePathForBorder=true;
    }
}
-(void)setLineWidthLeft:(CGFloat)lineWidthLeft{
    if (_lineWidthLeft!=lineWidthLeft) {
        _lineWidthLeft=lineWidthLeft;
        self.needUpdatePathForBorder=true;
    }
}
-(void)setLineWidthTop:(CGFloat)lineWidthTop{
    if (_lineWidthTop!=lineWidthTop) {
        _lineWidthTop=lineWidthTop;
        self.needUpdatePathForBorder=true;
    }
}
-(void)setLineWidthRight:(CGFloat)lineWidthRight{
    if (_lineWidthRight!=lineWidthRight) {
        _lineWidthRight=lineWidthRight;
        self.needUpdatePathForBorder=true;
    }
}

@end
