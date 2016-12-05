
//
//  LineGraphView.m
//  LineGraph
//
//  Created by XH on 16/11/30.
//  Copyright © 2016年 huoniu. All rights reserved.
//
//spacing
#import "LineGraphView.h"
#define scale [UIScreen mainScreen].bounds.size.height/320
#define SpacingToLeft  50 * scale
#define SpacingToTop 70 * scale
#define SpacingHeight 45 * scale
#define start  (self.frame.size.width - 2 * SpacingToLeft)/7
#define _dotH 5
#define LineGraphHeight 5 * SpacingHeight + SpacingToTop
#define YData 6
#define GrapLineHeight  5 * SpacingHeight

// 虚线的颜色
#define XHLineColor [UIColor whiteColor]
// 圆环外面的颜色
#define XHDotBorderColor  [UIColor redColor]
// 圆环的背景色
#define XHDotBackgroundColor  [UIColor blackColor]

@interface LineGraphView ()

@property (nonatomic,strong) NSMutableArray *datas;

@property (nonatomic,strong) NSMutableArray * Y_datas;

@property (nonatomic,strong) NSMutableArray *minDatas;

@property (nonatomic,strong) NSMutableArray *YMinDatas;


@property (nonatomic,strong) NSMutableArray * maxDatas;

@property (nonatomic,strong) NSMutableArray * YMaxDatas;

@end

@implementation LineGraphView

- (NSMutableArray *)minDatas{
    if (_minDatas == nil) {
        _minDatas = [NSMutableArray array];
    }
    return _minDatas;
}

- (NSMutableArray *)YMinDatas{
    if (_YMinDatas == nil) {
        
        _YMinDatas = [NSMutableArray array];
    }
    return _YMinDatas;
}
- (NSMutableArray *)maxDatas{
    if (_maxDatas == nil) {
        
        _maxDatas = [NSMutableArray array];
    }
    return _maxDatas;
}
- (NSMutableArray *)YMaxDatas{
    if (_YMaxDatas == nil) {
        
        _YMaxDatas = [NSMutableArray array];
    }
    return _YMaxDatas;
}
- (NSMutableArray *)Y_datas{
    if (_Y_datas == nil) {
        
        _Y_datas = [NSMutableArray array];
    }
    return _Y_datas;
}

// 绘图
- (NSMutableArray *)datas{
    if (_datas == nil) {
     
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        for (int i= 0; i < YData; i++) {
            
            CGFloat lineX = SpacingToLeft;
            CGFloat lineY = i * SpacingHeight + SpacingToTop;
            CGFloat lineW = self.frame.size.width - 2 * lineX;
            CGFloat lineH = 0.5;
            
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
            
            line.backgroundColor = [UIColor whiteColor];
            if (i != 0) line.alpha = 0.3;
            [self addSubview:line];
            
            
            CGFloat y_datasX = 0;
            CGFloat y_datasY = lineY - 5;
            CGFloat y_datasW = SpacingToLeft;
            CGFloat y_datasH = 10;
            
            UILabel *y_datas = [[UILabel alloc] initWithFrame:CGRectMake(y_datasX, y_datasY, y_datasW, y_datasH)];
            y_datas.tag = 100 + i;
            y_datas.textAlignment = NSTextAlignmentCenter;
            y_datas.textColor = [UIColor whiteColor];
            y_datas.text = [NSString stringWithFormat:@"%d",i];
            y_datas.font = [UIFont systemFontOfSize:9];
            [self addSubview:y_datas];
            
        }
        // 下面的月份
        NSArray *arr = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月"];
        for (int i = 0; i < arr.count; i++) {
            
            CGFloat x_datasW = (self.frame.size.width - 2 * SpacingToLeft)/arr.count;
            CGFloat x_datasX = SpacingToLeft + i * x_datasW;
            CGFloat x_datasY = LineGraphHeight;
            CGFloat x_datasH = 10;
            UILabel *x_datas = [[UILabel alloc] initWithFrame:CGRectMake(x_datasX, x_datasY, x_datasW, x_datasH)];
            x_datas.textColor = [UIColor whiteColor];
            x_datas.font = [UIFont systemFontOfSize:9];
            x_datas.textAlignment = NSTextAlignmentLeft;
            x_datas.text = arr[i];
            [self addSubview:x_datas];
        }
        
    }
    return self;
}


/**
 数组值

 @param y_datasArray Y坐标的数据
 @param coloreLines  线的颜色
 */
