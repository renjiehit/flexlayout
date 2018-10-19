//
//  ViewController.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/3.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FlexLayout.h"
#import "FLVirtualView.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *rootView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *rootView = [UIView new];
    rootView.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 200);
    rootView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.view addSubview:rootView];
    
    self.rootView = rootView;
    
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor lightGrayColor];
    
    UIView *iconCornerView = [UIView new];
    iconCornerView.backgroundColor = [UIColor greenColor];
    
    UILabel *label = [UILabel new];
    label.text = @"Jerry Ren";
    label.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"Today is a great day!";
    label1.backgroundColor = [UIColor darkGrayColor];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"\"Take up one idea. Make that one idea your life -- think of it, dream of it, live on that idea. Let the brain, muscles, nerves, every part of your body be full of that idea, and just leave every other idea alone. This is the way to success.\" -- Swami Vivekananda";
    label2.backgroundColor = [UIColor lightGrayColor];
    label2.numberOfLines = 0;
    
    [rootView.flex.fl_flexDirection(FLFlexDirectionColumn).fl_padding(20) define:^(FlexLayout *flex) {
        
        [flex.addChild(FLContainer).fl_flexDirection(FLFlexDirectionRow) define:^(FlexLayout *flex) {
            
            [flex.addChild(imageView).fl_height(50).fl_aspectRatio(1.0).fl_marginRight(20) define:^(FlexLayout *flex) { //image view layout
                
                [flex.addChild(iconCornerView) define:^(FlexLayout *flex) { // corner view layout
                    flex.fl_width(10).fl_aspectRatio(1.0).fl_left(40).fl_top(40);
                }];
            }];
            
            [flex.addChild(FLContainer) define:^(FlexLayout *flex) { // container2
                flex.fl_flexDirection(FLFlexDirectionColumn).fl_justifyContent(FLJustifySpaceBetween).fl_flexGrow(1.0);
                flex.addChild(label);
                flex.addChild(label1);
            }];
        }];
        
        flex.addChild(label2).fl_marginTop(20);
     }];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    [rootView.flex applyLayoutPreservingOrigin:YES dimensionFlexibility:FLDimensionFlexibleHeight];
    NSLog(@"------ time consuming: %lf ", [[NSDate date] timeIntervalSince1970] - timeInterval);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.rootView.flex applyLayoutPreservingOrigin:YES dimensionFlexibility:FLDimensionFlexibleHeight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
