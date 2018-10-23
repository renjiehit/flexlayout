//
//  NewsCardMultiImage.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/23.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "NewsCardMultiImage.h"
#import "FlexHeaders.h"

@implementation NewsCardMultiImage

- (instancetype)init {
    self = [super init];
    if (self) {
        UIFont *smallFont = [UIFont systemFontOfSize:11];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 2;
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
        UIImageView *imageView1 = [UIImageView new];
        UIImageView *imageView2 = [UIImageView new];
        
        
        [self.flex.direction(FLFlexDirectionColumn).padding(15) define:^(FlexLayout *flex) {
            flex.addChild(titleLabel);
            [flex.addChild(FLContainer).direction(FLFlexDirectionRow) define:^(FlexLayout *flex) {
                flex.marginTop(10);
                flex.addChild(imageView).aspectRatio(4.0/3).flexGrow(1.0);
                flex.addChild(FLContainer).width(5);
                flex.addChild(imageView1).aspectRatio(4.0/3).flexGrow(1.0);
                flex.addChild(FLContainer).width(5);
                flex.addChild(imageView2).aspectRatio(4.0/3).flexGrow(1.0);
            }];
            
            [flex.addChild(FLContainer).direction(FLFlexDirectionRow) define:^(FlexLayout *flex) {
                flex.justifyContent(FLJustifySpaceBetween).marginTop(10);
                
                [flex.addChild(FLContainer).direction(FLFlexDirectionRow) define:^(FlexLayout *flex) {
                    flex.addChild(sourceLabel).marginRight(10);
                    flex.addChild(commentLabel).marginRight(10);
                    flex.addChild(timeLabel).marginRight(40);
                }];
                
                flex.addChild(dislikeButton).width(20).height(20);
            }];
        }];
        
    }
    return self;
}

@end