- (void)LineGraphViewY_datasArray:(NSArray *)y_datasArray andColoreLines:(NSArray *)coloreLines{
    
    
    for (int i = 0; i < y_datasArray.count; i++) {
        
        NSArray *tempArr = y_datasArray[i];
        
        // Y 坐标的数组
        NSArray * y_arr = [self getPointsArray:tempArr];
        // 保存所有数据计算出最大值
        [self.Y_datas addObject:y_arr];
        
    }
    
    // 计算出最大值 最小值 绘制左边的坐标
    [self sety_datas:[self CalculationMax:self.Y_datas] andMin:[self CalculationMin:self.Y_datas]];
    
    for (int i = 0; i < y_datasArray.count; i++) {
        
        NSArray *tempArr = y_datasArray[i];
        
        tempArr = [self CalculationYDatas:tempArr];
        
        
        NSArray * arr = [self getPointsArray:tempArr];
        [self.datas addObject:arr];
        
        
        [self getEachGroupMaxMin:arr];
        
        
        [self drawLineAndDotAndBrokenLine:tempArr andColoreLines:coloreLines[i]];
        
    }
    /** 计算最大值  */
    [self getEachGroupDatasMax:y_datasArray];
//
    [self getEachGroupDatasMin:y_datasArray];
    
    /** 最大值,最小值 赋值 */
    [self setTitleLabel:self.YMinDatas andMaxMin:self.maxDatas];
//
    [self setTitleLabel:self.YMaxDatas andMaxMin:self.minDatas];
    
}


/**
 得到每组的最大值 最小值

 @param maxMin 每组数据
 */
- (void)getEachGroupMaxMin:(NSArray *)maxMin{
    
    CGPoint pointMax = [self getEachGroupMax:maxMin];
    
    CGPoint pointMin = [self getEachGroupMin:maxMin];
    
    
    [self.YMaxDatas addObject:[NSValue valueWithCGPoint:pointMax]];
    
    [self.YMinDatas addObject:[NSValue valueWithCGPoint:pointMin]];

//    NSLog(@"max == %@ min === %@",NSStringFromCGPoint(pointMax),NSStringFromCGPoint(pointMin));
}

/**
 设置label

 @param points 最大值  最小值的坐标
 */
- (void)setTitleLabel:(NSArray *)points andMaxMin:(NSArray *)maxMin{
    
    CGFloat labelW = 100;
    CGFloat labelH = 9;
    for (int i = 0; i < points.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        UILabel * label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:9];
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(point.x+5, point.y+5, labelW, labelH);
        label.text = [NSString stringWithFormat:@"%@",maxMin[i]];
        [self addSubview:label];
    }

}
/**
 得到每组数据的最大值坐标

 @param points 每组数据
 */
- (CGPoint )getEachGroupMax:(NSArray *)points{
    CGFloat max = 0;
    CGPoint POINT = CGPointZero;
    for (int i = 0 ; i < points.count; i++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        CGFloat pointY = point.y - 12;
        if (max < pointY) {
            max = pointY;
            POINT = CGPointMake(start * i + SpacingToLeft, max - 10);
        }
    }
    return POINT;
}

/**
 得到每组数据的最大值
 传进来的数组
 */
- (void)getEachGroupDatasMax:(NSArray *)arr{
    
    for (int i = 0; i < arr.count; i++) {
        NSArray *points = arr[i];
        CGFloat max = 0;
        NSString *maxString = nil;
        for (int y = 0 ; y < points.count; y++) {
            CGFloat pointY = [[points objectAtIndex:y] floatValue];
            if (max < pointY) {
                max = pointY;
                maxString = points[y];
            }
        }
        [self.maxDatas addObject:maxString];

    }
}

/**

 得到每组数据的最小值
 @param arr  传进来的数据

 */
- (void)getEachGroupDatasMin:(NSArray *)arr{
    
    for (int i = 0; i < arr.count; i++) {
        NSArray *points = arr[i];
        
        CGFloat min = 999999999;
        NSString *minString = nil;
        
        for (int y = 0 ; y < points.count; y++) {
            CGFloat pointY = [[points objectAtIndex:y] floatValue];
            
            if (min > pointY) {
                min = pointY;
                minString = points[y];
            }
        }
        [self.minDatas addObject:minString];
    }
}
/**
 得到每组数据的最小值

 @param points 每组数组

 @return 最小值
 */
- (CGPoint)getEachGroupMin:(NSArray *)points{
    CGFloat min = 999999999;
    CGPoint POINT = CGPointZero;

    for (int i = 0 ; i < points.count; i++) {
        CGPoint point = [[points objectAtIndex:i] CGPointValue];
        CGFloat pointY = point.y - 12;
        
        if (min > pointY) {
            min = pointY;
            POINT = CGPointMake(start * i + SpacingToLeft + 2, min);

        }
    }
    return POINT;
}
/**
 绘制折线、圆圈,竖线

 @param y_datasArray 每一组数据
 @param coloreLines  每组的颜色
 */
