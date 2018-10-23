//
//  UIColor+Random.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/23.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "UIColor+Random.h"
static const NSString *colorValues = @"#fe4a49,#2ab7ca,#fed766,#e6e6ea,#f4f4f8,#eee3e7,#ead5dc,#eec9d2,#f4b6c2,#f6abb6,#011f4b,#03396c,#005b96,#6497b1,#b3cde0,#051e3e,#251e3e,#451e3e,#651e3e,#851e3e,#dec3c3,#e7d3d3,#f0e4e4,#f9f4f4,#4a4e4d,#0e9aa7,#3da4ab,#f6cd61,#fe8a71,#2a4d69,#4b86b4,#adcbe3,#e7eff6,#63ace5,#fe9c8f,#feb2a8,#fec8c1,#fad9c1,#f9caa7,#009688,#35a79c,#54b2a9,#65c3ba,#83d0c9,#ee4035,#f37736,#fdf498,#7bc043,#0392cf,#d0e1f9,#4d648d,#283655,#1e1f26,#96ceb4,#ffeead,#ff6f69,#ffcc5c,#88d8b0,#a8e6cf,#dcedc1,#ffd3b6,#ffaaa5,#ff8b94,#d11141,#00b159,#00aedb,#f37735,#ffc425,#ebf4f6,#bdeaee,#76b4bd,#58668b,#5e5656,#ff77aa,#ff99cc,#ffbbee,#ff5588,#ff3377,#fff6e9,#ffefd7,#fffef9,#e3f0ff,#d2e7ff,#84c1ff,#add6ff,#d6eaff,#eaf4ff,#f8fbff,#bfd6f6,#8dbdff,#64a1f4,#4a91f2,#3b7dd8";

@implementation UIColor (Random)

+ (instancetype)randomColor {
//#define RandomColor
#ifdef RandomColor
    UIColor *randomRGBColor = [[UIColor alloc] initWithRed:arc4random()%256/256.0
                                                     green:arc4random()%256/256.0
                                                      blue:arc4random()%256/256.0
                                                     alpha:1.0];
#else
    NSString *colorHex = [[self beautifulColors] objectAtIndex:arc4random()%[self beautifulColors].count];
    UIColor *randomRGBColor = [UIColor colorWithHexString:colorHex];
#endif
    return randomRGBColor;
}

+ (NSArray *)beautifulColors {
    static NSArray *colorHexStrArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorHexStrArray = [colorValues componentsSeparatedByString:@","];
    });
    return colorHexStrArray;
}


+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSString *strippedString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:strippedString];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [UIColor colorWithRGBHex:hexNum];
}

@end
