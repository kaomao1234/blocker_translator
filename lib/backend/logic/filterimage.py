from PIL import Image, ImageFilter


#Import all the enhancement filter from pillow
from PIL.ImageFilter import (
   BLUR, CONTOUR, DETAIL, EDGE_ENHANCE, EDGE_ENHANCE_MORE,
   EMBOSS, FIND_EDGES, SMOOTH, SMOOTH_MORE, SHARPEN
)
#Create image object
img = Image.open('logic/capture.png')
#Applying the blur filter
img1 = img.filter(DETAIL)
img1.save('ImageFilter_blur.png')
img1.show()