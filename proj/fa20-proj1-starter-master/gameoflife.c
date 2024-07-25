/************************************************************************
**
** NAME:        gameoflife.c
**
** DESCRIPTION: CS61C Fall 2020 Project 1
**
** AUTHOR:      Justin Yokota - Starter Code
**				YOUR NAME HERE
**
**
** DATE:        2020-08-23
**
**************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include "imageloader.h"
#define BYTELEN 8



int getbitlocation(uint8_t a, int n)
{
	return (a >> n) & 01;
}


//Determines what color the cell at the given row/col should be. This function allocates space for a new Color.
//Note that you will need to read the eight neighbors of the cell in question. The grid "wraps", so we treat the top row as adjacent to the bottom row
//and the left column as adjacent to the right column.
Color *evaluateOneCell(Image *image, int row, int col, uint32_t rule)
{
	//YOUR CODE HERE
	// iterate the 8 nearby element
		// record the number of 24 bit in 24 different bit space
	// perform the rule to 24 bits plane
	int x, y, k, modif_x, modif_y;
	uint8_t redbit[BYTELEN] = {0}, greenbit[BYTELEN] = {0}, bluebit[BYTELEN] = {0};

	Color *c = (Color *)malloc(sizeof(Color));
	c->R = c->G = c->B = 0;
	int rows = image->rows, cols = image->cols;

	for (x = -1; x <= 1; x++)
		for (y = -1; y <= 1; y++)
		{
			modif_x = row + x, modif_y = col + y;
			if (modif_x < 0) modif_x = rows - 1;
			if (modif_x > rows - 1) modif_x = 0;
			if (modif_y < 0) modif_y =  cols - 1;
			if (modif_y > cols - 1) modif_y = 0;
			if (modif_x == row && modif_y == col) continue;

			for (k = 0; k < BYTELEN; k++)
			{
				redbit[k] += getbitlocation(image->image[modif_x][modif_y].R, k);
				greenbit[k] += getbitlocation(image->image[modif_x][modif_y].G, k);
				bluebit[k] += getbitlocation(image->image[modif_x][modif_y].B, k);
			}
		}

	for (k = 0; k < BYTELEN; k++)
	{
		int red_move = 0, green_move = 0, blue_move = 0;

		if ((image->image[row][col].R >> k) & 01) red_move = 9;
		if ((image->image[row][col].G >> k) & 01) green_move = 9;
		if ((image->image[row][col].B >> k) & 01) blue_move = 9;
		c->R = c->R | ((((1 << (redbit[k] + red_move)) & rule) >> (redbit[k] + red_move)) << k);
		c->G = c->G | ((((1 << (greenbit[k] + green_move)) & rule) >> (greenbit[k] + green_move)) << k);
		c->B = c->B | ((((1 << (bluebit[k] + blue_move)) & rule) >> (bluebit[k] + blue_move)) << k);
	}
	
	return c;
}

//The main body of Life; given an image and a rule, computes one iteration of the Game of Life.
//You should be able to copy most of this from steganography.c
Image *life(Image *image, uint32_t rule)
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
			Color *c = evaluateOneCell(image, i, j, rule);
			img2->image[i][j] = *c;
			free(c);
		}
	}
	freeImage(image);
	return img2;
}

/*
Loads a .ppm from a file, computes the next iteration of the game of life, then prints to stdout the new image.

argc stores the number of arguments.
argv stores a list of arguments. Here is the expected input:
argv[0] will store the name of the program (this happens automatically).
argv[1] should contain a filename, containing a .ppm.
argv[2] should contain a hexadecimal number (such as 0x1808). Note that this will be a string.
You may find the function strtol useful for this conversion.
If the input is not correct, a malloc fails, or any other error occurs, you should exit with code -1.
Otherwise, you should return from main with code 0.
Make sure to free all memory before returning!

You may find it useful to copy the code from steganography.c, to start.
*/
int main(int argc, char **argv)
{
	//YOUR CODE HERE
	int rule;
	if (argc != 3 || (rule = strtol(argv[2], NULL, 16)) < 0x00000 || rule > 0x3FFFF) 
	{
		printf("usage: ./gameOfLife filename rule \n filename is an ASCII PPM file (type P3) with maximum value 255.\nrule is a hex number beginning with 0x; Life is 0x1808.");
		return -1;
	}

	Image *img = readData(argv[1]);
	if (img == NULL)
	{
		printf("incorrect format, please use the right format input;\n");
		return -1;
	}

	img = life(img, rule);
	writeData(img);
	freeImage(img);
	return 0;
}
