#import <AppKit/AppKit.h>
#import "normal_C_Functions.h"
#import "constants.h"
#import "typedefs.h"
#import "Controller.h"
#import "MinefieldView.h"

@interface GameBrain:NSObject
{
    id             remaining;
    id             seconds;
    id             view;
    id             button;
    int            time, flags, remMines, tiles;
    BOOL           firstClick;
    NSTimer *counterTE;
    MineField      mineField;
    GameStatus	  *gameStatus;
}

- start:sender;
- handOver:(GameStatus*)gs;
- prepareGame;
- startGame;
- stopGame;
- startCounter;
- stopCounter;
- counterTick:(NSTimer *)timer;
- leftPressedAt:(int)i :(int)j;
- rightPressedAt:(int)i :(int)j;
- (int) minesRoundAbout:(int)i :(int)j;
- (int) flagsRoundAbout:(int)i :(int)j;
- uncoverFieldAt:(int)i :(int)j;
- clearRoundFieldAt:(int)i :(int)j;
- trimRoundFieldAt:(int)i :(int)j;
- alterField:(int)u :(int)v;
- showAllMines;
- fillField;
- finish;

@end
