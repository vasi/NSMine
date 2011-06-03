#import "GameLevelController.h"

#define GAME_CUSTOM    8

@implementation GameLevelController

- activatePanel:(GameStatus*)gs
{
  gameStatus = gs;
  if (![panel isVisible])
  {
    [buttons selectCellWithTag:gameStatus->level];
    if (gameStatus->level == GAME_CUSTOM)
    {
      [width setIntValue:gameStatus->width];
      [height setIntValue:gameStatus->height];
      [mines setIntValue:gameStatus->initialNumber];
    }
  }
  [panel makeKeyAndOrderFront:self];
  return self;
}

- customSelected:sender
{
  [buttons selectCellWithTag:GAME_CUSTOM];
  return self;
}

- update:sender
{
  gameStatus->level = [[buttons selectedCell] tag];
  switch (gameStatus->level)
  {
    case 0:
        gameStatus->width = 8;
        gameStatus->height = 8;
        gameStatus->initialNumber = 10;
        break;
    case 1:
        gameStatus->width = 16;
        gameStatus->height = 16;
        gameStatus->initialNumber = 40;
        break;
    case 2:
        gameStatus->width = 30;
        gameStatus->height = 16;
        gameStatus->initialNumber = 99;
        break;
	  default: gameStatus->width = [width intValue];
             gameStatus->height = [height intValue];
	     gameStatus->initialNumber = [mines intValue];
  }

  [panel orderOut:self];
  [[NSApp delegate] writePreferences:self];
  [gameStatus->gameBrain prepareGame];
  return self;
}

@end
