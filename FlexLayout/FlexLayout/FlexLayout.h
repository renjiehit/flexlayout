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

- (FlexLayout * (^)(FLDirection direction))layoutDirection;
- (FlexLayout * (^)(FLFlexDirection flexDirection))direction;
- (FlexLayout * (^)(FLJustify justifyContent))justifyContent;
- (FlexLayout * (^)(FLAlign alignContent))alignContent;
- (FlexLayout * (^)(FLAlign alignItems))alignItems;
- (FlexLayout * (^)(FLAlign alignSelf))alignSelf;
- (FlexLayout * (^)(FLPositionType position))position;
- (FlexLayout * (^)(FLWrap flexWrap))wrap;
- (FlexLayout * (^)(FLOverflow overflow))overflow;
- (FlexLayout * (^)(FLDisplay display))display;

- (FlexLayout * (^)(CGFloat flexGrow))grow;
- (FlexLayout * (^)(CGFloat flexShrink))shrink;
- (FlexLayout * (^)(CGFloat flexBasis))flexBasis;

- (FlexLayout * (^)(CGFloat top))top;
- (FlexLayout * (^)(CGFloat left))left;
- (FlexLayout * (^)(CGFloat bottom))bottom;
- (FlexLayout * (^)(CGFloat right))right;
- (FlexLayout * (^)(CGFloat start))start;
- (FlexLayout * (^)(CGFloat end))end;

- (FlexLayout * (^)(CGFloat marginTop))marginTop;
- (FlexLayout * (^)(CGFloat marginLeft))marginLeft;
- (FlexLayout * (^)(CGFloat marginBottom))marginBottom;
- (FlexLayout * (^)(CGFloat marginRight))marginRight;
- (FlexLayout * (^)(CGFloat marginStart))marginStart;
- (FlexLayout * (^)(CGFloat marginEnd))marginEnd;
- (FlexLayout * (^)(CGFloat marginHorizontal))marginHorizontal;
- (FlexLayout * (^)(CGFloat marginVertical))marginVertical;
- (FlexLayout * (^)(CGFloat margin))margin;

- (FlexLayout * (^)(CGFloat paddingTop))paddingTop;
- (FlexLayout * (^)(CGFloat paddingLeft))paddingLeft;
- (FlexLayout * (^)(CGFloat paddingBottom))paddingBottom;
- (FlexLayout * (^)(CGFloat paddingRight))paddingRight;
- (FlexLayout * (^)(CGFloat paddingStart))paddingStart;
- (FlexLayout * (^)(CGFloat paddingEnd))paddingEnd;
- (FlexLayout * (^)(CGFloat paddingHorizontal))paddingHorizontal;
- (FlexLayout * (^)(CGFloat paddingVertical))paddingVertical;
- (FlexLayout * (^)(CGFloat padding))padding;

- (FlexLayout * (^)(CGFloat width))width;
- (FlexLayout * (^)(CGFloat height))height;
- (FlexLayout * (^)(CGFloat minWidth))minWidth;
- (FlexLayout * (^)(CGFloat minHeight))minHeight;
- (FlexLayout * (^)(CGFloat maxWidth))maxWidth;
- (FlexLayout * (^)(CGFloat maxHeight))maxHeight;

- (FlexLayout * (^)(CGFloat aspectRatio))aspectRatio;

- (FlexLayout * (^)(id<FLElement> child))addChild;
- (FlexLayout * (^)(NSArray *children))children;
- (FlexLayout * (^)(NSArray *children))addChildren;

- (FlexLayout *)define:(void(^)(FlexLayout *flex))flex;

- (instancetype)init __attribute__((unavailable("you are not meant to initialise FlexLayout")));
- (void)applyLayout:(FLLayoutMode)layoutMode;
- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin;
- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin layoutMode:(FLLayoutMode)layoutMode;
- (CGSize)calculateLayoutWithSize:(CGSize)size;

@end