- (void)drawLineAndDotAndBrokenLine:(NSArray *)y_datasArray andColoreLines:(UIColor *)coloreLines{
    [self drawDot:y_datasArray];
    
    [self drawLine:y_datasArray];
    
    
    if (coloreLines) {
        [self drawBrokenLine:y_datasArray andLineColor:coloreLines];
        
    }else{
        [self drawBrokenLine:y_datasArray andLineColor:[UIColor whiteColor]];
    }

}


/**
 计算每组 数据在UI 上的坐标

 @param ds 每一组数据

 @return 在视图上的坐标数组
 */
- (NSArray *)CalculationYDatas:(NSArray *)ds{
    
    NSMutableArray *datas = [NSMutableArray array];

    for (int i = 0; i < ds.count; i++) {
        
        CGFloat pointy = [ds[i] floatValue];
        CGFloat spacing =  [self CalculationMax:self.Y_datas] - [self CalculationMin:self.Y_datas];

        pointy =  LineGraphHeight - (pointy/(spacing ))*GrapLineHeight ;
        
        [datas addObject:[NSString stringWithFormat:@"%f",pointy]];
       
    }
//     NSLog(@"%@",datas);
    return datas;
    
}

/**
 计算数据的最小值然后 设置间距
 
 @param arr 所有数据

 @return    最小值的差值
 */
- (CGFloat )CalculationMin:(NSArray *)arr{
    
    CGFloat min = 999999999;
    
    for (int i = 0; i < arr.count; i++) {
        NSArray *points = arr[i];
        for (int y = 0 ; y < points.count; y++) {
            CGPoint point = [[points objectAtIndex:y] CGPointValue];
            CGFloat pointY = point.y;
          
            if (min > pointY) {
                min = pointY;
            }
        }
    }
//    NSLog(@" min = %f",min);

    return  min;
    
}


/**
 计算最大值
 
 @param arr 所有数据

 @return 最大值
 */
- (CGFloat)CalculationMax:(NSArray *)arr{
    CGFloat max = 0;
    for (int i = 0; i < arr.count; i++) {
        NSArray *points = arr[i];
        for (int y = 0 ; y < points.count; y++) {
            CGPoint point = [[points objectAtIndex:y] CGPointValue];
            CGFloat pointY = point.y;
            if (max < pointY) {
                max = pointY;
            }
         
        }
    }
//    NSLog(@"max = %f ",max);
    
    return max;
}
/**
 得到点的数组

 @param points Y 坐标的数组

 */
- (NSArray *)getPointsArray:(NSArray *)points{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < points.count; i++) {
        CGFloat xPosition = start * i + SpacingToLeft;
        CGFloat yPosition = [[points objectAtIndex:i] floatValue] + _dotH * 0.5;
        CGPoint point =  CGPointMake(xPosition, yPosition);
        [arr addObject:[NSValue valueWithCGPoint:point]];

    }
    return (NSArray *)arr;
}

/**
 绘制折线
 */
- (void)drawBrokenLine:(NSArray *)points andLineColor:(UIColor *)lineColor{
    
    
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [linePath setLineCapStyle:kCGLineCapRound];
    [linePath setLineJoinStyle:kCGLineJoinRound];
    // 起点

    [linePath moveToPoint:CGPointMake(SpacingToLeft, [[points objectAtIndex:0] floatValue]+ _dotH * 0.5)];
    // 其他点

    for (int i = 1; i < points.count; i++) {
        CGFloat xPosition = start * i + SpacingToLeft;
        CGFloat yPosition = [[points objectAtIndex:i] floatValue] + _dotH * 0.5;

        [linePath addLineToPoint:CGPointMake(xPosition, yPosition)];

    }
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    
    // 设置虚线
    lineLayer.lineDashPattern = [NSArray arrayWithObjects:@4,@2, nil];
    lineLayer.lineWidth = 1;
    lineLayer.strokeColor = lineColor.CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = [UIColor clearColor].CGColor; // 默认为blackColor
    
    [self.layer addSublayer:lineLayer];
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [lineLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];

}

/**
 绘制圆点
 */
