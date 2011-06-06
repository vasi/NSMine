#import "GameBrain.h"
#import "normal_C_Functions.h"

@implementation GameBrain

- start:sender
{
  [self prepareGame];
  return self;
}

- handOver:(GameStatus*)gs
{
  gameStatus = gs;
  gameStatus->gameBrain = self;
  [view handOver:gs :&mineField];
  return self;
}

- prepareGame
{  
  int i, j;

  [self stopGame];
  [button setImage:[NSImage imageNamed:@"smileyNormal"]];
  [[view window] setTitle:[[NSBundle mainBundle] localizedStringForKey:@"title"value:@"NXMine" table:nil]];
  firstClick = YES;
  [self fillField];
  for (i = 0; i < gameStatus->width; i++)
    for (j = 0; j < gameStatus->height; j++)
      if (mineField[i][j] == FIELD_CLEAR)
        mineField[i][j] = [self minesRoundAbout:i :j];
  [view resize:NO];
  gameStatus->status = GAME_READY;
  flags = gameStatus->initialNumber;
  remMines = gameStatus->initialNumber;
  tiles = gameStatus->width * gameStatus->height;
  [seconds setIntValue:0];
  [remaining setIntValue:remMines];  
  return self;
}

- startGame
{  
  gameStatus->status = GAME_RUNNING;
  [self startCounter];
  return self;
}

- stopGame
{
  gameStatus->status = GAME_FINISHED;
  [self stopCounter];
  return self;
}

- startCounter
{
  [self stopCounter];
  time = 0;
  counterTE = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(counterTick:) userInfo:self repeats:YES] retain];
  return self;
}

- stopCounter
{
  if (counterTE)
  {
    [counterTE invalidate]; [counterTE release];;
    counterTE = 0;
  }
  return self;
}

- counterTick:(NSTimer *)sender
{
  [seconds setIntValue:++time];
  return self;
}

- (int) minesRoundAbout:(int)i :(int)j
{
  int s = 0; 
  if (i > 0) 
    s += mined(mineField[i - 1][j    ]);
  if (j > 0) 
    s += mined(mineField[i    ][j - 1]);
  if ((i > 0) && (j > 0))
    s += mined(mineField[i - 1][j - 1]);
  if (i < (gameStatus->width - 1))
    s += mined(mineField[i + 1][j    ]);
  if (j < (gameStatus->height - 1))
    s += mined(mineField[i    ][j + 1]);
  if ((i < (gameStatus->width-1)) && (j < (gameStatus->height - 1)))
    s += mined(mineField[i + 1][j + 1]);
  if ((i > 0) && (j < (gameStatus->height - 1)))
    s += mined(mineField[i - 1][j + 1]);
  if ((i < (gameStatus->width-1)) && (j > 0))
    s += mined(mineField[i + 1][j - 1]);
  return s;
}

- (int) flagsRoundAbout:(int)i :(int)j;
{
  int s = 0; 
  if (i > 0) 
    s += flagged(mineField[i - 1][j    ]);
  if (j > 0) 
    s += flagged(mineField[i    ][j - 1]);
  if ((i > 0) && (j > 0))
    s += flagged(mineField[i - 1][j - 1]);
  if (i < (gameStatus->width - 1))
    s += flagged(mineField[i + 1][j    ]);
  if (j < (gameStatus->height - 1))
    s += flagged(mineField[i    ][j + 1]);
  if ((i < (gameStatus->width-1)) && (j < (gameStatus->height - 1)))
    s += flagged(mineField[i + 1][j + 1]);
  if ((i > 0) && (j < (gameStatus->height - 1)))
    s += flagged(mineField[i - 1][j + 1]);
  if ((i < (gameStatus->width-1)) && (j > 0))
    s += flagged(mineField[i + 1][j - 1]);
  return s;
}

