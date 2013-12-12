//
//  ebGalleryViewController.h
//  quadrangle
//
//  Created by Evan Buxton on 4/3/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CVCell.h"
#import "SupplementaryView.h"
#import "FGalleryViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "embWebViewController.h"
#import "ViewController.h"

@interface embAlbumViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, FGalleryViewControllerDelegate, UIDocumentInteractionControllerDelegate, UIWebViewDelegate>
{
	// gallery
	NSString *secTitle;
	NSDictionary *albumDict;
	NSArray *albumSections;
	UICollectionViewFlowLayout *flowLayout;
	// fgallery
	FGalleryViewController	*localGallery;
	NSArray					*localCaptions;
    NSArray					*localImages;
    // documents
	UIDocumentInteractionController *doccontroller;
	// movie
	UIView *mpControlsView;
	UIButton *closeMovieButton;
	NSTimeInterval totalVideoTime;
	UISlider *progressIndicator;
	UIScreen *external_disp;
	UIWindow *external_wind;
    
    int     sectionIndex;
    
}
- (void)playMovie:(NSString*)movieName ofType:(NSString*)extension;
- (void)movieFinishedCallback:(NSNotification*)_notification;
//- (void)moviePlayBackDidFinish:(NSNotification*)_notification;

@property (nonatomic, strong) NSString *plistName;
@property (nonatomic, strong) NSString *backgroundName;
@property (nonatomic, strong) UIImageView *uiiv_Background;
// movie playback
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (strong, nonatomic) MPMoviePlayerViewController *playerViewController;

@property (strong, nonatomic) UISegmentedControl *albumType;
@property (nonatomic, strong) NSString *typeOfAlbum;

@property (nonatomic)         int sectionIndex;

@property (nonatomic, strong) UIViewController *controller;

@end
