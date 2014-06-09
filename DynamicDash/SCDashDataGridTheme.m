//
//  SCDataGridStyler.m
//  DynamicDash
//
//  Created by Sam Davies on 09/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import "SCDashDataGridTheme.h"

@interface SCDashDataGridTheme ()

@property (nonatomic, strong) id<SCColourTheme> colourTheme;

@end

@implementation SCDashDataGridTheme

+ (instancetype)themeWithColourTheme:(id<SCColourTheme>)colourTheme
{
    return [[[self class] alloc] initWithColourTheme:colourTheme];
}

- (instancetype)initWithColourTheme:(id<SCColourTheme>)colourTheme
{
    self = [super init];
    if(self) {
        self.colourTheme = colourTheme;
        [self updateDefaultStyles];
    }
    return self;
}

#pragma mark - Utility Methods
- (void)updateDefaultStyles
{
    self.rowStyle.contentInset = UIEdgeInsetsMake(3, 5, 3, 5);
    self.rowStyle.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
    
    // Don't want anything special for alternate rows
    self.alternateRowStyle = nil;
    
    self.headerRowStyle.contentInset = UIEdgeInsetsMake(3, 5, 3, 5);
    self.headerRowStyle.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
    self.headerRowStyle.textVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.gridLineStyle.width = 0.5;
}

@end
