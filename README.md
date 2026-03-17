# Flask App on AWS EC2 + S3

## Architecture
```
Internet → Nginx (port 80) → Flask (port 8080) → S3 (static files)
```

## Tech Stack
- **AWS EC2** - Ubuntu 22.04 server
- **AWS S3** - Static file storage
- **Flask** - Python web framework
- **Nginx** - Reverse proxy
- **boto3** - AWS SDK for Python
- **systemd** - Auto-start service

## Features
- Flask API endpoint
- Static files served from S3
- Nginx reverse proxy
- Auto-restart on reboot via systemd

## Setup
### 1. Clone repo
```bash
git clone git@github.com:Labeny/aws-ec2-flask-app.git
```

### 2. Install dependencies
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Configure AWS CLI
```bash
aws configure
```

### 4. Run
```bash
python3 app.py
```

## Author
Vladimir Vladov -  DevOps Engineer
