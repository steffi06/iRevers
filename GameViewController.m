//
//  GameViewController.m
//  iRevers
//
//  Created by Stephanie Shupe on 10/16/12.
//  Copyright (c) 2012 shupeCreations. All rights reserved.
//

#import "GameViewController.h"
#import "GamePiece.h"
#import "GameView.h"
#import <QuartzCore/QuartzCore.h>

@interface GameViewController ()

@property (strong, nonatomic) NSArray *pieces;
@property (strong, nonatomic) NSMutableDictionary *pieceLayers;

@end

@implementation GameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self startNewGame];
    }
    return self;
}

- (void)loadView
{
    self.view = [[GameView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ((GameView *) self.view).gameVC = self;
    ((GameView *) self.view).columnCount = self.pieces.count;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generatePieceLayers];
}

- (UIColor *)colorForPiece:(GamePiece *)piece
{
    UIColor *pieceColor;
    if (piece.state == @"black"){
        pieceColor = [UIColor blackColor];
    } else if (piece.state == @"white") {
        pieceColor = [UIColor whiteColor];
    } else {
        pieceColor = [UIColor greenColor];
    }
    return pieceColor;
}

- (void)generatePieceLayers
{
    self.view.layer.sublayers = nil;
    
    for ( NSInteger i = 0 ; i < self.pieces.count ; i++ ) {
        for ( NSInteger j = 0 ; j < ((NSArray *)self.pieces[i]).count ; j++ ) {
            GamePiece *piece = self.pieces[i][j];
            UIColor *pieceColor = [self colorForPiece:piece];
            
            CALayer *layer = [(GameView *)self.view makePieceLayerWithColumnIndex:i
                                                                   withPieceIndex:j
                                                                        withColor:pieceColor
                              ];
            [self.pieceLayers setObject:layer forKey:[NSValue valueWithNonretainedObject:piece]];
        }
    }
}

-(void)pieceTouchedInColumn:(NSInteger)col inRow:(NSInteger)row
{
    GamePiece *selectedPiece = [self pieceInColumn:col inRow:row];
    if (![self acceptableMove:selectedPiece inColumn:col inRow:row]) {
        [self pushAlertWithText:@"That appears to be an invalid move. Please try another move."];
        return;
    }
    
NSSet
    
    // if white turn
    
    selectedPiece.state = @"white";
    [self generatePieceLayers];
    
}

- (void)startNewGame
{
    self.pieces = [self setupGameBoardWithGridSize:8];
    self.pieceLayers = [NSMutableDictionary new];
}

- (NSMutableArray *)setupGameBoardWithGridSize:(NSInteger)gridDim
{
    NSMutableArray *allSpaces = [NSMutableArray new];

    for ( int i = 0 ; i < gridDim ; i++ ) {
        NSMutableArray *columnSpaces = [NSMutableArray new];
        
        for ( int j = 0 ; j < gridDim ; j++ ) {
            GamePiece *piece = [GamePiece new];
            [columnSpaces addObject:piece];
            if ( i == j && (i == (gridDim/2 - 1) || i == (gridDim/2)) ) {
                piece.state = @"white";
            } else if ( i != j && (i == (gridDim/2 - 1) || i == (gridDim/2)) && (j == (gridDim/2 - 1) || j == (gridDim/2))) {
                piece.state = @"black";
            }
        }
        [allSpaces addObject:columnSpaces];
    }
    return allSpaces;
}

- (BOOL)acceptableMove:(GamePiece *)piece inColumn:(NSInteger)col inRow:(NSInteger)row
{
    NSMutableArray *piecesToFlip = [self flipPiecesAfterTouchInColumn:col inRow:row];
    if (piece.state != @"blank") {
        return NO;
    } else if (piecesToFlip.count > 0 ){
        for (GamePiece *piece in piecesToFlip) {
            piece.state = @"white";
        }
        return YES;
    }
    
    /* check for white turn
       
     check pieces surrounding touched piece (8 possibilities) for black state
       
     cases:
        + 1 column
        - 1 column
        + 1 row
        - 1 row
        + 1 column, + 1 row
        + 1 column, - 1 row
        - 1 column, + 1 row
        - 1 column, - 1 row
    
    if piece.state at these spaces is black, check the SAME CASE until white is found
     if no white is found, move is invalid
     if white is found, move is valid and any black pieces between should change state to white
     
     ** this needs to be done for every case & multiple cases can be true
     
     only one needs to be valid for move to be valid
     
     */
}

- (NSMutableArray *)flipPiecesAfterTouchInColumn:(NSInteger)col inRow:(NSInteger)row {
    // check same row, add 1 to column
    GamePiece *rightPiece = self.pieces[col + 1][row];
    GamePiece *leftPiece = self.pieces[col - 1][row];
    GamePiece *upPiece = self.pieces[col][row + 1];
    GamePiece *downPiece = self.pieces[col][row - 1];
    GamePiece *rightUpPiece = self.pieces[col + 1][row + 1];
    GamePiece *rightDownPiece = self.pieces[col + 1][row - 1];
    GamePiece *leftUpPiece = self.pieces[col - 1][row + 1];
    GamePiece *leftDownPiece = self.pieces[col - 1][row - 1];
    
    NSMutableArray *piecesToFlip = [NSMutableArray new];
    NSString *currentPlayer = @"white";
    NSString *checkColor;
    
    if (currentPlayer == @"white") {
        checkColor = @"black";
    } else {
        checkColor = @"white";
    }
    
    if ([self rightStateForColumn:col forRow:row] == checkColor) {
        if ([self rightStateForColumn:(col +1) forRow:row] == currentPlayer) {
            GamePiece *flipPiece = [self pieceInColumn:(col + 1) inRow:row];
            [piecesToFlip addObject:flipPiece];
        }
    }
    
    return piecesToFlip;
}

- (NSString *)rightStateForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col + 1][row]).state;
}

- (NSString *)leftStateForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col - 1][row]).state;
}

- (NSString *)upStateForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col][row + 1]).state;
}

- (NSString *)downStateForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col][row - 1]).state;
}

- (NSString *)rightUpStateForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col + 1][row + 1]).state;
}

- (NSString *)rightDownStateForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col + 1][row - 1]).state;
}

- (NSString *)leftUpStateForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col - 1][row + 1]).state;
}

- (NSString *)leftDownPieceStateCheckForColumn:(NSInteger)col forRow:(NSInteger)row
{
    return ((GamePiece *)self.pieces[col - 1][row - 1]).state;
}

- (void)pushAlertWithText:(NSString *)alertText
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:alertText
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

- (GamePiece *)pieceInColumn:(NSInteger)col inRow:(NSInteger)row
{
    return [[self.pieces objectAtIndex:col] objectAtIndex:row];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
