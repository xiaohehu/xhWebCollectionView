//
//  ebGalleryViewController.m
//  quadrangle
//
//  Created by Evan Buxton on 4/3/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//


// In rootview controller, set property typeOfAlbum "Album" or "Photos" to load 2 different layouts.

#import "embAlbumViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "embUICollectionViewLayout.h"
@interface NDCollectionViewFlowLayout : UICollectionViewFlowLayout
@end

@interface embAlbumViewController ()
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSMutableArray* arr_AlbumData;
@property (nonatomic,strong) AppDelegate *appDelegate;

@property (nonatomic) int sumOfSections;
@property (nonatomic, strong) NSMutableArray *arr_sectionBtnArray;
@end

@implementation embAlbumViewController
@synthesize sectionIndex;
@synthesize collectionView;
@synthesize albumType, typeOfAlbum;
@synthesize controller;

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
	[self.collectionView setBackgroundColor:[UIColor clearColor]];

	[self.collectionView registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
	[self.collectionView registerClass:[SupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SupplementaryView"];
    
	flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(300, 111)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
//    embUICollectionViewLayout *fflowLayout = [[embUICollectionViewLayout alloc] init];
//    [self.collectionView setCollectionViewLayout:fflowLayout];
	
	// nsarray of dictionaries (galleries)
	// Path to the plist (in the application bundle)
	NSString *path = [[NSBundle mainBundle] pathForResource:
					  _plistName ofType:@"plist"];
	// Build the array from the plist
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.sumOfSections = [array count];
	NSMutableArray *array_1 = [[NSMutableArray alloc] init];
    [array_1 addObject:[array objectAtIndex:sectionIndex]];
	self.arr_AlbumData = array_1;
	albumSections = self.arr_AlbumData;
	
	_appDelegate = [AppDelegate appDelegate];
	
	_uiiv_Background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_backgroundName]];
	[self.view insertSubview:_uiiv_Background belowSubview:self.collectionView];
    
// If there a segment control is wanted, make it init.
// It helps to switch 2 different layouts.
//    [self initSegmentControl];
    [self initSectionButtons];
    [self addGesturesToView];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.frame = CGRectMake(0.0, 0.0, 1024, 768);;
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.origin.y = 0;
    self.navigationController.navigationBar.frame = frame;
	self.navigationController.navigationBar.translucent = YES;
    
    if (self.collectionView) {
        [self.collectionView reloadData];
    }

}

- (void)viewDidAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:YES animated:NO];
	[self.navigationController setToolbarHidden:YES animated:YES];
	[super viewDidAppear:animated];
}


#pragma mark - Buttons Contorl
-(void)initSectionButtons
{
    for (int i = 0; i < self.sumOfSections; i++) {
        UIButton *uib_section = [[UIButton alloc] init];
        uib_section = [UIButton buttonWithType:UIButtonTypeSystem];
        uib_section.frame = CGRectMake(20+i*(70), 50, 50, 50);
        NSString *str_btnTitle = [NSString stringWithFormat:@"%d",-(i-2013)];
        [uib_section setTitle:str_btnTitle forState:UIControlStateNormal];
        uib_section.tag = 2000+i;
        [self.view addSubview:uib_section];
        [uib_section addTarget:self action:@selector(changeSection:) forControlEvents:UIControlEventTouchDown];
        [_arr_sectionBtnArray addObject:uib_section];
    }
}
-(void)changeSection:(id)sender
{
    UIButton *tmpBtn = sender;
    int index = tmpBtn.tag;
    UIButton *tmp = [_arr_sectionBtnArray objectAtIndex:(index-2000)];
    tmp.selected = YES;
    self.sectionIndex = index-2000;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:
					  _plistName ofType:@"plist"];
	// Build the array from the plist
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.sumOfSections = [array count];
	NSMutableArray *array_1 = [[NSMutableArray alloc] init];
    [array_1 addObject:[array objectAtIndex:sectionIndex]];
	self.arr_AlbumData = array_1;
	albumSections = self.arr_AlbumData;
    [self.collectionView reloadData];
}

#pragma mark - Add gestures
-(void)addGesturesToView
{
    UISwipeGestureRecognizer *slideToRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToLeft:)];
    [slideToRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:slideToRight];
    
    UISwipeGestureRecognizer *slideToLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeToRight:)];
    [slideToLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:slideToLeft];
}

