//
//  SCGreenColourTheme.m
//  DynamicDash
//
//  Created by Sam Davies on 10/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCGreenColourTheme.h"
#import "UIColor+IntegerColours.h"

@interface SCGreenColourTheme ()

@property (nonatomic, strong, readwrite) UIColor *darkColour;
@property (nonatomic, strong, readwrite) UIColor *midDarkColour;
@property (nonatomic, strong, readwrite) UIColor *midColour;
@property (nonatomic, strong, readwrite) UIColor *midLightColour;
@property (nonatomic, strong, readwrite) UIColor *lightColour;

@end

@implementation SCGreenColourTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.darkColour = [UIColor colorWithIntegerRed:0 green:124 blue:9];
        self.midDarkColour = [UIColor colorWithIntegerRed:25 green:148 blue:32];
        self.midColour = [UIColor colorWithIntegerRed:60 green:173 blue:66];
        self.midLightColour = [UIColor colorWithIntegerRed:137 green:220 blue:140];
        self.lightColour = [UIColor colorWithIntegerRed:195 green:243 blue:194];
    }
    return self;
}

@end

