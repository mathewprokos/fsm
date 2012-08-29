#include <string.h>
#include <stdio.h>
#include "commands.h"

int cs;

%%{
  machine tier0;
  import "commands.h";

  action on_beacon { printf("BEACON\n"); }
  action on_tag { printf("TAG\n"); }
  action on_open { printf("OPEN\n"); }
  action on_closed { printf("CLOSED\n"); }
  action on_double_tag { printf("DOUBLE TAG\n"); }
  action on_tier0 { printf("TEIR 0\n"); }

main :=
          start:
          tier0: (
                  SECONDS_10 @on_tier0 -> tier0 |
                  (BEACON+ GREEN_TAG) @on_open -> open_from_tier0 |
                  DOUBLE_GREEN_TAG @on_open -> open_from_tier0),
          open_from_tier0: (
                 JOIN_MESSAGE @on_open -> open_from_tier0 |
                 DOUBLE_GREEN_TAG @on_closed -> closed |
                 CLOSE_MESSAGE @on_closed -> closed |
                 HOURS_2 @on_tier0 -> tier0),
          open_from_closed: (
                 JOIN_MESSAGE @on_open -> open_from_closed |
                 DOUBLE_GREEN_TAG @on_closed -> closed |
                 CLOSE_MESSAGE @on_closed -> closed |
                 HOURS_2 @on_closed -> closed),
          closed: (
                   OPEN_MESSAGE @on_open -> open_from_closed |
                   (LONG_BUTTON_PRESS GREEN_TAG) @on_open -> open_from_closed);

  write data;
}%%


void init() {
  %% write init;
}

void run(const char data, int isEof) {
  const char *p = &data;
  const char *pe = &data+1;
  const char *eof = isEof == 1 ? pe : 0;
  %% write exec;
}

int main(){
  init();
  run(DOUBLE_GREEN_TAG, 0); //transition to open
  run(HOURS_2, 0); //transition back to teir0
  run(DOUBLE_GREEN_TAG, 0); //transition to open
  run(DOUBLE_GREEN_TAG, 0); //transition to closed
  run(LONG_BUTTON_PRESS, 0); 
  run(GREEN_TAG, 0); //transition to open
  run(HOURS_2, 0); //transition back to closed

  return 0;
}
