//
//  CustomPageControlExampleViewController.h
//  CustomPageControlExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FXPageControl.h"


@interface ViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView1;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView2;
@property (nonatomic, strong) IBOutlet FXPageControl *pageControl1;
@property (nonatomic, strong) IBOutlet FXPageControl *pageControl2;
@property (nonatomic, strong) IBOutlet UIView *contentView1;
@property (nonatomic, strong) IBOutlet UIView *contentView2;

- (IBAction)pageControlAction:(FXPageControl *)sender;

@end
