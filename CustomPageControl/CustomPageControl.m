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
@synthesize defersCurrentPageDisplay;
@synthesize hidesForSinglePage;
@synthesize wrap;
@synthesize dotColour;
@synthesize selectedDotColour;
@synthesize dotSpacing;
@synthesize dotSize;

- (void)setup
{	
	//set defaults
    self.selectedDotColour = [UIColor blackColor];
	self.dotColour = [UIColor colorWithWhite:0.0 alpha:0.25];
	dotSpacing = 10.0;
	dotSize = 6.0;
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

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat width = dotSize + (dotSize + dotSpacing) * (numberOfPages - 1);
    return CGSizeMake(width, fmax(dotSize, 36));
}

- (void)updateCurrentPageDisplay
{
    if (defersCurrentPageDisplay)
    {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
	if (numberOfPages > 1 || !hidesForSinglePage)
	{
		CGContextRef context = UIGraphicsGetCurrentContext();
		
		CGFloat width = [self sizeForNumberOfPages:numberOfPages].width;
		CGFloat offset = (self.frame.size.width - width) / 2;
		
		for (int i = 0; i < numberOfPages; i++)
		{
			CGContextSetFillColorWithColor(context, [(i == currentPage)? selectedDotColour: dotColour CGColor]);
			CGContextFillEllipseInRect(context, CGRectMake(offset + (dotSize + dotSpacing) * i, (self.frame.size.height / 2) - (dotSize / 2), dotSize, dotSize));
		}
	}
}

- (NSInteger)clampedPageValue:(NSInteger)page
{
	if (wrap)
    {
        return (page + numberOfPages) % numberOfPages;
    }
    else
    {
        return MIN(MAX(0, page), numberOfPages - 1);
    }
}

- (void)setCurrentPage:(NSInteger)page
{
    currentPage = [self clampedPageValue:page];
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages
{
	if (numberOfPages != pages)
    {
        numberOfPages = pages;
        if (currentPage >= numberOfPages)
        {
            currentPage = numberOfPages - 1;
        }
        [self setNeedsDisplay];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint point = [touch locationInView:self];
	currentPage = [self clampedPageValue:currentPage + ((point.x > self.frame.size.width/2)? 1: -1)];
    if (!defersCurrentPageDisplay)
    {
        [self setNeedsDisplay];
    }
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(self.superview.bounds.size.width, [self sizeForNumberOfPages:1].height);
}

- (void)dealloc
{	
	[dotColour release];
	[selectedDotColour release];	
    [super dealloc];
}

@end
