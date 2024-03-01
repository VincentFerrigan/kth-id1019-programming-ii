import os
from PIL import Image

# Specify the directory containing the .ppm files
directory = os.getcwd()

for filename in os.listdir(directory):
    if filename.endswith('.ppm'):
        # Construct the full file path
        file_path = os.path.join(directory, filename)
        # Open the .ppm file
        image = Image.open(file_path)
        # Convert the filename to .png
        png_filename = os.path.splitext(file_path)[0] + '.png'
        # Save the image as a .png file
        image.save(png_filename)
        print(f'Converted {filename} to PNG format.')