//
//  FXPageControl.m
//
//  Version 1.3.2
//
//  Created by Nick Lockwood on 07/01/2010.
//  Copyright 2010 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version of FXPageControl from here:
//
//  https://github.com/nicklockwood/FXPageControl
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

#import "FXPageControl.h"


#pragma GCC diagnostic ignored "-Wgnu"
#pragma GCC diagnostic ignored "-Wreceiver-is-weak"
#pragma GCC diagnostic ignored "-Warc-repeated-use-of-weak"
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


const CGPathRef FXPageControlDotShapeCircle = (const CGPathRef)1;
const CGPathRef FXPageControlDotShapeSquare = (const CGPathRef)2;
const CGPathRef FXPageControlDotShapeTriangle = (const CGPathRef)3;
#define LAST_SHAPE FXPageControlDotShapeTriangle


@implementation NSObject (FXPageControl)

- (UIImage *)pageControl:(__unused FXPageControl *)pageControl imageForDotAtIndex:(__unused NSInteger)index { return nil; }
- (CGPathRef)pageControl:(__unused FXPageControl *)pageControl shapeForDotAtIndex:(__unused NSInteger)index { return NULL; }
- (UIColor *)pageControl:(__unused FXPageControl *)pageControl colorForDotAtIndex:(__unused NSInteger)index { return nil; }

- (UIImage *)pageControl:(__unused FXPageControl *)pageControl selectedImageForDotAtIndex:(__unused NSInteger)index { return nil; }
- (CGPathRef)pageControl:(__unused FXPageControl *)pageControl selectedShapeForDotAtIndex:(__unused NSInteger)index { return NULL; }
- (UIColor *)pageControl:(__unused FXPageControl *)pageControl selectedColorForDotAtIndex:(__unused NSInteger)index { return nil; }

@end


@implementation FXPageControl

- (void)setUp
{	
    //needs redrawing if bounds change
    self.contentMode = UIViewContentModeRedraw;
    
	//set defaults
	_dotSpacing = 10.0f;
	_dotSize = 6.0f;
    _dotShadowOffset = CGSizeMake(0, 1);
    _selectedDotShadowOffset = CGSizeMake(0, 1);
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		[self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setUp];
	}
	return self;
}

- (void)dealloc
{
    if (_dotShape > LAST_SHAPE) CGPathRelease(_dotShape);
    if (_selectedDotShape > LAST_SHAPE) CGPathRelease(_selectedDotShape);
}

- (CGSize)sizeForNumberOfPages:(__unused NSInteger)pageCount
{
    CGSize dotSize = CGSizeMake(self.dotSize + (self.dotSize + self.dotSpacing) * (self.numberOfPages - 1), self.dotSize);
    return CGSizeMake(dotSize.width, MAX(dotSize.height, 36.0f));
}

- (void)updateCurrentPageDisplay
{
    [self setNeedsDisplay];
}

