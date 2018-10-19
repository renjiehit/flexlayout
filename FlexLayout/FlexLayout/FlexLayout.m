//
//  FlexLayout.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/4.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "FlexLayout+Private.h"
#import "FlexLayoutProtocol.h"
#import "FLVirtualView.h"
#import <yoga/Yoga.h>
#import <YogaKit/YGLayout.h>

#define FL_PROPERTY(type, lowercased_name, capitalized_name)    \
- (type)lowercased_name                                         \
{                                                               \
return (type)YGNodeStyleGet##capitalized_name(self.node);       \
}                                                               \
\
- (void)set##capitalized_name:(type)lowercased_name             \
{                                                               \
YGNodeStyleSet##capitalized_name(self.node, lowercased_name);   \
}

#define FL_VALUE_PROPERTY(lowercased_name, capitalized_name)                       \
- (YGValue)lowercased_name                                                         \
{                                                                                  \
  return YGNodeStyleGet##capitalized_name(self.node);                              \
}                                                                                  \
\
- (void)set##capitalized_name:(YGValue)lowercased_name                             \
{                                                                                  \
  switch (lowercased_name.unit) {                                                  \
     case YGUnitUndefined:                                                         \
      YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value);          \
      break;                                                                       \
    case YGUnitPoint:                                                              \
      YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value);          \
      break;                                                                       \
    case YGUnitPercent:                                                            \
      YGNodeStyleSet##capitalized_name##Percent(self.node, lowercased_name.value); \
      break;                                                                       \
    default:                                                                       \
      NSAssert(NO, @"Not implemented");                                            \
  }                                                                                \
}

#define FL_AUTO_VALUE_PROPERTY(lowercased_name, capitalized_name)                  \
- (YGValue)lowercased_name                                                         \
{                                                                                  \
  return YGNodeStyleGet##capitalized_name(self.node);                              \
}                                                                                  \
\
- (void)set##capitalized_name:(YGValue)lowercased_name                             \
{                                                                                  \
  switch (lowercased_name.unit) {                                                  \
    case YGUnitPoint:                                                              \
      YGNodeStyleSet##capitalized_name(self.node, lowercased_name.value);          \
      break;                                                                       \
    case YGUnitPercent:                                                            \
      YGNodeStyleSet##capitalized_name##Percent(self.node, lowercased_name.value); \
      break;                                                                       \
    case YGUnitAuto:                                                               \
      YGNodeStyleSet##capitalized_name##Auto(self.node);                           \
      break;                                                                       \
    default:                                                                       \
      NSAssert(NO, @"Not implemented");                                            \
  }                                                                                \
}

#define FL_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)   \
FL_EDGE_PROPERTY_GETTER(YGValue, lowercased_name, capitalized_name, property, edge) \
FL_VALUE_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define FL_EDGE_PROPERTY_GETTER(type, lowercased_name, capitalized_name, property, edge) \
- (type)lowercased_name                                                                  \
{                                                                                        \
return YGNodeStyleGet##property(self.node, edge);                                      \
}

#define FL_VALUE_EDGE_PROPERTY_SETTER(objc_lowercased_name, objc_capitalized_name, c_name, edge) \
- (void)set##objc_capitalized_name:(YGValue)objc_lowercased_name                                 \
{                                                                                                \
switch (objc_lowercased_name.unit) {                                                           \
case YGUnitUndefined:                                                                        \
YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value);                       \
break;                                                                                     \
case YGUnitPoint:                                                                            \
YGNodeStyleSet##c_name(self.node, edge, objc_lowercased_name.value);                       \
break;                                                                                     \
case YGUnitPercent:                                                                          \
YGNodeStyleSet##c_name##Percent(self.node, edge, objc_lowercased_name.value);              \
break;                                                                                     \
default:                                                                                     \
NSAssert(NO, @"Not implemented");                                                          \
}                                                                                              \
}

#define FL_EDGE_PROPERTY_GETTER(type, lowercased_name, capitalized_name, property, edge) \
- (type)lowercased_name                                                                  \
{                                                                                        \
return YGNodeStyleGet##property(self.node, edge);                                      \
}

#define FL_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge) \
- (void)set##capitalized_name:(CGFloat)lowercased_name                             \
{                                                                                  \
YGNodeStyleSet##property(self.node, edge, lowercased_name);                      \
}

