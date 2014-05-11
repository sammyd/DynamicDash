//
//  SCPinkColourTheme.m
//  DynamicDash
//
//  Created by Sam Davies on 11/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCPinkColourTheme.h"
#import "UIColor+IntegerColours.h"

@interface SCPinkColourTheme ()

@property (nonatomic, strong, readwrite) UIColor *darkColour;
@property (nonatomic, strong, readwrite) UIColor *midDarkColour;
@property (nonatomic, strong, readwrite) UIColor *midColour;
@property (nonatomic, strong, readwrite) UIColor *midLightColour;
@property (nonatomic, strong, readwrite) UIColor *lightColour;

@end

@implementation SCPinkColourTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.darkColour = [UIColor colorWithIntegerRed:124 green:0 blue:119];
        self.midDarkColour = [UIColor colorWithIntegerRed:148 green:32 blue:143];
        self.midColour = [UIColor colorWithIntegerRed:173 green:79 blue:173];
        self.midLightColour = [UIColor colorWithIntegerRed:220 green:157 blue:217];
        self.lightColour = [UIColor colorWithIntegerRed:240 green:216 blue:243];
    }
    return self;
}

@end
