from flask import Flask, request, jsonify # flutter 는 반드시 json 으로 넘겨주기
from werkzeug.utils import secure_filename
import os
from PIL import Image
import numpy as np
import tensorflow as tf

import joblib
import cv2

app = Flask(__name__)

@app.route('/uploader',methods = ['GET','POST'])
def uploader():
    f = request.files['image'] # 앱쪽은 image 라고 변수 이름을 준다.
    os.chdir("./images")
    f.save(secure_filename(f.filename))
    # ---------------
    os.chdir("..")

    # TFLite model을 읽어와서 tensor에 할당하기

    interpreter = tf.lite.Interpreter(model_path='./best-cnn-model.tflite')
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    os.chdir("./images")
    path = f.filename
    img = np.array(Image.open(path))
    img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    img = cv2.resize(img,(400,400))
    ret, img = cv2.threshold(img,100,255,cv2.THRESH_TOZERO)
    tmp_mean = img[img > 0].mean() 
    img = (img / tmp_mean) * 150 / 255.0
    os.chdir('..')
    input_data = img.reshape(1,400,400,1)
    input_data = input_data.astype(np.float32)

    interpreter.set_tensor(input_details[0]['index'],input_data.reshape(1,400,400,1))
    interpreter.invoke()

    output_data = interpreter.get_tensor(output_details[0]['index'])
    
    answers = np.arange(10).astype(np.object0)

    
    return jsonify({'result': answers[np.argmax(output_data[0])]})

if __name__ == '__main__':
    app.run(host = '127.0.0.1', port= 5000, debug= True)
    
