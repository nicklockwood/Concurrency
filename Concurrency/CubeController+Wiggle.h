//
//  CubeController+Wiggle.h
//  Concurrency
//
//  Created by Nick Lockwood on 02/01/2014.
//  Copyright (c) 2014 Charcoal Design. All rights reserved.
//

#import "CubeController.h"

@interface CubeController (Wiggle)

- (void)wiggleWithCompletionBlock:(void (^)(BOOL finished))block;
- (void)cancelWiggle;

@end
