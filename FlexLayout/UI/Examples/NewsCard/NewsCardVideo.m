//
//  NewsCardVideo.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/24.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "NewsCardVideo.h"
#import "FlexHeaders.h"

@implementation NewsCardVideo

- (instancetype)init {
    self = [super init];
    if (self) {
        
        UIImageView *titleBackImageView = [UIImageView new];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.numberOfLines = 3;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.text = @"施工队挖出蓝色火焰，专家竟从下面发现汉朝古墓，挖出无价国宝,哇咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔咔咳咳咳咳咳咳咳咳咳咳咳咳咳咳咳咳咳咳咳咳咔不动了";
        
        UIImageView *coverView = [UIImageView new];
        
        UIButton *playButton = [UIButton new];
        
        UIView *bottomView = [UIView new];
        
        UIButton *protraitButton = [UIButton new];
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"小野自媒体";
        nameLabel.font = [UIFont systemFontOfSize:12];
        
        UIButton *commentButton = [UIButton new];
        UIButton *shareButton = [UIButton new];
        UIButton *dislikeButton = [UIButton new];
        
        
        [self.flex.direction(FLFlexDirectionColumn) define:^(FlexLayout *flex) {
            [flex.addChild(coverView).aspectRatio(16.0/9).grow(1.0) define:^(FlexLayout *flex) {
                [flex.addChild(FLContainer) define:^(FlexLayout *flex) {
                    flex.justifyContent(FLJustifyCenter).alignItems(FLAlignCenter).grow(1.0);
                    flex.addChild(playButton).width(60).aspectRatio(1.0);
                }];
                [flex.addChild(titleBackImageView) define:^(FlexLayout *flex) {
                    flex.position(FLPositionTypeAbsolute).left(0).top(0).right(0).aspectRatio(40.0/8); // overlay!!!
                }];
                [flex.addChild(titleLabel) define:^(FlexLayout *flex) {
                    flex.position(FLPositionTypeAbsolute).left(0).top(0).right(0);
                }];
            }];
            [flex.addChild(bottomView).direction(FLFlexDirectionRow).height(64) define:^(FlexLayout *flex) {
                flex.justifyContent(FLJustifySpaceBetween);
                [flex.addChild(FLContainer).direction(FLFlexDirectionRow) define:^(FlexLayout *flex) {
                    flex.alignItems(FLAlignCenter);
                    flex.addChild(protraitButton).width(40).aspectRatio(1.0).marginRight(10).marginLeft(15);
                    flex.addChild(nameLabel);
                }];
                
                [flex.addChild(FLContainer).direction(FLFlexDirectionRow) define:^(FlexLayout *flex) {
                    flex.justifyContent(FLJustifyFlexEnd).alignItems(FLAlignCenter);
                    
                    flex.addChild(commentButton).width(50).height(40).marginRight(10);
                    flex.addChild(shareButton).width(50).height(40).marginRight(10);
                    flex.addChild(dislikeButton).width(50).height(40).marginRight(15);
                }];
            }];
        }];
        
    }
    return self;
}

@end