-(void)handleSwipeToRight:(UISwipeGestureRecognizer *)recognizer
{
    if (self.sectionIndex == 5) {
        self.sectionIndex = 0;
    }
    else
    {
        self.sectionIndex++;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:
					  _plistName ofType:@"plist"];
	// Build the array from the plist
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.sumOfSections = [array count];
	NSMutableArray *array_1 = [[NSMutableArray alloc] init];
    [array_1 addObject:[array objectAtIndex:sectionIndex]];
	self.arr_AlbumData = array_1;
	albumSections = self.arr_AlbumData;
    [self.collectionView reloadData];
}
-(void)handleSwipeToLeft:(UISwipeGestureRecognizer *)recognizer
{
    if (self.sectionIndex == 0) {
        self.sectionIndex = 5;
    }
    else
    {
        self.sectionIndex--;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:
					  _plistName ofType:@"plist"];
	// Build the array from the plist
	NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:path];
    self.sumOfSections = [array count];
	NSMutableArray *array_1 = [[NSMutableArray alloc] init];
    [array_1 addObject:[array objectAtIndex:sectionIndex]];
	self.arr_AlbumData = array_1;
	albumSections = self.arr_AlbumData;
    [self.collectionView reloadData];
}

#pragma mark - Gallery UICollection View
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
	NSUInteger numGallSections = [albumSections count];
	NSLog(@"gallerySections %i",[albumSections count]);
	return numGallSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
	if ([typeOfAlbum isEqualToString:@"photos"]) {
        NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[self.arr_AlbumData objectAtIndex:section]];
        NSMutableArray *secInfo = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"sectioninfo"]];
        int sumOfImg = 0;
        NSString *typeOfFile = [[NSString alloc] init];
        
        for (int i = 0; i < [secInfo count]; i++) {
            NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:secInfo[i]];
            typeOfFile = [itemDic objectForKey:@"albumtype"];
            if ([typeOfFile isEqualToString:@"image"]) {
                NSMutableArray *imgArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"images"]];
                sumOfImg = sumOfImg + [imgArray count];
            }
            else
            {
                sumOfImg++;
            }

        }
        return sumOfImg;
    }
    else
    {
        NSDictionary *ggallDict = [albumSections objectAtIndex:section];
        NSArray *sectionAlbums = [ggallDict objectForKey:@"sectioninfo"];
        int galleryIndex = [sectionAlbums count];
        return  galleryIndex;
    }
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)ccollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    SupplementaryView *supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SupplementaryView" forIndexPath:indexPath];
    
    if(kind == UICollectionElementKindSectionHeader){
        supplementaryView.backgroundColor = [UIColor clearColor];
		NSDictionary *gallDictionary = albumSections[indexPath.section]; // grab dict
		secTitle = [[gallDictionary objectForKey:@"SectionName"] uppercaseString];
		supplementaryView.label.text = secTitle;
    }
    
    return supplementaryView;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(500, 55);
}
////Delegate method from collection view flow layout. 
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize itemSize = CGSizeZero;
//    
//    if (indexPath.item == 0) {
//        itemSize = CGSizeMake(175*2+20, 175*2+20);
//        return itemSize;
//    }
//    else
//    {
//        itemSize = CGSizeMake(175, 175);
//        return itemSize;
//    }
//}
-(UICollectionViewCell *)collectionView:(UICollectionView *)ccollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cvCell";
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

