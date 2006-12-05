#import "Controller.h"

@implementation Controller

+ (void)initialize
{
NSDictionary *defaultsDict = [NSDictionary dictionaryWithObjectsAndKeys:
        @"1",				@"Level", 		
        @"16",				@"FieldWidth", 		
        @"16",				@"FieldHeight", 	
        @"40",				@"NumberOfMines", 	
        @"999",				@"BestTimeBeginner",	
        @"999",				@"BestTimeIntermediate",
        @"999",				@"BestTimeExpert",	
        @"1",				@"UsesSound",		
        @"1",				@"TileSize",		
        @"0.266671:0.599994:0.666662",	@"TileColour",		
        @"0.666662:0.666662:0.666662",	@"BackgroundColour",	
	@"0.333338:0.333338:0.333338",	@"JointColour",		
	nil];
          
  [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsDict];
  return;
}

- (void)applicationWillFinishLaunching:(NSNotification *)notification
{
    [self readPreferences:self];
  gameStatus.stringtable = stringtable;
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    NSString *path;
  
  if (path = [[NSBundle mainBundle] pathForResource:@"uncover" ofType:@"aiff"])
  gameStatus.sounds[SND_UNCOVER] = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
  if (path = [[NSBundle mainBundle] pathForResource:@"newRecord" ofType:@"snd"])
  gameStatus.sounds[SND_NEWRECORD] = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
  if (path = [[NSBundle mainBundle] pathForResource:@"newRecord" ofType:@"snd"])
  gameStatus.sounds[SND_FINISHED] = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
  if (path = [[NSBundle mainBundle] pathForResource:@"explosion" ofType:@"snd"])
  gameStatus.sounds[SND_EXPLOSION] = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
  if (path = [[NSBundle mainBundle] pathForResource:@"flag" ofType:@"snd"])
  gameStatus.sounds[SND_FLAG] = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
  if (path = [[NSBundle mainBundle] pathForResource:@"unflag" ofType:@"snd"])
  gameStatus.sounds[SND_UNFLAG] = [[NSSound alloc] initWithContentsOfFile:path byReference:NO];
    
  [self readPreferences:self]; 
  [gameBrain handOver:&gameStatus];
  [(GameBrain *)gameBrain start:self];
}

- getHiscores:sender
{
  if (hiscorePanel == nil)
  {
    if (![NSBundle loadNibNamed:@"hiscore.nib" owner:self])
      return nil;
  }
  [self updateBestTimes:self];
  [hiscorePanel makeKeyAndOrderFront:nil];
  return self;
}

- getInfoPanel:sender
{
  [NSApp orderFrontStandardAboutPanelWithOptions:nil];
  return self;
}

- getGameLevel:sender
{
  if (gamelevelController == nil)
  {
    if (![NSBundle loadNibNamed:@"gamelevel.nib" owner:self])
      return nil;
  }
  [gamelevelController activatePanel:&gameStatus];
  return self;
}

- getPreferences:sender
{
  if (preferencesController == nil)
  {
    if (![NSBundle loadNibNamed:@"preferences.nib" owner:self])
      return nil;
  }
  [preferencesController activatePanel:&gameStatus];
  return self;
}

- verifySettings:sender
{
  if (gameStatus.width > FIELD_MAXSIZE_X)
    gameStatus.width = FIELD_MAXSIZE_X;
  if (gameStatus.height > FIELD_MAXSIZE_Y)
    gameStatus.height = FIELD_MAXSIZE_Y;
  if (gameStatus.initialNumber > (gameStatus.width * gameStatus.height)) 
    gameStatus.initialNumber = 1;
  if (gameStatus.width < 4) gameStatus.width = 4;
  if (gameStatus.height < 4) gameStatus.height = 4;
  if (gameStatus.initialNumber < 1) gameStatus.initialNumber = 1;
  return self;
}

- readPreferences:sender
{
    gameStatus.level = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"Level"] cString]);
gameStatus.width = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"FieldWidth"] cString]);
gameStatus.height = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"FieldHeight"] cString]);
  gameStatus.initialNumber = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"NumberOfMines"] cString]);
  gameStatus.best[0] = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"BestTimeBeginner"] cString]);
  gameStatus.best[1] = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"BestTimeIntermediate"] cString]);
  gameStatus.best[2] = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"BestTimeExpert"] cString]);
  gameStatus.best[3] = -1;
  gameStatus.usesSound = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"UsesSound"] cString]);
  gameStatus.tileSize = ASCIIToInt([[[NSUserDefaults standardUserDefaults] objectForKey:@"TileSize"] cString]);
  gameStatus.tileColour = [ASCIIToColor([[[NSUserDefaults standardUserDefaults] objectForKey:@"TileColour"] cString]) retain];
  gameStatus.backgroundColour = [ASCIIToColor([[[NSUserDefaults standardUserDefaults] objectForKey:@"BackgroundColour"] cString]) retain];
  gameStatus.jointColour = [ASCIIToColor([[[NSUserDefaults standardUserDefaults] objectForKey:@"JointColour"] cString]) retain];
  [self verifySettings:self];

  return self;
}

- writePreferences:sender
{

    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.level) forKey:@"Level"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.width) forKey:@"FieldWidth"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.height) forKey:@"FieldHeight"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.initialNumber) forKey:@"NumberOfMines"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.best[0]) forKey:@"BestTimeBeginner"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.best[1]) forKey:@"BestTimeIntermediate"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.best[2]) forKey:@"BestTimeExpert"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.usesSound) forKey:@"UsesSound"];
    [[NSUserDefaults standardUserDefaults] setObject:intToNSString(gameStatus.tileSize) forKey:@"TileSize"];
    [[NSUserDefaults standardUserDefaults] setObject:colorToNSString(gameStatus.tileColour) forKey:@"TileColour"];
    [[NSUserDefaults standardUserDefaults] setObject:colorToNSString(gameStatus.backgroundColour) forKey:@"BackgroundColour"];
    [[NSUserDefaults standardUserDefaults] setObject:colorToNSString(gameStatus.jointColour) forKey:@"JointColour"];

  return self;
}

- updateBestTimes:sender
{
  if (hiscorePanel)
  {
    if (gameStatus.best[0] < 999)
      [begTF setIntValue:gameStatus.best[0]];
    else
      [begTF setStringValue:@"na"];
    if (gameStatus.best[1] < 999)
      [intTF setIntValue:gameStatus.best[1]];
    else
      [intTF setStringValue:@"na"];
    if (gameStatus.best[2] < 999)
      [expTF setIntValue:gameStatus.best[2]];
    else
      [expTF setStringValue:@"na"];
  }
  return self;
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{ 
}

- (void)applicationDidResignActive:(NSNotification *)notification
{
}

- (BOOL)applicationShouldTerminate:(id)sender
{
  [self applicationDidResignActive:nil];
  return YES;
}

- (BOOL) hiscoresVisible
{
  if ((hiscorePanel != nil) && ([hiscorePanel isVisible]))
    return YES;
  else
    return NO;

  return NO;
}

@end
