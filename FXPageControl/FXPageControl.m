//
//  FXPageControl.m
//
//  Version 1.2.1
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


#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif


@implementation NSObject (FXPageControl)

- (UIColor *)pageControl:(FXPageControl *)pageControl colorForDotAtIndex:(NSInteger)index { return nil; }
- (UIColor *)pageControl:(FXPageControl *)pageControl selectedColorForDotAtIndex:(NSInteger)index { return nil; }
- (UIImage *)pageControl:(FXPageControl *)pageControl imageForDotAtIndex:(NSInteger)index { return nil; }
- (UIImage *)pageControl:(FXPageControl *)pageControl selectedImageForDotAtIndex:(NSInteger)index { return nil; }

@end


@implementation FXPageControl

- (void)setUp
{	
    //needs redrawing if bounds change
    //this isn't a private method, but this approach avoids having to import <QuartzCore>
    [self setValue:@YES forKeyPath:@"layer.needsDisplayOnBoundsChange"];
    
	//set defaults
	_dotSpacing = 10.0f;
	_dotSize = 6.0f;
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

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    CGFloat width = _dotSize + (_dotSize + _dotSpacing) * (_numberOfPages - 1);
    return CGSizeMake(width, fmaxf(_dotSize, 36.0f));
}

- (void)updateCurrentPageDisplay
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	if (_numberOfPages > 1 || !_hidesForSinglePage)
	{		
		CGFloat width = [self sizeForNumberOfPages:_numberOfPages].width;
		CGFloat offset = (self.frame.size.width - width) / 2.0f;
		
		for (int i = 0; i < _numberOfPages; i++)
		{
			UIImage *dotImage = nil;
            UIColor *dotColor = nil;
			if (i == _currentPage)
			{
				[_selectedDotColor setFill];
				dotImage = [_delegate pageControl:self selectedImageForDotAtIndex:i] ?: _selectedDotImage;
				dotColor = [_delegate pageControl:self selectedColorForDotAtIndex:i] ?: _selectedDotColor ?: [UIColor blackColor];
			}
			else
			{
				[_dotColor setFill];
                dotImage = [_delegate pageControl:self imageForDotAtIndex:i] ?: _dotImage;
				dotColor = [_delegate pageControl:self colorForDotAtIndex:i] ?: _dotColor;
                if (!dotColor)
                {
                    //fall back to selected dot color with reduced alpha
                    dotColor = [_delegate pageControl:self selectedColorForDotAtIndex:i] ?: _selectedDotColor ?: [UIColor blackColor];
                    dotColor = [dotColor colorWithAlphaComponent:0.25f];
                }
			}
			if (dotImage)
			{
				[dotImage drawInRect:CGRectMake(offset + (_dotSize + _dotSpacing) * i + (_dotSize - dotImage.size.width) / 2.0f, (self.frame.size.height / 2.0f) - (dotImage.size.height / 2.0f), dotImage.size.width, dotImage.size.height)];
			}
			else
			{
                [dotColor setFill];
                CGContextRef context = UIGraphicsGetCurrentContext();
				CGContextFillEllipseInRect(context, CGRectMake(offset + (_dotSize + _dotSpacing) * i, (self.frame.size.height / 2.0f) - (_dotSize / 2.0f), _dotSize, _dotSize));
			}
		}
	}
}

- (NSInteger)clampedPageValue:(NSInteger)page
{
	if (_wrapEnabled)
    {
        return _numberOfPages? (page + _numberOfPages) % _numberOfPages: 0;
    }
    else
    {
        return MIN(MAX(0, page), _numberOfPages - 1);
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

- (void)setSelectedDotColor:(UIColor *)dotColor
{
	if (_selectedDotColor != dotColor)
	{
		_selectedDotColor = dotColor;
		[self setNeedsDisplay];
	}
}

- (void)setDotSpacing:(CGFloat)dotSpacing
{
	if (_dotSpacing != dotSpacing)
	{
		_dotSpacing = dotSpacing;
		[self setNeedsDisplay];
	}
}

- (void)setDotSize:(CGFloat)dotSize
{
	if (_dotSize != dotSize)
	{
		_dotSize = dotSize;
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
        if (_currentPage >= pages)
        {
            _currentPage = pages - 1;
        }
        [self setNeedsDisplay];
    }
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint point = [touch locationInView:self];
	_currentPage = [self clampedPageValue:_currentPage + ((point.x > self.frame.size.width / 2.0f)? 1: -1)];
    if (!_defersCurrentPageDisplay)
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

@end
