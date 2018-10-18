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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *rootView = [UIView new];
    rootView.frame = CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 200);
    rootView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
    [self.view addSubview:rootView];
    
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [rootView addSubview:imageView];
    
    UIView *iconCornerView = [UIView new];
    iconCornerView.backgroundColor = [UIColor greenColor];
    [imageView addSubview:iconCornerView];
    
    UILabel *label = [UILabel new];
    label.text = @"Jerry Ren";
    label.backgroundColor = [UIColor lightGrayColor];
    [rootView addSubview:label];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"Today is a great day!";
    label1.backgroundColor = [UIColor darkGrayColor];
    [rootView addSubview:label1];
    
    UILabel *label2 = [UILabel new];
    label2.text = @"\"Take up one idea. Make that one idea your life -- think of it, dream of it, live on that idea. Let the brain, muscles, nerves, every part of your body be full of that idea, and just leave every other idea alone. This is the way to success.\" -- Swami Vivekananda";
    label2.backgroundColor = [UIColor lightGrayColor];
    label2.numberOfLines = 0;
    [rootView addSubview:label2];
    
    FLVirtualView *container1 = [FLVirtualView new];
    
    FLVirtualView *container2 = [FLVirtualView new];
    
    //[rootView addSubview:container1];
    
    //[container1 addSubview:label];
    //[container1 addSubview:label1];
    
//    iconCornerView.flex.fl_width(10).fl_aspectRatio(1.0).fl_position(FLPositionTypeRelative).fl_left(40).fl_top(40);
//    imageView.flex.fl_height(50).fl_aspectRatio(1.0).fl_marginRight(20).addChild(iconCornerView);
//    label2.flex.fl_marginHorizontal(20);//fl_marginLeft(20).fl_marginRight(20);
    
//    container1.flex.fl_flexDirection(FLFlexDirectionColumn).fl_justifyContent(FLJustifySpaceBetween)
//    .fl_flexGrow(1.0).children(@[label, label1]);
    
    [rootView.flex define:^(FlexLayout *flex) {
        flex
        .fl_flexDirection(FLFlexDirectionColumn)
        .fl_justifyContent(FLJustifyFlexStart)
        .fl_padding(20)
        .fl_direction(FLDirectionLTR);
        
        [flex.addChild(container1).fl_flexDirection(FLFlexDirectionRow) define:^(FlexLayout *flex) {
//            flex.fl_flexDirection(FLFlexDirectionColumn);
            
            [flex.addChild(imageView) define:^(FlexLayout *flex) { //image view layout
                flex.fl_height(50).fl_aspectRatio(1.0).fl_marginRight(20);
                
                [flex.addChild(iconCornerView) define:^(FlexLayout *flex) { // corner view layout
                    flex.fl_width(10).fl_aspectRatio(1.0).fl_position(FLPositionTypeRelative).fl_left(40).fl_top(40);
                }];
            }];
            
            [flex.addChild(container2) define:^(FlexLayout *flex) { // container1
                flex.fl_flexDirection(FLFlexDirectionColumn).fl_justifyContent(FLJustifySpaceBetween).fl_flexGrow(1.0);
                flex.addChild(label);
                flex.addChild(label1);
            }];
        }];
        
        flex.addChild(label2).fl_marginTop(20);
     }];
    

//    rootFlexContainer.flex.direction(.row).padding(20).define { (flex) in
//        flex.addItem().width(80).marginEnd(20).backgroundColor(.flexLayoutColor)
//        flex.addItem().height(25).alignSelf(.center).grow(1).backgroundColor(.black)
//    }
//    addSubview(rootFlexContainer)
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    //NSLog(@"------ time consuming: %lf total time: %lf line: %d func: %s ", currentTimeStamp - lastTimeStamp, currentTimeStamp - startTimeStamp, line, func);
    [rootView.flex applyLayoutPreservingOrigin:YES dimensionFlexibility:FLDimensionFlexibleHeight];
    NSLog(@"------ time consuming: %lf ", [[NSDate date] timeIntervalSince1970] - timeInterval);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//void PrintTimeConsuming(const int32_t line, const char *func) {
//    static NSTimeInterval startTimeStamp = 0;
//    static NSTimeInterval lastTimeStamp = 0;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        lastTimeStamp = [[NSDate date] timeIntervalSince1970];
//        startTimeStamp = lastTimeStamp;
//    });
//
//    NSTimeInterval currentTimeStamp = [[NSDate date] timeIntervalSince1970];
//    NSLog(@"------ time consuming: %lf total time: %lf line: %d func: %s ", currentTimeStamp - lastTimeStamp, currentTimeStamp - startTimeStamp, line, func);
//    lastTimeStamp = currentTimeStamp;
//}

