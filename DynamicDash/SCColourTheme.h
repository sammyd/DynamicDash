//
//  SCColourTheme.h
//  DynamicDash
//
//  Created by Sam Davies on 08/05/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCColourTheme <NSObject>

@property (nonatomic, strong, readonly) UIColor *darkColour;
@property (nonatomic, strong, readonly) UIColor *midDarkColour;
@property (nonatomic, strong, readonly) UIColor *midColour;
@property (nonatomic, strong, readonly) UIColor *midLightColour;
@property (nonatomic, strong, readonly) UIColor *lightColour;

@end
