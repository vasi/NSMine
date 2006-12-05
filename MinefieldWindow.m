#import "MinefieldWindow.h"

@implementation MinefieldWindow

- (void)mouseDown:(NSEvent *)theEvent 
{
  [[self delegate] touchedByLeft:[theEvent locationInWindow].x 
                         :[theEvent locationInWindow].y];
}

- (void)rightMouseDown:(NSEvent *)theEvent 
{
  [[self delegate] touchedByRight:[theEvent locationInWindow].x 
                          :[theEvent locationInWindow].y];
}

@end
