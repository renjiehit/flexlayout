//
//  FlexLayout+Private.h
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/5.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "FlexLayoutProtocol.h"
#import "FlexLayout.h"
#import <yoga/Yoga.h>

@interface FlexLayout ()

@property (nonatomic, assign, readonly) YGNodeRef node;

- (instancetype)initWithElement:(id<FLElement>)element;

@end