- leftPressedAt:(int)i :(int)j
{    
  if (!flagged(mineField[i][j]))
  {
    if (uncovered(mineField[i][j]))
      [self trimRoundFieldAt:i :j];
    else
      [self uncoverFieldAt:i :j];
  }
  if (firstClick) firstClick = NO;
  return self;
}

- rightPressedAt:(int)i :(int)j
{
  if (uncovered(mineField[i][j]))
    [self trimRoundFieldAt:i :j];
  else
  {
    if (flagged(mineField[i][j]))
    {
      if (gameStatus->usesSound == SNDUSE_FULL)
        [gameStatus->sounds[SND_UNFLAG] play];
      [remaining setIntValue:++flags];
      if (mined(mineField[i][j]))
        remMines++;
      tiles++;
      mineField[i][j] &= ~FIELD_FLAGGED;
      [view updateTile:i :j];
    }
    else
    {
      if (gameStatus->usesSound == SNDUSE_FULL)
        [gameStatus->sounds[SND_FLAG] play];
      [remaining setIntValue:--flags];
      if (mined(mineField[i][j]))
        remMines--;
      tiles--;
      mineField[i][j] |= FIELD_FLAGGED;
      [view updateTile:i :j];
      if ((((remMines == 0) && (tiles == 0)) || (tiles == remMines)) &&
          (flags >= 0))
        [self finish];
    }
  }
  if (firstClick) firstClick = NO;
  return self;
}

- finish
{
  [self stopGame];
  [button setImage:[NSImage imageNamed:@"smileyCool"]]; 
  if ((gameStatus->level >= Max)||
      ([seconds intValue] >= gameStatus->best[gameStatus->level]))
  {
  	[[view window] setTitle:[[NSBundle mainBundle] localizedStringForKey:@"congratulations" value:@"Congrats!" table:nil]];
    if (gameStatus->usesSound != SNDUSE_NONE)
      [gameStatus->sounds[SND_FINISHED] play];
  }
  else
  {
    gameStatus->best[gameStatus->level] = [seconds intValue];
    [[NSApp delegate] writePreferences:self];
    [[view window] setTitle:[[NSBundle mainBundle] localizedStringForKey:@"newrecord" value:@"Wow!" table:nil]];
    if ([[NSApp delegate] hiscoresVisible])
      [[NSApp delegate] getHiscores:self];
    if (gameStatus->usesSound != SNDUSE_NONE)
      [gameStatus->sounds[SND_NEWRECORD] play];
  }
  return self;
}

- uncoverFieldAt:(int)i :(int)j
{
  if (mined(mineField[i][j]))
  {
    if(firstClick)
    {
      [self alterField:i :j];
      if (gameStatus->usesSound == SNDUSE_FULL)
	[gameStatus->sounds[SND_UNCOVER] play];
      mineField[i][j] |= FIELD_UNCOVERED;
      tiles--;
      if ((((remMines == 0) && (tiles == 0)) || (tiles == remMines)) &&
          (flags >= 0))
        [self finish];
      [view updateTile:i :j];
      if (vacant(mineField[i][j]))
	[self clearRoundFieldAt:i :j];
    }
    else
    {
    [[view window] setTitle:[[NSBundle mainBundle] localizedStringForKey:@"ouch"value:@"Ouch!" table:nil]];
      [button setImage:[NSImage imageNamed:@"smileyCrunch"]];
      if (gameStatus->usesSound != SNDUSE_NONE)
	[gameStatus->sounds[SND_EXPLOSION] play];
      [self stopGame];
      mineField[i][j] = FIELD_EXPLODED | FIELD_UNCOVERED;
      [view updateTile:i :j];
      [self showAllMines];
    }
  }
  else
  {
      if (gameStatus->usesSound == SNDUSE_FULL)
    [gameStatus->sounds[SND_UNCOVER] play];

    mineField[i][j] |= FIELD_UNCOVERED;
    tiles--;
    if ((((remMines == 0) && (tiles == 0)) || (tiles == remMines)) &&
        (flags >= 0))
      [self finish];
    [view updateTile:i :j];
    if (vacant(mineField[i][j]))
      [self clearRoundFieldAt:i :j];
  }
  mineField[i][j] |= FIELD_UNCOVERED;
  return self;
}

