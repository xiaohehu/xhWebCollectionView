//
//  embWebViewController.m
//  embAlbumViewController
//
//  Created by Xiaohe Hu on 10/8/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embWebViewController.h"

@interface embWebViewController ()
@property (strong, nonatomic) NSString *urlAddress;
@property (strong, nonatomic) AppDelegate *appDelegate;
@end

@implementation embWebViewController


@synthesize activityIndicator;
@synthesize webView, ebTitle;

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
	[self checkWireless];
	[activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator setHidesWhenStopped:YES];
}

-(void)checkWireless {
    
	_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"Reading as %@", _appDelegate.isWirelessAvailable);
    
    if ([_appDelegate.isWirelessAvailable isEqualToString:@"NO"]) {
        NSLog(@"Wireless NO");
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Status"
														message:@"A network connection is required to view this website. Please check your internet connection and try again."
													   delegate:self
											  cancelButtonTitle:@"OK"
											  otherButtonTitles: nil];
        [alert show];
    } else if ([_appDelegate.isWirelessAvailable isEqualToString:@"YES"]) {
        NSLog(@"Wireless YES");
    }
}

-(IBAction)socialButton:(NSString*)myTag;
{
	
	NSLog(@"load %@", myTag);
	CGRect webFrame = CGRectMake(0.0, 44.0, 1024.0, 724.0);
	webView = [[UIWebView alloc] initWithFrame:webFrame];
    
	[webView setBackgroundColor:[UIColor blackColor]];
	webView.delegate = self;
	webView.scalesPageToFit=YES;
	_urlAddress = myTag;
	NSURL *url = [NSURL URLWithString:_urlAddress];
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	[webView loadRequest:requestObj];
	[self.view addSubview:webView];
	[webView addSubview:activityIndicator];
}

-(IBAction)callOutActSheet
{
    NSString* someText = _urlAddress;
    NSArray *dataShare = [[NSArray alloc] initWithObjects:someText, nil];
    UIActivityViewController* activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:dataShare
                                      applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:^{}];
//    [activityViewController setCompletionHandler:^(NSString *act, BOOL done)
//     {
//         NSString *serviceMsg = nil;
//         if ([act isEqualToString:UIActivityTypeMail]) {
//             serviceMsg = @"Mail Sended!";
//         }
//         if ( [act isEqualToString:UIActivityTypePostToTwitter] )  serviceMsg = @"Post on twitter, ok!";
//         if ( [act isEqualToString:UIActivityTypePostToFacebook] ) serviceMsg = @"Post on facebook, ok!";
//         if ( [act isEqualToString:UIActivityTypeMessage] )        serviceMsg = @"SMS sended!";
//         if ( done )
//         {
//             UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:serviceMsg message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//             [Alert show];
//         }
//     }];
}

-(IBAction)webGoBack
{
	if ([webView canGoBack]) {
		[webView goBack];
	}
}

-(IBAction)webGoForward
{
	if ([webView canGoForward]) {
		[webView goForward];
	}
}

-(IBAction)webStop
{
    [webView stopLoading];
}

-(IBAction)webRefresh
{
	[webView reload];
}

-(IBAction)dismissModal {
	[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webPage
{
	[activityIndicator startAnimating];
	NSLog(@"start animating");
}

- (void)webViewDidFinishLoad:(UIWebView *)webPage
{
	[activityIndicator stopAnimating];
	NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	ebTitle.text = theTitle;
	NSLog(@"STOP animating");
}

- (void)webPage:(UIWebView *)webPages didFailLoadWithError:(NSError *)error
{
	NSString* errorString = [NSString stringWithFormat:
							 @"<html><center><br /><br /><font size=+5 color='red'>Error<br /><br />Your request %@</font></center></html>",
							 error.localizedDescription];
	[webPages loadHTMLString:errorString baseURL:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft | interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)viewDidUnload {
	[self setTitle:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

@end
