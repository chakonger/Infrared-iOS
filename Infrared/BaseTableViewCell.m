//
//  BaseTableViewCell.m
//  LDSBenchmark
//
//  Created by hwb on 14-5-12.
//  Copyright (c) 2014年 ludashi. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()
{
    UIImageView *_backgroundImageView;
    UIImageView *_selectedBackgroundImageView;
}


- (void)addBackgroundForCell;

@end


@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _cellBgImage = nil;
        _cellBgImageH = nil;
        [self addBackgroundForCell];
//        _containerView = nil;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//- (void)addContainerForCell
//{
//    _containerView = [[UIView alloc] initWithFrame:self.contentView.bounds];
//    _containerView.backgroundColor = [UIColor clearColor];
//    [self.contentView addSubview:_containerView];
//    self.contentView.backgroundColor = [UIColor clearColor];
//}

- (void)addBackgroundForCell
{
    _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundImageView.backgroundColor = [UIColor clearColor];
    self.backgroundView = _backgroundImageView;
    
    _selectedBackgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _selectedBackgroundImageView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = _selectedBackgroundImageView;
}

-(void) setCellBgImage:(UIImage *)bgImage;
{
    if (bgImage != _cellBgImage)
    {
        ARC_RELEASE(_cellBgImage);
        _cellBgImage = bgImage;
        
        _backgroundImageView.image = _cellBgImage;
    }
}

-(void) setCellBgImageH:(UIImage *)bgImageH;
{
    if (bgImageH != _cellBgImageH)
    {
        ARC_RELEASE(_cellBgImageH);
        _cellBgImageH = bgImageH;
        
        _selectedBackgroundImageView.image = _cellBgImageH;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGRect rect = self.bounds;
//    _containerView.frame = rect;
}

@end

