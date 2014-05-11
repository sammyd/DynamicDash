//
//  SGauge+ColourTheme.h
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <ShinobiGauges/ShinobiGauges.h>
#import "SCColourTheme.h"

@interface SGauge (ColourTheme)

- (void)applyColourTheme:(id<SCColourTheme>)theme;

@end
