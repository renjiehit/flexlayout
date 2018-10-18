//
//  FlexLayoutProtocol.h
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/18.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlexLayout;

@protocol FLElement <NSObject>
@required
@property (nonatomic, readonly, strong) FlexLayout *flex;
@property (nonatomic, assign) CGRect frame;

- (BOOL)isVirtualView;

@end
