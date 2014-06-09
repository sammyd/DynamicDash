//
//  SCDataGridStyler.h
//  DynamicDash
//
//  Created by Sam Davies on 09/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiGrids/ShinobiDataGrid.h>
#import "SCColourTheme.h"

@interface SCDashDataGridTheme : SDataGridiOS7Theme

+ (instancetype)themeWithColourTheme:(id<SCColourTheme>)colourTheme;
- (instancetype)initWithColourTheme:(id<SCColourTheme>)colourTheme;

@end
