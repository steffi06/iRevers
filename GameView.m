//
//  GameView.m
//  iRevers
//
//  Created by Stephanie Shupe on 10/11/12.
//  Copyright (c) 2012 shupeCreations. All rights reserved.
//

#import "GameView.h"
#import <QuartzCore/QuartzCore.h>
#import "GameViewController.h"


@interface GameView()

@property (nonatomic) NSInteger pieceSize;

@end


@implementation GameView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setColumnCount:(NSInteger)columnCount
{
    _columnCount = columnCount;
    self.pieceSize = self.layer.frame.size.width / self.columnCount;
}

-(CALayer *)makePieceLayerWithColumnIndex: (NSInteger)col withPieceIndex: (NSInteger)row withColor:(UIColor *)color
{
    CALayer *pieceLayer = [[CALayer alloc] init];
    // boxLayer.position = CGPointMake((0.5 + i) * self.boxDimension, self.frame.size.height - (0.5 + j) * self.boxDimension);
    
    pieceLayer.position = CGPointMake((0.5+col)*self.pieceSize, (0.5+row)*self.pieceSize + (self.frame.size.height - self.frame.size.width)/2);
    pieceLayer.bounds = CGRectMake(0,0,self.pieceSize,self.pieceSize);
    pieceLayer.backgroundColor = [color CGColor];
    pieceLayer.shadowColor = [[UIColor blackColor] CGColor];
    pieceLayer.shadowOffset = CGSizeMake(0, 0);
    pieceLayer.shadowOpacity = 1.0;
    pieceLayer.shadowRadius = 4.0;
    
    [self.layer addSublayer:pieceLayer];
    return pieceLayer;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPt = [touch locationInView:self];
    NSInteger col = touchPt.x / self.pieceSize;
    NSInteger row = (touchPt.y - (self.frame.size.height - (self.pieceSize * self.columnCount))/2 ) / self.pieceSize;
    
    [self.gameVC pieceTouchedInColumn:col inRow:row];
}




//- (void)drawRect:(CGRect)rect
//{
//    
//}


@end
