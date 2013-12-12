//
//  embUICollectionViewLayout.h
//  embAlbumViewController
//
//  Created by Xiaohe Hu on 11/13/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import <UIKit/UIKit.h>
@class embUICollectionViewLayout;
//@protocol embUICollectionViewLayoutDelegate <UICollectionViewDelegate>
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView
//                   layout:(embUICollectionViewLayout *)collectionViewLayout
// heightForItemAtIndexPath:(NSIndexPath *)indexPath;
//@end

@interface embUICollectionViewLayout : UICollectionViewLayout
{
    int  sectionIndex;
}

//@property (nonatomic, weak) IBOutlet id<embUICollectionViewLayoutDelegate> delegate;

@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) CGFloat itemHight;
@property (nonatomic) CGFloat topInset;
@property (nonatomic) CGFloat bottomInset;

@end
