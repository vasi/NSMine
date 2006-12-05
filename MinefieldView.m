#import "MinefieldView.h"
#import <AppKit/NSCursor.h>

#define SMALLTILE 18
#define LARGETILE 22

#define SMALLJOINT 1
#define LARGEJOINT 1

@implementation MinefieldView

- initWithFrame:(NSRect)r;
{
  NSPoint pt = {0,0};
  [super initWithFrame:r];
  blackRectList = NULL;
  whiteRectList = NULL;
  mainRectList = NULL;
  rectListCount = 0;
  tilesize[TILES_SMALL] = SMALLTILE;
  tilesize[TILES_LARGE] = LARGETILE;
  jointsize[TILES_SMALL] = SMALLJOINT;
  jointsize[TILES_LARGE] = LARGEJOINT;
  theCursor = [[NSCursor alloc] initWithImage:[NSImage imageNamed:@"theCursor"] hotSpot:pt];
  sCX = [[NSScreen mainScreen] frame].size.width / 2;
  sCY = [[NSScreen mainScreen] frame].size.height / 2;
  oW = 0; oH = 0; oS = 0;
  tiles[ 1][TILES_SMALL] = [NSImage imageNamed:@"small1"];
  tiles[ 2][TILES_SMALL] = [NSImage imageNamed:@"small2"];
  tiles[ 3][TILES_SMALL] = [NSImage imageNamed:@"small3"];
  tiles[ 4][TILES_SMALL] = [NSImage imageNamed:@"small4"];
  tiles[ 5][TILES_SMALL] = [NSImage imageNamed:@"small5"];
  tiles[ 6][TILES_SMALL] = [NSImage imageNamed:@"small6"];
  tiles[ 7][TILES_SMALL] = [NSImage imageNamed:@"small7"];
  tiles[ 8][TILES_SMALL] = [NSImage imageNamed:@"small8"];
  tiles[ 9][TILES_SMALL] = [NSImage imageNamed:@"smallExplodedMine"];
  tiles[10][TILES_SMALL] = [NSImage imageNamed:@"smallMine"];
  tiles[ 0][TILES_SMALL] = [NSImage imageNamed:@"smallFlag"];  
  tiles[11][TILES_SMALL] = [NSImage imageNamed:@"smallWrongFlag"]; 
  tiles[ 1][TILES_LARGE] = [NSImage imageNamed:@"large1"];
  tiles[ 2][TILES_LARGE] = [NSImage imageNamed:@"large2"];
  tiles[ 3][TILES_LARGE] = [NSImage imageNamed:@"large3"];
  tiles[ 4][TILES_LARGE] = [NSImage imageNamed:@"large4"];
  tiles[ 5][TILES_LARGE] = [NSImage imageNamed:@"large5"];
  tiles[ 6][TILES_LARGE] = [NSImage imageNamed:@"large6"];
  tiles[ 7][TILES_LARGE] = [NSImage imageNamed:@"large7"];
  tiles[ 8][TILES_LARGE] = [NSImage imageNamed:@"large8"];
  tiles[ 9][TILES_LARGE] = [NSImage imageNamed:@"largeExplodedMine"];
  tiles[10][TILES_LARGE] = [NSImage imageNamed:@"largeMine"];
  tiles[ 0][TILES_LARGE] = [NSImage imageNamed:@"largeFlag"];  
  tiles[11][TILES_LARGE] = [NSImage imageNamed:@"largeWrongFlag"]; 
  return self;
}

- handOver:(GameStatus*)gs :(MineField*)mf
{
  gameStatus = gs;
  mineField = mf;
  gameStatus->view = self;
  stepsize = tilesize[gameStatus->tileSize] +
             jointsize[gameStatus->tileSize];
  return self;
}

