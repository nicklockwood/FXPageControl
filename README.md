Purpose
--------------

CustomPageControl is a drop-in replacement for Apple's UIPageControl that replicates all the functionality of the standard control, but adds the ability to edit the dot colour, size and spacing.


Installation
--------------

Just drag the CustomPageControl.m and .h files into your project. In Interface Builder add a new view to your window. Set the size to approximately 320 x 36 pixels and set the class to CustomPageControl (you can also create the control programmatically by using:

	[[alloc] initWithRect:CGRectMake(0,0,320,36)])

You can now wire up the CustomPageControl in exactly the same way as a standard UIPageControl, as described in Apple's documentation.


Configuration
---------------

To change the dot colour, size and spacing, use the following properties of the control:

	@property (nonatomic, retain) UIColor *dotColour;
	@property (nonatomic, retain) UIColor *selectedDotColour;
	@property (nonatomic, assign) CGFloat dotSpacing;
	@property (nonatomic, assign) CGFloat dotSize;

These properties must be set programmatically in your view controller, as Interface Builder does not expose a way to edit custom fields. Alternatively, you could create a subclass of PageControl that overrides the default values for these fields, set in the `setup` method.

Unlike the standard UIPageControl, you can also make the CustomPageControl wrap around by setting the following property to YES:

	BOOL wrap;