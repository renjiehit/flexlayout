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
#import "FlexHeaders.h"
#import "Utils.h"

@interface NewsCardViewController ()

@end

@implementation NewsCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NewsCardSingleImage *cardSingleImage = [NewsCardSingleImage new];
    NewsCardMultiImage *cardMultiImage = [NewsCardMultiImage new];
    
    [self.view.flex.direction(FLFlexDirectionColumn).justifyContent(FLJustifySpaceBetween) define:^(FlexLayout *flex) {
        flex.addChild(cardSingleImage).width(self.view.bounds.size.width).marginTop(80);
        flex.addChild(cardMultiImage).marginTop(20);
    }];
    
    [self.view.flex applyLayout:FLAjustHeight];
    
    [Utils fillRandomColorWithViewHierarchy:self.view];
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
