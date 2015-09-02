//
//  AnnotationConverter.h
//  99taxis
//
//  Created by Renan Kosicki on 9/2/15.
//  Copyright © 2015 Renan Kosicki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnotationConverter : NSObject

+ (NSArray *)convertToAnnotations:(NSArray *)driverList;

@end
