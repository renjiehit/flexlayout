//
//  MethodCell.h
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/26.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MethodItem : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;

+ (instancetype)itemWithName:(NSString *)name description:(NSString *)description;

@end

@interface MethodCell : UITableViewCell

@property (nonatomic, strong) MethodItem *item;

@end
