//
//  NewsCardSingleImage.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/23.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "NewsCardSingleImage.h"
#import "FlexHeaders.h"

@implementation NewsCardSingleImage

- (instancetype)init {
    self = [super init];
    if (self) {
        UIFont *smallFont = [UIFont systemFontOfSize:11];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 3;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"施工队挖出蓝色火焰，专家竟从下面发现汉朝古墓，挖出无价国宝,哇咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔";
        
        UILabel *sourceLabel = [UILabel new];
        sourceLabel.font = smallFont;
        sourceLabel.text = @"海外网";
        
        UILabel *commentLabel = [UILabel new];
        commentLabel.font = smallFont;
        commentLabel.text = @"62评";
        
        UILabel *timeLabel = [UILabel new];
        timeLabel.font = smallFont;
        timeLabel.text = @"1小时前";
        
        UIButton *dislikeButton = [UIButton new];
        
        UIImageView *imageView = [UIImageView new];
        
        [self.flex.direction(FLFlexDirectionRow).padding(15).justifyContent(FLJustifySpaceBetween) define:^(FlexLayout *flex) {
            [flex.addChild(FLContainer).direction(FLFlexDirectionColumn) define:^(FlexLayout *flex) {
                flex.justifyContent(FLJustifySpaceBetween).shrink(1.0).marginRight(10);
                flex.addChild(titleLabel).shrink(1.0).marginTop(10);
                [flex.addChild(FLContainer).direction(FLFlexDirectionRow).marginBottom(10) define:^(FlexLayout *flex) {
                    flex.justifyContent(FLJustifySpaceBetween);
                    
                    [flex.addChild(FLContainer).direction(FLFlexDirectionRow).shrink(1) define:^(FlexLayout *flex) {
                        flex.alignItems(FLAlignCenter);
                        flex.addChild(sourceLabel).marginRight(10);
                        flex.addChild(commentLabel).marginRight(10);
                        flex.addChild(timeLabel).marginRight(20).shrink(1);
                    }];
            
                    flex.addChild(dislikeButton).width(20).height(20);
                }];
                
            }];
            flex.addChild(imageView).width(145).aspectRatio(4.0/3);
        }];
        
    }
    return self;
}

@end
