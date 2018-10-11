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
    
    UIView *rootView = [UIView new];
    rootView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:rootView];
    
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor lightGrayColor];
    [rootView addSubview:imageView];
    
    UILabel *label = [UILabel new];
    label.text = @"Jerry Ren";
    label.backgroundColor = [UIColor lightGrayColor];
    [rootView addSubview:label];
    
    UILabel *label1 = [UILabel new];
    label1.text = @"Sunday";
    label1.backgroundColor = [UIColor darkGrayColor];
    [rootView addSubview:label1];
    
    rootView.flex.fl_flexDirection(FLFlexDirectionRow).fl_justifyContent(FLJustifySpaceBetween)/*.fl_alignItems(FLAlignCenter)*/
    .fl_padding(20).children(@[label, label1]);

//    rootFlexContainer.flex.direction(.row).padding(20).define { (flex) in
//        flex.addItem().width(80).marginEnd(20).backgroundColor(.flexLayoutColor)
//        flex.addItem().height(25).alignSelf(.center).grow(1).backgroundColor(.black)
//    }
//    addSubview(rootFlexContainer)
    
    [rootView.flex applyLayoutPreservingOrigin:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