- clearRoundFieldAt:(int)i :(int)j
{
  if ((j > 0) && 
      !uncovered(mineField[i][j-1]) &&
      !flagged(mineField[i][j-1]))
    [self uncoverFieldAt:i :j-1];
  
  if ((j < (gameStatus->height - 1)) && 
      !uncovered(mineField[i][j+1]) &&
      !flagged(mineField[i][j+1]))
    [self uncoverFieldAt:i :j+1];
  
  if ((i > 0) && 
      !uncovered(mineField[i-1][j]) &&
      !flagged(mineField[i-1][j]))
    [self uncoverFieldAt:i-1 :j];
  
  if ((i < (gameStatus->width - 1)) && 
      !uncovered(mineField[i+1][j]) &&
      !flagged(mineField[i+1][j]))
    [self uncoverFieldAt:i+1 :j];
    
  if (((i < (gameStatus->width - 1)) && (j > 0)) && 
      !uncovered(mineField[i+1][j-1]) &&
      !flagged(mineField[i+1][j-1]))
    [self uncoverFieldAt:i+1 :j-1];
  
  if (((i > 0) && (j > 0)) && 
      !uncovered(mineField[i-1][j-1]) &&
      !flagged(mineField[i-1][j-1]))
    [self uncoverFieldAt:i-1 :j-1];
  
  if (((i > 0) && (j < (gameStatus->height - 1))) && 
      !uncovered(mineField[i-1][j+1]) &&
      !flagged(mineField[i-1][j+1]))
    [self uncoverFieldAt:i-1 :j+1];
  
  if (((i < (gameStatus->width - 1)) && (j < (gameStatus->height - 1))) && 
      !uncovered(mineField[i+1][j+1]) &&
      !flagged(mineField[i+1][j+1]))
    [self uncoverFieldAt:i+1 :j+1];
  
  return self;
}

- trimRoundFieldAt:(int)i :(int)j
{
  if ([self flagsRoundAbout:i :j] >= surround(mineField[i][j]))
    [self clearRoundFieldAt:i :j];

  return self;
}

- alterField:(int)u :(int)v
{
  int i, j;
  
  do
    [self fillField];
  while(mined(mineField[u][v]));
 
  for (i = 0; i < gameStatus->width; i++)
    for (j = 0; j < gameStatus->height; j++)
      if (mineField[i][j] == FIELD_CLEAR)
        mineField[i][j] = [self minesRoundAbout:i :j];
	
  return self;
}

- showAllMines
{
  int i, j;

  [[view window] disableFlushWindow];
  for (i = 0; i < gameStatus->width; i++)
    for (j = 0; j < gameStatus->height; j++)
    {
      if (mined(mineField[i][j]) && !uncovered(mineField[i][j]))
      {
        mineField[i][j] |= FIELD_UNCOVERED;        
        [view updateTile:i :j];
      }
      if (flagged(mineField[i][j]) && !mined(mineField[i][j]))
      {
        mineField[i][j] = FIELD_WRONGFLAG | FIELD_FLAGGED;        
        [view updateTile:i :j];
      }
    }
  [[view window] enableFlushWindow];
  [[view window] flushWindow];

return self;
}

- fillField
{
  int i, j, x, y;
  
  for(i = 0; i < gameStatus->width; i++)
    for(j = 0; j < gameStatus->height; j++)
      mineField[i][j] = FIELD_CLEAR;
  for (i = 0; i < gameStatus->initialNumber; i++)
  {
    do
    {
      x = intRandom(gameStatus->width);
      y = intRandom(gameStatus->height);
    }
    while (mineField[x][y] == FIELD_MINE);
    mineField[x][y] = FIELD_MINE;
  }
  return self;
}

@end
