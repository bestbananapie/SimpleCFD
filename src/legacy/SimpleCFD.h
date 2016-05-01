#ifndef SIMPLECFD_H
#define SIMPLECFD_H

#include "options.h"

typedef struct {
  double u[X_POINTS][Y_POINTS][Z_POINTS];
  double v[X_POINTS][Y_POINTS][Z_POINTS];
  double w[X_POINTS][Y_POINTS][Z_POINTS];
  double p[X_POINTS][Y_POINTS][Z_POINTS];
} fieldStruct;

typedef struct {
  double dx;
  double dy;
  double dz;
  double dt;
} meshStruct;

#endif
