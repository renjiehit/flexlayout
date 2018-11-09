//
//  FlexLayout+Properties.h
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/11/8.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "FlexLayout.h"
#import <yoga/Yoga.h>

/*
 * 半开放FlexLayout的常规读写属性，为一些特殊场合制定。推荐使用链式调用
 */

@interface FlexLayout ()

@property (nonatomic, readwrite, assign) FLDirection flDirection;
@property (nonatomic, readwrite, assign) FLFlexDirection flFlexDirection;
@property (nonatomic, readwrite, assign) FLJustify flJustifyContent;
@property (nonatomic, readwrite, assign) FLAlign flAlignContent;
@property (nonatomic, readwrite, assign) FLAlign flAlignItems;
@property (nonatomic, readwrite, assign) FLAlign flAlignSelf;
@property (nonatomic, readwrite, assign) FLPositionType flPosition;
@property (nonatomic, readwrite, assign) FLWrap flFlexWrap;
@property (nonatomic, readwrite, assign) FLOverflow flOverflow;
@property (nonatomic, readwrite, assign) FLDisplay flDisplay;

@property (nonatomic, readwrite, assign) CGFloat flFlexGrow;
@property (nonatomic, readwrite, assign) CGFloat flFlexShrink;
@property (nonatomic, readwrite, assign) FLValue flFlexBasis;

@property (nonatomic, readwrite, assign) FLValue flLeft;
@property (nonatomic, readwrite, assign) FLValue flTop;
@property (nonatomic, readwrite, assign) FLValue flRight;
@property (nonatomic, readwrite, assign) FLValue flBottom;
@property (nonatomic, readwrite, assign) FLValue flStart;
@property (nonatomic, readwrite, assign) FLValue flEnd;

@property (nonatomic, readwrite, assign) FLValue flMarginLeft;
@property (nonatomic, readwrite, assign) FLValue flMarginTop;
@property (nonatomic, readwrite, assign) FLValue flMarginRight;
@property (nonatomic, readwrite, assign) FLValue flMarginBottom;
@property (nonatomic, readwrite, assign) FLValue flMarginStart;
@property (nonatomic, readwrite, assign) FLValue flMarginEnd;
@property (nonatomic, readwrite, assign) FLValue flMarginHorizontal;
@property (nonatomic, readwrite, assign) FLValue flMarginVertical;
@property (nonatomic, readwrite, assign) FLValue flMargin;

@property (nonatomic, readwrite, assign) FLValue flPaddingLeft;
@property (nonatomic, readwrite, assign) FLValue flPaddingTop;
@property (nonatomic, readwrite, assign) FLValue flPaddingRight;
@property (nonatomic, readwrite, assign) FLValue flPaddingBottom;
@property (nonatomic, readwrite, assign) FLValue flPaddingStart;
@property (nonatomic, readwrite, assign) FLValue flPaddingEnd;
@property (nonatomic, readwrite, assign) FLValue flPaddingHorizontal;
@property (nonatomic, readwrite, assign) FLValue flPaddingVertical;
@property (nonatomic, readwrite, assign) FLValue flPadding;

@property (nonatomic, readwrite, assign) FLValue flWidth;
@property (nonatomic, readwrite, assign) FLValue flHeight;
@property (nonatomic, readwrite, assign) FLValue flMinWidth;
@property (nonatomic, readwrite, assign) FLValue flMinHeight;
@property (nonatomic, readwrite, assign) FLValue flMaxWidth;
@property (nonatomic, readwrite, assign) FLValue flMaxHeight;

// Yoga specific properties, not compatible with flexbox specification
@property (nonatomic, readwrite, assign) CGFloat flAspectRatio;

@end
