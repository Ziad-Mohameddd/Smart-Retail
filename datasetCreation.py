import imutils
import time
import cv2
import csv
import os
def createDatasetFolder(name):
    cascade = 'haarcascade_frontalface_default.xml'
    detector = cv2.CascadeClassifier(cascade)
    dataset = 'dataset'
    sub_data = name
    path = dataset+'/'+sub_data
    if not os.path.isdir(path):
        os.mkdir(path)
    info = [str(name)]
    with open('student.csv','a') as csvFile:
        write = csv.writer(csvFile)
        write.writerow(info)
    csvFile.close()

    cam = cv2.VideoCapture(0)
    time.sleep(2.0)
    total = 0

    while total < 200:
        _, frame = cam.read()
        img = frame
        img = imutils.resize(frame, width=400)
        rects = detector.detectMultiScale(
            cv2.cvtColor(img, cv2.COLOR_BGR2GRAY), scaleFactor=1.1,
            minNeighbors=5, minSize=(30,30))
        for (x, y, w, h) in rects:
            cv2.rectangle(frame, (x, y), (x+w, y+h), (0,255,0),2)
            p = os.path.sep.join([path, "{}.png".format(
                str(total).zfill(5))])
            cv2.imwrite(p, img)
            total += 1

    cam.release()
    cv2.destroyAllWindows()

