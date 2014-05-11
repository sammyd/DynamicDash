//
//  SCYellowColourTheme.m
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCYellowColourTheme.h"
#import "UIColor+IntegerColours.h"

@interface SCYellowColourTheme ()

@property (nonatomic, strong, readwrite) UIColor *darkColour;
@property (nonatomic, strong, readwrite) UIColor *midDarkColour;
@property (nonatomic, strong, readwrite) UIColor *midColour;
@property (nonatomic, strong, readwrite) UIColor *midLightColour;
@property (nonatomic, strong, readwrite) UIColor *lightColour;

@end

@implementation SCYellowColourTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.darkColour = [UIColor colorWithIntegerRed:124 green:85 blue:0];
        self.midDarkColour = [UIColor colorWithIntegerRed:148 green:111 blue:34];
        self.midColour = [UIColor colorWithIntegerRed:173 green:145 blue:89];
        self.midLightColour = [UIColor colorWithIntegerRed:220 green:201 blue:163];
        self.lightColour = [UIColor colorWithIntegerRed:243 green:239 blue:220];
    }
    return self;
}

@end

