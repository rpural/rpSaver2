//
//  rpSaver2View.m
//  rpSaver2
//
//  Created by Nix, Robert P. on 10/25/16.
//  Copyright © 2016 Nix, Robert P. All rights reserved.
//

#import "rpSaver2View.h"

@implementation rpSaver2View

static NSString * const MyModuleName = @"net.rpural.rpSaver2";

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/5.0];
        
        ScreenSaverDefaults *defaults;
        defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
        
        // Register our default values
        [defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                    @"NO",  @"DrawFilledShapes",
                                    @"NO",  @"DrawOutlinedShapes",
                                    @"YES", @"DrawBoth",
                                    nil]];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    ScreenSaverDefaults *defaults;
    
    NSBezierPath *path;
    NSRect rect;
    NSSize size;
    NSColor *color;
    float red, green, blue, alpha;
    int shapeType;
    
    size = [self bounds].size;
    
    // Calculate random width and height
    rect.size = NSMakeSize( SSRandomFloatBetween( size.width / 100.0,
                                                  size.width / 10.0 ),
                            SSRandomFloatBetween( size.height / 100.0,
                                                  size.height / 10.0 ));
    
     // Calculate random origin point
    rect.origin = SSRandomPointForSizeWithinRect( rect.size, [self bounds] );
    
    // Decide what kind of shape to draw
    shapeType = SSRandomIntBetween( 0, 5 );
    switch (shapeType) {
        case 0:
            // rect
            path = [NSBezierPath bezierPathWithRect:rect];
            break;
        case 1:
            // oval
            path = [NSBezierPath bezierPathWithOvalInRect:rect];
            break;
        case 2: {
            // arc
            float startAngle, endAngle, radius;
            NSPoint point;
            
            startAngle = SSRandomFloatBetween( 0.0, 360.0 );
            endAngle = SSRandomFloatBetween( startAngle, 360.0 + startAngle );
            // Use the smallest value for the radius (either width or height)
            radius = rect.size.width <= rect.size.height ? rect.size.width / 2 : rect.size.height / 2;
            // Calculate our center point
            point = NSMakePoint( rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height / 2 );
            // Construct the path
            path = [NSBezierPath bezierPath];
            [path appendBezierPathWithArcWithCenter: point radius: radius
                                         startAngle: startAngle
                                         endAngle: endAngle
                                         clockwise: SSRandomIntBetween( 0, 1 )];
            break;
        }
        case 3:
            // rounded corners rect
            path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:SSRandomFloatBetween(4.0, 20.0) yRadius:SSRandomFloatBetween(4.0,20.0)];
            break;
        case 4:
            // triangle
            path = [NSBezierPath bezierPath];
            [path moveToPoint:rect.origin];
            [path lineToPoint:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                      rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))];
            [path lineToPoint:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                          rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))];
            [path closePath];
            break;
        case 5:
            // odd
            path = [NSBezierPath bezierPath];
            [path moveToPoint:rect.origin];
            [path curveToPoint:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                           rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))
                 controlPoint1:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                           rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))
                 controlPoint2:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                           rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))];
            [path lineToPoint:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                          rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))];
            [path closePath];
        default:
            break;
    }
    
    // Calculate a random color
    red = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    green = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    blue = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    alpha = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    color = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
    [color set];
    // And finally draw it
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    if ([defaults boolForKey:@"DrawBoth"]) {
        if (SSRandomIntBetween( 0, 1 ) == 0)
            [path fill];
        else
            [path stroke]; }
    else if ([defaults boolForKey:@"DrawFilledShapes"])
        [path fill];
    else
        [path stroke];
    
    return;
}

- (BOOL)hasConfigureSheet
{
    return YES;
}

- (NSWindow *)configureSheet {
    ScreenSaverDefaults *defaults;
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    if (!configSheet) {
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) {
            NSLog( @"Failed to load configure sheet." ); NSBeep();
        }
    }
    [drawFilledShapesOption setState:[defaults boolForKey:@"DrawFilledShapes"]];
    [drawOutlinedShapesOption setState:[defaults boolForKey:@"DrawOutlinedShapes"]];
    [drawBothOption setState:[defaults boolForKey:@"DrawBoth"]]; return configSheet;
}

- (IBAction) okClick: (id)sender {
    ScreenSaverDefaults *defaults;
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    // Update our defaults
    [defaults setBool:[drawFilledShapesOption state] forKey:@"DrawFilledShapes"];
    [defaults setBool:[drawOutlinedShapesOption state] forKey:@"DrawOutlinedShapes"];
    [defaults setBool:[drawBothOption state] forKey:@"DrawBoth"];
    // Save the settings to disk
    [defaults synchronize];
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)cancelClick:(id)sender {
    [[NSApplication sharedApplication] endSheet:configSheet];
}
@end
