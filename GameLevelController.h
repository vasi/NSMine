#import "typedefs.h"
#import "Controller.h"
#import "GameBrain.h"

@interface GameLevel : NSObject {
	int width, height, mines;
	GameLevelTag level;
	NSString *name;
}
+ (GameLevel*) level: (GameLevelTag)t name: (NSString*)n
							 width: (int)w height: (int)h mines: (int)m;
- (id) initWithLevel: (GameLevelTag)t name: (NSString*)n
							 width: (int)w height: (int)h mines: (int)m;
- (int) width;
- (int) height;
- (int) mines;
- (NSString*) name;
- (GameLevelTag) level;
@end

@interface GameLevelController:NSObject
{
    id		buttons;
    id		height;
    id		mines;
    id		panel;
    id		width;
    GameStatus *gameStatus;
		NSMutableArray *levels;
}

- activatePanel:(GameStatus*)gs;
- customSelected:sender;
- update:sender;

@end
