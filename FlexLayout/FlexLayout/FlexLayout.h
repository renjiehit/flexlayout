//
//  FlexLayout.h
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/4.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FLEnums.h"
#import "FlexLayoutProtocol.h"

@interface FlexLayout : NSObject

@property (nonatomic, readwrite, assign, setter=setEnabled:) BOOL isEnabled;
@property (nonatomic, readonly, assign) BOOL isLeaf;

- (FlexLayout * (^)(FLDirection direction))fl_direction;
- (FlexLayout * (^)(FLFlexDirection flexDirection))fl_flexDirection;
- (FlexLayout * (^)(FLJustify justifyContent))fl_justifyContent;
- (FlexLayout * (^)(FLAlign alignContent))fl_alignContent;
- (FlexLayout * (^)(FLAlign alignItems))fl_alignItems;
- (FlexLayout * (^)(FLAlign alignSelf))fl_alignSelf;
- (FlexLayout * (^)(FLPositionType position))fl_position;
- (FlexLayout * (^)(FLWrap flexWrap))fl_flexWrap;
- (FlexLayout * (^)(FLOverflow overflow))fl_overflow;
- (FlexLayout * (^)(FLDisplay display))fl_display;

- (FlexLayout * (^)(CGFloat flexGrow))fl_flexGrow;
- (FlexLayout * (^)(CGFloat flexShrink))fl_flexShrink;
- (FlexLayout * (^)(CGFloat flexBasis))fl_flexBasis;

- (FlexLayout * (^)(CGFloat top))fl_top;
- (FlexLayout * (^)(CGFloat left))fl_left;
- (FlexLayout * (^)(CGFloat bottom))fl_bottom;
- (FlexLayout * (^)(CGFloat right))fl_right;
- (FlexLayout * (^)(CGFloat start))fl_start;
- (FlexLayout * (^)(CGFloat end))fl_end;

- (FlexLayout * (^)(CGFloat marginTop))fl_marginTop;
- (FlexLayout * (^)(CGFloat marginLeft))fl_marginLeft;
- (FlexLayout * (^)(CGFloat marginBottom))fl_marginBottom;
- (FlexLayout * (^)(CGFloat marginRight))fl_marginRight;
- (FlexLayout * (^)(CGFloat marginStart))fl_marginStart;
- (FlexLayout * (^)(CGFloat marginEnd))fl_marginEnd;
- (FlexLayout * (^)(CGFloat marginHorizontal))fl_marginHorizontal;
- (FlexLayout * (^)(CGFloat marginVertical))fl_marginVertical;
- (FlexLayout * (^)(CGFloat margin))fl_margin;

- (FlexLayout * (^)(CGFloat paddingTop))fl_paddingTop;
- (FlexLayout * (^)(CGFloat paddingLeft))fl_paddingLeft;
- (FlexLayout * (^)(CGFloat paddingBottom))fl_paddingBottom;
- (FlexLayout * (^)(CGFloat paddingRight))fl_paddingRight;
- (FlexLayout * (^)(CGFloat paddingStart))fl_paddingStart;
- (FlexLayout * (^)(CGFloat paddingEnd))fl_paddingEnd;
- (FlexLayout * (^)(CGFloat paddingHorizontal))fl_paddingHorizontal;
- (FlexLayout * (^)(CGFloat paddingVertical))fl_paddingVertical;
- (FlexLayout * (^)(CGFloat padding))fl_padding;

- (FlexLayout * (^)(CGFloat width))fl_width;
- (FlexLayout * (^)(CGFloat height))fl_height;
- (FlexLayout * (^)(CGFloat minWidth))fl_minWidth;
- (FlexLayout * (^)(CGFloat minHeight))fl_minHeight;
- (FlexLayout * (^)(CGFloat maxWidth))fl_maxWidth;
- (FlexLayout * (^)(CGFloat maxHeight))fl_maxHeight;

- (FlexLayout * (^)(CGFloat aspectRatio))fl_aspectRatio;

- (FlexLayout * (^)(id<FLElement> child))addChild;
- (FlexLayout * (^)(NSArray *children))children;
- (FlexLayout * (^)(NSArray *children))addChildren;

- (FlexLayout *)define:(void(^)(FlexLayout *flex))flex;

- (instancetype)init __attribute__((unavailable("you are not meant to initialise FlexLayout")));
- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin;
- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin dimensionFlexibility:(FLDimensionFlexibility)dimensionFlexibility;
- (CGSize)calculateLayoutWithSize:(CGSize)size;

@end
