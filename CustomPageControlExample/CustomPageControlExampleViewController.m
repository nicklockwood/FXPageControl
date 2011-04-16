//
//  CustomPageControlExampleViewController.m
//  CustomPageControlExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomPageControlExampleViewController.h"


@implementation CustomPageControlExampleViewController

@synthesize scrollView1;
@synthesize scrollView2;
@synthesize pageControl1;
@synthesize pageControl2;
@synthesize contentView1;
@synthesize contentView2;


- (void)dealloc
{
    [scrollView1 release];
    [scrollView2 release];
    [pageControl1 release];
    [pageControl2 release];
    [contentView1 release];
    [contentView2 release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up first view
    scrollView1.pagingEnabled = YES;
    scrollView1.contentSize = contentView1.bounds.size;
    scrollView1.showsHorizontalScrollIndicator = NO;
    [scrollView1 addSubview:contentView1];
    pageControl1.numberOfPages = contentView1.bounds.size.width / scrollView1.bounds.size.width;
    pageControl1.defersCurrentPageDisplay = YES;
    
    //set up second view
    scrollView2.pagingEnabled = YES;
    scrollView2.contentSize = contentView2.bounds.size;
    scrollView2.showsHorizontalScrollIndicator = NO;
    [scrollView2 addSubview:contentView2];
    pageControl2.numberOfPages = contentView2.bounds.size.width / scrollView2.bounds.size.width;
    pageControl2.defersCurrentPageDisplay = YES;
    pageControl2.selectedDotColour = [UIColor redColor];
    pageControl2.dotColour = [UIColor blueColor];
    pageControl2.dotSize = 10.0;
    pageControl2.dotSpacing = 30.0;
    pageControl2.wrap = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.scrollView1 = nil;
    self.scrollView2 = nil;
    self.pageControl1 = nil;
    self.pageControl2 = nil;
    self.contentView1 = nil;
    self.contentView2 = nil;
}

- (IBAction)pageControlAction:(CustomPageControl *)sender
{
    //update scrollview when pagecontrol is tapped
    if (sender == pageControl1)
    {
        CGPoint offset = CGPointMake(sender.currentPage * scrollView1.bounds.size.width, 0);
        [scrollView1 setContentOffset:offset animated:YES];
    }
    else
    {
        CGPoint offset = CGPointMake(sender.currentPage * scrollView2.bounds.size.width, 0);
        [scrollView2 setContentOffset:offset animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //update page control when scrollview scrolls
    //prevent flicker by only updating when page index has changed
    NSInteger pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.size.width);
    if (scrollView == scrollView1)
    {
        pageControl1.currentPage = pageIndex;
        pageControl1.selectedDotColour = (pageIndex == 2)? [UIColor whiteColor]: [UIColor blackColor];
        pageControl1.dotColour = (pageIndex == 2)?
            [UIColor colorWithWhite:1.0 alpha:0.25]: [UIColor colorWithWhite:0.0 alpha:0.25];
    }
    else
    {
        pageControl2.currentPage = pageIndex;
    }
}

@end
