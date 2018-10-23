//
//  UIColor+Random.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/23.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+ (instancetype)randomColor {
    UIColor *randomRGBColor = [[UIColor alloc] initWithRed:arc4random()%256/256.0
                                                     green:arc4random()%256/256.0
                                                      blue:arc4random()%256/256.0
                                                     alpha:1.0];
    return randomRGBColor;
}

@end
