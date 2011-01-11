//
//  PageControl.h
//
//  Created by Nick Lockwood on 07/01/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

@interface PageControl : UIControl
{	
	NSUInteger currentPage;
	NSUInteger numberOfPages;
	BOOL hidesForSinglePage;
	
	UIColor *dotColour;
	UIColor *selectedDotColour;
	CGFloat dotSpacing;
	CGFloat dotSize;
}

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger numberOfPages;
@property (nonatomic, assign) BOOL hidesForSinglePage;

@property (nonatomic, retain) UIColor *dotColour;
@property (nonatomic, retain) UIColor *selectedDotColour;
@property (nonatomic, assign) CGFloat dotSpacing;
@property (nonatomic, assign) CGFloat dotSize;

@end
