//
//  ViewController.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/3.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FlexLayout.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UILabel *label = [UILabel new];
    label.text = @"Text";
    label.frame = CGRectMake(100, 100, 100, 20);
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
    
    self.view.flex.fl_flexDirection(FLFlexDirectionRow).children(@[label]);
    label.flex.fl_left(10).fl_top(10);
    
    [self.view.flex calculateLayoutWithSize:self.view.bounds.size];
    NSLog(@"");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