#define FL_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, property, edge)   \
FL_EDGE_PROPERTY_GETTER(YGValue, lowercased_name, capitalized_name, property, edge) \
FL_VALUE_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge)

#define FL_VALUE_EDGES_PROPERTIES(lowercased_name, capitalized_name)                                                  \
FL_VALUE_EDGE_PROPERTY(lowercased_name##Left, capitalized_name##Left, capitalized_name, YGEdgeLeft)                   \
FL_VALUE_EDGE_PROPERTY(lowercased_name##Top, capitalized_name##Top, capitalized_name, YGEdgeTop)                      \
FL_VALUE_EDGE_PROPERTY(lowercased_name##Right, capitalized_name##Right, capitalized_name, YGEdgeRight)                \
FL_VALUE_EDGE_PROPERTY(lowercased_name##Bottom, capitalized_name##Bottom, capitalized_name, YGEdgeBottom)             \
FL_VALUE_EDGE_PROPERTY(lowercased_name##Start, capitalized_name##Start, capitalized_name, YGEdgeStart)                \
FL_VALUE_EDGE_PROPERTY(lowercased_name##End, capitalized_name##End, capitalized_name, YGEdgeEnd)                      \
FL_VALUE_EDGE_PROPERTY(lowercased_name##Horizontal, capitalized_name##Horizontal, capitalized_name, YGEdgeHorizontal) \
FL_VALUE_EDGE_PROPERTY(lowercased_name##Vertical, capitalized_name##Vertical, capitalized_name, YGEdgeVertical)       \
FL_VALUE_EDGE_PROPERTY(lowercased_name, capitalized_name, capitalized_name, YGEdgeAll)

static YGConfigRef flexConfig;

@interface FlexLayout () {
    /**
     * children数组中存放的是child element，不是child flex。原因在于：因为存在虚拟节点，虚拟节点不会进入view hierarchy,
     * 虚拟节点强持有flex，但flex弱持有虚拟节点，这样就导致没有对象持有虚拟节点，会造成虚拟节点的自动释放。结果是虚拟节点的flex存在，
     * 但虚拟节点不存在了。
     */
    NSMutableArray *_children;
}

@property (nonatomic, weak, readonly) id<FLElement> element;
@property (nonatomic, readonly) NSMutableArray *flexChildren;
@property (nonatomic, weak) FlexLayout *parentLayout;

@end

@implementation FlexLayout
@synthesize flexChildren = _children;

+ (void)initialize
{
    flexConfig = YGConfigNew();
    YGConfigSetExperimentalFeatureEnabled(flexConfig, YGExperimentalFeatureWebFlexBasis, true);
    YGConfigSetPointScaleFactor(flexConfig, [UIScreen mainScreen].scale);
}

- (void)dealloc {
    YGNodeFree(self.node);
}

- (instancetype)initWithElement:(id<FLElement>)element {
    self = [super init];
    if (self) {
        _element = element;
        _node = YGNodeNewWithConfig(flexConfig);
        YGNodeSetContext(_node, (__bridge void *)element);
        _children = [NSMutableArray array];
        _isEnabled = YES;
        
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@:%p> element:%@", [self class], &self, self.element];
}

#pragma mark - property methods

- (BOOL)isLeaf {
    NSAssert([NSThread isMainThread], @"This method must be called on the main thread.");
    if (self.isEnabled) {
        if (self.element.isVirtualView) { // virtual element can not be leaf element
            return NO;
        }
        
        for (id<FLElement> element in _children) {
            if (element.flex.isEnabled) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

#pragma mark - private method

- (void)addChild:(id<FLElement>)child {
    child.flex.parentLayout = self;
    [_children addObject:child];
    FLAddElementToViewHierarchy(child, self.element);
    YGNodeInsertChild(_node, child.flex.node, YGNodeGetChildCount(_node));
}

- (void)addChildren:(NSArray *)children {
    for (id<FLElement> child in children) {
        [self addChild:child];
    }
}

- (void)removeChild:(id<FLElement>)child {
    child.flex.parentLayout = nil;
    [_children removeObject:child];
    FLRemoveElementFromViewHierarchy(child);
    YGNodeRemoveChild(_node, child.flex.node);
}

- (void)removeAllChildren {
    for (id<FLElement> element in _children) { //
        FLRemoveElementFromViewHierarchy(element);
        element.flex.parentLayout = nil;
    }
    
    [_children removeAllObjects];
    while (YGNodeGetChildCount(_node) > 0) {
        YGNodeRemoveChild(_node, YGNodeGetChild(_node, YGNodeGetChildCount(_node) - 1));
    }
}

#pragma mark - method chaining block
- (FlexLayout *(^)(FLDirection direction))fl_direction {
    return ^FlexLayout *(FLDirection direction) {
        [self setDirection:(YGDirection)direction];
        return self;
    };
}

- (FlexLayout * (^)(FLFlexDirection flexDirection))fl_flexDirection {
    return ^FlexLayout *(FLFlexDirection flexDirection) {
        [self setFlexDirection:(YGFlexDirection)flexDirection];
        return self;
    };
}

- (FlexLayout * (^)(FLJustify justifyContent))fl_justifyContent {
    return ^FlexLayout *(FLJustify justifyContent) {
        [self setJustifyContent:(YGJustify)justifyContent];
        return self;
    };
}

- (FlexLayout * (^)(FLAlign alignContent))fl_alignContent {
    return ^FlexLayout *(FLAlign alignContent) {
        [self setAlignContent:(YGAlign)alignContent];
        return self;
    };
}

- (FlexLayout * (^)(FLAlign alignItems))fl_alignItems {
    return ^FlexLayout *(FLAlign alignItems) {
        [self setAlignItems:(YGAlign)alignItems];
        return self;
    };
}

- (FlexLayout * (^)(FLAlign alignSelf))fl_alignSelf {
    return ^FlexLayout *(FLAlign alignSelf) {
        [self setAlignSelf:(YGAlign)alignSelf];
        return self;
    };
}

- (FlexLayout * (^)(FLPositionType position))fl_position {
    return ^FlexLayout *(FLPositionType position) {
        [self setPosition:(YGPositionType)position];
        return self;
    };
}

- (FlexLayout * (^)(FLWrap flexWrap))fl_flexWrap {
    return ^FlexLayout *(FLWrap flexWrap) {
        [self setFlexWrap:(YGWrap)flexWrap];
        return self;
    };
}

- (FlexLayout * (^)(FLOverflow overflow))fl_overflow {
    return ^FlexLayout *(FLOverflow overflow) {
        [self setOverflow:(YGOverflow)overflow];
        return self;
    };
}

- (FlexLayout * (^)(FLDisplay display))fl_display {
    return ^FlexLayout *(FLDisplay display) {
        [self setDisplay:(YGDisplay)display];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat flexGrow))fl_flexGrow {
    return ^FlexLayout *(CGFloat flexGrow) {
        [self setFlexGrow:flexGrow];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat flexShrink))fl_flexShrink {
    return ^FlexLayout *(CGFloat flexShrink) {
        [self setFlexShrink:flexShrink];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat flexBasis))fl_flexBasis {
    return ^FlexLayout *(CGFloat flexBasis) {
        [self setFlexBasis:YGPointValue(flexBasis)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat top))fl_top {
    return ^FlexLayout *(CGFloat top) {
        [self setTop:YGPointValue(top)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat left))fl_left {
    return ^FlexLayout *(CGFloat left) {
        [self setLeft:YGPointValue(left)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat bottom))fl_bottom {
    return ^FlexLayout *(CGFloat bottom) {
        [self setBottom:YGPointValue(bottom)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat right))fl_right {
    return ^FlexLayout *(CGFloat right) {
        [self setRight:YGPointValue(right)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat start))fl_start {
    return ^FlexLayout *(CGFloat start) {
        [self setStart:YGPointValue(start)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat end))fl_end {
    return ^FlexLayout *(CGFloat end) {
        [self setEnd:YGPointValue(end)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginTop))fl_marginTop {
    return ^FlexLayout *(CGFloat marginTop) {
        [self setMarginTop:YGPointValue(marginTop)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginLeft))fl_marginLeft {
    return ^FlexLayout *(CGFloat marginLeft) {
        [self setMarginLeft:YGPointValue(marginLeft)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginBottom))fl_marginBottom {
    return ^FlexLayout *(CGFloat marginBottom) {
        [self setMarginBottom:YGPointValue(marginBottom)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginRight))fl_marginRight {
    return ^FlexLayout *(CGFloat marginRight) {
        [self setMarginRight:YGPointValue(marginRight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginStart))fl_marginStart {
    return ^FlexLayout *(CGFloat marginStart) {
        [self setMarginStart:YGPointValue(marginStart)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginEnd))fl_marginEnd {
    return ^FlexLayout *(CGFloat marginEnd) {
        [self setMarginEnd:YGPointValue(marginEnd)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginHorizontal))fl_marginHorizontal {
    return ^FlexLayout *(CGFloat marginHorizontal) {
        [self setMarginHorizontal:YGPointValue(marginHorizontal)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginVertical))fl_marginVertical {
    return ^FlexLayout *(CGFloat marginVertical) {
        [self setMarginVertical:YGPointValue(marginVertical)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat margin))fl_margin {
    return ^FlexLayout *(CGFloat margin) {
        [self setMargin:YGPointValue(margin)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingTop))fl_paddingTop {
    return ^FlexLayout *(CGFloat paddingTop) {
        [self setPaddingTop:YGPointValue(paddingTop)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingLeft))fl_paddingLeft {
    return ^FlexLayout *(CGFloat paddingLeft) {
        [self setPaddingLeft:YGPointValue(paddingLeft)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingBottom))fl_paddingBottom {
    return ^FlexLayout *(CGFloat paddingBottom) {
        [self setPaddingBottom:YGPointValue(paddingBottom)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingRight))fl_paddingRight {
    return ^FlexLayout *(CGFloat paddingRight) {
        [self setPaddingRight:YGPointValue(paddingRight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingStart))fl_paddingStart {
    return ^FlexLayout *(CGFloat paddingStart) {
        [self setPaddingStart:YGPointValue(paddingStart)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingEnd))fl_paddingEnd {
    return ^FlexLayout *(CGFloat paddingEnd) {
        [self setPaddingEnd:YGPointValue(paddingEnd)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingHorizontal))fl_paddingHorizontal {
    return ^FlexLayout *(CGFloat paddingHorizontal) {
        [self setPaddingHorizontal:YGPointValue(paddingHorizontal)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingVertical))fl_paddingVertical {
    return ^FlexLayout *(CGFloat paddingVertical) {
        [self setPaddingVertical:YGPointValue(paddingVertical)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat padding))fl_padding {
    return ^FlexLayout *(CGFloat padding) {
        [self setPadding:YGPointValue(padding)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat width))fl_width {
    return ^FlexLayout *(CGFloat width) {
        [self setWidth:YGPointValue(width)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat height))fl_height {
    return ^FlexLayout *(CGFloat height) {
        [self setHeight:YGPointValue(height)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat minWidth))fl_minWidth {
    return ^FlexLayout *(CGFloat minWidth) {
        [self setMinWidth:YGPointValue(minWidth)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat minHeight))fl_minHeight {
    return ^FlexLayout *(CGFloat minHeight) {
        [self setMinHeight:YGPointValue(minHeight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat maxWidth))fl_maxWidth {
    return ^FlexLayout *(CGFloat maxWidth) {
        [self setMaxWidth:YGPointValue(maxWidth)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat maxHeight))fl_maxHeight {
    return ^FlexLayout *(CGFloat maxHeight) {
        [self setMaxHeight:YGPointValue(maxHeight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat aspectRatio))fl_aspectRatio {
    return ^FlexLayout *(CGFloat aspectRatio) {
        [self setAspectRatio:aspectRatio];
        return self;
    };
}

- (FlexLayout * (^)(id<FLElement> child))addChild {
    return ^FlexLayout *(id<FLElement> child) {
        [self addChild:child];
        return child.flex;
    };
}

- (FlexLayout * (^)(NSArray *children))children {
    return ^FlexLayout *(NSArray *children) {
        [self removeAllChildren];
        [self addChildren:children];
        return self;
    };
}

- (FlexLayout * (^)(NSArray *children))addChildren {
    return ^FlexLayout *(NSArray *children) {
        [self addChildren:children];
        return self;
    };
}

- (FlexLayout *)define:(void (^)(FlexLayout *))flex {
    if (flex) {
        flex(self);
    }
    return self;
}

#pragma mark - public calc methods

- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin {
    [self calculateLayoutWithSize:self.element.frame.size];
    FLApplyLayoutToViewHierarchy(self.element, nil, preservingOrigin);
}

- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin dimensionFlexibility:(FLDimensionFlexibility)dimensionFlexibility {
    CGSize size = self.element.frame.size;
    if (dimensionFlexibility & FLDimensionFlexibleWidth) {
        size.width = YGUndefined;
    }
    if (dimensionFlexibility & FLDimensionFlexibleHeight) {
        size.height = YGUndefined;
    }
    [self calculateLayoutWithSize:size];
    FLApplyLayoutToViewHierarchy(self.element, nil, preservingOrigin);
}

- (CGSize)calculateLayoutWithSize:(CGSize)size {
    NSAssert([NSThread isMainThread], @"Flexlayout calculation must be done on main.");
    NSAssert(self.isEnabled, @"Flexlayout is not enabled for this view.");
    
    FLSetMeasureFunction(self);
    
    const YGNodeRef node = self.node;
    YGNodeCalculateLayout(
                          node,
                          size.width,
                          size.height,
                          YGNodeStyleGetDirection(node));
    
    CGSize finalSize = (CGSize) {
        .width = YGNodeLayoutGetWidth(node),
        .height = YGNodeLayoutGetHeight(node),
    };
    return finalSize;
}

#pragma mark - Style

- (YGPositionType)position {
    return YGNodeStyleGetPositionType(self.node);
}

- (void)setPosition:(YGPositionType)position {
    YGNodeStyleSetPositionType(self.node, position);
}

FL_PROPERTY(YGDirection, direction, Direction)
FL_PROPERTY(YGFlexDirection, flexDirection, FlexDirection)
FL_PROPERTY(YGJustify, justifyContent, JustifyContent)
FL_PROPERTY(YGAlign, alignContent, AlignContent)
FL_PROPERTY(YGAlign, alignItems, AlignItems)
FL_PROPERTY(YGAlign, alignSelf, AlignSelf)
FL_PROPERTY(YGWrap, flexWrap, FlexWrap)
FL_PROPERTY(YGOverflow, overflow, Overflow)
FL_PROPERTY(YGDisplay, display, Display)

FL_PROPERTY(CGFloat, flexGrow, FlexGrow)
FL_PROPERTY(CGFloat, flexShrink, FlexShrink)
FL_AUTO_VALUE_PROPERTY(flexBasis, FlexBasis)

FL_VALUE_EDGE_PROPERTY(left, Left, Position, YGEdgeLeft)
FL_VALUE_EDGE_PROPERTY(top, Top, Position, YGEdgeTop)
FL_VALUE_EDGE_PROPERTY(right, Right, Position, YGEdgeRight)
FL_VALUE_EDGE_PROPERTY(bottom, Bottom, Position, YGEdgeBottom)
FL_VALUE_EDGE_PROPERTY(start, Start, Position, YGEdgeStart)
FL_VALUE_EDGE_PROPERTY(end, End, Position, YGEdgeEnd)

FL_VALUE_EDGES_PROPERTIES(margin, Margin)
FL_VALUE_EDGES_PROPERTIES(padding, Padding)

FL_AUTO_VALUE_PROPERTY(width, Width)
FL_AUTO_VALUE_PROPERTY(height, Height)
FL_VALUE_PROPERTY(minWidth, MinWidth)
FL_VALUE_PROPERTY(minHeight, MinHeight)
FL_VALUE_PROPERTY(maxWidth, MaxWidth)
FL_VALUE_PROPERTY(maxHeight, MaxHeight)
FL_PROPERTY(CGFloat, aspectRatio, AspectRatio)

#pragma mark - private C methods

static CGFloat FLRoundPixelValue(CGFloat value)
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    
    return roundf(value * scale) / scale;
}

static CGFloat FLSanitizeMeasurement(
                                     CGFloat constrainedSize,
                                     CGFloat measuredSize,
                                     YGMeasureMode measureMode)
{
    CGFloat result;
    if (measureMode == YGMeasureModeExactly) {
        result = constrainedSize;
    } else if (measureMode == YGMeasureModeAtMost) {
        result = MIN(constrainedSize, measuredSize);
    } else {
        result = measuredSize;
    }
    
    return result;
}


static YGSize FLMeasureView(
                            YGNodeRef node,
                            float width,
                            YGMeasureMode widthMode,
                            float height,
                            YGMeasureMode heightMode)
{
    const CGFloat constrainedWidth = (widthMode == YGMeasureModeUndefined) ? CGFLOAT_MAX : width;
    const CGFloat constrainedHeight = (heightMode == YGMeasureModeUndefined) ? CGFLOAT_MAX: height;
    
    UIView *view = (__bridge UIView*) YGNodeGetContext(node);
    __block CGSize sizeThatFits;
    if ([[NSThread currentThread] isMainThread]) {
        sizeThatFits = [view sizeThatFits:(CGSize) {
            .width = constrainedWidth,
            .height = constrainedHeight,
        }];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            sizeThatFits = [view sizeThatFits:(CGSize) {
                .width = constrainedWidth,
                .height = constrainedHeight,
            }];
        });
    }
    return (YGSize) {
        .width = FLSanitizeMeasurement(constrainedWidth, sizeThatFits.width, widthMode),
        .height = FLSanitizeMeasurement(constrainedHeight, sizeThatFits.height, heightMode),
    };
}

static void FLSetMeasureFunction(FlexLayout *flex) {
    const YGNodeRef node = flex.node;
    if (flex.isLeaf) {
        YGNodeSetMeasureFunc(node, FLMeasureView);
    } else {
        YGNodeSetMeasureFunc(node, NULL);

        for (id<FLElement> child in flex.flexChildren) {
            FLSetMeasureFunction(child.flex);
        }
    }
}

static void FLApplyLayoutToViewHierarchy(id<FLElement> element,
                                         id<FLElement> parentElement,
                                         BOOL preserveOrigin) {
    NSCAssert([NSThread isMainThread], @"Framesetting should only be done on the main thread.");
    
    const FlexLayout *flex = element.flex;
    
    YGNodeRef node = flex.node;
    const CGPoint topLeft = {
        YGNodeLayoutGetLeft(node),
        YGNodeLayoutGetTop(node),
    };
    
    const CGPoint bottomRight = {
        topLeft.x + YGNodeLayoutGetWidth(node),
        topLeft.y + YGNodeLayoutGetHeight(node),
    };
    
    BOOL needToAddParentOrigin = parentElement && parentElement.isVirtualView;
    const CGPoint origin = preserveOrigin ? element.frame.origin : (needToAddParentOrigin ? parentElement.frame.origin : CGPointZero);
    element.frame = (CGRect) {
        .origin = {
            .x = FLRoundPixelValue(topLeft.x + origin.x),
            .y = FLRoundPixelValue(topLeft.y + origin.y),
        },
        .size = {
            .width = FLRoundPixelValue(bottomRight.x) - FLRoundPixelValue(topLeft.x),
            .height = FLRoundPixelValue(bottomRight.y) - FLRoundPixelValue(topLeft.y),
        },
    };
    
    if (!flex.isLeaf) {
        for (id<FLElement> childElement in flex.flexChildren) {
            FLApplyLayoutToViewHierarchy(childElement, element, NO);
        }
    }
}

static void FLAddElementToViewHierarchy(id<FLElement> element, id<FLElement> parentElement) {
    UIView *parentView = nil;
    while (parentElement) { // 找出实体父View
        if (parentElement.isVirtualView == NO) {
            parentView = parentElement.view;
            break;
        } else {
            parentElement = parentElement.flex.parentLayout.element;
        }
    }
    if (parentView == nil) { // 找不到，则代表还没有实体root view，放弃add subview
        return;
    }
    
    FLAddElementToParentView(element, parentView);
}

static void FLAddElementToParentView(id<FLElement> element, UIView *parentView) {
    if (element.isVirtualView == NO) {
        [parentView addSubview:element.view];
        return;
    } else {
        for (id<FLElement> childElement in element.flex.flexChildren) {
            FLAddElementToParentView(childElement, parentView);
        }
    }
}

static void FLRemoveElementFromViewHierarchy(id<FLElement> element) {
    if (element.isVirtualView == NO) {
        [element.view removeFromSuperview];
        return;
    } else {
        for (id<FLElement> childElement in element.flex.flexChildren) {
            FLRemoveElementFromViewHierarchy(childElement);
        }
    }
}

@end
