# USAGE
# python Video.py --input videos/airport.mp4 --output output/airport_output.avi --yolo yolo-coco

# import the necessary packages
import pickle
import numpy as np
import argparse
import imutils
import time
import cv2
import os
import requests
from PIL import Image
import torch.optim
import torch.nn.parallel
from torch.nn import functional as F
import threading
import models

activity = 'unknown'


def processFrames(frames,modelq,transform,categories,clientname,itemname):
    input = torch.stack([transform(frame) for frame in frames], 1).unsqueeze(0)

    # Make video predictionq
    with torch.no_grad():
        logits = modelq(input)
        h_x = F.softmax(logits, 1).mean(dim=0)
        probs, idx = h_x.sort(0, True)
    # Output the prediction.
    # print(str(probs[0])+'->'+ str(categories[idx[0]]))
    global activity
    activity = str(categories[idx[0]])
    if activity == 'picking' and clientname!=None and itemname!=None :
        activityJson = {'clientName': clientname, 'itemName': itemname}
        activityResponse = requests.get('http://localhost/Vodafone/system/addToCart', params=activityJson)
        print(activityResponse.text)


class myThread2 (threading.Thread):
   def __init__(self):
       threading.Thread.__init__(self)
   def setFrames(self, frames, modelq, transform, categories, clientname=None, itemname=None):
       self.frames=frames
       self.transform = transform
       self.categories = categories
       self.model = modelq
       self.clientname=clientname
       self.itemname=itemname
   def run(self):
       processFrames(self.frames,self.model,self.transform,self.categories,self.clientname,self.itemname)

stopba2olk=False;
def stop():
    global stopba2olk
    stopba2olk=True
def start():
    global stopba2olk
    stopba2olk=False
