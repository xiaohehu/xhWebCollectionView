//
//  embUICollectionViewLayout.m
//  embAlbumViewController
//
//  Created by Xiaohe Hu on 11/13/13.
//  Copyright (c) 2013 neoscape. All rights reserved.
//

#import "embUICollectionViewLayout.h"
static float kCellSize_W = 210.0;
static float kCellSize_H = 169.0;
static float kOffsets = 10;

@interface embUICollectionViewLayout()
@property (nonatomic) CGFloat                windowWidth;
@property (nonatomic) CGFloat                windowHeight;
@property (nonatomic) int                    numOfCells;
@property (nonatomic) int                    sumOfCells;
@property (nonatomic) int                    sizOfBigCell;
@end

@implementation embUICollectionViewLayout

-(void)setSectionIndex:(int)section
{
    sectionIndex = section;
}

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    
    return self;
}

- (void)prepareLayout {
    self.windowWidth = self.collectionView.bounds.size.width;
    self.windowHeight = self.collectionView.bounds.size.height;
    self.numOfCells = self.windowWidth / (kCellSize_W + kOffsets);
    self.sumOfCells = [self.collectionView numberOfItemsInSection:0];

    self.sizOfBigCell = 2;
}
//If collection view is slided veritcally, calculate # of pages and then multiply height of window
- (CGSize)collectionViewContentSize
{
    // Determine how many pages are needed
    int rowsOfPages = self.windowHeight / (kCellSize_H + kOffsets);
    int sumOfRows = 1+(self.sumOfCells+self.sizOfBigCell*self.sizOfBigCell -1) / self.numOfCells;
    int numOfPages = (sumOfRows/rowsOfPages);
    // Set the size
    float pageWidth = self.collectionView.frame.size.width;
    float pageHeight = self.collectionView.frame.size.height;
    CGSize contentSize = CGSizeMake(pageWidth, pageHeight*(numOfPages));//+kCellSize_W*(self.sizOfBigCell-1));
    
    return contentSize;
}
- (CGRect) frameForBigCell {
    CGSize size = CGSizeMake(self.sizOfBigCell*kCellSize_W+(self.sizOfBigCell-1)*kOffsets, self.sizOfBigCell*kCellSize_H+(self.sizOfBigCell-1)*kOffsets);

    return CGRectMake(0, 0, size.width, size.height);
}
- (CGRect) frameForTopRightCells:(int) index {
    CGSize size = CGSizeMake(kCellSize_W, kCellSize_H);
    CGFloat originX = 0.0;
    CGFloat originY = 0.0;
    
    int quotient = (index-1) / (self.numOfCells - self.sizOfBigCell);
    int residual = (index-1) % (self.numOfCells - self.sizOfBigCell);
    

    originY = quotient * (kOffsets + kCellSize_H);
    originX = (residual + self.sizOfBigCell) * (kOffsets + kCellSize_W);

    return CGRectMake(originX, originY, size.width, size.height);
}

-(CGRect)frameForNormalCells: (int)index
{
    CGSize size = CGSizeMake(kCellSize_W, kCellSize_H);
    CGFloat originX;
    CGFloat originY;
    int changedIndex = index - (self.sizOfBigCell*(self.numOfCells - self.sizOfBigCell) + 1);
    int residual = changedIndex % self.numOfCells;
    int quotient = changedIndex / self.numOfCells;
    
    originX = residual * (kCellSize_W + kOffsets);
    originY = (self.sizOfBigCell + quotient) * (kCellSize_H + kOffsets);
    
    return CGRectMake(originX, originY, size.width, size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    if (path.item == 0) {
        attributes.frame = [self frameForBigCell];
    }
    if (path.item > 0 && path.item < (self.sizOfBigCell*(self.numOfCells - self.sizOfBigCell) + 1))
    {
        attributes.frame = [self frameForTopRightCells:(int)path.item];
    }
    if (path.item >=(self.sizOfBigCell*(self.numOfCells - self.sizOfBigCell) + 1)) {
        
        attributes.frame = [self frameForNormalCells:(int)path.item];
    }

    return attributes;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray* arr_attributes = [NSMutableArray array];
    
    for (int i = 0 ; i < self.sumOfCells; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes* cellAttribs = [self layoutAttributesForItemAtIndexPath:indexPath];
        
        [arr_attributes addObject:cellAttribs];
    }
    
    return arr_attributes;
}
@end
