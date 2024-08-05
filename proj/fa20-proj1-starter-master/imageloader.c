/************************************************************************
**
** NAME:        imageloader.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Dan Garcia  -  University of California at Berkeley
**              Copyright (C) Dan Garcia, 2020. All rights reserved.
**              Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-15
**
**************************************************************************/

#include "imageloader.h"

//Opens a .ppm P3 image file, and constructs an Image object. 
//You may find the function fscanf useful.
//Make sure that you close the file with fclose before returning.
Image *readData(char *filename) 
{
	//YOUR CODE HERE
	FILE *fp = fopen(filename, "r");
	if (fp == NULL) 
	{
		printf("usage: ./gameOfLife filename rule\nfilename is an ASCII PPM file (type P3) with maximum value 255.\n rule is a hex number beginning with 0x; Life is 0x1808.");
		return NULL;
	}
	int rows, cols;
	fscanf(fp, "P3\n%d %d\n255\n", &cols, &rows);
	Image *img = (Image *)malloc(sizeof(Image));
	img->rows = rows;
	img->cols = cols;
	img->image = (Color **)malloc(sizeof(Color *) * rows);

	int red, green, blue, i, j;

	for (i = 0; i < rows; ++i)
	{
		img->image[i] = (Color *)malloc(sizeof(Color) * cols);
		for (j = 0; j < cols; ++j)
		{
			if (j != cols - 1)
				fscanf(fp, "%3d %3d %3d   ", &red, &green, &blue);
			else
				fscanf(fp, "%3d %3d %3d\n", &red, &green, &blue);
			img->image[i][j].R = red;
			img->image[i][j].G = green;
			img->image[i][j].B = blue;
		}
	}
	fclose(fp);
	return img; // make sure no statemnt after return
}

//Given an image, prints to stdout (e.g. with printf) a .ppm P3 file with the image's data.
void writeData(Image *image)
{
	//YOUR CODE HERE
	printf("P3\n%d %d\n255\n", image->cols, image->rows);

	int i, j;
	int rows = image->rows, cols = image->cols;

	for (i = 0; i < rows; ++i)
		for (j = 0; j < cols; ++j)
		{
			if (j != cols - 1)
				printf("%3d %3d %3d   ", image->image[i][j].R,image->image[i][j].G,image->image[i][j].B);
			else
				printf("%3d %3d %3d\n", image->image[i][j].R,image->image[i][j].G,image->image[i][j].B);
		}	
}

//Frees an image
void freeImage(Image *image)
{
	//YOUR CODE HERE
	int rows = image->rows;
	for (int i = 0; i < rows; i++)
			free(image->image[i]);
	free(image->image);
	free(image);
}