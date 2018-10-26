//
//  FlexLayout.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/4.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "FlexLayout+Private.h"
#import "FlexLayoutProtocol.h"
#import <yoga/Yoga.h>

#define FL_PROPERTY(type, lowercased_name, capitalized_name)    \
- (type)fl_##lowercased_name                                         \
{                                                               \
return (type)YGNodeStyleGet##capitalized_name(self.node);       \
}                                                               \
\
- (void)fl_set##capitalized_name:(type)lowercased_name             \
{                                                               \
YGNodeStyleSet##capitalized_name(self.node, lowercased_name);   \
}

#define FL_VALUE_PROPERTY(lowercased_name, capitalized_name)                       \
- (YGValue)fl_##lowercased_name                                                         \
{                                                                                  \
  return YGNodeStyleGet##capitalized_name(self.node);                              \
}                                                                                  \
\
- (void)fl_set##capitalized_name:(YGValue)lowercased_name                             \
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
- (YGValue)fl_##lowercased_name                                                         \
{                                                                                  \
  return YGNodeStyleGet##capitalized_name(self.node);                              \
}                                                                                  \
\
- (void)fl_set##capitalized_name:(YGValue)lowercased_name                             \
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

#define FL_VALUE_EDGE_PROPERTY_SETTER(objc_lowercased_name, objc_capitalized_name, c_name, edge) \
- (void)fl_set##objc_capitalized_name:(YGValue)objc_lowercased_name                                 \
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
- (type)fl_##lowercased_name                                                                  \
{                                                                                        \
return YGNodeStyleGet##property(self.node, edge);                                      \
}

#define FL_EDGE_PROPERTY_SETTER(lowercased_name, capitalized_name, property, edge) \
- (void)fl_set##capitalized_name:(CGFloat)lowercased_name                             \
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

