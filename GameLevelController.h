#import "typedefs.h"
#import "Controller.h"
#import "GameBrain.h"

@interface GameLevelController:NSObject
{
    IBOutlet id height, width, mines, density;
    IBOutlet id list;
    IBOutlet id panel;
    
    NSArray *presets;
    GameStatus *gameStatus;
}

- activatePanel:(GameStatus*)gs;
- (IBAction) play: (id)sender;
- (IBAction) save: (id)sender;
- (IBAction) saveAs: (id)sender;
- (IBAction) remove: (id)sender;

@end
