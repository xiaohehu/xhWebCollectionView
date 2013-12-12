//
//  ViewController.m
//  xhWebCollectionView
//
//  Created by Xiaohe Hu on 12/12/13.
//  Copyright (c) 2013 Xiaohe Hu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property embAlbumViewController *albumVC;
@end

@implementation ViewController


- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tap2013:(id)sender {
    _albumVC = [[embAlbumViewController alloc] initWithNibName:@"embAlbumViewController" bundle:nil];
    _albumVC.plistName = @"data";
    _albumVC.typeOfAlbum = @"photos";
    [self performSelector:@selector(vcTransition) withObject:nil afterDelay:0.1];
}

-(void)vcTransition
{
    CATransition *transitionAnimation = [CATransition animation];
	[transitionAnimation setDuration:0.33];
	[transitionAnimation setType:kCATransitionFade];
	[transitionAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    transitionAnimation.delegate = self;
	[self.view.layer addAnimation:transitionAnimation forKey:kCATransitionFade];
    
    [self addChildViewController:_albumVC];
//    [self.view insertSubview:albumVC.view belowSubview:uib_back];
    [self.view addSubview:_albumVC.view];
    [_albumVC didMoveToParentViewController:self];
}

@end
