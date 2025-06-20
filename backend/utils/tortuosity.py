import cv2
import numpy as np
from skimage.morphology import skeletonize
from skimage.measure import label, regionprops
from scipy.spatial.distance import euclidean

def compute_tortuosity(image_bytes):
    import io
    from PIL import Image

    image = Image.open(io.BytesIO(image_bytes)).convert("L")
    img = np.array(image)
    binary = (img > 127).astype(np.uint8)
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

    avg_tort = np.mean(tortuosities) if tortuosities else 0
    max_tort = np.max(tortuosities) if tortuosities else 0
    return round(avg_tort, 3), round(max_tort, 3), len(tortuosities)