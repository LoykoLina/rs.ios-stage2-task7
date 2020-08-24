//
//  TEDDetailedInfoController.m
//  RSSchool_T7
//
//  Created by Lina Loyko on 7/20/20.
//  Copyright © 2020 Lina Loyko. All rights reserved.
//

#import "TEDDetailedInfoController.h"
#import "TEDItem.h"
#import <AVKit/AVKit.h>
#import "TEDItemService.h"

@interface TEDDetailedInfoController ()

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *speaker;
@property (nonatomic, strong) UILabel *info;
@property (nonatomic, strong) UIView *infoUnderline;
@property (nonatomic, strong) UILabel *itemDescription;
@property (nonatomic, strong) UILabel *itemTitle;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, strong) TEDItem *item;
@property (nonatomic, strong) AVPlayerViewController *playerVC;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL isFavorite;
@property (nonatomic, assign) BOOL isSaved;

@property (strong, nonatomic) TEDItemService *itemService;

@end

@implementation TEDDetailedInfoController

- (instancetype)initWithItem:(TEDItem *)item {
    self = [super init];
    if (self) {
        _item = item;
        _itemService = [TEDItemService new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back"]
                                                                                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self.navigationController
                                                                            action:@selector(popViewControllerAnimated:)];
    
    
    [self setupItemStates];
    
    if (self.item.image == nil) {
        [self loadImage];
    }
    
    [self setupUI];
}
- (void)loadImage {
    __weak typeof(self) weakSelf = self;
    
    [self.itemService loadImageForURL:self.item.imageURL completion:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.imageView.image = image;
        });
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!self.isSaved && self.isFavorite) {
        [self.itemService saveItem:self.item];
    } else if(self.isSaved && !self.isFavorite) {
        [self.itemService deleteItem:self.item];
    }
}

- (void)setupItemStates {
    self.isSaved = [self.itemService isSavedItem:self.item];
    self.isFavorite = self.isSaved;
}

- (BOOL)hidesBottomBarWhenPushed {
    return self.navigationController.topViewController == self;
}

- (void)setupUI {
    [self setupScrollView];
    [self setupPlayer];
    [self setupItemTitle];
    [self setupSpeaker];
    [self setupLikeButton];
    [self setupShareButton];
    [self setupInfo];
    [self setupItemDescription];
}

#pragma mark - ScroolView configuration

- (void)setupScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    
    self.contentView = [[UIView alloc] initWithFrame:self.scrollView.frame];
    [self.scrollView addSubview:self.contentView];
//    self.contentView.backgroundColor = UIColor.whiteColor;
    
    self.contentView.translatesAutoresizingMaskIntoConstraints = false;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
        [self.scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.scrollView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-10],
        [self.scrollView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        
        [self.contentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [self.contentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [self.contentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        [self.contentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [self.contentView.widthAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.widthAnchor]
    ]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGFloat newHeight;
    newHeight = [self.itemDescription convertRect:self.itemDescription.bounds toView:self.contentView].origin.y + self.itemDescription.bounds.size.height;
    
    [self.contentView.heightAnchor constraintEqualToConstant:newHeight].active = YES;
    self.scrollView.contentSize = self.contentView.bounds.size;
}

#pragma mark - Player configuration

- (void)setupPlayer {
    AVPlayer *player = [AVPlayer playerWithURL: [NSURL URLWithString:self.item.videoURL]];
    self.playerVC = [AVPlayerViewController new];
    self.playerVC.player = player;

    [self.playerVC setShowsPlaybackControls:NO];
    
    [self addChildViewController:self.playerVC];
    [self.contentView addSubview:self.playerVC.view];
    [self.playerVC didMoveToParentViewController:self];
    
    [self setupImageView];
    [self setupPlayButton];
    
    self.playerVC.view.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.playerVC.view.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor],
        [self.playerVC.view.heightAnchor constraintEqualToAnchor:self.imageView.heightAnchor],
        [self.playerVC.view.widthAnchor constraintEqualToAnchor:self.imageView.widthAnchor],
    ]];
}

- (void)setupImageView {
    self.imageView = [UIImageView new];
    self.imageView.image = self.item.image;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.imageView];
    self.imageView.backgroundColor = UIColor.blackColor;
    
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.imageView.heightAnchor constraintEqualToConstant:312],
        [self.imageView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [self.imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [self.imageView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor]
    ]];
}

- (void)setupPlayButton {
    UIButton *playButton = [[UIButton alloc] init];
    [playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.contentView addSubview:playButton];
    
    [playButton addTarget:self action:@selector(pressedPlay:) forControlEvents:UIControlEventTouchUpInside];
    
    playButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [playButton.centerYAnchor constraintEqualToAnchor:self.imageView.centerYAnchor],
        [playButton.centerXAnchor constraintEqualToAnchor:self.imageView.centerXAnchor],
        [playButton.heightAnchor constraintEqualToAnchor:playButton.widthAnchor],
        [playButton.widthAnchor constraintEqualToConstant:70],
    ]];
}

- (void)pressedPlay:(UIButton*)sender {
    [self.contentView bringSubviewToFront:self.playerVC.view];
    [self.playerVC.player play];
    [self.playerVC setShowsPlaybackControls:YES];
}

#pragma mark - Share button configuration