- (void)drawDot:(NSArray *)dots
{

    for (int i = 0 ; i < dots.count; i++) {
        
        CGFloat dotW = _dotH;
        CGFloat dotX = start * i - (dotW - 1) * 0.5 + SpacingToLeft;
        CGFloat doty = [[dots objectAtIndex:i] floatValue];
        CGFloat dotH = _dotH;
        
        UIView *dot = [[UIView alloc] init];
        dot.frame = CGRectMake(dotX, doty, dotW, dotH);
        dot.layer.masksToBounds = YES;
        dot.layer.cornerRadius = dotH/2;
        dot.layer.borderWidth = 1;
        dot.layer.borderColor = XHDotBorderColor.CGColor;
        dot.backgroundColor = XHDotBackgroundColor;
        [self addSubview:dot];
        
        if (i == dots.count - 1) {
            
            dot.layer.shadowColor = [UIColor redColor].CGColor;
            dot.layer.shadowRadius = 4;
//            dot.layer.shadowOffset = CGSizeMake(5, 5);
            dot.layer.shadowOpacity = 0.8;
            dot.clipsToBounds = NO;

        }

    }
}

/**
 绘制线
 */
- (void)drawLine:(NSArray *)lines{
    
    CGFloat dotH = _dotH;
    
    for (int i = 0 ; i < lines.count; i++) {
        
        CGFloat lineX = start * i + SpacingToLeft;
        CGFloat lineY = [[lines objectAtIndex:i] floatValue] + dotH;
        CGFloat lineH = LineGraphHeight - [[lines objectAtIndex:i] floatValue]  - dotH;
        CGFloat lineW = 1;
        UIView *line = [[UIView alloc] init];
        line.frame = CGRectMake(lineX, lineY, lineW, lineH);
        line.backgroundColor = XHLineColor;
        line.alpha = 0.3;
        [self addSubview:line];
    }
}

/**
 给Y坐标Label赋值

 */
- (void)sety_datas:(CGFloat)max andMin:(CGFloat)min{

    CGFloat spa = (max - min)/(YData - 1);
    
    for (int i = 0; i < YData ; i++) {
      
        UILabel *Ylabel = (UILabel *)[self viewWithTag:100+YData -1-i];

        Ylabel.text = [NSString stringWithFormat:@"%.02f", spa * i];

    }
    
}

// 绘制阴影
- (void)drawRect:(CGRect)rect {
    
    
//    CGFloat spacing =  [self CalculationMax:self.Y_datas] - [self CalculationMin:self.Y_datas];

    
    for (int i = 0; i < self.datas.count; i++) {
        
        NSArray * arr = self.datas[i];
        
        if (!arr || [arr count]<=0) return;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        {
            //先画出要裁剪的区域
            CGPoint firstPoint = [[arr objectAtIndex:0] CGPointValue];
            CGContextMoveToPoint(context, firstPoint.x, self.frame.size.height);
            CGContextSetLineWidth(context, 2);
            for (int i=0; i<[arr count]; i++) {
                //画中间的区域
                CGPoint point = [[arr objectAtIndex:i] CGPointValue];
                CGContextAddLineToPoint(context, point.x, point.y);
            }
            CGPoint lastPoint = [[arr objectAtIndex:([arr count]-1)] CGPointValue];
            {
                //画边框
                CGContextAddLineToPoint(context, lastPoint.x, self.frame.size.height);
                
                CGContextAddLineToPoint(context, self.frame.size.width, self.frame.size.height);
                CGContextAddLineToPoint(context, self.frame.size.width, 0);
                CGContextAddLineToPoint(context, 0, 0);
                CGContextAddLineToPoint(context, 0, self.frame.size.height);
            }
            
            CGContextClosePath(context);
            CGContextAddRect(context, CGContextGetClipBoundingBox(context));
            CGContextEOClip(context);
            //裁剪
            CGContextMoveToPoint(context, firstPoint.x, 0);
            CGContextAddLineToPoint(context, firstPoint.x, LineGraphHeight);
            CGContextSetLineWidth(context,self.frame.size.width*2);
            CGContextReplacePathWithStrokedPath(context);
            CGContextClip(context);
            //填充渐变
            CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
            if (i == 0) {
                CGFloat colors[] = {
                    68/255.0,192/255.0,254/255.0,0.6,
                    68/255.0,192/255.0,254/255.0,0.0,
                    68/255.0,192/255.0,254/255.0,0.0
                };
                CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
                CGContextDrawLinearGradient(context, gradient, CGPointMake(firstPoint.x, 0), CGPointMake(firstPoint.x, self.frame.size.height), 0);
                CGGradientRelease(gradient);
            }
            else
            {
                CGFloat colors[] = {
                    239/255.0,0/255.0,180/255.0,0.6,
                    239/255.0,0/255.0,180/255.0,0.0,
                    239/255.0,0/255.0,180/255.0,0.0
                };
                CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, 2);
                CGContextDrawLinearGradient(context, gradient, CGPointMake(firstPoint.x, 0), CGPointMake(firstPoint.x, self.frame.size.height), 0);
                CGGradientRelease(gradient);
            }
            
            
        }
        CGContextRestoreGState(context);
        
    }
}

@end
