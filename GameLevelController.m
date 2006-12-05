#import "GameLevelController.h"

@implementation GameLevelController

#define PRESET(n,w,h,m) \
    [NSDictionary dictionaryWithObjectsAndKeys: \
        n, @"name", \
        [NSNumber numberWithInt: w], @"width", \
        [NSNumber numberWithInt: h], @"height", \
        [NSNumber numberWithInt: m], @"mines", \
        [NSNumber numberWithFloat: (float)(w*h)/m], @"density", nil]

+ (NSArray*) standardPresets {
    return [NSArray arrayWithObjects:
        PRESET(@"Beginner", 8, 8, 10),
        PRESET(@"Intermediate", 16, 16, 40),
        PRESET(@"Expert", 30, 16, 99),
        nil];
}

- (id) activatePanel:(GameStatus*)gs {
    gameStatus = gs;
    if (![panel isVisible]) {
        presets = [[[self class] standardPresets] retain];
    }
    [panel makeKeyAndOrderFront:self];
    return self;
}

- (IBAction) play: (id)sender {
    id preset = [presets objectAtIndex: [list selectedRow]];
    gameStatus->width = [[preset objectForKey: @"width"] intValue];
    gameStatus->height = [[preset objectForKey: @"height"] intValue];
    gameStatus->initialNumber = [[preset objectForKey: @"mines"] intValue];
    
    [panel orderOut:self];
    [[NSApp delegate] writePreferences:self];
    [gameStatus->gameBrain prepareGame];
}

- (int) numberOfRowsInTableView: (NSTableView *)view {
    return [presets count];
}

- (id) tableView: (id)tv objectValueForTableColumn: (id)col row: (int)row {
    return [[presets objectAtIndex: row] objectForKey: @"name"];
}

- (IBAction) save: (id)sender {
    
}

- (IBAction) saveAs: (id)sender {
    
}

- (IBAction) remove: (id)sender {
    
}

@end