// If type of album is photos, get a total array from each sectioninfo in plist
    if ([typeOfAlbum isEqualToString:@"photos"]) {
        NSDictionary *tempDic = [[NSDictionary alloc] initWithDictionary:[_arr_AlbumData objectAtIndex:indexPath.section]];
        NSMutableArray *secInfo = [[NSMutableArray alloc] initWithArray:[tempDic objectForKey:@"sectioninfo"]];

        NSMutableArray *totalImg = [[NSMutableArray alloc] init];
        NSMutableArray *totalCap = [[NSMutableArray alloc] init];
        NSMutableArray *totalDes = [[NSMutableArray alloc] init];
        NSMutableArray *totalDat = [[NSMutableArray alloc] init];
        NSString *typeOfCell = [[NSString alloc] init];
        
        for (int i = 0; i < [secInfo count]; i++) {
            NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:[secInfo objectAtIndex:i]];
            typeOfCell = [itemDic objectForKey:@"albumtype"];
            
            if ([typeOfCell isEqualToString:@"image"]) {
                NSMutableArray *imgArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"images"]];
                NSMutableArray *capArray = [[NSMutableArray alloc] initWithArray:[itemDic objectForKey:@"captions"]];
                [totalImg addObjectsFromArray:imgArray];
                [totalCap addObjectsFromArray:capArray];
            }
            else
            {
                [totalImg addObject:[itemDic objectForKey:@"albumthumb"]];
                [totalCap addObject:[itemDic objectForKey:@"albumcaption"]];
                [totalDat addObject:[itemDic objectForKey:@"date"]];
                [totalDes addObject:[itemDic objectForKey:@"description"]];
            }

        }
        
        [cell.titleLabel setText:[totalCap objectAtIndex:indexPath.row]];
        cell.cellThumb.image = [UIImage imageNamed:[totalImg objectAtIndex:indexPath.row]];
        [cell.dateLabel setText:[totalDat objectAtIndex:indexPath.row]];
        [cell.description setText:[totalDes objectAtIndex:indexPath.row]];
        [cell.description setFont:[UIFont systemFontOfSize:15]];
    }
    else// if ([typeOfAlbum isEqualToString:@"album"])
    {
    	NSDictionary *ggallDict = [_arr_AlbumData objectAtIndex:indexPath.section];
        NSArray *ggalleryArray = [ggallDict objectForKey:@"sectioninfo"];
        NSDictionary *aalbumDict = [ggalleryArray objectAtIndex:indexPath.row];
        NSMutableArray *imageCount = [[NSMutableArray alloc]initWithCapacity:1];
        
        [imageCount addObjectsFromArray:[aalbumDict objectForKey:@"images"]];
        
        [cell.titleLabel setText:[aalbumDict objectForKey:@"albumcaption"]];
        cell.cellThumb.image = [UIImage imageNamed:[aalbumDict objectForKey:@"albumthumb"]];
        cell.imgFrame.image = [UIImage imageNamed:[aalbumDict objectForKey:@"albumframe"]];
        
        if (imageCount.count>0) {
            [cell.countLabel setText:[NSString stringWithFormat:@"%i",[imageCount count]]];
            cell.countLabel.hidden=NO;
        } else {
            cell.countLabel.hidden=YES;
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tapOnCell" object:self];
    
	UIButton *tmp = [[UIButton alloc] init];
	int currentIndex = indexPath.section;
	tmp.tag = indexPath.row;
    if ([typeOfAlbum isEqualToString:@"photos"]) {
        [self click2Open:tmp inSection:currentIndex];
        NSLog(@"row is %i  and section is  %i", indexPath.row, indexPath.section);
    }
    else
    {
        [self clickOpen:tmp inSection:currentIndex];
    }
}

#pragma mark - Thumbnail Action
// Used in Photos Layout.
// In Photos layout, tap on one thumbnail, photo gallery start at that index
-(void)click2Open:(id)sender inSection:(int)section {
	
	NSMutableArray *imageArr = [[NSMutableArray alloc] init];
	NSMutableArray *capArr = [[NSMutableArray alloc] init];
    NSMutableArray *typeArr = [[NSMutableArray alloc] init];
    NSMutableArray *fileArr = [[NSMutableArray alloc] init];
    
	NSDictionary *ggallDict = [_arr_AlbumData objectAtIndex:section];
	NSArray *ggalleryArray = [ggallDict objectForKey:@"sectioninfo"];
    for (int i = 0; i < [ggalleryArray count]; i++) {
        NSDictionary *itemDic = [[NSDictionary alloc] initWithDictionary:ggalleryArray[i]];

        //Add all items' names into this array
        if ([[itemDic objectForKey:@"albumtype"] isEqualToString:@"image"]) {
            [fileArr addObjectsFromArray: [itemDic objectForKey:@"images"]];
            [imageArr addObjectsFromArray: [itemDic objectForKey:@"images"]];
            [capArr addObjectsFromArray: [itemDic objectForKey:@"captions"]];
            
            NSArray *tmpImgArr = [[NSArray alloc] initWithArray:[itemDic objectForKey:@"images"]];
            for (int j = 0; j < [tmpImgArr count]; j++) {
                [typeArr addObject:[itemDic objectForKey:@"albumtype"]];
            }
        }
        if ([[itemDic objectForKey:@"albumtype"] isEqualToString:@"film"]) {
            [fileArr addObject:[itemDic objectForKey:@"film"]];
            // Add item's type into this array
            [typeArr addObject:[itemDic objectForKey:@"albumtype"]];
        }
        if ([[itemDic objectForKey:@"albumtype"] isEqualToString:@"pdf"]) {
            [fileArr addObject:[itemDic objectForKey:@"pdf"]];
            // Add item's type into this array
            [typeArr addObject:[itemDic objectForKey:@"albumtype"]];
        }
        if ([[itemDic objectForKey:@"albumtype"] isEqualToString:@"url"]) {
            [fileArr addObject:[itemDic objectForKey:@"url"]];
            // Add item's type into this array
            [typeArr addObject:[itemDic objectForKey:@"albumtype"]];
        }
    }
//    NSLog(@"names: %@ =", fileArr);
//    NSLog(@"types: %@ =", typeArr);
    NSMutableDictionary *typesAndNamesDict = [[NSMutableDictionary alloc] init];
    [typesAndNamesDict setObject:typeArr forKey:@"types"];
    [typesAndNamesDict setObject:fileArr forKey:@"fileName"];
    
	if ([[[typesAndNamesDict objectForKey:@"types"] objectAtIndex:[sender tag]]isEqualToString:@"film"]) {
		NSArray *tmpFile = [[NSArray alloc] initWithArray:[typesAndNamesDict objectForKey:@"fileName"]];
        
		NSString *fileString = [[[tmpFile objectAtIndex:[sender tag]] lastPathComponent] stringByDeletingPathExtension];
		NSString *extensionString = [[tmpFile objectAtIndex:[sender tag]] pathExtension];
		NSLog(@"%@.%@",fileString,extensionString);
        
		[self playMovie:fileString ofType:extensionString];
		
	} else if ([[[typesAndNamesDict objectForKey:@"types"] objectAtIndex:[sender tag]] isEqualToString:@"image"]) {
		NSLog(@"image");
		localImages =  imageArr;
		localCaptions = [NSArray arrayWithArray:capArr];
		//[self imageViewer:sender];
        UINavigationController *fGalleryNavigationController = [[UINavigationController alloc] init];
        fGalleryNavigationController.view.frame = self.view.frame;
        //[fGalleryNavigationController setToolbarHidden:NO];
//        [fGalleryNavigationController.view setBackgroundColor:[UIColor clearColor]];
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
        localGallery.startingIndex = [sender tag];
        [fGalleryNavigationController addChildViewController:localGallery];
        [fGalleryNavigationController.view addSubview:localGallery.view];
//		[self.navigationController pushViewController:localGallery animated:YES];
        [self addChildViewController:fGalleryNavigationController];
        [self.view addSubview:fGalleryNavigationController.view];
        
        
	} else if ([[[typesAndNamesDict objectForKey:@"types"] objectAtIndex:[sender tag]] isEqualToString:@"pdf"]) {
        NSArray *tmpFile = [[NSArray alloc] initWithArray:[typesAndNamesDict objectForKey:@"fileName"]];
        [self viewPDF:[tmpFile objectAtIndex:[sender tag]]];
		
	}else if([[[typesAndNamesDict objectForKey:@"types"] objectAtIndex:[sender tag]]  isEqualToString:@"url"]){
        NSArray *tmpFile = [[NSArray alloc] initWithArray:[typesAndNamesDict objectForKey:@"fileName"]];
        NSString *theURL =[tmpFile objectAtIndex:[sender tag]];
        NSLog(@"the  url is %@", theURL);
        [self openWebPage:theURL];
    }
}

-(void)clickOpen:(id)sender inSection:(int)section {
	
	NSMutableArray *imageArr = [[NSMutableArray alloc] initWithCapacity:1];
	NSMutableArray *capArr = [[NSMutableArray alloc] initWithCapacity:1];
    
	NSDictionary *ggallDict = [_arr_AlbumData objectAtIndex:section];
	NSArray *ggalleryArray = [ggallDict objectForKey:@"sectioninfo"];
	NSDictionary *aalbumDict = [ggalleryArray objectAtIndex:[sender tag]];
	
    
	if ([[aalbumDict objectForKey:@"albumtype"] isEqualToString:@"film"]) {
		
		NSString *fileString = [[[aalbumDict objectForKey:@"film"] lastPathComponent] stringByDeletingPathExtension];
		NSString *extensionString = [[aalbumDict objectForKey:@"film"] pathExtension];
		NSLog(@"%@.%@",fileString,extensionString);
        
		[self playMovie:fileString ofType:extensionString];
		
	} else if ([[aalbumDict objectForKey:@"albumtype"] isEqualToString:@"image"]) {
		NSLog(@"image");
		[imageArr addObjectsFromArray:[aalbumDict objectForKey:@"images"]];
		[capArr addObjectsFromArray:[aalbumDict objectForKey:@"captions"]];
		localImages =  imageArr;
		localCaptions = [NSArray arrayWithArray:capArr];
		//[self imageViewer:sender];
		localGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
		//[navigationController pushViewController:localGallery animated:YES];
		
	} else if ([[aalbumDict objectForKey:@"albumtype"] isEqualToString:@"pdf"]) {
		NSLog(@"pdf %@",[aalbumDict objectForKey:@"pdf"]);
		[self viewPDF:[aalbumDict objectForKey:@"pdf"]];

	}else if([[aalbumDict objectForKey:@"albumtype"] isEqualToString:@"url"]){
        NSString *theURL =[aalbumDict objectForKey:@"url"];
        NSLog(@"the  url is %@", theURL);
        [self openWebPage:theURL];
    }
}

-(void)openWebPage:(NSString *)theUrl
{
	embWebViewController *webViewController = [[embWebViewController alloc]
                                                   initWithNibName:@"embWebViewController"
                                                   bundle:nil];
	[webViewController socialButton:theUrl];
	webViewController.title = theUrl;
//    webViewController.tabBarController.tabBar.tintColor = [UIColor ebPurpleColor];
    
    [self presentViewController:webViewController animated:YES completion:nil];
}
#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    int num;
//    if( gallery == localGallery ) {
//		num = [localImages count];
//	}
//	else if( gallery == networkGallery ) {
//		num = [networkImages count];
//	}
	num = [localImages count];
	return num;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
	if( gallery == localGallery ) {
		return FGalleryPhotoSourceTypeLocal;
	}
	else return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
   if( gallery == localGallery ) {
        caption = [localCaptions objectAtIndex:index];
    }
	//    else if( gallery == networkGallery ) {
	//        caption = [networkCaptions objectAtIndex:index];
	//    }
	return caption;
}

