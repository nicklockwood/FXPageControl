//
//  CustomPageControl.h
//
//  Created by Nick Lockwood on 07/01/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

@interface CustomPageControl : UIControl

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) BOOL wrap;

@property (nonatomic, retain) UIColor *dotColour;
@property (nonatomic, retain) UIColor *selectedDotColour;
@property (nonatomic, assign) CGFloat dotSpacing;
@property (nonatomic, assign) CGFloat dotSize;

@end
