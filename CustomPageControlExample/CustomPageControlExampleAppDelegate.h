//
//  CustomPageControlExampleAppDelegate.h
//  CustomPageControlExample
//
//  Created by Nick Lockwood on 03/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomPageControlExampleViewController;

@interface CustomPageControlExampleAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CustomPageControlExampleViewController *viewController;

@end