- resize:(BOOL)b
{  
  NSRect rect;
  int    i, j;
  
  int sizeX = gameStatus->width * 
              (jointsize[gameStatus->tileSize] +
	       tilesize[gameStatus->tileSize]) -
	       jointsize[gameStatus->tileSize];
  int sizeY = gameStatus->height * 
              (jointsize[gameStatus->tileSize] +
	       tilesize[gameStatus->tileSize]) -
	       jointsize[gameStatus->tileSize];
  isTouched = b;
  if ((oW != gameStatus->width) ||
      (oH != gameStatus->height) ||
      (oS != gameStatus->tileSize))
  {
    stepsize = tilesize[gameStatus->tileSize] +
               jointsize[gameStatus->tileSize];
    if (mainRectList)
    {
        free(blackRectList);
        free(whiteRectList);
        free(mainRectList);
    }
    rectListCount = gameStatus->width * gameStatus->height;
    blackRectList = malloc(sizeof(NSRect) * rectListCount);
    whiteRectList = malloc(sizeof(NSRect) * rectListCount);
    mainRectList = malloc(sizeof(NSRect) * rectListCount);
    for (i = 0; i < gameStatus->width; i++)
      for (j = 0; j < gameStatus->height; j++)
      {
        blackRectList[i*gameStatus->height+j].origin.x = i*stepsize;
        blackRectList[i*gameStatus->height+j].origin.y = j*stepsize;
        blackRectList[i*gameStatus->height+j].size.width =
	                            tilesize[gameStatus->tileSize];
        blackRectList[i*gameStatus->height+j].size.height =
	                            tilesize[gameStatus->tileSize];
        whiteRectList[i*gameStatus->height+j].origin.x = i*stepsize;
        whiteRectList[i*gameStatus->height+j].origin.y = j*stepsize+1;
        whiteRectList[i*gameStatus->height+j].size.width =
	                            tilesize[gameStatus->tileSize]-1;
        whiteRectList[i*gameStatus->height+j].size.height =
	                            tilesize[gameStatus->tileSize]-1;
        mainRectList[i*gameStatus->height+j].origin.x = i*stepsize+1;
        mainRectList[i*gameStatus->height+j].origin.y = j*stepsize+1;
        mainRectList[i*gameStatus->height+j].size.width =
	                            tilesize[gameStatus->tileSize]-2;
        mainRectList[i*gameStatus->height+j].size.height =
	                            tilesize[gameStatus->tileSize]-2;
      }
    [[self window] orderOut:self];
    [self setFrameSize:NSMakeSize(sizeX, sizeY)];
    rect = [self frame];
    [fieldFrame setFrameSize:NSMakeSize(sizeX +  4, sizeY +  4)];		
    [[self window] setContentSize:NSMakeSize(sizeX + 23, sizeY + 62)];
    
    [[self window] setFrameOrigin:NSMakePoint(sCX - (sizeX / 2), sCY - (sizeY / 2))];
    
    [fieldFrame setFrameOrigin:NSMakePoint(10, 10)];
    [self setFrameOrigin:NSMakePoint(12, 12)];
    
    [[self window] invalidateCursorRectsForView:self];
    [[self window] display];
    [[self window] makeKeyAndOrderFront:self];
    oW = gameStatus->width;
    oH = gameStatus->height;
    oS = gameStatus->tileSize;
  }
  else
    [self display];
  return self;
}

- (void)resetCursorRects
{
   NSRect visible;
   if (!NSIsEmptyRect(visible = [self visibleRect]))
     [self addCursorRect:visible cursor:theCursor];
}

- (void)drawRect:(NSRect)rects
{  
  int    i,j;
  
  /* if (isTouched)
  {
    myBounds = [self bounds];
    [gameStatus->backgroundColour set];
    NSRectFill(NSMakeRect(NSMinX(myBounds), NSMinY(myBounds),
		NSWidth(myBounds), NSHeight(myBounds)));
    [gameStatus->jointColour set];		
    for (i = 1; i < gameStatus->width; i++)
    {
      CGContextMoveToPoint(ctxt, i*stepsize-1, 0);
      CGContextAddLineToPoint(ctxt, i*stepsize-1, stepsize*gameStatus->height);
    }
    for (i = 1; i < gameStatus->height; i++)
    {
      CGContextMoveToPoint(ctxt, 0, i*stepsize);
      CGContextAddLineToPoint(ctxt, stepsize*gameStatus->width, i*stepsize);
    }
    CGContextStrokePath(ctxt); */
    
    for (i = 0; i < gameStatus->width; i++)
      for (j = 0; j < gameStatus->height; j++)
        [self drawTile:i:j];
  /* }
  else
  {
    myBounds = [self bounds];
    [gameStatus->jointColour set];
    NSRectFill(NSMakeRect(NSMinX(myBounds), NSMinY(myBounds),
		NSWidth(myBounds), NSHeight(myBounds)));

    [[NSColor blackColor] set];
    NSRectFillList(blackRectList, rectListCount);
    
    [[NSColor whiteColor] set];
    NSRectFillList(whiteRectList, rectListCount);
    
    [gameStatus->tileColour set];
    NSRectFillList(mainRectList, rectListCount);
  } */
}

