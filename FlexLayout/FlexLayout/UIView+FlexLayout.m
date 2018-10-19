//
//  UIView+FlexLayout.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/5.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "UIView+FlexLayout.h"
#import "FlexLayout+Private.h"
#import <objc/runtime.h>

static const void *kFlexLayoutAssociatedKey = &kFlexLayoutAssociatedKey;

@implementation UIView (FlexLayout)

- (FlexLayout *)flex
{
    FlexLayout *flex = objc_getAssociatedObject(self, kFlexLayoutAssociatedKey);
    if (!flex) {
        flex = [[FlexLayout alloc] initWithElement:self];
        objc_setAssociatedObject(self, kFlexLayoutAssociatedKey, flex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return flex;
}

- (UIView *)view {
    return self;
}

- (BOOL)isVirtualView {
    return NO;
}

@end
