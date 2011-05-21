//
//  AccuracyBarView.m
//  iOSGPSTester
//
//  Created by Bryan Everly on 5/16/11.
//  Copyright 2011 BCE Associates, Inc. All rights reserved.
//

#import "AccuracyBarView.h"


@implementation AccuracyBarView
@synthesize currentAccuracy=_currentAccuracy;
@synthesize bestAccuracy=_bestAccuracy;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    //    _currentAccuracy = [[NSNumber alloc]initWithDouble:25.0];
    
    // Get the bounding rectangle of our view
    CGRect currentFrame = [self frame];
    
    // Get the UIView size
    CGSize size = currentFrame.size;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    // Set up the graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    
    // Draw the outside rectangle
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);    
    CGRect rectangle = CGRectMake(0,0,width,height);
    CGContextAddRect(context, rectangle);
    CGContextStrokePath(context);
    
    // Calculate the percentage "signal strength" by using the height
    // of our view as 100%
    if (_currentAccuracy != nil) {
        // Set our "best" accuracy for the top of the scale
        double bestAccuracy = 5.0;
        if (_bestAccuracy != nil) {
            bestAccuracy = [_bestAccuracy floatValue];
        }
        
        // Get current accuracy
        double accuracy = [_currentAccuracy floatValue];
        
        // Process only if we are a positive number (negative means we don't have a fix)
        if (accuracy > 0) {
            if (accuracy > 100.0) {
                accuracy = 100.0;
            }
            
            double ratio = 1.0;
            
            if (accuracy <= 5.0) {
                // Less than or equal to 5.0 for xyAccuracy is likely the best possible value
                ratio = 1.0;
            } else if (accuracy == 0.0) {
                // A zero zAccuracy is a non-fix situation
                ratio = 0.0;
            }else {
                // Calculate our ratio
                ratio = (100.0 + bestAccuracy - accuracy) / 100.0;
            }
            
            double heightToFill = height * ratio;
            
            // We now know how many pixels tall to make our rectangle so
            // we start out at the coordinate (1, [heightToFill + 1]) and draw
            // a filled rectangle to ([width-1], [height-1]).  This will allow
            // us to preserve the borders of our rectangle if ratio = 1 (i.e.
            // we are at 1 meter accuracy which is the best we can do).
            if (ratio < 0.3333) {
                CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
            } else if (ratio < 0.6667) {
                CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
            } else {
                CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            }
            
            CGRect rectangle = CGRectMake(1, (height - heightToFill + 1), (width -2), (heightToFill - 2));
            CGContextAddRect(context, rectangle);
            CGContextStrokePath(context);
            
            if (ratio < 0.3333) {
                CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            } else if (ratio < 0.6667) {
                CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
            } else {
                CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            }
            
            CGContextFillRect(context, rectangle);
        }
    }
}

- (void)dealloc
{
    [super dealloc];
}

@end
