//
//  FLVirtualView.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/16.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "FLVirtualView.h"
#import "FlexLayout.h"
#import "FlexLayout+Private.h"

@interface FLVirtualView ()

@property (nonatomic, strong) FlexLayout *flex;

@end

@implementation FLVirtualView
@synthesize frame = _frame;

- (FlexLayout *)flex {
    if (!_flex) {
        _flex = [[FlexLayout alloc] initWithElement:self];
    }
    return _flex;
}

- (BOOL)isVirtualView {
    return YES;
}

- (UIView *)view {
    NSAssert(NO, @"Virtual view does not has view");
    return nil;
}

@end
