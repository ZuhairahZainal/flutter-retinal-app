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

def calculate_tortuosity(image_path):
    image = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    binary = (image > 127).astype(np.uint8)
    skeleton = skeletonize(binary).astype(np.uint8)
    labeled = label(skeleton)
    regions = regionprops(labeled)

    tortuosities = []

    for region in regions:
        coords = region.coords
        if len(coords) < 10:
            continue
        arc_len = sum(np.linalg.norm(coords[i] - coords[i - 1]) for i in range(1, len(coords)))
        euclid_dist = euclidean(coords[0], coords[-1])
        if euclid_dist == 0:
            continue
        tort = arc_len / euclid_dist
        tortuosities.append(tort)

    return {
        "average_tortuosity": round(np.mean(tortuosities), 3) if tortuosities else 0,
        "max_tortuosity": round(np.max(tortuosities), 3) if tortuosities else 0,
        "num_vessels": len(tortuosities),
    }