from cv2 import cv2 as cv
import numpy as np
import os

file_list = []
for i in range(10000):
    file_name = os.path.join(r'./seq/','img_' + str(i+1) + '.png')
    file_list.append(file_name)

first = cv.imread(file_list[0])

j = 0

while j < len(file_list):
    avg = np.zeros((len(first),len(first[0])), dtype=np.int)
    print(j)
    for i in range(400):
        file = file_list[j]
        img=cv.imread(file,cv.IMREAD_GRAYSCALE)
        avg = avg + img
        j += 1

    avg = avg/400
    cv.imwrite(r'./seq_avg/'+'img_'+str(int(j/400))+'.png', avg)
