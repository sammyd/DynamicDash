//
//  SCOrdersDataProvider.h
//  DynamicDash
//
//  Created by Sam Davies on 07/06/2014.
//  Copyright (c) 2014 ShinobiControls. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShinobiGrids/ShinobiDataGrid.h>

@interface SCOrdersDataProvider : NSObject

@property (nonatomic, strong, readonly) ShinobiDataGrid *dataGrid;
@property (nonatomic, strong) NSArray *orders;

- (instancetype)initWithDataGrid:(ShinobiDataGrid *)dataGrid orders:(NSArray *)orders;

@end
