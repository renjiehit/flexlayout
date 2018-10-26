//
//  MethodCell.m
//  FlexLayout
//
//  Created by 任 洪杰 on 2018/10/26.
//  Copyright © 2018年 任 洪杰. All rights reserved.
//

#import "MethodCell.h"
#import "FlexHeaders.h"

@implementation MethodItem

+ (instancetype)itemWithName:(NSString *)name description:(NSString *)description {
    MethodItem *item = [MethodItem new];
    item.name = name;
    item.desc = description;
    return item;
}

@end

@interface MethodCell ()

@property (nonatomic, strong) UIImageView *methodIcon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation MethodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _methodIcon = [UIImageView new];
        _methodIcon.backgroundColor = [UIColor lightGrayColor];
        
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _descriptionLabel = [UILabel new];
        _descriptionLabel.font = [UIFont systemFontOfSize:12];
        _descriptionLabel.numberOfLines = 0;
        
        [self.contentView.flex.direction(FLFlexDirectionColumn).padding(15) define:^(FlexLayout *flex) {
            [flex.addChild(FLContainer).direction(FLFlexDirectionRow) define:^(FlexLayout *flex) {
                flex.alignItems(FLAlignCenter);
                flex.addChild(_methodIcon).width(30).height(30).marginRight(10);
                flex.addChild(_nameLabel);
            }];
            flex.addChild(_descriptionLabel).marginTop(10);
        }];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(MethodItem *)item {
    _item = item;
    
    _nameLabel.text = item.name;
    [_nameLabel.flex markDirty];
    _descriptionLabel.text = item.desc;
    [_descriptionLabel.flex markDirty];
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self.contentView.frame = frame;;
    [self.contentView.flex applyLayout:FLAjustHeight];
    return self.contentView.frame.size;
}

@end
