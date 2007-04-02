#import "typedefs.h"
#import "Controller.h"
#import "GameBrain.h"

@interface GameLevelController:NSObject
{
    id		buttons;
    id		height;
    id		mines;
    id		panel;
    id		width;
    GameStatus *gameStatus;
}

- activatePanel:(GameStatus*)gs;
- customSelected:sender;
- update:sender;

@end
