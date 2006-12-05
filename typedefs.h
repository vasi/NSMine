#import "constants.h"

typedef int MineField[FIELD_MAXSIZE_X][FIELD_MAXSIZE_Y];

typedef struct
{
  int     initialNumber, width, height, status;
  int     tileSize, best[4], level, usesSound;
  id      sounds[6], gameBrain, view, stringtable;
  NSColor *tileColour;
  NSColor *backgroundColour;
  NSColor *jointColour;
}
GameStatus;