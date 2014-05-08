//
//  SCBlueColourTheme.m
//  DynamicDash
//
//  Created by Sam Davies on 08/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCBlueColourTheme.h"
#import "UIColor+IntegerColours.h"

@interface SCBlueColourTheme ()

@property (nonatomic, strong, readwrite) UIColor *darkColour;
@property (nonatomic, strong, readwrite) UIColor *midDarkColour;
@property (nonatomic, strong, readwrite) UIColor *midColour;
@property (nonatomic, strong, readwrite) UIColor *midLightColour;
@property (nonatomic, strong, readwrite) UIColor *lightColour;

@end

@implementation SCBlueColourTheme

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.darkColour = [UIColor colorWithIntegerRed:0 green:85 blue:124];
        self.midDarkColour = [UIColor colorWithIntegerRed:24 green:109 blue:148];
        self.midColour = [UIColor colorWithIntegerRed:52 green:136 blue:173];
        self.midLightColour = [UIColor colorWithIntegerRed:129 green:193 blue:220];
        self.lightColour = [UIColor colorWithIntegerRed:187 green:229 blue:243];
    }
    return self;
}

@end
