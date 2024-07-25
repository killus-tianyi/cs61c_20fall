/************************************************************************
**
** NAME:        steganography.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**				Justin Yokota - Starter Code
**				YOUR NAME HERE
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"

//Determines what color the cell at the given row/col should be. This should not affect Image, and should allocate space for a new Color.
Color *evaluateOnePixel(Image *image, int row, int col)
{
	//YOUR CODE HERE
	int blue = image->image[row][col].B;
	int blue_LSB = blue & 01;

	Color *c = (Color *)malloc(sizeof(Color));
	c->R = c->G = c->B = blue_LSB * 255;
	return c;
}

//Given an image, creates a new image extracting the LSB of the B channel.
Image *steganography(Image *image)
{
	//YOUR CODE HERE
	int rows = image->rows, cols = image->cols, i, j;
	Image *img2 = (Image *)malloc(sizeof(Image));
	img2->rows = rows;
	img2->cols = cols;
	img2->image = (Color **)malloc(sizeof(Color *) * rows);
	

	for (i = 0; i < rows; ++i)
	{
		img2->image[i] = (Color *)malloc(sizeof(Color) * cols);
		for (j = 0; j < cols; ++j)
		{
			Color *c = evaluateOnePixel(image, i, j);
			img2->image[i][j] = *c;
			free(c);
		}
	}
	freeImage(image);
	return img2;
}

/*
Loads a file of ppm P3 format from a file, and prints to stdout (e.g. with printf) a new image, 
where each pixel is black if the LSB of the B channel is 0, 
and white if the LSB of the B channel is 1.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a file of ppm P3 format (not necessarily with .ppm file extension).
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	Image *img = readData(argv[1]);
	img = steganography(img);
	writeData(img);
	freeImage(img);
}
