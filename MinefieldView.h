#import "normal_C_Functions.h"
#import "constants.h"
#import "typedefs.h"
#import "GameBrain.h"

@interface MinefieldView:NSView
{
  id		tiles[12][2];
  id		fieldFrame;
  int		tilesize[2], jointsize[2], sCX, sCY, oW, oH, oS, stepsize;
  int           rectListCount;
  NSRect       *blackRectList, *whiteRectList, *mainRectList;
  GameStatus   *gameStatus;
  MineField    *mineField;
  BOOL          isTouched;
}

- initWithFrame:(NSRect)r;
- handOver:(GameStatus*)gs :(MineField*)mf;
- resize:(BOOL)b;
- (void)mouseDown:(NSEvent *)theEvent;
- (void)rightMouseDown:(NSEvent *)theEvent;
- updateTile:(int)i :(int)j;
- drawTile:(int)i :(int)j;

@end
