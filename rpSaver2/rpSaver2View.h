//
//  rpSaver2View.h
//  rpSaver2
//
//  Created by Nix, Robert P. on 10/25/16.
//  Copyright © 2016 Nix, Robert P. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface rpSaver2View : ScreenSaverView {
    IBOutlet id configSheet;
    IBOutlet id drawFilledShapesOption;
    IBOutlet id drawOutlinedShapesOption;
    IBOutlet id drawBothOption;
    IBOutlet id drawRectanglesOption;
    IBOutlet id drawOvalsOption;
    IBOutlet id drawTrianglesOption;
    IBOutlet id drawDoodlesOption;
    IBOutlet id strokeOutlinesOption;
}

@end