- (NSString*)photoGallery:(FGalleryViewController*)gallery filePathForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index {
    return [localImages objectAtIndex:index];
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
}

- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

-(void)imageViewer:(id)sender {
	
    //	UIButton *tmpBtn = (UIButton*)sender;
    //
    //	galleryNameString = tmpBtn.titleLabel.text;
    //	tmpBtn.alpha = 0.6;
    //
    //	GalleryImagesViewController *vc = [[GalleryImagesViewController alloc] initWithGallery:[Gallery galleryNamed:galleryNameString]];
    //	[vc goToPageAtIndex:0 animated:NO];
    //
    //	CATransition* transition = [CATransition animation];
    //	transition.duration = 0.33;
    //	transition.type = kCATransitionFade;
    //	transition.subtype = kCATransitionFromTop;
    //
    //	[self.navigationController.view.layer
    //	 addAnimation:transition forKey:kCATransition];
    //	[self.navigationController pushViewController:vc animated:NO];
}

#pragma mark
#pragma mark PDF Viewer

-(void)viewPDF:(NSString*)thisPDF {
	
	NSLog(@"thisPDF %@",thisPDF);
    
	NSString *fileToOpen = [[NSBundle mainBundle] pathForResource:thisPDF ofType:@"pdf"];
	NSLog(@"fileToOpen %@",fileToOpen);
	NSURL *url = [NSURL fileURLWithPath:fileToOpen];
	
	doccontroller = [UIDocumentInteractionController interactionControllerWithURL:url];
	[self previewDocumentWithURL:url];
}

