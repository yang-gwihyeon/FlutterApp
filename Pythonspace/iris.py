from flask import Flask, jsonify, render_template, request
import joblib

app = Flask(__name__)

@app.route("/iris")
def iris():
    imgFileCode = request.args.get("imageFile")
    
#    clf = joblib.load("./rf_iris.h5")
#    pre = clf.predict([[sepalLengh,sepalWidth,petalLengh,petalWidth]])
#    print(pre)
    return jsonify({'result' : imgFileCode})

def home():
    return render_template("home.html")

if __name__ == "__main__":
    app.run(host = '192.168.150.83', port = 5000, debug= True)
