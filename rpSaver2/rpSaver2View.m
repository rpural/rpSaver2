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
                                    @"YES", @"DrawRectangles",
                                    @"YES", @"DrawOvals",
                                    @"YES", @"DrawTriangles",
                                    @"YES", @"DrawDoodles",
                                    @"YES", @"StrokeOutlines",
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
    NSPoint pointA, pointB, pointC, pointD;
    NSSize size;
    NSColor *color;
    float red, green, blue, alpha;
    int shapeType;
    
    int nSides;
    float nDist;
    int i;
    
    size = [self bounds].size;
    
    // Calculate random width and height
    rect.size = NSMakeSize( SSRandomFloatBetween( size.width / 100.0,
                                                  size.width / 10.0 ),
                            SSRandomFloatBetween( size.height / 100.0,
                                                  size.height / 10.0 ));
    
     // Calculate random origin point
    rect.origin = SSRandomPointForSizeWithinRect( rect.size, [self bounds] );
    
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];

    // Decide what kind of shape to draw
    shapeType = SSRandomIntBetween( 0, 5 );
    switch (shapeType) {
        case 0:
            // rect
            if ([defaults boolForKey:@"DrawRectangles"]) {
                path = [NSBezierPath bezierPathWithRect:rect];
            }
            break;
        case 1:
            // oval
            if ([defaults boolForKey:@"DrawOvals"]) {
                path = [NSBezierPath bezierPathWithOvalInRect:rect];
            }
            break;
        case 2: {
            // arc
            if ([defaults boolForKey:@"DrawOvals"]) {
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
            }
            break;
        }
        case 3:
            // rounded corners rect
            if ([defaults boolForKey:@"DrawRectangles"]) {
                path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:SSRandomFloatBetween(4.0, 20.0) yRadius:SSRandomFloatBetween(4.0,20.0)];
            }
            break;
        case 4:
            // triangle
            if ([defaults boolForKey:@"DrawTriangles"]) {
                path = [NSBezierPath bezierPath];
                [path moveToPoint:rect.origin];
                [path lineToPoint:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                      rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))];
                [path lineToPoint:NSMakePoint(rect.origin.x + SSRandomFloatBetween(-100.0, 100.0),
                                          rect.origin.y + SSRandomFloatBetween(-100.0, 100.0))];
                [path closePath];
            }
            break;
        case 5:
            // Doodles
                // three to ten sides, curved
            if ([defaults boolForKey:@"DrawDoodles"]) {
                nSides = SSRandomIntBetween(3, 10);
                nDist = 100.0 - (5 * nSides);  // Limit on the final size of the object
            
                path = [NSBezierPath bezierPath];
                [path moveToPoint:rect.origin];
            
                pointD = rect.origin;
            
                for (i = 0; i < nSides; i++) {
                    pointA = NSMakePoint(pointD.x + SSRandomFloatBetween(-(nDist), nDist),
                                     pointD.y + SSRandomFloatBetween(-(nDist), nDist));
                    if (SSRandomIntBetween(1, 4) < 4) {
                        pointB = NSMakePoint(pointA.x + SSRandomFloatBetween(-(nDist), nDist),
                                         pointA.y + SSRandomFloatBetween(-(nDist), nDist));
                        pointC = NSMakePoint(pointB.x + SSRandomFloatBetween(-(nDist), nDist),
                                         pointB.y + SSRandomFloatBetween(-(nDist), nDist));
                    
                        [path curveToPoint:pointA
                             controlPoint1:pointB
                             controlPoint2:pointC];
   
                    } else {
                    [path lineToPoint:pointA];
                    }

                    pointD = pointA;
                }
            
                pointB = NSMakePoint(pointD.x + SSRandomFloatBetween(-100.0, 100.0),
                                 pointD.y +SSRandomFloatBetween(-100.0, 100.0));
                pointC = NSMakePoint(pointB.x + SSRandomFloatBetween(-100.0, 100.0),
                                 pointB.y +SSRandomFloatBetween(-100.0, 100.0));

                [path curveToPoint:rect.origin controlPoint1:pointB controlPoint2:pointC];
            
                [path closePath];
            }
            break;
        default:
            break;
    }
    
    NSAffineTransform *rotator = [NSAffineTransform transform];
    [rotator rotateByDegrees: SSRandomFloatBetween(0.0, 359.9)];
    path = [rotator transformBezierPath: path];
    
    // Calculate a random color
    color = randomColor();
    [color set];
    // And finally draw it
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    if ([defaults boolForKey:@"DrawBoth"]) {
        if (SSRandomIntBetween( 0, 1 ) == 0) {
            [path fill];
            if ([defaults boolForKey:@"StrokeOutlines"]) {
                color = randomColor();
                [color set];
                [path stroke];
            }
        } else
            [path stroke]; }
    else if ([defaults boolForKey:@"DrawFilledShapes"]) {
        [path fill];
        if ([defaults boolForKey:@"StrokeOutlines"]) {
            color = randomColor();
            [color set];
            [path stroke];
        }

    } else
        [path stroke];
    
    return;
}

NSColor* randomColor() {
    NSColor *color;
    float red, green, blue, alpha;

    red = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    green = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    blue = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    alpha = SSRandomFloatBetween( 0.0, 255.0 ) / 255.0;
    color = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:alpha];
    return color;

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
    [drawBothOption setState:[defaults boolForKey:@"DrawBoth"]];
    [drawRectanglesOption setState:[defaults boolForKey:@"DrawRectangles"]];
    [drawOvalsOption setState:[defaults boolForKey:@"DrawOvals"]];
    [drawTrianglesOption setState:[defaults boolForKey:@"DrawTriangles"]];
    [drawDoodlesOption setState:[defaults boolForKey:@"DrawDoodles"]];
    [strokeOutlinesOption setState:[defaults boolForKey:@"StrokeOutlines"]];
    return configSheet;
}

- (IBAction) okClick: (id)sender {
    ScreenSaverDefaults *defaults;
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:MyModuleName];
    // Update our defaults
    [defaults setBool:[drawFilledShapesOption state] forKey:@"DrawFilledShapes"];
    [defaults setBool:[drawOutlinedShapesOption state] forKey:@"DrawOutlinedShapes"];
    [defaults setBool:[drawBothOption state] forKey:@"DrawBoth"];
    [defaults setBool:[drawRectanglesOption state] forKey:@"DrawRectangles"];
    [defaults setBool:[drawOvalsOption state] forKey:@"DrawOvals"];
    [defaults setBool:[drawTrianglesOption state] forKey:@"DrawTriangles"];
    [defaults setBool:[drawDoodlesOption state] forKey:@"DrawDoodles"];
    [defaults setBool:[strokeOutlinesOption state] forKey:@"StrokeOutlines"];
    // Save the settings to disk
    [defaults synchronize];
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

- (IBAction)cancelClick:(id)sender {
    [[NSApplication sharedApplication] endSheet:configSheet];
}
@end
