from base64 import encodebytes
from flask import Flask, request, jsonify, make_response,send_file
from werkzeug.serving import WSGIRequestHandler
from datasetCreation import createDatasetFolder
from preprocessingEmbedding import preprocess
from trainingFaceML import training
import Video
import threading
# class StoppableThread(threading.Thread):
#     """Thread class with a stop() method. The thread itself has to check
#     regularly for the stopped() condition."""
#
#     def __init__(self,  *args, **kwargs):
#         super(StoppableThread, self).__init__(*args, **kwargs)
#         self._stop_event = threading.Event()
#
#     def stop(self):
#         self._stop_event.set()
#
#     def stopped(self):
#         return self._stop_event.is_set()
#
#     def run(self):
#         Video.captureFrames()
class myThread2 (threading.Thread):
   def __init__(self):
      threading.Thread.__init__(self)
   def stop(self):
       Video.stop()
   def run(self):
       Video.captureFrames()
Thread2 = myThread2()
# Thread2 = StoppableThread()
WSGIRequestHandler.protocol_version = "HTTP/1.1"
app = Flask(__name__)
isDatasetCreated=False
app.config['FLASK_ENV'] = 'development'
import io
from PIL import Image
@app.route('/captureFrames', methods=['POST'])
def captureFrame():
    if not request.json:
        return "not found", 400
    else:
        global Thread2
        if 'start' in request.json:

           Video.start()
           Thread2.start()
           return jsonify({'status':'started'})
        elif 'stop' in request.json:
            Video.stop()
            Thread2 = myThread2()
            return jsonify({'status': 'stopped'})

@app.route('/createDataset', methods=['POST'])
def createDataset():
    if not request.json:
        return "not found", 400
    else:
        if 'name' in request.json:

            name = request.json['name']
            createDatasetFolder(name)
            Thread = myThread()
            Thread.start()
            filePath='dataset/'+name+'/'
            result = [filePath+'00000.png',filePath+'00019.png',filePath+'00039.png',
                          filePath+'00059.png',filePath+'00079.png',filePath+'00099.png',
                          filePath+'00119.png',filePath+'00139.png',filePath+'00159.png',
                          filePath+'00179.png']
            encoded_imges = []
            for image_path in result:
             encoded_imges.append(get_response_image(image_path))
            return jsonify({'result': encoded_imges,'status':'done'})


def get_response_image(image_path):
    pil_img = Image.open(image_path, mode='r') # reads the PIL image
    byte_arr = io.BytesIO()
    pil_img.save(byte_arr, format='PNG') # convert the PIL image to byte array
    encoded_img = encodebytes(byte_arr.getvalue()).decode('ascii') # encode as base64
    return encoded_img

class myThread (threading.Thread):
   def __init__(self):
      threading.Thread.__init__(self)

   def run(self):
       preprocess()
       training()
       print('done')



