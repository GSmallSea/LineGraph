//
//  ViewController.m
//  LineGraph
//
//  Created by XH on 16/11/30.
//  Copyright © 2016年 huoniu. All rights reserved.
//

#import "ViewController.h"
#import "LineGraphView.h"
@interface ViewController ()

@property (nonatomic,weak) LineGraphView *lineGraph;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    CGFloat lineGraphW = self.view.frame.size.width;
    CGFloat lineGraphH = self.view.frame.size.height;
  
    LineGraphView *lineGraph = [[LineGraphView alloc] initWithFrame:CGRectMake(0, 0, lineGraphW, lineGraphH)];
    [self.view addSubview:lineGraph];
    [lineGraph LineGraphViewY_datasArray:@[@[@"200",@"800",@"250",@"80",@"60",@"150",@"60"],@[@"250",@"180",@"55",@"200",@"70",@"1000",@"88"],@[@"222",@"50",@"100",@"70",@"260",@"10",@"150"]] andColoreLines:@[[UIColor redColor],[UIColor yellowColor],[UIColor cyanColor]]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