def captureFrames():
    yolox="yolo-coco"
    confidencex=0.5
    threshholdx=0.3

    num_segments = 16
    archx = 'resnet3d50'
    modelq = models.load_model(archx)
    categories = models.load_categories('category_momentsv2.txt')

    # Load the video frame transform
    transform = models.load_transform()
    frames = []

    # load the COCO class labels our YOLO model was trained on
    labelsPath = os.path.sep.join([yolox, "coco.names"])
    LABELS = open(labelsPath).read().strip().split("\n")
    thread = myThread2()
    adspositionx = 150
    adspositiony = 150
    adspositionHeight = 450
    adspositionWidth = 450
    # initialize a list of colors to represent each possible class label
    np.random.seed(42)
    COLORS = np.random.randint(0, 255, size=(len(LABELS), 3),
        dtype="uint8")

    # derive the paths to the YOLO weights and model configuration
    weightsPath = os.path.sep.join([yolox, "yolov3.weights"])
    configPath = os.path.sep.join([yolox, "yolov3.cfg"])

    # load our YOLO object detector trained on COCO dataset (80 classes)
    # and determine only the *output* layer names that we need from YOLO
    print("[INFO] loading YOLO from disk...")
    net = cv2.dnn.readNetFromDarknet(configPath, weightsPath)
    ln = net.getLayerNames()
    ln = [ln[i[0] - 1] for i in net.getUnconnectedOutLayers()]

    # initialize the video stream, pointer to output video file, and
    # frame dimensions
    writer = None
    (W, H) = (None, None)
    embeddingModel = "openface_nn4.small2.v1.t7"

    embeddingFile = "output/embeddings.pickle"
    recognizerFile = "output/recognizer.pickle"
    labelEncFile = "output/le.pickle"
    conf = 0.5

    print("Loading face embedding....")
    prototxt = "model/deploy.prototxt"
    model = "model/res10_300x300_ssd_iter_140000.caffemodel"
    detector = cv2.dnn.readNetFromCaffe(prototxt, model)

    print("Loading face recognizer......")
    embedder = cv2.dnn.readNetFromTorch(embeddingModel)

    recognizer = pickle.loads(open(recognizerFile, "rb").read())
    le = pickle.loads(open(labelEncFile, "rb").read())

    box2 = []
    vs = cv2.VideoCapture(1)
    print("Starting video stream........")
    mobileDetected=False
    time.sleep(2.0)
    global stopba2olk
    clientname=None
    itemname=None
    while not stopba2olk:

        # read the next frame from the file
        (grabbed, frame) = vs.read()

        # if the frame was not grabbed, then we have reached the end
        # of the stream
        if not grabbed:
            break

        framex = frame
        frameImage = Image.fromarray(frame)
        frames.append(frameImage)
        if len(frames) % 10 == 0:
            if not thread.is_alive():


                del thread
                thread = myThread2()
                print(itemname)
                print(clientname)
                thread.setFrames(frames,modelq,transform,categories,clientname,itemname)
                thread.start()
                print('Thread 1 started')
            else:
                print('all alive')
            del frames
            frames = []
        cv2.putText(framex, activity, (50, 50),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.45, (0, 255, 0))
        # if the frame dimensions are empty, grab themcd
        if W is None or H is None:
            (H, W) = frame.shape[:2]

        # construct a blob from the input frame and then perform a forward
        # pass of the YOLO object detector, giving us our bounding boxes
        # and associated probabilities
        blob = cv2.dnn.blobFromImage(frame, 1 / 255.0, (416, 416),
            swapRB=True, crop=False)
        net.setInput(blob)
        start = time.time()
        layerOutputs = net.forward(ln)
        end = time.time()

        # initialize our lists of detected bounding boxes, confidences,
        # and class IDs, respectively
        boxes = []
        confidences = []
        classIDs = []
        # boxes.append([10,10, 20, 20])

        # loop over each of the layer outputs
        for output in layerOutputs:
            # loop over each of the detections
            for detection in output:
                # extract the class ID and confidence (i.e., probability)
                # of the current object detection
                scores = detection[5:]
                classID = np.argmax(scores)
                confidence = scores[classID]

                # filter out weak predictions by ensuring the detected
                # probability is greater than the minimum probability
                if confidence >confidencex:
                    if  classID==67 or classID==39 or classID==41 or classID==64 or classID==63:
                        # scale the bounding box coordinates back relative to
                        # the size of the image, keeping in mind that YOLO
                        # actually returns the center (x, y)-coordinates of
                        # the bounding box followed by the boxes' width and
                        # height
                        box = detection[0:4] * np.array([W, H, W, H])
                        (centerX, centerY, width, height) = box.astype("int")

                        # use the center (x, y)-coordinates to derive the top
                        # and and left corner of the bounding box
                        x = int(centerX - (width / 2))
                        y = int(centerY - (height / 2))

                        # update our list of bounding box coordinates,
                        # confidences, and class IDs

                        boxes.append([x, y, int(width), int(height)])
                        confidences.append(float(confidence))

                        classIDs.append(classID)

        # apply non-maxima suppression to suppress weak, overlapping
        # bounding boxes
        idxs = cv2.dnn.NMSBoxes(boxes, confidences, confidencex,
            threshholdx)
        # cv2.rectangle(frame, (adspositionx, adspositiony), ( adspositionWidth,adspositionHeight), (255,255,255), 2)
        frame = imutils.resize(frame, width=600)
        (h, w) = frame.shape[:2]
        imageBlob = cv2.dnn.blobFromImage(
            cv2.resize(frame, (300, 300)), 1.0, (300, 300), (104.0, 177.0, 123.0))

        detector.setInput(imageBlob)
        detections = detector.forward()

        for i in range(0, detections.shape[2]):
            confidence = detections[0, 0, i, 2]

            if confidence > conf:
                box = detections[0, 0, i, 3:7] * np.array([w, h, w, h])
                (startX, startY, endX, endY) = box.astype("int")
                face = frame[startY:endY, startX:endX]
                (fH, fW) = face.shape[:2]

                if fW < 20 or fH < 20:
                    continue

                faceBlob = cv2.dnn.blobFromImage(face, 1.0 / 255, (96, 96), (64.0, 107.0, 83.0))
                embedder.setInput(faceBlob)
                vec = embedder.forward()
                preds = recognizer.predict_proba(vec)[0]
                j = np.argmax(preds)
                proba = preds[j]
                name = le.classes_[j]
                if proba > 0.8:
                    text = "{} : {:.2f}%".format(name, proba * 100)
                    clientname=name
                    pload = {'name': name}
                    res = requests.get('http://localhost/Vodafone/system/recognize', params=pload)
                else:
                    clientname=None
                    # createDataset()
                    text = 'unknown_' + str(i)
                y = startY - 10 if startY - 10 > 10 else startY + 10
                cv2.rectangle(frame, (startX, startY), (endX, endY), (0, 0, 255), 2)
                cv2.putText(frame, text, (startX, y),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.45, (0, 255, 0))
                if adspositionx < startX and adspositiony < startY:
                    if startX + fW < adspositionx + adspositionWidth \
                            and startY + fH < adspositiony + adspositionHeight:
                        if mobileDetected :
                            pload2 = {'name': name,'itemType':'Mobiles'}
                            res2 = requests.get('http://localhost/Vodafone/system/adddisplayAds', params=pload2)
                            print(res2.text)
                            mobileDetected=False

                    else:
                        print('Some part of the box is outside the bounding box.')
                pload = {'name': name}
                res = requests.get('http://localhost/Vodafone/system/recognize', params=pload)
        # ensure at least one detection exists
        if len(idxs) > 0:
            # loop over the indexes we are keeping
            for i in idxs.flatten():
                # extract the bounding box coordinates
                (x, y) = (boxes[i][0], boxes[i][1])
                (w, h) = (boxes[i][2], boxes[i][3])

                # draw a bounding box rectangle and label on the frame
                color = [int(c) for c in COLORS[classIDs[i]]]
                cv2.rectangle(frame, (x, y), (x + w, y + h), color, 2)
                # if LABELS[classIDs[i]]=="cell phone":
                    # mobileDetected=True
                itemname=LABELS[classIDs[i]]
                cv2.putText(frame, LABELS[classIDs[i]], (x, y - 5), cv2.FONT_HERSHEY_SIMPLEX,
                                0.5, color, 2)
                    # pload = {'class': LABELS[classIDs[i]]}
                    # r = requests.get('http://localhost/Vodafone/home/queue', params=pload)
                    # print(r.status_code)
                    # print(r.text)

        # check if the video writer is None

        cv2.imshow("Frame", frame)
        key = cv2.waitKey(1) & 0xFF
    vs.release()

    # release the file pointers
    print("[INFO] cleaning up...")



# start()
# captureFrames()
