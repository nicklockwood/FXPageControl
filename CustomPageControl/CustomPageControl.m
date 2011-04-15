//
//  CustomPageControl.m
//
//  Created by Nick Lockwood on 07/01/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//

#import "CustomPageControl.h"


@implementation CustomPageControl

@synthesize currentPage;
@synthesize numberOfPages;
@synthesize hidesForSinglePage;
@synthesize wrap;
@synthesize dotColour;
@synthesize selectedDotColour;
@synthesize dotSpacing;
@synthesize dotSize;

- (void)setup
{	
	//set defaults
    self.selectedDotColour = [UIColor whiteColor];
	self.dotColour = [UIColor colorWithWhite:1.0 alpha:0.25];
	dotSpacing = 10.0;
	dotSize = 6.0;
	hidesForSinglePage = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setup];
	}
	return self;
}

- (void)drawRect:(CGRect)rect
{
	if ([self numberOfPages] > 1 || !hidesForSinglePage)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGFloat width = dotSize + (dotSize + dotSpacing) * (numberOfPages - 1);
		CGFloat offset = (self.frame.size.width - width) / 2;
		
		for (int i = 0; i < [self numberOfPages]; i++)
		{
			CGContextSetFillColorWithColor(context, [(i == currentPage)? selectedDotColour: dotColour CGColor]);
			CGContextFillEllipseInRect(context, CGRectMake(offset + (dotSize + dotSpacing) * i, (self.frame.size.height / 2) - (dotSize / 2), dotSize, dotSize));
		}
	}
}

- (void)setCurrentPage:(NSInteger)page
{
	if (wrap)
    {
        page = (page + numberOfPages) % numberOfPages;
    }
    else
    {
        page = MIN(MAX(0, page), numberOfPages - 1);
    }
    currentPage = page;
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages
{
	if (numberOfPages != pages)
    {
        numberOfPages = pages;
        [self setNeedsDisplay];
    }
	if (currentPage >= numberOfPages)
	{
		self.currentPage = numberOfPages - 1;
	}
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint point = [touch locationInView:self];
	self.currentPage += (point.x > self.frame.size.width/2)? 1: -1;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (void)dealloc
{	
	[dotColour release];
	[selectedDotColour release];	
    [super dealloc];
}

@end
