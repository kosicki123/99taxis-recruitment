//
//  ModelConverter.h
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright (c) 2015 Renan Kosicki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle.h>

@interface ModelConverter : NSObject

+ (id)convertModelFromJSON:(NSDictionary *)JSON class:(Class)classToParse;
+ (NSArray *)convertModelsFromJSON:(NSArray *)JSON class:(Class)classToParse;
+ (NSDictionary *)convertObjectFromModel:(MTLModel<MTLJSONSerializing> *)model;

@end