- (void)previewDocumentWithURL:(NSURL*)url
{
    UIDocumentInteractionController* preview = [UIDocumentInteractionController interactionControllerWithURL:url];
    preview.delegate = self;
    [preview presentPreviewAnimated:YES];
}

//======================================================================
- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{
}

//===================================================================
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
	return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
	return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
	return self.view.frame;
}


#pragma mark - External Monitor Detection
- (void)setupExternalScreen
{
	if ([[UIScreen screens] count] > 1)
    {
		[self setUpScreenConnectionNotificationHandlers];
        // Get the screen object that represents the external display.
        external_disp = [[UIScreen screens] objectAtIndex:1];
        // Get the screen's bounds so that you can create a window of the correct size.
        CGRect screenBounds = external_disp.bounds;
		
        external_wind = [[UIWindow alloc] initWithFrame:screenBounds];
        external_wind.screen = external_disp;
        // Set up initial content to display...
        // Show the window.
        external_wind.hidden = NO;
    }
}

#pragma mark - Movie Player
#pragma mark - PLAY MOVIE
-(void)playMovie:(NSString*)movieName ofType:(NSString*)extension {
	
	NSLog(@"The parameters are %@ and %@", movieName, extension);
	NSString *url = [[NSBundle mainBundle]
					 pathForResource:@"Groundbreaking"
					 ofType:@"mp4"];
	NSLog(@"The url is %@", url);
    _playerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
	_playerViewController.view.frame = CGRectMake(0, 0, 1024, 768);
	_playerViewController.view.alpha=0.0;
    _playerViewController.wantsFullScreenLayout = YES;
	//_playerViewController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
	_playerViewController.moviePlayer.controlStyle =  MPMovieControlStyleNone;
	[_playerViewController.moviePlayer setAllowsAirPlay:YES];
	_playerViewController.moviePlayer.repeatMode = MPMovieRepeatModeOne;
	
	if (!external_wind) {
		[self setupExternalScreen];
	}
	if (external_wind) {
		[external_wind addSubview:_playerViewController.view];
		[self useCustomMovieControls];
	} else {
		[self.view addSubview:_playerViewController.view];
		[UIView animateWithDuration:0.33 animations:^(void) {
			_playerViewController.view.alpha=1.0;
		}];
		[_playerViewController.moviePlayer play];
	}
	
	[[NSNotificationCenter defaultCenter] removeObserver:_playerViewController
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:_playerViewController.moviePlayer];
	
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(movieFinishedCallback:)
												 name:MPMoviePlayerPlaybackDidFinishNotification
											   object:_playerViewController.moviePlayer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidecontrol)
												 name:MPMoviePlayerLoadStateDidChangeNotification
											   object:_playerViewController.moviePlayer];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDurationAvailableNotification)
												 name:MPMovieDurationAvailableNotification
											   object:_playerViewController.moviePlayer];
	
	[self.navigationController setNavigationBarHidden:YES animated:YES];
	[self.navigationController setToolbarHidden:YES animated:YES];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)useCustomMovieControls
{
	// Create a category view and add it to the window.
	mpControlsView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 1024, 768)];
	[mpControlsView setBackgroundColor: [UIColor blackColor]];
	mpControlsView.alpha = 0.8;
	[self.view addSubview:mpControlsView];
	
	closeMovieButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[closeMovieButton setTitle:@"PAUSE" forState:UIControlStateNormal];
	CGRect frame = CGRectMake (512, 384, 90, 37);
	[closeMovieButton setFrame: frame];
	[closeMovieButton addTarget:self action:@selector(pause) forControlEvents:UIControlEventTouchUpInside];
	[mpControlsView addSubview:closeMovieButton];
	
	UIButton* closeMe = [UIButton buttonWithType: UIButtonTypeRoundedRect];
	[closeMe setTitle:@"CLOSE" forState:UIControlStateNormal];
	frame = CGRectMake (512, 430, 90, 37);
	[closeMe setFrame: frame];
	[closeMe addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
	[mpControlsView addSubview:closeMe];
	
	frame = CGRectMake(512, 530.0, 200.0, 10.0);
    progressIndicator = [[UISlider alloc] initWithFrame:frame];
    [progressIndicator addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [progressIndicator setBackgroundColor:[UIColor clearColor]];
    //progressIndicator.minimumValue = 0.0;
    //progressIndicator.maximumValue = 5000.0;
    progressIndicator.continuous = YES;
    //progressIndicator.value = 25.0;
	[mpControlsView addSubview:progressIndicator];
	
	[self monitorPlaybackTime];
}

- (IBAction)sliderAction: (UISlider*)sender
{
	_playerViewController.moviePlayer.currentPlaybackTime = totalVideoTime*progressIndicator.value;
}

-(void)pause {
	if (_playerViewController.moviePlayer.playbackState == MPMoviePlaybackStatePlaying) {
		[_playerViewController.moviePlayer pause];
		[closeMovieButton setTitle:@"PLAY" forState:UIControlStateNormal];
	} else {
		[_playerViewController.moviePlayer play];
		[closeMovieButton setTitle:@"PAUSE" forState:UIControlStateNormal];
		[self monitorPlaybackTime];
	}
}

-(void)remove {
    if ([[UIScreen screens] count] > 1) {
        // Hide and then delete the window.
		[_playerViewController.moviePlayer pause];
		external_wind.hidden = YES;
		external_wind = nil;
		[mpControlsView removeFromSuperview];
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(monitorPlaybackTime) object:nil];
	}
}

