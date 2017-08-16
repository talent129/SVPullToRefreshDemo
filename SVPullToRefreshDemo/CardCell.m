//
//  CardCell.m
//  SVPullToRefreshDemo
//
//  Created by luckyCoderCai on 2017/8/16.
//  Copyright © 2017年 luckyCoderCai. All rights reserved.
//

#import "CardCell.h"
#import "CardModel.h"
#import "Masonry.h"

@interface CardCell ()

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CardCell

#pragma mark -lazy load
- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textColor = [UIColor grayColor];
        _dayLabel.font = [UIFont boldSystemFontOfSize:25];
    }
    return _dayLabel;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.textColor = [UIColor blackColor];
        _monthLabel.font = [UIFont systemFontOfSize:12];
    }
    return _monthLabel;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor lightGrayColor];
    }
    return _imgView;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor purpleColor];
        _contentLabel.font = [UIFont boldSystemFontOfSize:15];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initView];
    }
    return self;
}

- (void)_initView
{
    [self.contentView addSubview:self.dayLabel];
    [self.contentView addSubview:self.monthLabel];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.lineView];
    
    [_dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(@20);
    }];
    //抗拉伸性 越高越不容易被拉伸
    [self.dayLabel setContentHuggingPriority:UILayoutPriorityRequired
                                     forAxis:UILayoutConstraintAxisHorizontal];
    //抗压缩性 越高越不容易被压缩
    [self.dayLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@15);
        make.top.equalTo(_dayLabel.mas_bottom).mas_offset(2);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_dayLabel.mas_trailing).mas_offset(18);
        make.top.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(70, 70));
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_imgView.mas_trailing).mas_offset(10);
        make.top.equalTo(@20);
        make.trailing.equalTo(@-15);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView.mas_bottom).mas_offset(20);
        make.leading.and.trailing.and.bottom.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
}

- (void)setModel:(CardModel *)model
{
    _model = model;
    
    self.monthLabel.text = [NSString stringWithFormat:@"%ld月", model.month];
    self.dayLabel.text = [NSString stringWithFormat:@"%02lu", model.day];
    
    self.contentLabel.text = model.cardContent;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4.5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_contentLabel.text length])];
    _contentLabel.attributedText = attributedString;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    [_contentLabel sizeToFit];
    
    UIColor *col = [UIColor redColor];
    if (model.color == 0) {
        col = [UIColor redColor];
    }else if (model.color == 1) {
        col = [UIColor orangeColor];
    }else if (model.color == 2) {
        col = [UIColor yellowColor];
    }else if (model.color == 3) {
        col = [UIColor greenColor];
    }else if (model.color == 4) {
        col = [UIColor blueColor];
    }else if (model.color == 5) {
        col = [UIColor cyanColor];
    }else if (model.color == 6) {
        col = [UIColor purpleColor];
    }else if (model.color == 7) {
        col = [UIColor magentaColor];
    }else if (model.color == 8) {
        col = [UIColor brownColor];
    }else {
        col = [UIColor darkGrayColor];
    }
    self.imgView.backgroundColor = col;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
