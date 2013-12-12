//
//  xhActivituprovider.m
//  embAlbumViewController
//
//  Created by Xiaohe Hu on 10/10/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "xhActivituprovider.h"

@implementation xhActivituprovider
- (id) activityViewController:(UIActivityViewController *)activityViewController
          itemForActivityType:(NSString *)activityType
{
    if ( [activityType isEqualToString:UIActivityTypePostToTwitter] )
        return @"This is a #twitter post!";
    if ( [activityType isEqualToString:UIActivityTypePostToFacebook] )
        return @"This is a facebook post!";
    if ( [activityType isEqualToString:UIActivityTypeMessage] )
        return @"SMS message text";
    if ( [activityType isEqualToString:UIActivityTypeMail] )
        return @"Email text here!";
    return nil;
}
- (id) activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController { return @""; }
@end
