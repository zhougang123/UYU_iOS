//
//  UYUPrescriptionCell.m
//  UYUClient
//
//  Created by mac on 17/4/12.
//  Copyright © 2017年 cyjjkz1. All rights reserved.
//

#import "UYUPrescriptionCell.h"
#import "UYUColor.h"
#import "UIView+YSKit.h"

@interface UYUPrescriptionCell ()
@property (nonatomic, strong) UIView *presPadView;
@property (nonatomic, strong) UIView *infoPadView;
@property (nonatomic, strong) UILabel *presTitleLab;
@property (nonatomic, strong) UILabel *presNameLab;
@property (nonatomic, strong) UILabel *serialNumLab;
@property (nonatomic, strong) UILabel *trainTimesLab;
@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UIButton *presDeleteBtn;

@end

@implementation UYUPrescriptionCell
- (UIButton *)presDeleteBtn
{
    if (_presDeleteBtn == nil) {
        _presDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _presDeleteBtn.backgroundColor = UIColorFromRGB(0xD1F1FD);
        _presDeleteBtn.layer.cornerRadius = 3;
        _presDeleteBtn.layer.masksToBounds = YES;
        _presDeleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_presDeleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_presDeleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_presDeleteBtn addTarget:self action:@selector(presDelete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presDeleteBtn;
}
- (UIView *)presPadView
{
    if (_presPadView == nil) {
        _presPadView = [[UIView alloc] init];
        _presPadView.backgroundColor = UIColorFromRGB(0x35B38E);
        _presPadView.layer.cornerRadius = 6;
        _presPadView.layer.masksToBounds = YES;
        
    }
    return _presPadView;
}

- (UIView *)infoPadView
{
    if (_infoPadView == nil) {
        _infoPadView = [[UIView alloc] init];
        _infoPadView.backgroundColor = [UYUColor whiteColor];
        _infoPadView.layer.cornerRadius = 3;
        _infoPadView.layer.masksToBounds = YES;
    }
    return _infoPadView;
}

- (UILabel *)presTitleLab
{
    if (_presTitleLab == nil) {
        _presTitleLab = [[UILabel alloc] init];
        _presTitleLab.font = [UIFont systemFontOfSize:AdaptWidth(15)];
        _presTitleLab.textColor = [UIColor whiteColor];
        _presTitleLab.textAlignment = NSTextAlignmentCenter;
        _presTitleLab.text = @"处方";
    }
    return _presTitleLab;
}
- (UILabel *)presNameLab
{
    if (_presNameLab == nil) {
        _presNameLab = [[UILabel alloc] init];
        _presNameLab.font = [UIFont systemFontOfSize:AdaptWidth(14)];
        _presNameLab.textColor = [UIColor blackColor];
        _presNameLab.textAlignment = NSTextAlignmentLeft;
    }
    return _presNameLab;
}

- (UILabel *)serialNumLab
{
    if (_serialNumLab == nil) {
        _serialNumLab = [[UILabel alloc] init];
        _serialNumLab.font = [UIFont systemFontOfSize:AdaptWidth(14)];
        _serialNumLab.textAlignment = NSTextAlignmentLeft;
        _serialNumLab.textColor = [UIColor blackColor];
    }
    return _serialNumLab;
}

- (UILabel *)trainTimesLab
{
    if (_trainTimesLab == nil) {
        _trainTimesLab = [[UILabel alloc] init];
        _trainTimesLab.font = [UIFont systemFontOfSize:AdaptWidth(14)];
        _trainTimesLab.textColor = [UIColor blackColor];
        _trainTimesLab.textAlignment = NSTextAlignmentLeft;
    }
    return _trainTimesLab;
}

- (UIImageView *)headImage
{
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc] init];
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}


- (void)addSubviews
{
    [self.contentView addSubview:self.presPadView];
    [self.presPadView addSubview:self.headImage];
    [self.presPadView addSubview:self.presTitleLab];
    [self.presPadView addSubview:self.presDeleteBtn];
    [self.presPadView addSubview:self.infoPadView];
    
    
    [self.infoPadView addSubview:self.presNameLab];
    [self.infoPadView addSubview:self.serialNumLab];
    [self.infoPadView addSubview:self.trainTimesLab];
}

- (void)layoutSubviews
{
    self.presPadView.frame = CGRectMake(0, AdaptWidth(8), kScreenWidth, kPrescriptionCellHeight-AdaptWidth(8));
    self.headImage.frame = CGRectMake(16, AdaptWidth(3), AdaptWidth(50), AdaptWidth(50));
    self.presTitleLab.frame = CGRectMake(_headImage.right, _headImage.top, kScreenWidth - _headImage.right * 2, _headImage.height);
    self.presDeleteBtn.frame = CGRectMake(_presPadView.width - AdaptWidth(90), _headImage.top+AdaptWidth(7), AdaptWidth(80), AdaptWidth(36));
    self.infoPadView.frame = CGRectMake(10, _headImage.bottom+AdaptWidth(3), kScreenWidth - 10*2, AdaptWidth(60));
    
    self.presNameLab.frame = CGRectMake(10, 0, _infoPadView.width - 10*2, AdaptWidth(20));
    self.serialNumLab.frame = CGRectMake(10, _presNameLab.bottom, _presNameLab.width, _presNameLab.height);
    self.trainTimesLab.frame = CGRectMake(10, _serialNumLab.bottom, _presNameLab.width, _presNameLab.height);
    self.headImage.layer.cornerRadius = _headImage.height/2.0;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubviews];
        [self layoutSubviews];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)handlePrescriptionWithName:(NSString *)name
                         serialNum:(NSString *)serialNum
                         trainTime:(NSString *)times
                           headImg:(UIImage *)icon
{
    [self.headImage setImage:icon];
    [self.presNameLab setText:[NSString stringWithFormat:@"名称: %@", name]];
    [self.serialNumLab setText:[NSString stringWithFormat:@"流程号: %@", serialNum]];
    [self.trainTimesLab setText:[NSString stringWithFormat:@"训练次数: %@", times]];
}

- (void)presDelete:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(prescriptionDeleteWithIndexPath:)]) {
        [self.delegate prescriptionDeleteWithIndexPath:self];
    }
}
@end
