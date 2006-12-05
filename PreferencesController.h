#import "typedefs.h"
#import "Controller.h"
#import "MinefieldView.h"

@interface PreferencesController:NSObject
{
    id		backgroundWell;
    id		jointsWell;
    id		sizeButtons;
    id		soundButtons;
    id		tilesWell;
    id  	panel;
    GameStatus  *gameStatus;
    NSColor 	*backgroundColour;
    NSColor     *tileColour;
    NSColor	*jointColour;
    int         tileSize, usesSound;
}

- activatePanel:(GameStatus*)gs;
- accept:sender;
- (void)cancel:(id)sender;
- revert:sender;
- setIEs;

@end
