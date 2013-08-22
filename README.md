Purpose
--------------

FXPageControl is a drop-in replacement for Apple's UIPageControl that replicates all the functionality of the standard control, but adds the ability to edit the dot colour, size and spacing.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 6.0 (Xcode 4.5)
* Earliest supported deployment target - iOS 5.0
* Earliest compatible deployment target - iOS 4.3

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

As of version 1.2, FXPageControl requires ARC. If you wish to use FXPageControl in a non-ARC project, just add the -fobjc-arc compiler flag to the FXPageControl.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click FXPageControl.m in the list and type -fobjc-arc into the popover.

If you wish to convert your whole project to ARC, comment out the #error line in FXPageControl.m, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including FXPageControl.m) are checked.


Installation
--------------

Just drag the FXPageControl.m and .h files into your project. In Interface Builder add a new view to your window. Set the size to approximately 320 x 36 pixels and set the class to FXPageControl (you can also create the control programmatically by using:

	[[alloc] initWithRect:CGRectMake(0.0f, 0.0f, 320.0f, 36.0f)])

You can now wire up the FXPageControl in exactly the same way as a standard UIPageControl, as described in Apple's documentation.


Configuration
---------------

FXPageControl supports all of the methods of UIPageControl (with the exception of the tint options introduced in iOS 6). To change the dot appearance, size and spacing, use the following properties of the control:

	@property (nonatomic, strong) UIColor *dotColour;
	@property (nonatomic, strong) UIColor *selectedDotColour;
	@property (nonatomic, strong) UIImage *dotImage;
	@property (nonatomic, strong) UIImage *selectedDotImage;
	@property (nonatomic, assign) CGFloat dotSpacing;
	@property (nonatomic, assign) CGFloat dotSize;

The dotColor properties are nil by default and will be drawn as black unless otherwise specified. If you only specify the selectedDotColor, the dotColor will be automatically set to the same color, but with 25% opacity.
 
The dotImage properties are nil by default and will override the color options if set.

These properties can either be set programmatically, or in Interface Builder by using the User Defined Runtime Attirbutes feature. Alternatively, you could create a subclass of FXPageControl that overrides the default values for these fields, set in the `setUp` method.

Unlike the standard UIPageControl, you can also make the FXPageControl wrap around by setting the following property to YES:

	@property (nonatomic, assign) BOOL wrapEnabled;
	

Delegate
------------

To set the dot image or color individually, implement the FXPageControl delegate. This will allow you to specify different images or colors for different dot indexes. This can be used to implement the iPhone SpringBoard's appearance, where the first dot is replaced by a magnifiying glass icon.

The FXPageControlDelegate provides the following methods, all optional:

    - (UIColor *)pageControl:(FXPageControl *)pageControl colorForDotAtIndex:(NSInteger)index;
    - (UIColor *)pageControl:(FXPageControl *)pageControl selectedColorForDotAtIndex:(NSInteger)index;
    - (UIImage *)pageControl:(FXPageControl *)pageControl imageForDotAtIndex:(NSInteger)index;
    - (UIImage *)pageControl:(FXPageControl *)pageControl selectedImageForDotAtIndex:(NSInteger)index;
    
If you need to change the color or image for a specific dot at runtime, call -setNeedsDisplay on the FXPageControl to force it to redraw.