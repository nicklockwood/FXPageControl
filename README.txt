Purpose
--------------

CustomPageControl is a replacement for Apple's UIPageControl that replicates all the functionality of the standard control, but adds the ability to edit the dot
colour, size and spacing.


Installation
--------------

Just drag the CustomPageControl.m and .h files into your project. In Interface Builder, add a new view to your window. Set the size to approximately 320 x 36 pixels and set the class to CustomPageControl.

You can now wire up the CustomPageControl in exactly the same way as a standard UIPageControl, as described in Apple's documentation.

To change the dot colour, size and spacing, use the following properties of the control:

UIColor *dotColour;
UIColor *selectedDotColour;
CGFloat dotSpacing;
CGFloat dotSize;

These properties must be set programmatically in your view controller, as Interface Builder does not expose a way to edit custom fields. Alternatively, you could create a subclass of PageControl that overrides the default values for these fields, set in the - (void)setup; method.