//
//  TEdVideoPreviewCell.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDVideoPreviewCell.h"
#import "TEDItem.h"

@interface TEDVideoPreviewCell ()

@property (nonatomic, strong) TEDItem *item;
@property (nonatomic, strong) UIImageView *videoImage;
@property (nonatomic, strong) UITextView *title;
@property (nonatomic, strong) UILabel *speaker;
@property (nonatomic, strong) UILabel *time;

@end

@implementation TEDVideoPreviewCell

- (UIImageView *)videoImage {
    if (!_videoImage) {
        _videoImage = [UIImageView new];
        _videoImage.contentMode = UIViewContentModeScaleAspectFill;
        _videoImage.clipsToBounds = YES;
        _videoImage.layer.cornerRadius = 10;
    }
    return _videoImage;
}

- (UILabel *)speaker {
    if (!_speaker) {
        _speaker = [UILabel new];
        [_speaker setFont:[UIFont systemFontOfSize:13 weight:UIFontWeightMedium]];
        [_speaker setTextColor:[UIColor colorNamed:@"speaker_color"]];
    }
    return _speaker;
}

- (UITextView *)title {
    if (!_title) {
        _title = [UITextView new];
        _title.userInteractionEnabled = NO;
        [_title setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightBold]];
        [_title setTextColor:[UIColor colorNamed:@"title_color"]];
        _title.backgroundColor = [UIColor clearColor];
        _title.textContainer.lineBreakMode = NSLineBreakByTruncatingTail;
        _title.textContainerInset = UIEdgeInsetsZero;
        _title.textContainer.lineFragmentPadding = 0;
    }
    return _title;
}

- (void)setupCellWithItem:(TEDItem *)item {
    self.videoImage.image = item.image ? item.image : [UIImage imageNamed:@"default_image"];
    [self.speaker setText:item.speaker];
    [self.title setText:item.title];
    [self.speaker sizeToFit];
    
    [self.contentView addSubview:self.videoImage];
    [self.contentView addSubview:self.speaker];
    [self.contentView addSubview:self.title];
    
    self.videoImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    self.speaker.translatesAutoresizingMaskIntoConstraints = NO;

    [NSLayoutConstraint activateConstraints:@[
//        [self.contentView.heightAnchor constraintEqualToAnchor:self.videoImage.heightAnchor constant:10],
        
        [self.videoImage.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.videoImage.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
        [self.videoImage.widthAnchor constraintEqualToConstant:170],
        [self.videoImage.heightAnchor constraintEqualToConstant:128],

        [self.speaker.leadingAnchor constraintEqualToAnchor:self.videoImage.trailingAnchor constant:15],
        [self.speaker.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.speaker.topAnchor constraintEqualToAnchor:self.videoImage.topAnchor constant:10],

        [self.title.leadingAnchor constraintEqualToAnchor:self.speaker.leadingAnchor],
        [self.title.trailingAnchor constraintEqualToAnchor:self.speaker.trailingAnchor],
        [self.title.topAnchor constraintEqualToAnchor:self.speaker.bottomAnchor constant:5],
        [self.title.bottomAnchor constraintEqualToAnchor:self.videoImage.bottomAnchor constant:-10],
    ]];
    
}

- (void)willMoveToSuperview:(UIView *)subview {
    [super willMoveToSuperview:subview];
    
    self.backgroundColor = [UIColor colorNamed:@"background_color"];
}

@end
