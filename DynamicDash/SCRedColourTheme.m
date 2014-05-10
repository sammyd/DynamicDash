//
//  SCRedColourTheme.m
//  DynamicDash
//
//  Created by Sam Davies on 10/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCRedColourTheme.h"
#import "UIColor+IntegerColours.h"

@interface SCRedColourTheme ()

@property (nonatomic, strong, readwrite) UIColor *darkColour;
@property (nonatomic, strong, readwrite) UIColor *midDarkColour;
@property (nonatomic, strong, readwrite) UIColor *midColour;
@property (nonatomic, strong, readwrite) UIColor *midLightColour;
@property (nonatomic, strong, readwrite) UIColor *lightColour;

@end

@implementation SCRedColourTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.darkColour = [UIColor colorWithIntegerRed:124 green:18 blue:0];
        self.midDarkColour = [UIColor colorWithIntegerRed:148 green:49 blue:32];
        self.midColour = [UIColor colorWithIntegerRed:173 green:91 blue:78];
        self.midLightColour = [UIColor colorWithIntegerRed:220 green:157 blue:148];
        self.lightColour = [UIColor colorWithIntegerRed:243 green:206 blue:201];
    }
    return self;
}

@end
