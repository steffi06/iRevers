//
//  GamePiece.m
//  iRevers
//
//  Created by Stephanie Shupe on 10/11/12.
//  Copyright (c) 2012 shupeCreations. All rights reserved.
//

#import "GamePiece.h"

@implementation GamePiece

-(id) init
{
    self = [super init];
    if (self) {
        self.state = @"blank";
    }
    return self;
}

@end
