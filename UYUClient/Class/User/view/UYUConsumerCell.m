//
//  UYUConsumerCell.m
//  UYUClient
//
//  Created by mac on 17/4/10.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUConsumerCell.h"
#import "Macro.h"
#import "UIView+YSKit.h"
@interface UYUConsumerCell ()
@property (nonatomic, strong) UILabel *nickNameLab;
@property (nonatomic, strong) UILabel *addDateLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIImageView *headImage;


@end

@implementation UYUConsumerCell


- (UILabel *)nickNameLab
{
    if (_nickNameLab == nil) {
        _nickNameLab = [[UILabel alloc] init];
        _nickNameLab.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _nickNameLab.textColor = [UIColor blackColor];
        _nickNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _nickNameLab;
}

- (UILabel *)addDateLab
{
    if (_addDateLab == nil) {
        _addDateLab = [[UILabel alloc] init];
        _addDateLab.font = [UIFont systemFontOfSize:AdaptWidth(13)];
        _addDateLab.textAlignment = NSTextAlignmentLeft;
        _addDateLab.textColor = [UIColor lightGrayColor];
    }
    return _addDateLab;
}

- (UILabel *)typeLab
{
    if (_typeLab == nil) {
        _typeLab = [[UILabel alloc] init];
        _typeLab.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _typeLab.textColor = [UIColor blackColor];
        _typeLab.textAlignment = NSTextAlignmentRight;
    }
    return _typeLab;
}

- (UIImageView *)headImage
{
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc] init];
    }
    return _headImage;
}


- (void)addSubviews
{
    [self.contentView addSubview:self.headImage];
    [self.contentView addSubview:self.nickNameLab];
//    [self.contentView addSubview:self.typeLab];
    [self.contentView addSubview:self.addDateLab];
}

- (void)layoutSubviews
{
    self.headImage.frame = CGRectMake(15, 10, kConsumerCellHeight - 10*2, kConsumerCellHeight - 10*2);
    self.typeLab.frame = CGRectMake(kScreenWidth - AdaptWidth(100), 0, AdaptWidth(100) - 8, kConsumerCellHeight);
    self.nickNameLab.frame = CGRectMake(_headImage.right+5, _headImage.top, kScreenWidth - _headImage.right - AdaptWidth(100) - 5, _headImage.height/2.0);
    self.addDateLab.frame = CGRectMake(_nickNameLab.left, _nickNameLab.bottom, kScreenWidth - _nickNameLab.left - 10, _nickNameLab.height);
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubviews];
        [self layoutSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)handleCellWithName:(NSString *)nickName
                createDate:(NSString *)time
                      type:(NSString *)type
                headeImage:(UIImage *)icon
{
    self.nickNameLab.text = nickName;
    self.addDateLab.text = [NSString stringWithFormat:@"创建时间: %@", time];
    self.typeLab.text = [NSString stringWithFormat:@"类型:%@", type];
    [self.headImage setImage:icon];
}
@end
