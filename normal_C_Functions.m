#import "normal_C_Functions.h"

char *intToASCII(int i, char *buf)
{
  sprintf(buf, "%i", i);
  return buf;
}

id intToNSString(int i)
{
  return [[NSNumber numberWithInt:i] stringValue];
}

int ASCIIToInt(const char *buf)
{
  int i;
  
  sscanf(buf, "%i", &i);
  return i;
}

char *colorToASCII(NSColor * color, char *buf)
{
  float   r, g, b;
  [[color colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&r green:&g blue:&b alpha:NULL];
  sprintf(buf, "%f:%f:%f", r, g, b);
  return buf;
}

id colorToNSString(NSColor * color)
{
  float   r, g, b;
  char	buf[256];
  [[color colorUsingColorSpaceName:NSCalibratedRGBColorSpace] getRed:&r green:&g blue:&b alpha:NULL];
  sprintf(buf, "%f:%f:%f", r, g, b);
  return [NSString stringWithCString:buf];
}

NSColor * ASCIIToColor(const char *buf)
{
  float   r, g, b;
  sscanf(buf, "%f:%f:%f", &r, &g, &b);
  return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];
}

int surround(int i)
{
  if (flagged(i))
    return surround(i & ~FIELD_FLAGGED);
  if (uncovered(i))
    return surround(i & ~FIELD_UNCOVERED);
  return i; 
}

BOOL vacant(int i)
{
  if ((i & 0x000F) != FIELD_CLEAR)
    return NO; 
  else
    return YES;
}

BOOL number(int i)
{
  if (((i & 0x000F) > 0) && ((i & 0x000F) < 9))
    return YES; 
  else
    return NO;
}

BOOL mined(int i)
{
  if ((i & 0x000F) == FIELD_MINE)
    return YES; 
  else
    return NO;
}

BOOL uncovered(int i)
{
  if ((i | FIELD_UNCOVERED) != i)
    return NO; 
  else
    return YES;
}

BOOL flagged(int i)
{
  if ((i | FIELD_FLAGGED) != i)
    return NO; 
  else
    return YES;
}

static int didSeed = 0;

int intRandom(int upper)
{
  float d;
  if (!didSeed) {
    srandom(time(NULL) * getpid());
    didSeed = 1;
  }
  d  =  0xFFFFFFFF / (2 * upper);
  return random() / d;
}
