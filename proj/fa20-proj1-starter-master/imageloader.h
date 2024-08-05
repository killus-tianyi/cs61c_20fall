#ifndef IMAGELOADER_H
#define IMAGELOADER_H

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <string.h>

typedef struct Color 
{
    uint8_t R;
    uint8_t G;
    uint8_t B;
} Color;

typedef struct Image
{
    Color **image;
    uint32_t rows;
    uint32_t cols;
} Image;

Image *readData(char *filename);
void writeData(Image *image);
void freeImage(Image *image);

#endif // IMAGELOADER_H
