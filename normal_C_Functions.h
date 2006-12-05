#include <string.h>
#include <time.h>
#include <unistd.h>
#import <AppKit/AppKit.h>
#import "constants.h"

char *intToASCII(int i, char *buf);
id intToNSString(int i);
char *colorToASCII(NSColor * color, char *buf);
id colorToNSString(NSColor * color);
int     ASCIIToInt(const char *buf);
NSColor * ASCIIToColor(const char *buf);
int surround(int i);
BOOL vacant(int i);
BOOL number(int i);
BOOL mined(int i);
BOOL uncovered(int i);
BOOL flagged(int i);
int intRandom(int upper);
