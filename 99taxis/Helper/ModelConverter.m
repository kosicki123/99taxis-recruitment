//
//  ModelConverter.m
//  99taxis
//
//  Created by Renan Kosicki on 8/31/15.
//  Copyright (c) 2015 Renan Kosicki. All rights reserved.
//

#import "ModelConverter.h"

@implementation ModelConverter

+ (id)convertModelFromJSON:(NSDictionary *)JSON class:(Class)classToParse {
    NSParameterAssert(classToParse != nil);
    NSError *error = nil;
    id object = [MTLJSONAdapter modelOfClass:classToParse fromJSONDictionary:JSON error:&error];
    
    if (error) {
        return nil;
    }
    
    return object;
}

+ (NSArray *)convertModelsFromJSON:(NSArray *)JSON class:(Class)classToParse {
    NSParameterAssert(classToParse != nil);
    
    NSError *error = nil;
    
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    for (id object in JSON) {
        [objects addObject:[self convertModelFromJSON:object class:classToParse]];
    }
    
    if (error) {
        return nil;
    }
    
    return objects;
}

+ (NSDictionary *)convertObjectFromModel:(MTLModel<MTLJSONSerializing> *)model {
    NSError *error = nil;

    NSDictionary *object = [MTLJSONAdapter JSONDictionaryFromModel:model error:&error];
    
    if (error) {
        return nil;
    }
    
    return object;
}

@end
