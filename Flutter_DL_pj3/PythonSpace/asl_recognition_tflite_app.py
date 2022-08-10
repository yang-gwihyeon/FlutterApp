from flask import Flask, request, jsonify # flutter 는 반드시 json 으로 넘겨주기
from werkzeug.utils import secure_filename
import os
from PIL import Image
import numpy as np
import tensorflow as tf
import requests
from datetime import datetime
from pytimekr import pytimekr
import pandas as pd
import math

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

    interpreter = tf.lite.Interpreter(model_path='./best_gray_cnn_number_model.tflite')
    interpreter.allocate_tensors()
    
    input_details = interpreter.get_input_details()
    output_details = interpreter.get_output_details()

    os.chdir("./images")
    path = f.filename
    img = np.array(Image.open(path))
    img = cv2.cvtColor(img, cv2.COLOR_RGB2GRAY)
    img = cv2.resize(img,(36,36))
    ret, img = cv2.threshold(img,100,255,cv2.THRESH_TOZERO)
    tmp_mean = img[img > 0].mean() 
    img = (img / tmp_mean) * 150 / 255.0
    os.chdir('..')
    input_data = img.reshape(1,36,36,1)
    input_data = input_data.astype(np.float32)

    interpreter.set_tensor(input_details[0]['index'],input_data.reshape(1,36,36,1))
    interpreter.invoke()

    output_data = interpreter.get_tensor(output_details[0]['index'])
    
    answers = np.arange(10).astype(np.object0)

    
    return jsonify({'result': answers[np.argmax(output_data[0])]})

@app.route('/dri',methods = ['GET','POST'])
def dri():
    date = request.args.get('date', default = '-1', type = str)
    today = request.args.get('today', default = '-10', type = str)
    
    today_day = today.split()[0].replace('-','')
    today_time = today.split()[1].replace(':','')
    date_day = date.split()[0].replace('-','')
    date_time = date.split()[1].replace(':','')
    
    holiday = 0
    
    
    rentaltime = int(date_time[:2])
    


    day1= datetime(2020,7,1,00,00,00,0)
    day2= datetime(int(date_day[:4]),int(date_day[4:6]),int(date_day[6:]),int(date_time[:2]),00,00,0)
    delta = (day2-day1).days *24 + (day2-day1).seconds // 3600
    
    lin_scaled = delta * 0.01727456  / (495.45979971092436 - 199.77118521722153)
    
    for x_date in  pytimekr.holidays(year=int(date_day[:4])):
        if(str(x_date) == (date_day[:4] + '-'+ date_day[4:6] + '-' + date_day[6:])):
            holiday = 1
            
    if pd.to_datetime(date_day[:4] + '-'+ date_day[4:6] + '-' + date_day[6:]).weekday() in [5,6]:
        holiday = 1

        
    if date_day[4:6] in ['07','08','06']:
        season = [0,1,0,0]
    elif date_day[4:6] in ['09','10','11']:
        season = [0,0,1,0]
    elif date_day[4:6] in ['12','01','02']:
        season = [1,0,0,0]
    else:
        season = [0,0,0,1]
    
    
    temp,pcp,wsd,vec,reh = get_weather(today,date)
    
#     38.1 -17.5
# 100 17
# 41.5 0.0
    if pcp == '강수없음':
        pcp = '0'
    temp_scaled = (float(temp) + 17.5)/(38.1 + 17.5)
    reh_scaled = (float(reh) - 17) / (83)
    pcp_scaled = (float(pcp))/41.5
    
    input = [rentaltime,lin_scaled, holiday,temp_scaled,reh_scaled,pcp_scaled] + season
     
    
    model = joblib.load("./lgbm_dri.h5")
    
    print('***********!@#!@',model.predict([input])[0] )
    
    return jsonify({'result': round(model.predict([input])[0]) })
    

def get_weather(today,date):
    today_day = today.split()[0].replace('-','')
    today_time = today.split()[1].replace(':','')
    date_day = date.split()[0].replace('-','')
    date_time = date.split()[1].replace(':','')
    
    temp = ''
    pcp = ''
    wsd = ''
    vec = ''
    reh = ''
    

    apikey = '3kBMQo1vri3CU+lAk+Q0d5mIuSYJGMnuXo1+Q2T3WhfM5O+bgtU5RHXNDdrLxndWkLln0vjJH9qiusisiZqonQ=='
    url = 'http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst'

    if int(today_time[:2]) % 3 !=  2:
        if int(today_time[:2]) < 2:
            today = datetime(int(today_day[:4]),int(today_day[4:6]),int(today_day[6:]), int(today_time[:2],00,00,0 ) + timedelta(hours=(-int(today_time[:2])-1)))
            today_day = today.split()[0].replace('-','')
            today_time = today.split()[1].replace(':','')
        else:
            today = datetime(int(today_day[:4]),int(today_day[4:6]),int(today_day[6:]), int(today_time[:2],00,00,0 ) + timedelta(hours=(-(int(today_time[:2])%3)-1)))
            today_day = today.split()[0].replace('-','')
            today_time = today.split()[1].replace(':','')
    print(today_day, today_time)
            
    
    params ={'serviceKey' : apikey, 'pageNo' : '1', 'numOfRows' : '1000', 'dataType' : 'JSON', 'base_date' : today_day, 'base_time' : today_time, 'nx' : '55', 'ny' : '127' }

    response = requests.get(url, params=params)

    tmp= response.json()['response']['body']['items']['item']
    print(today_day, today_time)
    tmp_list = []
    for i in range(len(tmp)):
        if((date_day  in tmp[i].values()) & (date_time in tmp[i].values())):
            tmp_list.append(list(tmp[i].values()))

    for i in range(len(tmp_list)):
        if ('TMP' in tmp_list[i]):
            temp = (tmp_list[i][5])
        elif ('PCP' in tmp_list[i]):
            pcp = (tmp_list[i][5])
        elif ('WSD' in tmp_list[i]):
            wsd = (tmp_list[i][5])
        elif ('VEC' in tmp_list[i]):
            vec = (tmp_list[i][5])
        elif ('REH' in tmp_list[i]):
            reh = (tmp_list[i][5])

    return temp,pcp,wsd,vec,reh
    



if __name__ == '__main__':
    app.run(host = '127.0.0.1', port= 5000, debug= True)
    