- (void)drawRect:(__unused CGRect)rect
{
	if (self.numberOfPages > 1 || !self.hidesForSinglePage)
	{
        CGContextRef context = UIGraphicsGetCurrentContext();
        
		CGFloat width = [self sizeForNumberOfPages:self.numberOfPages].width;
		CGFloat offset = (self.frame.size.width - width) / 2;
    
		for (int i = 0; i < self.numberOfPages; i++)
		{
			UIImage *dotImage = nil;
            UIColor *dotColor = nil;
            CGPathRef dotShape = NULL;
            CGFloat dotSize = 0;
            UIColor *dotShadowColor = nil;
            CGSize dotShadowOffset = CGSizeZero;
            CGFloat dotShadowBlur = 0;
            
			if (i == self.currentPage)
			{
				dotImage = [self.delegate pageControl:self selectedImageForDotAtIndex:i] ?: self.selectedDotImage;
                dotShape = [self.delegate pageControl:self selectedShapeForDotAtIndex:i] ?: self.selectedDotShape ?: self.dotShape;
				dotColor = [self.delegate pageControl:self selectedColorForDotAtIndex:i] ?: self.selectedDotColor ?: [UIColor blackColor];
                dotShadowBlur = self.selectedDotShadowBlur;
                dotShadowColor = self.selectedDotShadowColor;
                dotShadowOffset = self.selectedDotShadowOffset;
                dotSize = self.selectedDotSize ?: self.dotSize;
			}
			else
			{
                dotImage = [self.delegate pageControl:self imageForDotAtIndex:i] ?: self.dotImage;
                dotShape = [self.delegate pageControl:self shapeForDotAtIndex:i] ?: self.dotShape;
				dotColor = [self.delegate pageControl:self colorForDotAtIndex:i] ?: self.dotColor;
                if (!dotColor)
                {
                    //fall back to selected dot color with reduced alpha
                    dotColor = [self.delegate pageControl:self selectedColorForDotAtIndex:i] ?: self.selectedDotColor ?: [UIColor blackColor];
                    dotColor = [dotColor colorWithAlphaComponent:0.25f];
                }
                dotShadowBlur = self.dotShadowBlur;
                dotShadowColor = self.dotShadowColor;
                dotShadowOffset = self.dotShadowOffset;
                dotSize = self.dotSize;
			}
            
            [dotColor setFill];
            
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, offset + (self.dotSize + self.dotSpacing) * i + self.dotSize / 2, self.frame.size.height / 2);
            if (dotShadowColor && ![dotShadowColor isEqual:[UIColor clearColor]])
            {
                CGContextSetShadowWithColor(context, dotShadowOffset, dotShadowBlur, dotShadowColor.CGColor);
            }
			if (dotImage)
			{
				[dotImage drawInRect:CGRectMake(-dotImage.size.width / 2, -dotImage.size.height / 2, dotImage.size.width, dotImage.size.height)];
			}
			else
			{
                if (!dotShape || dotShape == FXPageControlDotShapeCircle)
                {
                    CGContextFillEllipseInRect(context, CGRectMake(-dotSize / 2, -dotSize / 2, dotSize, dotSize));
                }
                else if (dotShape == FXPageControlDotShapeSquare)
                {
                    CGContextFillRect(context, CGRectMake(-dotSize / 2, -dotSize / 2, dotSize, dotSize));
                }
                else if (dotShape == FXPageControlDotShapeTriangle)
                {
                    CGContextBeginPath(context);
                    CGContextMoveToPoint(context, 0, -dotSize / 2);
                    CGContextAddLineToPoint(context, dotSize / 2, dotSize / 2);
                    CGContextAddLineToPoint(context, -dotSize / 2, dotSize / 2);
                    CGContextAddLineToPoint(context, 0, -dotSize / 2);
                    CGContextFillPath(context);
                }
                else
                {
                    CGContextBeginPath(context);
                    CGContextAddPath(context, dotShape);
                    CGContextFillPath(context);
                }
			}
            CGContextRestoreGState(context);
		}
	}
}

- (NSInteger)clampedPageValue:(NSInteger)page
{
	if (self.wrapEnabled)
    {
        return self.numberOfPages? (page + self.numberOfPages) % self.numberOfPages: 0;
    }
    else
    {
        return MIN(MAX(0, page), self.numberOfPages - 1);
    }
}

- (void)setDotImage:(UIImage *)dotImage
{
	if (_dotImage != dotImage)
	{
		_dotImage = dotImage;
		[self setNeedsDisplay];
	}
}

- (void)setDotShape:(CGPathRef)dotShape
{
	if (_dotShape != dotShape)
	{
        if (_dotShape > LAST_SHAPE) CGPathRelease(_dotShape);
        _dotShape = dotShape;
        if (_dotShape > LAST_SHAPE) CGPathRetain(_dotShape);
		[self setNeedsDisplay];
	}
}

- (void)setDotSize:(CGFloat)dotSize
{
    if (ABS(_dotSize - dotSize) > 0.001)
	{
		_dotSize = dotSize;
		[self setNeedsDisplay];
	}
}

- (void)setDotColor:(UIColor *)dotColor
{
	if (_dotColor != dotColor)
	{
		_dotColor = dotColor;
		[self setNeedsDisplay];
	}
}

- (void)setDotShadowColor:(UIColor *)dotColor
{
	if (_dotShadowColor != dotColor)
	{
		_dotShadowColor = dotColor;
		[self setNeedsDisplay];
	}
}

- (void)setDotShadowBlur:(CGFloat)dotShadowBlur
{
	if (ABS(_dotShadowBlur - dotShadowBlur) > 0.001)
	{
		_dotShadowBlur = dotShadowBlur;
		[self setNeedsDisplay];
	}
}

- (void)setDotShadowOffset:(CGSize)dotShadowOffset
{
	if (!CGSizeEqualToSize(_dotShadowOffset, dotShadowOffset))
	{
		_dotShadowOffset = dotShadowOffset;
		[self setNeedsDisplay];
	}
}

