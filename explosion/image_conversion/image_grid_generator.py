import os
import re
import cv2
import numpy as np
import math


def natural_sort_key(s):
	"""
	Sort strings that contain numbers in a natural way.
	For example: ['1.png', '10.png', '2.png'] -> ['1.png', '2.png', '10.png']
	"""
	return [int(text) if text.isdigit() else text.lower()
			for text in re.split(r'(\d+)', s)]


def extract_number(filename):
	"""
	Extract the first number found in the filename.
	If no number is found, return a very large number to sort it last.
	"""
	numbers = re.findall(r'\d+', filename)
	if numbers:
		return int(numbers[0])
	return float('inf')


def create_image_grid():
	# Get all image files in the current directory
	image_extensions = ['.png', '.jpg', '.jpeg', '.bmp', '.tiff', '.webp']
	image_files = [f for f in os.listdir('.') if os.path.isfile(f) and 
				  os.path.splitext(f)[1].lower() in image_extensions]
	
	if not image_files:
		print("No image files found in the current directory.")
		return
	
	# Sort images by the numbers they contain
	image_files.sort(key=extract_number)
	
	# Ask for the number of rows
	while True:
		try:
			rows = int(input("Enter the number of rows for the grid: "))
			if rows <= 0:
				print("Number of rows must be positive.")
				continue
			break
		except ValueError:
			print("Please enter a valid integer.")
	
	# Calculate the number of columns
	total_images = len(image_files)
	columns = math.ceil(total_images / rows)
	
	# Read the first image to get size and type information
	first_image = cv2.imread(image_files[0], cv2.IMREAD_UNCHANGED)
	if first_image is None:
		print(f"Error reading image: {image_files[0]}")
		return
	
	height, width = first_image.shape[:2]
	channels = 1 if len(first_image.shape) == 2 else first_image.shape[2]
	depth = first_image.dtype
	
	print(f"Image dimensions: {width}x{height}, Channels: {channels}, Type: {depth}")
	
	# Create the output grid image
	if channels == 1:
		# Grayscale image
		grid_image = np.zeros((height * rows, width * columns), dtype=depth)
	elif channels == 3:
		# RGB image
		grid_image = np.zeros((height * rows, width * columns, channels), dtype=depth)
	elif channels == 4:
		# RGBA image
		grid_image = np.zeros((height * rows, width * columns, channels), dtype=depth)
	else:
		print(f"Unsupported number of channels: {channels}")
		return
	
	# Fill the grid with images
	for index, img_file in enumerate(image_files):
		if index >= rows * columns:
			print(f"Warning: Only using {rows * columns} images out of {total_images}.")
			break
			
		# Calculate position in grid (row, column)
		row = index // columns
		col = index % columns
		
		# Read the image
		img = cv2.imread(img_file, cv2.IMREAD_UNCHANGED)
		
		# Skip if image couldn't be read
		if img is None:
			print(f"Error reading image: {img_file}")
			continue
			
		# Resize if necessary to match the first image
		if img.shape[:2] != (height, width):
			print(f"Resizing {img_file} to match the first image's dimensions")
			if channels == 1:
				img = cv2.resize(img, (width, height))
			else:
				img = cv2.resize(img, (width, height), interpolation=cv2.INTER_AREA)
		
		# Convert image type to match the first image if necessary
		if img.dtype != depth:
			print(f"Converting {img_file} to match the first image's depth")
			img = img.astype(depth)
		
		# Convert channels to match the first image if necessary
		if len(img.shape) < len(first_image.shape):
			# Convert grayscale to color
			img = cv2.cvtColor(img, cv2.COLOR_GRAY2BGR)
		elif len(img.shape) > len(first_image.shape):
			# Convert color to grayscale
			img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
		elif channels == 3 and img.shape[2] == 4:
			# Convert RGBA to RGB
			img = cv2.cvtColor(img, cv2.COLOR_RGBA2BGR)
		elif channels == 4 and img.shape[2] == 3:
			# Convert RGB to RGBA
			img = cv2.cvtColor(img, cv2.COLOR_BGR2BGRA)
		
		# Calculate position in pixels
		y_start = row * height
		y_end = (row + 1) * height
		x_start = col * width
		x_end = (col + 1) * width
		
		# Place image in the grid
		grid_image[y_start:y_end, x_start:x_end] = img
	
	# Save the grid image
	output_filename = "grid_image.png"
	cv2.imwrite(output_filename, grid_image)
	print(f"Grid image saved as '{output_filename}'")


if __name__ == "__main__":
	create_image_grid()
