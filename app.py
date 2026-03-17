from flask import Flask, jsonify
import boto3

app = Flask(__name__)

s3 = boto3.client('s3', region_name='eu-north-1')
BUCKET = 'flask-app-static-vladimir.vladov'

@app.route("/")
def index():
    obj = s3.get_object(Bucket=BUCKET, Key='index.html')
    html = obj['Body'].read().decode('utf-8')
    return html

@app.route("/api")
def api():
    return jsonify({"message": "Hello from Flask API on EC2! 🚀"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
