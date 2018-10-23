//
//  Utils.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/23.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "Utils.h"
#import "UIColor+Random.h"

@implementation Utils

+ (void)fillRandomColorWithViewHierarchy:(UIView *)rootView {
    if (rootView == nil || [rootView isKindOfClass:[UIView class]] == NO) {
        return;
    }
    rootView.backgroundColor = [UIColor randomColor];
    for (UIView *subview in rootView.subviews) {
        [self fillRandomColorWithViewHierarchy:subview];
    }
}

@end
