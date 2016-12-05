//
//  LineGraphView.h
//  LineGraph
//
//  Created by XH on 16/11/30.
//  Copyright © 2016年 huoniu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LineGraphViewDelegate <NSObject>
// 横坐标标题数组
- (NSMutableArray *)LineGraphViewChart_XTitleArray;

// 纵坐标数组
- (NSMutableArray *)LineGraphViewChart_YTitleArray;

@optional
// 颜色数组
- (NSMutableArray *)LineGraphViewChart_colorArray;

@end

@interface LineGraphView : UIView

// y 的坐标
//@property (nonatomic,strong) NSArray * y_datasArray;
//
//// 线的颜色
//@property (nonatomic,strong) NSArray * coloreLines;


- (void)LineGraphViewY_datasArray:(NSArray *)y_datasArray andColoreLines:(NSArray *)coloreLines;

@end