- (void)setSelectedDotImage:(UIImage *)dotImage
{
	if (_selectedDotImage != dotImage)
	{
		_selectedDotImage = dotImage;
		[self setNeedsDisplay];
	}
}

- (void)setSelectedDotColor:(UIColor *)dotColor
{
	if (_selectedDotColor != dotColor)
	{
		_selectedDotColor = dotColor;
		[self setNeedsDisplay];
	}
}

- (void)setSelectedDotShape:(CGPathRef)dotShape
{
	if (_selectedDotShape != dotShape)
	{
        if (_selectedDotShape > LAST_SHAPE) CGPathRelease(_selectedDotShape);
        _selectedDotShape = dotShape;
        if (_selectedDotShape > LAST_SHAPE) CGPathRetain(_selectedDotShape);
		[self setNeedsDisplay];
	}
}

- (void)setSelectedDotSize:(CGFloat)dotSize
{
    if (ABS(_selectedDotSize - dotSize) > 0.001)
	{
		_selectedDotSize = dotSize;
		[self setNeedsDisplay];
	}
}

- (void)setSelectedDotShadowColor:(UIColor *)dotColor
{
	if (_selectedDotShadowColor != dotColor)
	{
		_selectedDotShadowColor = dotColor;
		[self setNeedsDisplay];
	}
}

- (void)setSelectedDotShadowBlur:(CGFloat)dotShadowBlur
{
    if (ABS(_selectedDotShadowBlur - dotShadowBlur) > 0.001)
	{
		_selectedDotShadowBlur = dotShadowBlur;
		[self setNeedsDisplay];
	}
}

- (void)setSelectedDotShadowOffset:(CGSize)dotShadowOffset
{
	if (!CGSizeEqualToSize(_selectedDotShadowOffset, dotShadowOffset))
	{
		_selectedDotShadowOffset = dotShadowOffset;
		[self setNeedsDisplay];
	}
}

- (void)setDotSpacing:(CGFloat)dotSpacing
{
    if (ABS(_dotSpacing - dotSpacing) > 0.001)
	{
		_dotSpacing = dotSpacing;
		[self setNeedsDisplay];
	}
}

- (void)setDelegate:(id<FXPageControlDelegate>)delegate
{
	if (_delegate != delegate)
	{
		_delegate = delegate;
		[self setNeedsDisplay];
	}
}

- (void)setCurrentPage:(NSInteger)page
{
    _currentPage = [self clampedPageValue:page];
    [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages
{
	if (_numberOfPages != pages)
    {
        _numberOfPages = pages;
        if (self.currentPage >= pages)
        {
            self.currentPage = pages - 1;
        }
        [self setNeedsDisplay];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint point = [touch locationInView:self];
	_currentPage = [self clampedPageValue:self.currentPage + ((point.x > self.frame.size.width / 2)? 1: -1)];
    if (!self.defersCurrentPageDisplay)
    {
        [self setNeedsDisplay];
    }
	[self sendActionsForControlEvents:UIControlEventValueChanged];
	return [super beginTrackingWithTouch:touch withEvent:event];
}

- (CGSize)sizeThatFits:(__unused CGSize)size
{
    CGSize dotSize = [self sizeForNumberOfPages:self.numberOfPages];
    if (self.selectedDotSize)
    {
        dotSize.width += (self.selectedDotSize - self.dotSize);
        dotSize.height = MAX(self.dotSize, self.selectedDotSize);
    }
    if ((self.dotShadowColor && ![self.dotShadowColor isEqual:[UIColor clearColor]]) ||
        (self.selectedDotShadowColor && ![self.selectedDotShadowColor isEqual:[UIColor clearColor]]))
    {
        dotSize.width += MAX(self.dotShadowOffset.width, self.selectedDotShadowOffset.width) * 2;
        dotSize.height += MAX(self.dotShadowOffset.height, self.selectedDotShadowOffset.height) * 2;
        dotSize.width += MAX(self.dotShadowBlur, self.selectedDotShadowBlur) * 2;
        dotSize.height += MAX(self.dotShadowBlur, self.selectedDotShadowBlur) * 2;
    }
    return dotSize;
}

- (CGSize)intrinsicContentSize
{
    return [self sizeThatFits:self.bounds.size];
}

@end
