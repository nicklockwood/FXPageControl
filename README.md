Purpose
--------------

FXPageControl is a drop-in replacement for Apple's UIPageControl that replicates all the functionality of the standard control, but adds the ability to edit the dot colour, size and spacing.


Supported iOS & SDK Versions
-----------------------------

* Supported build target - iOS 10.3 (Xcode 8.3, Apple LLVM compiler 8.1)
* Earliest supported deployment target - iOS 8.0
* Earliest compatible deployment target - iOS 6.0

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this iOS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

As of version 1.2, FXPageControl requires ARC. If you wish to use FXPageControl in a non-ARC project, just add the -fobjc-arc compiler flag to the FXPageControl.m class. To do this, go to the Build Phases tab in your target settings, open the Compile Sources group, double-click FXPageControl.m in the list and type -fobjc-arc into the popover.

If you wish to convert your whole project to ARC, comment out the #error line in FXPageControl.m, then run the Edit > Refactor > Convert to Objective-C ARC... tool in Xcode and make sure all files that you wish to use ARC for (including FXPageControl.m) are checked.


Installation
--------------

Just drag the FXPageControl.m and .h files into your project. In Interface Builder add a new view to your window. Set the size to approximately 320 x 36 points and set the class to FXPageControl (you can also create the control programmatically by using:

    [[FXPageControl alloc] initWithFrame:CGRectMake(0, 0, 320, 36)])

You can now wire up the FXPageControl in exactly the same way as a standard UIPageControl, as described in Apple's documentation.


Configuration
---------------

FXPageControl supports all of the methods of UIPageControl (with the exception of the tint options introduced in iOS 6). To change the dot appearance, shape, size and spacing, use the following properties of the control:

    @property (nonatomic, strong) UIImage *dotImage;
    @property (nonatomic, assign) CGPathRef dotShape;
    @property (nonatomic, assign) CGFloat dotSize;
    @property (nonatomic, strong) UIColor *dotColor;
    @property (nonatomic, strong) UIColor *dotShadowColor;
    @property (nonatomic, assign) CGFloat dotShadowBlur;
    @property (nonatomic, assign) CGSize dotShadowOffset;
    @property (nonatomic, assign) CGFloat dotBorderWidth;
    @property (nonatomic, strong) UIColor *dotBorderColor;
    
    @property (nonatomic, strong) UIImage *selectedDotImage;
    @property (nonatomic, assign) CGPathRef selectedDotShape;
    @property (nonatomic, assign) CGFloat selectedDotSize;
    @property (nonatomic, strong) UIColor *selectedDotColor;
    @property (nonatomic, strong) UIColor *selectedDotShadowColor;
    @property (nonatomic, assign) CGFloat selectedDotShadowBlur;
    @property (nonatomic, assign) CGSize selectedDotShadowOffset;
    @property (nonatomic, assign) CGFloat selectedDotBorderWidth;
    @property (nonatomic, strong) UIColor *selectedDotBorderColor;
    
    @property (nonatomic, assign) CGFloat dotSpacing;

The `dotColor`/`selectedDotColor` properties are nil by default and will be drawn as black unless otherwise specified. If you only specify the `selectedDotColor`, the `dotColor` will be automatically set to the same color, but with 25% opacity.
 
The `dotShape`/`selectedDotShape` properties are `NULL` by default, and will be treated as `FXPageControlDotShapeCircle`. You can either use one of the supplied shape constants, or supply your own CGPath to be drawn for each dot. Note that the path will be retained.

The `selectedDotSize` properties are 0 by default and will default to the same size as the `dotSize` (for backwards compatibility).

The `dotShadowColor`/`selectedDotShadowColor` properties are `nil` by default, and will be treated as transparent.

The `dotBorderColor`/`selectedDotBorderColor` properties are `nil` by default, and will be treated as transparent.

The `dotBorderWidth`/`selectedDotBorderWidth` properties are `0` by default.

The `dotImage`/`selectedDotImage` properties are `nil` by default and will override the shape and color options if set.

The `dotSpacing` property specifies the spacing (in points) between the regular (unselected) dots. There is no equivalent "selectedDotSpacing" property.

Most of these properties can either be set programmatically, or in Interface Builder by using the User Defined Runtime Attributes feature. Alternatively, you could create a subclass of FXPageControl that overrides the default values for these fields, set in the `-setUp` method.

Unlike the standard UIPageControl, you can also make the FXPageControl wrap around by setting the following property to YES:

	@property (nonatomic, assign, getter = isWrapEnabled) BOOL wrapEnabled;

You can align the FXPageControl vertically by setting the following property to YES:

    @property (nonatomic, assign, getter = isVertical) BOOL vertical;

**Note:** with the exception of the CGPathRef values, all of these properties can be set directly in Interface Builder.
	

Delegate
------------

To set the dot image or color individually, implement the FXPageControl delegate. This will allow you to specify different images or colors for different dot indexes.

The FXPageControlDelegate provides the following methods, all optional:

    - (UIImage *)pageControl:(FXPageControl *)pageControl imageForDotAtIndex:(NSInteger)index;
    - (CGPathRef)pageControl:(FXPageControl *)pageControl shapeForDotAtIndex:(NSInteger)index;
    - (UIColor *)pageControl:(FXPageControl *)pageControl colorForDotAtIndex:(NSInteger)index;
    
    - (UIImage *)pageControl:(FXPageControl *)pageControl selectedImageForDotAtIndex:(NSInteger)index;
    - (CGPathRef)pageControl:(FXPageControl *)pageControl selectedShapeForDotAtIndex:(NSInteger)index;
    - (UIColor *)pageControl:(FXPageControl *)pageControl selectedColorForDotAtIndex:(NSInteger)index;

If you need to change the color shape or image for a specific dot at runtime, call `-setNeedsDisplay` on the FXPageControl to force it to redraw.

Note that CGPathRefs that are created and returned from the `-pageControl:shapeForDotAtIndex:` method should be autoreleased to prevent memory leaks. The simplest way to do this is to use a UIBezierPath to create the CGPath.


Release Notes
--------------

Version 1.5

- Now requires iOS 6 or above
- Added support for VoiceOver
- Added support for Xcode UITesting
- Added `borderWidth`, `borderColor`, `selectedBorderWidth`, and `selectedBorderColor` properties
- Improved compatibility with AutoLayout

Version 1.4

- Added `vertical` property for implementing vertical page controls
- Added `IBInspectable` attributes for simpler configuration within Interface Builder
- Now handles taps on touch-up instead of touch-down, like the standard UIPageControl

Version 1.3.2

- Added `intrinsicContentSize` method to support AutoLayout

Version 1.3.1

- Custom dot images are now correctly centered
- Fixed some additional warnings when targeting iOS 5+
- Fixed some layout issues in the example project

Version 1.3

- Added support for custom dot shapes
- Added support for dot shadows
- Can now specify a different size for selected dot
- Now complies with -Weverything warning level

Version 1.2.1

- Fixed bug in custom dot image delegate method
- Now sets dotColor automatically if you specify selectedDotColor
- Added Podspec

Version 1.2

- Renamed to FXPageControl
- FXPageControl now requires ARC. See README for details
- Added support for custom dot images
- Renamed wrap property to wrapEnabled

Version 1.1.1

- View now redraws itself automatically if bounds are changed

Version 1.1

- Added wrap property
- Changed default color to black
- Added missing methods and properties from standard UIPageControl
- Fixed flicker in example code when tapping the page control

Version 1.0

- Initial release