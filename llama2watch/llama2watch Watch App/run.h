//
//  run.h
//  llama2watch Watch App
//
//  Created by Tyler Kruer on 2/17/24.
//

#ifndef run_h
#define run_h

#include <stdio.h>

// Define a callback function type for output
typedef void (*OutputCallback)(const char *);
void setOutputCallback(OutputCallback callback);
int mainLlama(int argc, char *argv[]);

#endif /* run_h */
