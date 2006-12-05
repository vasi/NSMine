#import "PreferencesController.h"

@implementation PreferencesController

- activatePanel:(GameStatus*)gs
{
  gameStatus = gs;
  if (![panel isVisible])
  {
    [self setIEs];
    tileColour        = gameStatus->tileColour;
    backgroundColour  = gameStatus->backgroundColour;
    jointColour       = gameStatus->jointColour;
    tileSize          = gameStatus->tileSize;
    usesSound         = gameStatus->usesSound;
  }
  [panel makeKeyAndOrderFront:self];
  return self;
}

- accept:sender
{
  gameStatus->tileSize  = [[sizeButtons selectedCell] tag];
  gameStatus->usesSound = [[soundButtons selectedCell] tag];
  gameStatus->tileColour = [tilesWell color];
  gameStatus->backgroundColour = [backgroundWell color];
  gameStatus->jointColour = [jointsWell color];
  [panel performClose:self];
  [[NSApp delegate] writePreferences:self];
  [gameStatus->view resize:YES];
  return self;
}

- (void)cancel:(id)sender
{
  [self revert:self];
  [panel performClose:self];
}

- revert:sender
{
  gameStatus->tileColour        = tileColour;
  gameStatus->backgroundColour  = backgroundColour;
  gameStatus->jointColour       = jointColour;
  gameStatus->tileSize          = tileSize;
  gameStatus->usesSound         = usesSound;
  [self setIEs];
  return self;
}

- setIEs
{
  [tilesWell setColor:gameStatus->tileColour];
  [backgroundWell setColor:gameStatus->backgroundColour];
  [jointsWell setColor:gameStatus->jointColour];
  [sizeButtons selectCellWithTag:gameStatus->tileSize];
  [soundButtons selectCellWithTag:gameStatus->usesSound];
  return self;
}

@end
