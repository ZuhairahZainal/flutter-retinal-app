#This code displays vessels reduced to 1 pixel lines and calculates tortuosity 
#first run the following program to extract vessels from a retinal image:

#https://github.com/orobix/retina-unet/blob/master/Readme.md

import cv2
import numpy as np
from skimage.morphology import skeletonize
from skimage.measure import label, regionprops
from scipy.spatial.distance import euclidean
from scipy.ndimage import distance_transform_edt
import matplotlib.pyplot as plt

# Load and preprocess image
image = cv2.imread("Screenshot 2025-06-16 at 2.50.39 PM.png", cv2.IMREAD_GRAYSCALE)
binary = (image > 127).astype(np.uint8)

# Skeletonize
skeleton = skeletonize(binary).astype(np.uint8)

# Label connected components
labeled = label(skeleton)
regions = regionprops(labeled)

tortuosities = []

for region in regions:
    coords = region.coords
    if len(coords) < 10:
        continue  # skip small noise

    # Compute arc length
    arc_len = 0
    for i in range(1, len(coords)):
        arc_len += np.linalg.norm(coords[i] - coords[i - 1])

    # Compute Euclidean distance
    euclid_dist = euclidean(coords[0], coords[-1])
    if euclid_dist == 0:
        continue

    tort = arc_len / euclid_dist
    tortuosities.append(tort)

# Output
print(f"Average Tortuosity: {np.mean(tortuosities):.3f}")
print(f"Max Tortuosity: {np.max(tortuosities):.3f}")
print(f"Number of vessels analyzed: {len(tortuosities)}")

# Optional: visualize skeleton
plt.imshow(skeleton, cmap='gray')
plt.title('Skeletonized Vessels')
plt.axis('off')
plt.show()
