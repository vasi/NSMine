#import "constants.h"

typedef int MineField[FIELD_MAXSIZE_X][FIELD_MAXSIZE_Y];

typedef enum {
	Beginner, Intermediate, Expert, Max,
	None, Custom
} GameLevelTag;

typedef struct
{
  int     initialNumber, width, height, status;
  int     tileSize, best[4], usesSound;
  id      sounds[6], gameBrain, view, stringtable;
	GameLevelTag level;
  NSColor *tileColour;
  NSColor *backgroundColour;
  NSColor *jointColour;
}
GameStatus;