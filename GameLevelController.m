#import "GameLevelController.h"

@implementation GameLevel
+ (GameLevel*) level: (GameLevelTag)t name: (NSString*)n
							 width: (int)w height: (int)h mines: (int)m {
	return [[[self alloc] initWithLevel: t name: n
																width: w height: h mines: m] autorelease];
}

- (id) initWithLevel: (GameLevelTag)t name: (NSString*)n
							 width: (int)w height: (int)h mines: (int)m {
	if ((self = [super init])) {
		level = t;
		width = w;
		height = h;
		mines = m;
		name = [n retain];
	}
	return self;
}
- (void) dealloc {
	[name release];
	[super dealloc];
}

- (GameLevelTag) level { return level; }
- (NSString*) name { return name; }
- (int) width { return width; }
- (int) height { return height; }
- (int) mines { return mines; }
@end

@implementation GameLevelController

- (void) addLevel: (GameLevelTag)tag name: (NSString*)n width: (int)w height: (int)h
						mines: (int)m {
	[levels addObject: [GameLevel level: tag name: n width: w height: h mines: m]];
}

- (void) setupLevels {
	[self addLevel: Beginner name: @"Beginner" width: 8 height: 8 mines: 10];
	[self addLevel: Intermediate name: @"Intermediate" width: 16 height: 16 mines: 40];
	[self addLevel: Expert name: @"Expert" width: 30 height: 16 mines: 99];
	
	// Read more from user defaults
	NSArray *extra = [[NSUserDefaults standardUserDefaults] objectForKey: @"ExtraLevels"];
	if (extra) {
		NSDictionary *d;
		NSEnumerator *e = [extra objectEnumerator];
		while ((d = [e nextObject])) {
			int w = [[d objectForKey: @"Width"] intValue],
				h = [[d objectForKey: @"Height"] intValue],
				m = [[d objectForKey: @"Mines"] intValue];
			NSString *name = [d objectForKey: @"Name"];
			[self addLevel: None name: name width: w height: h mines: m];
		}
	}
}

- (void) awakeFromNib {
	levels = [[NSMutableArray alloc] init];
	[self setupLevels];

	CGFloat origHeight = [buttons frame].size.height;
	NSCell *template = [buttons cellAtRow: 0 column: 0];
	
	int i = 0;
	NSEnumerator *e = [levels objectEnumerator];
	GameLevel *l;
	while ((l = [e nextObject])) {
		NSCell *copy = [template copy];
		[copy setState: NSOffState];
		[copy setTitle: [NSString stringWithFormat: @"%@ (%d x %d with %d Mines)",
										 [l name], [l width], [l height], [l mines]]];
		[buttons insertRow: i++ withCells: [NSArray arrayWithObject: copy]];
	}
	
	[buttons sizeToCells];	
	CGFloat dHeight = [buttons frame].size.height - origHeight;
	NSRect winFrame = [panel frame];
	winFrame.size.height += dHeight;
	[panel setFrame: winFrame display: YES];
}

- (void) dealloc {
	[levels release];
	[super dealloc];
}

- activatePanel:(GameStatus*)gs
{
  gameStatus = gs;
  if (![panel isVisible])
  {		
		int i = 0;
		NSEnumerator *e = [levels objectEnumerator];
		GameLevel *l;
		while ((l = [e nextObject])) {
			if ([l width] == gs->width && [l height] == gs->height &&
					[l mines] == gs->initialNumber) {
				[buttons selectCellAtRow: i column: 0];
				break;
			}
			++i;
		}
		if (i == [levels count]) {
			[buttons selectCellAtRow: i column: 0];
      [width setIntValue:gameStatus->width];
      [height setIntValue:gameStatus->height];
      [mines setIntValue:gameStatus->initialNumber];
		}
  }
  [panel makeKeyAndOrderFront:self];
  return self;
}

- customSelected:sender {
	[buttons selectCellAtRow: [levels count] column: 0];
	return self;
}

- update:sender
{
	int i = [buttons selectedRow];
	if (i == [levels count]) { // custom
		gameStatus->level = Custom;
		gameStatus->width = [width intValue];
		gameStatus->height = [height intValue];
		gameStatus->initialNumber = [mines intValue];
	} else {
		GameLevel *l = [levels objectAtIndex: i];
		gameStatus->level = [l level];
		gameStatus->width = [l width];
		gameStatus->height = [l height];
		gameStatus->initialNumber = [l mines];		
	}

  [panel orderOut:self];
  [[NSApp delegate] writePreferences:self];
  [gameStatus->gameBrain prepareGame];
  return self;
}

@end