- (void)setupShareButton {
    self.shareButton = [[UIButton alloc] init];
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.shareButton];
    
    [self.shareButton addTarget:self action:@selector(pressedShareButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.shareButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.shareButton.heightAnchor constraintEqualToConstant:30],
        [self.shareButton.widthAnchor constraintEqualToAnchor:self.shareButton.heightAnchor],
        [self.shareButton.leadingAnchor constraintEqualToAnchor:self.likeButton.trailingAnchor constant:10],
        [self.shareButton.topAnchor constraintEqualToAnchor:self.likeButton.topAnchor]
    ]];
}

- (void)pressedShareButton:(UIButton*)sender {
    NSArray *activityItems = @[self.item.link];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self.navigationController presentViewController:activityViewControntroller animated:true completion:nil];
}

#pragma mark - Like button configuration

- (void)setupLikeButton {
    self.likeButton = [[UIButton alloc] init];
    if (self.isSaved) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateNormal];
    } else {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like_unselected"] forState:UIControlStateNormal];
    }
    [self.contentView addSubview:self.likeButton];
    
    [self.likeButton addTarget:self action:@selector(pressedLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    self.likeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.likeButton.heightAnchor constraintEqualToConstant:30],
        [self.likeButton.widthAnchor constraintEqualToAnchor:self.likeButton.heightAnchor],
        [self.likeButton.leadingAnchor constraintEqualToAnchor:self.itemTitle.leadingAnchor],
        [self.likeButton.topAnchor constraintEqualToAnchor:self.speaker.bottomAnchor constant:30]
    ]];
}

- (void)pressedLikeButton:(UIButton*)sender {
    if (!self.isFavorite) {
       [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like_selected"] forState:UIControlStateNormal];
        self.isFavorite = YES;
    } else {
       [self.likeButton setBackgroundImage:[UIImage imageNamed:@"like_unselected"] forState:UIControlStateNormal];
        self.isFavorite = NO;
    }
}

#pragma mark - Labels configuration

- (void)setupItemTitle {
    self.itemTitle = [[UILabel alloc] init];
    self.itemTitle.text = self.item.title;
    
    [self.contentView addSubview:self.itemTitle];
    
    [self.itemTitle setFont:[UIFont systemFontOfSize:26 weight:UIFontWeightBold]];
    [self.itemTitle setTextColor:[UIColor colorNamed:@"title_color"]];
    self.itemTitle.numberOfLines = 0;
    
    self.itemTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.itemTitle.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20],
        [self.itemTitle.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20],
        [self.itemTitle.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:20]
    ]];
}

- (void)setupSpeaker {
    self.speaker = [[UILabel alloc] init];
    self.speaker.text = self.item.speaker;
    
    [self.contentView addSubview:self.speaker];
    
    [self.speaker setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightRegular]];
    [self.speaker setTextColor:[UIColor colorNamed:@"speaker_color"]];
    self.speaker.numberOfLines = 0;
    
    self.speaker.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.speaker.leadingAnchor constraintEqualToAnchor:self.itemTitle.leadingAnchor],
        [self.speaker.trailingAnchor constraintEqualToAnchor:self.itemTitle.trailingAnchor],
        [self.speaker.topAnchor constraintEqualToAnchor:self.itemTitle.bottomAnchor constant:10]
    ]];
}

- (void)setupInfo {
    self.info = [[UILabel alloc] init];
    self.info.text = @"INFORMATION";
    [self.info sizeToFit];
    
    self.infoUnderline = [[UIView alloc] init];
    self.infoUnderline.backgroundColor = [UIColor colorNamed:@"red_color"];
    
    
    [self.contentView addSubview:self.info];
    [self.contentView addSubview:self.infoUnderline];
    
    [self.info setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
    [self.info setTextColor:[UIColor colorNamed:@"speaker_color"]];
    
    self.info.translatesAutoresizingMaskIntoConstraints = NO;
    self.infoUnderline.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.info.leadingAnchor constraintEqualToAnchor:self.itemTitle.leadingAnchor],
        [self.info.topAnchor constraintEqualToAnchor:self.likeButton.bottomAnchor constant:30],
        
        [self.infoUnderline.heightAnchor constraintEqualToConstant:1],
        [self.infoUnderline.leadingAnchor constraintEqualToAnchor:self.info.leadingAnchor],
        [self.infoUnderline.trailingAnchor constraintEqualToAnchor:self.info.trailingAnchor],
        [self.infoUnderline.topAnchor constraintEqualToAnchor:self.info.bottomAnchor constant:5],
    ]];
    
    
}

- (void)setupItemDescription {
    self.itemDescription = [[UILabel alloc] init];
    self.itemDescription.text = self.item.itemDescription;
    
    [self.contentView addSubview:self.itemDescription];
    
    [self.itemDescription setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightRegular]];
    [self.itemDescription setTextColor:[UIColor colorNamed:@"title_color"]];
    self.itemDescription.numberOfLines = 0;
    
    self.itemDescription.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [self.itemDescription.leadingAnchor constraintEqualToAnchor:self.itemTitle.leadingAnchor],
        [self.itemDescription.trailingAnchor constraintEqualToAnchor:self.itemTitle.trailingAnchor],
        [self.itemDescription.topAnchor constraintEqualToAnchor:self.infoUnderline.bottomAnchor constant:10]
    ]];
}

@end