- (void)monitorPlaybackTime
{
	[[NSNotificationCenter defaultCenter] removeObserver:_playerViewController
													name:MPMovieDurationAvailableNotification
												  object:_playerViewController.moviePlayer];
	
	progressIndicator.value = _playerViewController.moviePlayer.currentPlaybackTime / totalVideoTime;
	//constantly keep checking if at the end of video:
	if (totalVideoTime != 0 && _playerViewController.moviePlayer.currentPlaybackTime >= totalVideoTime - 0.1)
	{
		//-------- rewind code:
		_playerViewController.moviePlayer.currentPlaybackTime = 0;
		[_playerViewController.moviePlayer pause];
	}
	else
	{
		[self performSelector:@selector(monitorPlaybackTime) withObject:nil afterDelay:0.5];
	}
}

- (void) handleDurationAvailableNotification
{
	totalVideoTime = _playerViewController.moviePlayer.duration;
	_playerViewController.moviePlayer.currentPlaybackTime = 0;
	[_playerViewController.moviePlayer play];
	NSLog(@"handleDurationAvailableNotification");
}

- (void)movieFinishedCallback:(NSNotification*)aNotification {
	NSLog(@"movieFinishedCallback");
    
	// Obtain the reason why the movie playback finished
    NSNumber *finishReason = [[aNotification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"unhideMainMenuBtm"
     object:self];
	[[NSNotificationCenter defaultCenter]
     postNotificationName:@"unhideMainMenuLogo"
     object:self];
	// Dismiss the view controller ONLY when the reason is not "playback ended"
    if ([finishReason intValue] != MPMovieFinishReasonPlaybackEnded)
    {
		NSLog(@"!!MPMovieFinishReasonPlaybackEnded");
        
		MPMoviePlayerController *moviePlayer = [aNotification object];
        // Remove this class from the observers
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:moviePlayer];
        // Dismiss the view controller
		
		[UIView animateWithDuration:0.33
	 					 animations:^{
							 _playerViewController.view.alpha=0.0;
						 }
	 					 completion:^(BOOL  completed){
							 [_playerViewController.view removeFromSuperview];
							 _playerViewController = nil;
						 }];
    } else {
		NSLog(@"else movieFinishedCallback");
        
		[_playerViewController.view removeFromSuperview];
		_playerViewController = nil;
	}
	
	if ([[UIScreen screens] count] > 1) {
		NSLog(@"window");
		// Hide and then delete the window.
		external_wind.hidden = YES;
		external_wind = nil;
		[mpControlsView removeFromSuperview];
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:MPMovieDurationAvailableNotification
													  object:_playerViewController.moviePlayer];
	} else {
		NSLog(@"who knows movieFinishedCallback");
		[UIView animateWithDuration:0.33
	 					 animations:^{
							 _playerViewController.view.alpha=0.0;
						 }
	 					 completion:^(BOOL  completed){
							 [_playerViewController.view removeFromSuperview];
							 _playerViewController = nil;
						 }];
        
	}
}

- (void)setUpScreenConnectionNotificationHandlers
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
				   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
				   name:UIScreenDidDisconnectNotification object:nil];
}

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification
{
    UIScreen *newScreen = [aNotification object];
    CGRect screenBounds = newScreen.bounds;
	
    if (!external_wind)
    {
        external_wind = [[UIWindow alloc] initWithFrame:screenBounds];
        external_wind.screen = newScreen;
		
        // Set the initial UI for the window.
    }
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification
{
    if ([[UIScreen screens] count] > 1)
    {
        // Hide and then delete the window.
        external_wind.hidden = YES;
        external_wind = nil;
    }
}

- (void)hidecontrol {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerNowPlayingMovieDidChangeNotification
												  object:_playerViewController];
	_playerViewController.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)moviePlaybackComplete:(NSNotification *)notification
{
	NSLog(@"moviePlaybackComplete");
    
	MPMoviePlayerController *moviePlayerController = [notification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:MPMoviePlayerPlaybackDidFinishNotification
												  object:moviePlayerController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
