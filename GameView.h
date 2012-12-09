//
//  GameView.h
//  iRevers
//
//  Created by Stephanie Shupe on 10/11/12.
//  Copyright (c) 2012 shupeCreations. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GameViewController;

@interface GameView : UIView

-(CALayer *)makePieceLayerWithColumnIndex:(NSInteger)col withPieceIndex:(NSInteger)row withColor:(UIColor *)color;
@property (weak, nonatomic) GameViewController *gameVC;
@property (nonatomic) NSInteger columnCount;

@end