- (void)markDirty {
    if (self.isDirty || !self.isLeaf) {
        return;
    }
    
    // Yoga is not happy if we try to mark a node as "dirty" before we have set
    // the measure function. Since we already know that this is a leaf,
    // this *should* be fine. Forgive me Hack Gods.
    const YGNodeRef node = self.node;
    if (YGNodeGetMeasureFunc(node) == NULL) {
        YGNodeSetMeasureFunc(node, FLMeasureView);
    }
    
    YGNodeMarkDirty(node);
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

- (BOOL)isDirty {
    return YGNodeIsDirty(self.node);
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
- (FlexLayout *(^)(FLDirection direction))layoutDirection {
    return ^FlexLayout *(FLDirection direction) {
        [self fl_setDirection:(YGDirection)direction];
        return self;
    };
}

- (FlexLayout * (^)(FLFlexDirection flexDirection))direction {
    return ^FlexLayout *(FLFlexDirection flexDirection) {
        [self fl_setFlexDirection:(YGFlexDirection)flexDirection];
        return self;
    };
}

- (FlexLayout * (^)(FLJustify justifyContent))justifyContent {
    return ^FlexLayout *(FLJustify justifyContent) {
        [self fl_setJustifyContent:(YGJustify)justifyContent];
        return self;
    };
}

- (FlexLayout * (^)(FLAlign alignContent))alignContent {
    return ^FlexLayout *(FLAlign alignContent) {
        [self fl_setAlignContent:(YGAlign)alignContent];
        return self;
    };
}

- (FlexLayout * (^)(FLAlign alignItems))alignItems {
    return ^FlexLayout *(FLAlign alignItems) {
        [self fl_setAlignItems:(YGAlign)alignItems];
        return self;
    };
}

- (FlexLayout * (^)(FLAlign alignSelf))alignSelf {
    return ^FlexLayout *(FLAlign alignSelf) {
        [self fl_setAlignSelf:(YGAlign)alignSelf];
        return self;
    };
}

- (FlexLayout * (^)(FLPositionType position))position {
    return ^FlexLayout *(FLPositionType position) {
        [self fl_setPosition:(YGPositionType)position];
        return self;
    };
}

- (FlexLayout * (^)(FLWrap flexWrap))wrap {
    return ^FlexLayout *(FLWrap flexWrap) {
        [self fl_setFlexWrap:(YGWrap)flexWrap];
        return self;
    };
}

- (FlexLayout * (^)(FLOverflow overflow))overflow {
    return ^FlexLayout *(FLOverflow overflow) {
        [self fl_setOverflow:(YGOverflow)overflow];
        return self;
    };
}

- (FlexLayout * (^)(FLDisplay display))display {
    return ^FlexLayout *(FLDisplay display) {
        [self fl_setDisplay:(YGDisplay)display];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat flexGrow))grow {
    return ^FlexLayout *(CGFloat flexGrow) {
        [self fl_setFlexGrow:flexGrow];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat flexShrink))shrink {
    return ^FlexLayout *(CGFloat flexShrink) {
        [self fl_setFlexShrink:flexShrink];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat flexBasis))flexBasis {
    return ^FlexLayout *(CGFloat flexBasis) {
        [self fl_setFlexBasis:FLPointValue(flexBasis)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat top))top {
    return ^FlexLayout *(CGFloat top) {
        [self fl_setTop:FLPointValue(top)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat left))left {
    return ^FlexLayout *(CGFloat left) {
        [self fl_setLeft:FLPointValue(left)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat bottom))bottom {
    return ^FlexLayout *(CGFloat bottom) {
        [self fl_setBottom:FLPointValue(bottom)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat right))right {
    return ^FlexLayout *(CGFloat right) {
        [self fl_setRight:FLPointValue(right)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat start))start {
    return ^FlexLayout *(CGFloat start) {
        [self fl_setStart:FLPointValue(start)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat end))end {
    return ^FlexLayout *(CGFloat end) {
        [self fl_setEnd:FLPointValue(end)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginTop))marginTop {
    return ^FlexLayout *(CGFloat marginTop) {
        [self fl_setMarginTop:FLPointValue(marginTop)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginLeft))marginLeft {
    return ^FlexLayout *(CGFloat marginLeft) {
        [self fl_setMarginLeft:FLPointValue(marginLeft)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginBottom))marginBottom {
    return ^FlexLayout *(CGFloat marginBottom) {
        [self fl_setMarginBottom:FLPointValue(marginBottom)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginRight))marginRight {
    return ^FlexLayout *(CGFloat marginRight) {
        [self fl_setMarginRight:FLPointValue(marginRight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginStart))marginStart {
    return ^FlexLayout *(CGFloat marginStart) {
        [self fl_setMarginStart:FLPointValue(marginStart)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginEnd))marginEnd {
    return ^FlexLayout *(CGFloat marginEnd) {
        [self fl_setMarginEnd:FLPointValue(marginEnd)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginHorizontal))marginHorizontal {
    return ^FlexLayout *(CGFloat marginHorizontal) {
        [self fl_setMarginHorizontal:FLPointValue(marginHorizontal)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat marginVertical))marginVertical {
    return ^FlexLayout *(CGFloat marginVertical) {
        [self fl_setMarginVertical:FLPointValue(marginVertical)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat margin))margin {
    return ^FlexLayout *(CGFloat margin) {
        [self fl_setMargin:FLPointValue(margin)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingTop))paddingTop {
    return ^FlexLayout *(CGFloat paddingTop) {
        [self fl_setPaddingTop:FLPointValue(paddingTop)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingLeft))paddingLeft {
    return ^FlexLayout *(CGFloat paddingLeft) {
        [self fl_setPaddingLeft:FLPointValue(paddingLeft)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingBottom))paddingBottom {
    return ^FlexLayout *(CGFloat paddingBottom) {
        [self fl_setPaddingBottom:FLPointValue(paddingBottom)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingRight))paddingRight {
    return ^FlexLayout *(CGFloat paddingRight) {
        [self fl_setPaddingRight:FLPointValue(paddingRight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingStart))paddingStart {
    return ^FlexLayout *(CGFloat paddingStart) {
        [self fl_setPaddingStart:FLPointValue(paddingStart)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingEnd))paddingEnd {
    return ^FlexLayout *(CGFloat paddingEnd) {
        [self fl_setPaddingEnd:FLPointValue(paddingEnd)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingHorizontal))paddingHorizontal {
    return ^FlexLayout *(CGFloat paddingHorizontal) {
        [self fl_setPaddingHorizontal:FLPointValue(paddingHorizontal)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat paddingVertical))paddingVertical {
    return ^FlexLayout *(CGFloat paddingVertical) {
        [self fl_setPaddingVertical:FLPointValue(paddingVertical)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat padding))padding {
    return ^FlexLayout *(CGFloat padding) {
        [self fl_setPadding:FLPointValue(padding)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat width))width {
    return ^FlexLayout *(CGFloat width) {
        [self fl_setWidth:FLPointValue(width)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat height))height {
    return ^FlexLayout *(CGFloat height) {
        [self fl_setHeight:FLPointValue(height)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat minWidth))minWidth {
    return ^FlexLayout *(CGFloat minWidth) {
        [self fl_setMinWidth:FLPointValue(minWidth)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat minHeight))minHeight {
    return ^FlexLayout *(CGFloat minHeight) {
        [self fl_setMinHeight:FLPointValue(minHeight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat maxWidth))maxWidth {
    return ^FlexLayout *(CGFloat maxWidth) {
        [self fl_setMaxWidth:FLPointValue(maxWidth)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat maxHeight))maxHeight {
    return ^FlexLayout *(CGFloat maxHeight) {
        [self fl_setMaxHeight:FLPointValue(maxHeight)];
        return self;
    };
}

- (FlexLayout * (^)(CGFloat aspectRatio))aspectRatio {
    return ^FlexLayout *(CGFloat aspectRatio) {
        [self fl_setAspectRatio:aspectRatio];
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

- (void)applyLayout:(FLLayoutMode)layoutMode {
    [self applyLayoutPreservingOrigin:YES layoutMode:layoutMode];
}

- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin {
    [self calculateLayoutWithSize:self.element.frame.size];
    FLApplyLayoutToViewHierarchy(self.element, nil, preservingOrigin);
}

- (void)applyLayoutPreservingOrigin:(BOOL)preservingOrigin layoutMode:(FLLayoutMode)layoutMode {
    CGSize size = self.element.frame.size;
    if (layoutMode & FLAjustWidth) {
        size.width = YGUndefined;
    }
    if (layoutMode & FLAjustHeight) {
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

- (YGPositionType)fl_position {
    return YGNodeStyleGetPositionType(self.node);
}

- (void)fl_setPosition:(YGPositionType)position {
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

YGValue FLPointValue(CGFloat value)
{
    return (YGValue) { .value = value, .unit = YGUnitPoint };
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
