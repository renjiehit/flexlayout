//
//  FLEnums.h
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/9/5.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#ifndef FLEnums_h
#define FLEnums_h

typedef NS_ENUM(NSInteger, FLAlign) {
    FLAlignAuto,
    FLAlignFlexStart,
    FLAlignCenter,
    FLAlignFlexEnd,
    FLAlignStretch,
    FLAlignBaseline,
    FLAlignSpaceBetween,
    FLAlignSpaceAround,
};

typedef NS_ENUM(NSInteger, FLDimension) {
    FLDimensionWidth,
    FLDimensionHeight,
};

typedef NS_ENUM(NSInteger, FLDirection) {
    FLDirectionInherit,
    FLDirectionLTR, // direction left to right
    FLDirectionRTL, // direction right to left
};

typedef NS_ENUM(NSInteger, FLDisplay) {
    FLDisplayFlex,
    FLDisplayNone,
};

typedef NS_ENUM(NSInteger, FLEdge) {
    FLEdgeLeft,
    FLEdgeTop,
    FLEdgeRight,
    FLEdgeBottom,
    FLEdgeStart,
    FLEdgeEnd,
    FLEdgeHorizontal,
    FLEdgeVertical,
    FLEdgeAll,
};

typedef NS_ENUM(NSInteger, FLExperimentalFeature) {
    FLExperimentalFeatureWebFlexBasis,
};

typedef NS_ENUM(NSInteger, FLFlexDirection) {
    FLFlexDirectionColumn,
    FLFlexDirectionColumnReverse,
    FLFlexDirectionRow,
    FLFlexDirectionRowReverse,
};

typedef NS_ENUM(NSInteger, FLJustify){
    FLJustifyFlexStart,
    FLJustifyCenter,
    FLJustifyFlexEnd,
    FLJustifySpaceBetween,
    FLJustifySpaceAround,
    FLJustifySpaceEvenly,
};

typedef NS_ENUM(NSInteger, FLMeasureMode) {
    FLMeasureModeUndefined,
    FLMeasureModeExactly,
    FLMeasureModeAtMost,
};

typedef NS_ENUM(NSInteger, FLNodeType) {
    FLNodeTypeDefault,
    FLNodeTypeText,
};

typedef NS_ENUM(NSInteger, FLOverflow) {
    FLOverflowVisible,
    FLOverflowHidden,
    FLOverflowScroll,
};

typedef NS_ENUM(NSInteger, FLPositionType) {
    FLPositionTypeRelative,
    FLPositionTypeAbsolute,
};

typedef NS_ENUM(NSInteger, FLPrintOptions) {
    FLPrintOptionsLayout = 1,
    FLPrintOptionsStyle = 2,
    FLPrintOptionsChildren = 4,
};

typedef NS_ENUM(NSInteger, FLUnit) {
    FLUnitUndefined,
    FLUnitPoint,
    FLUnitPercent,
    FLUnitAuto,
};

typedef NS_ENUM(NSInteger, FLWrap) {
    FLWrapNoWrap,
    FLWrapWrap,
    FLWrapWrapReverse,
};

typedef NS_OPTIONS(NSInteger, FLLayoutMode) {
    FLAjustWidth = 1 << 0,
    FLAjustHeight = 1 << 1,
};

#endif /* FLEnums_h */
