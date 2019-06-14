from flask import Flask, request
import sys

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello!"

@app.route('/upload', methods = ['GET', 'POST'])
def saveImage():
    print(request.get_data(), file=sys.stderr)
    imfile = request.get_data()
    with open('image.jpg','wb') as f:
        f.write(imfile)
    return "Uploaded"
