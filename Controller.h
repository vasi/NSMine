#import "constants.h"
#import "typedefs.h"
#import "normal_C_Functions.h"
#import "GameBrain.h"
#import "GameLevelController.h"
#import "PreferencesController.h"

@interface Controller:NSObject
{
    id		hiscorePanel;
    id		infoPanel;
    id		gameBrain;
    id		preferencesController;
    id		gamelevelController;
    id		begTF;
    id		intTF;
    id		expTF;
    id          stringtable;
    BOOL        mouseChanged;
    GameStatus	gameStatus;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification;
- (void)applicationDidFinishLaunching:(NSNotification *)notification;
- (BOOL)applicationShouldTerminate:(id)sender;
- getHiscores:sender;
- getInfoPanel:sender;
- getGameLevel:sender;
- getPreferences:sender;
- readPreferences:sender;
- writePreferences:sender;
- verifySettings:sender;
- updateBestTimes:sender;
- (void)applicationDidBecomeActive:(NSNotification *)notification;
- (void)applicationDidResignActive:(NSNotification *)notification;
- (BOOL) hiscoresVisible;
@end