- (void)mouseDown:(NSEvent *)theEvent 
{
  int x, y;

if (([theEvent modifierFlags] & NSControlKeyMask) || ([theEvent modifierFlags] & NSAlternateKeyMask)
			|| ([theEvent modifierFlags] & NSShiftKeyMask)) {
        [self rightMouseDown:theEvent];
        return;
    }
  
  if (gameStatus->status == GAME_FINISHED)
    return;
  if (gameStatus->status == GAME_READY)
    [[[self window] delegate] startGame];
  x = ([theEvent locationInWindow].x - 15) / stepsize;
  y = ([theEvent locationInWindow].y - 15) / stepsize;
  [[[self window] delegate] leftPressedAt:x :y];
}

- (void)rightMouseDown:(NSEvent *)theEvent 
{
  int x, y;
  
  if (gameStatus->status == GAME_FINISHED)
    return;
  if (gameStatus->status == GAME_READY)
    [[[self window] delegate] startGame];
  x = ([theEvent locationInWindow].x - 15) / stepsize;
  y = ([theEvent locationInWindow].y - 15) / stepsize;
  [[[self window] delegate] rightPressedAt:x :y];
}


- updateTile:(int)i :(int)j
{
  
  [self lockFocus];
  [self drawTile:i :j];
  [self unlockFocus];
  [[self window] flushWindow];

  return self;
}

- drawTile:(int)i :(int)j
{
  NSPoint iP;
  int k;
    CGContextRef ctxt = [[NSGraphicsContext currentContext] graphicsPort];
    
  iP.x = i*stepsize;
  iP.y = j*stepsize;
  isTouched = YES;
  if (flagged((*mineField)[i][j]) || !uncovered((*mineField)[i][j]))
  {
    [gameStatus->tileColour set];
    NSRectFill(NSMakeRect(iP.x,
	       iP.y,
	       tilesize[gameStatus->tileSize],
	       tilesize[gameStatus->tileSize]));
    [[NSColor whiteColor] set];
    CGContextMoveToPoint(ctxt, iP.x, iP.y + 1);
    CGContextAddLineToPoint(ctxt, iP.x, iP.y + tilesize[gameStatus->tileSize]);
    CGContextAddLineToPoint(ctxt, iP.x + tilesize[gameStatus->tileSize] - 1,
	      iP.y + tilesize[gameStatus->tileSize]);
    CGContextStrokePath(ctxt);
    
    [[NSColor blackColor] set];
    CGContextMoveToPoint(ctxt, iP.x, iP.y + 1);
    CGContextAddLineToPoint(ctxt, iP.x + tilesize[gameStatus->tileSize] - 1, iP.y + 1);
    CGContextAddLineToPoint(ctxt, iP.x + tilesize[gameStatus->tileSize] - 1,
	      iP.y + tilesize[gameStatus->tileSize]);
    CGContextStrokePath(ctxt);
    if (flagged((*mineField)[i][j]))
    {
      if (((*mineField)[i][j] & 0x000F) == FIELD_WRONGFLAG)
        [tiles[11][gameStatus->tileSize] compositeToPoint:iP operation:NSCompositeSourceOver];
      else
        [tiles[ 0][gameStatus->tileSize] compositeToPoint:iP operation:NSCompositeSourceOver];
    }
  }
  if (uncovered((*mineField)[i][j]) && !flagged((*mineField)[i][j]))
  {
    [gameStatus->backgroundColour set];
    NSRectFill(NSMakeRect(iP.x,
	       iP.y,
	       tilesize[gameStatus->tileSize],
	       tilesize[gameStatus->tileSize]));
    k = ((*mineField)[i][j]) & 0x000F;
    if (k != 0)
      [tiles[k][gameStatus->tileSize] compositeToPoint:iP operation:NSCompositeSourceOver];
  }
  return self;
}

@end
