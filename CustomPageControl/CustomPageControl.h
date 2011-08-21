//
//  CustomPageControl.h
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

@interface CustomPageControl : UIControl

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;
- (void)updateCurrentPageDisplay;

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, assign) BOOL defersCurrentPageDisplay;
@property (nonatomic, assign) BOOL hidesForSinglePage;
@property (nonatomic, assign) BOOL wrap;

@property (nonatomic, retain) UIColor *dotColour;
@property (nonatomic, retain) UIColor *selectedDotColour;
@property (nonatomic, assign) CGFloat dotSpacing;
@property (nonatomic, assign) CGFloat dotSize;

@end
