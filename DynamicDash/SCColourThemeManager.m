//
//  SCColourThemeManager.m
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCColourThemeManager.h"

#import "SCRedColourTheme.h"
#import "SCGreenColourTheme.h"
#import "SCBlueColourTheme.h"
#import "SCYellowColourTheme.h"
#import "SCPinkColourTheme.h"

@interface SCColourThemeManager ()

@property (nonatomic, strong) NSDictionary *themes;

@end

@implementation SCColourThemeManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.themes = @{@"red": [SCRedColourTheme new],
                        @"green" : [SCGreenColourTheme new],
                        @"yellow" : [SCYellowColourTheme new],
                        @"pink" : [SCPinkColourTheme new],
                        @"blue" : [SCBlueColourTheme new]};
    }
    return self;
}

- (id<SCColourTheme>)colourThemeWithName:(NSString *)name
{
    return self.themes[name];
}

@end
