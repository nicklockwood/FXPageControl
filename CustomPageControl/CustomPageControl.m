//
//  CustomPageControl.m
//
//  Version 1.1.1
//
//  Created by Nick Lockwood on 07/01/2010.
//  Copyright 2010 Charcoal Design. All rights reserved.
//
//  Get the latest version of CustomPageControl from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#custompagecontrol
//  https://github.com/nicklockwood/CustomPageControl
//
//  This software is provided 'as-is', without any express or implied
//  warranty.  In no event will the authors be held liable for any damages
//  arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,
//  including commercial applications, and to alter it and redistribute it
//  freely, subject to the following restrictions:
//
//  1. The origin of this software must not be misrepresented; you must not
//  claim that you wrote the original software. If you use this software
//  in a product, an acknowledgment in the product documentation would be
//  appreciated but is not required.
//
//  2. Altered source versions must be plainly marked as such, and must not be
//  misrepresented as being the original software.
//
//  3. This notice may not be removed or altered from any source distribution.
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
    //needs redrawing if bounds change
    //this isn't a private method, but using KVC avoids having to import <QuartzCore>
    [self.layer setValue:[NSNumber numberWithBool:YES] forKey:@"needsDisplayOnBoundsChange"];
    
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
