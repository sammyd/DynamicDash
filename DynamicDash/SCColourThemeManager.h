//
//  SCColourThemeManager.h
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCColourTheme.h"

@interface SCColourThemeManager : NSObject

- (id<SCColourTheme>)colourThemeWithName:(NSString *)name;

@end
