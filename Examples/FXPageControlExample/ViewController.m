//
//  CustomPageControlExampleViewController.m
//  CustomPageControlExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set up first view
    self.scrollView1.pagingEnabled = YES;
    self.contentView1.frame = CGRectMake(0, 0, self.contentView1.bounds.size.width, self.scrollView1.bounds.size.height);
    self.scrollView1.contentSize = self.contentView1.bounds.size;
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    [self.scrollView1 addSubview:self.contentView1];
    self.pageControl1.numberOfPages = (NSInteger)(self.contentView1.bounds.size.width / self.scrollView1.bounds.size.width);
    self.pageControl1.defersCurrentPageDisplay = YES;
    
    //set up second view
    self.scrollView2.pagingEnabled = YES;
    self.contentView2.frame = CGRectMake(0, 0, self.contentView2.bounds.size.width, self.scrollView2.bounds.size.height);
    self.scrollView2.contentSize = self.contentView2.bounds.size;
    self.scrollView2.showsHorizontalScrollIndicator = NO;
    [self.scrollView2 addSubview:self.contentView2];
    self.pageControl2.numberOfPages = (NSInteger)(self.contentView2.bounds.size.width / self.scrollView2.bounds.size.width);
    self.pageControl2.defersCurrentPageDisplay = YES;
    self.pageControl2.selectedDotColor = [UIColor redColor];
    self.pageControl2.selectedDotShape = FXPageControlDotShapeSquare;
    self.pageControl2.selectedDotSize = 10.0;
    self.pageControl2.dotColor = [UIColor blueColor];
    self.pageControl2.dotSpacing = 30.0;
    self.pageControl2.wrapEnabled = YES;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (IBAction)pageControlAction:(FXPageControl *)sender
{
    //update scrollview when pagecontrol is tapped
    if (sender == self.pageControl1)
    {
        CGPoint offset = CGPointMake(sender.currentPage * self.scrollView1.bounds.size.width, 0);
        [self.scrollView1 setContentOffset:offset animated:YES];
    }
    else
    {
        CGPoint offset = CGPointMake(sender.currentPage * self.scrollView2.bounds.size.width, 0);
        [self.scrollView2 setContentOffset:offset animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //update page control when scrollview scrolls
    //prevent flicker by only updating when page index has changed
    NSInteger pageIndex = (NSInteger)(round(scrollView.contentOffset.x / scrollView.bounds.size.width));
    if (scrollView == self.scrollView1)
    {
        self.pageControl1.currentPage = pageIndex;
        self.pageControl1.selectedDotColor = (pageIndex == 2)? [UIColor whiteColor]: [UIColor blackColor];
        self.pageControl1.dotColor = (pageIndex == 2)?
            [UIColor colorWithWhite:1.0 alpha:0.25]: [UIColor colorWithWhite:0.0 alpha:0.25];
    }
    else
    {
        self.pageControl2.currentPage = pageIndex;
    }
}

@end
