//
//  NewsCardViewController.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/23.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "NewsCardViewController.h"
#import "NewsCardSingleImage.h"
#import "NewsCardMultiImage.h"
#import "NewsCardVideo.h"
#import "FlexHeaders.h"
#import "Utils.h"

@interface NewsCardViewController ()

@end

@implementation NewsCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [scrollView addSubview:contentView];
    
    NewsCardSingleImage *cardSingleImage = [NewsCardSingleImage new];
    NewsCardMultiImage *cardMultiImage = [NewsCardMultiImage new];
    NewsCardVideo *cardVideo = [NewsCardVideo new];
    
    [contentView.flex.direction(FLFlexDirectionColumn).justifyContent(FLJustifySpaceBetween) define:^(FlexLayout *flex) {
        flex.addChild(cardSingleImage).marginTop(0);
        flex.addChild(cardMultiImage).marginTop(20);
        flex.addChild(cardVideo).marginTop(20);
    }];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    [contentView.flex applyLayout:FLAjustHeight];
    NSLog(@"------ time consuming: %lf ", [[NSDate date] timeIntervalSince1970] - timeInterval);
    
    scrollView.contentSize = contentView.frame.size;
    
    [Utils fillRandomColorWithViewHierarchy:self.view];
    
    contentView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
