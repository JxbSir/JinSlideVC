//
//  ViewController.m
//  JinSlideVC
//
//  Created by Peter on 15/1/7.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "ViewController.h"
#import "JinSlideView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIViewController* vc1 = [[UIViewController alloc] init];
    vc1.title = @"百度新闻";
    UILabel* lbl1 = [[UILabel alloc ] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [lbl1 setText:@"111111"];
    [vc1.view addSubview:lbl1];
    
    
    UIViewController* vc2 = [[UIViewController alloc] init];
    vc2.title = @"网易新闻";
    UILabel* lbl2 = [[UILabel alloc ] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [lbl2 setText:@"222222"];
    [vc2.view addSubview:lbl2];
    
    UIViewController* vc3 = [[UIViewController alloc] init];
    vc3.title = @"头条新闻";
    UILabel* lbl3 = [[UILabel alloc ] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [lbl3 setText:@"333333"];
    [vc3.view addSubview:lbl3];
    
    UIViewController* vc4 = [[UIViewController alloc] init];
    vc4.title = @"湖南卫视";
    UILabel* lbl4 = [[UILabel alloc ] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [lbl4 setText:@"4444444"];
    [vc4.view addSubview:lbl4];
    
    
    JinSlideView* sl = [[JinSlideView alloc] initWithTitlesAndColor:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) vcArray:@[vc1,vc2,vc3,vc4] selectIndex:1 corSel:[UIColor redColor] corUnSel:[UIColor blackColor] corBotView:[UIColor greenColor]];
    
    [self.view addSubview:sl];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
