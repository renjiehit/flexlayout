//
//  FLVirtualView.h
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/16.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlexLayoutProtocol.h"

#define VirtualContainer 1
#if VirtualContainer
#define FLContainer [FLVirtualView new]
#else
#define FLContainer [UIView new]
#endif

@interface FLVirtualView : NSObject <FLElement>

@end
