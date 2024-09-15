from flask import Flask, request, jsonify
import random
import smtplib
from email.mime.text import MIMEText

app = Flask(__name__)

otp_store = {}

# Function to generate a random OTP
def generate_otp():
    return random.randint(100000, 999999)

# Function to send OTP via email (you can adapt this for SMS if needed)
def send_otp_via_email(email, otp):
    sender_email = "your-email@gmail.com"
    sender_password = "your-email-password"
    
    msg = MIMEText(f"Your OTP code is {otp}")
    msg['Subject'] = 'Your OTP Code'
    msg['From'] = sender_email
    msg['To'] = email

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, email, msg.as_string())

# Route to generate and send OTP
@app.route('/send_otp', methods=['POST'])
def send_otp():
    data = request.json
    email = data.get('email')
    
    if email:
        otp = generate_otp()
        otp_store[email] = otp
        send_otp_via_email(email, otp)
        return jsonify({'message': 'OTP sent to your email!'}), 200
    return jsonify({'error': 'Email is required!'}), 400

# Route to verify the OTP
@app.route('/verify_otp', methods=['POST'])
def verify_otp():
    data = request.json
    email = data.get('email')
    otp = data.get('otp')
    
    if email in otp_store and otp_store[email] == int(otp):
        del otp_store[email]  # OTP used, delete it
        return jsonify({'message': 'OTP verified successfully!'}), 200
    return jsonify({'error': 'Invalid OTP!'}), 400

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
