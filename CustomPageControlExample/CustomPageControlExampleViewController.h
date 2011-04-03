//
//  CustomPageControlExampleViewController.h
//  CustomPageControlExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPageControl.h"


@interface CustomPageControlExampleViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView1;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView2;
@property (nonatomic, retain) IBOutlet CustomPageControl *pageControl1;
@property (nonatomic, retain) IBOutlet CustomPageControl *pageControl2;
@property (nonatomic, retain) IBOutlet UIView *contentView1;
@property (nonatomic, retain) IBOutlet UIView *contentView2;

- (IBAction)pageControlAction:(CustomPageControl *)sender;

@end
