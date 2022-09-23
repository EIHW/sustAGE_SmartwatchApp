
from flask_sqlalchemy import SQLAlchemy
import os

# Instantiating sqlalchemy object
db = SQLAlchemy()  # Creating database class

class Garmin_User_Data(db.Model):
    __tablename__ = 'user_data'

    # Creating field/columns of the database as class variables
    id = db.Column(db.Integer, primary_key=True)

    device_id = db.Column(db.String(40), unique=False, nullable=False)

    timestamp = db.Column(db.Text, unique=False, nullable=True)

    heart_rate = db.Column(db.Text, unique=False, nullable=True)

    hrv = db.Column(db.Text, unique=False, nullable=True)

    steps = db.Column(db.Text, unique=False, nullable=True)

    accel_x = db.Column(db.Text, unique=False, nullable=True)
    accel_y = db.Column(db.Text, unique=False, nullable=True)
    accel_z = db.Column(db.Text, unique=False, nullable=True)

    def __init__(self, device_id, timestamp, heart_rate, hrv, steps, accel_x, accel_y, accel_z):

        self.device_id = device_id
        self.timestamp = str(timestamp)
        self.heart_rate = str(heart_rate)
        self.hrv = str(hrv)
        self.steps = str(steps)
        self.accel_x = str(accel_x)
        self.accel_y = str(accel_y)
        self.accel_z = str(accel_z)

    # Method to show data as dictionary object
    def json(self):
    
        return {'Device': self.device_id, 'Timestamp': self.timestamp, 'Heart Rate': self.heart_rate, 'HRV': self.hrv, 'Steps': self.steps, 'AccelX': self.accel_x, 'AccelY': self.accel_y, 'AccelZ': self.accel_z}

    # Method to find the query instance is existing or not
    @classmethod
    def find_by_user(cls, user):
        return cls.query.filter_by(user_id=user)  

    # Method to save data to database
    def save_to(self):
        db.session.add(self)
        db.session.commit()  

    # Method to delete data from database
    def delete_(self):
        db.session.delete(self)
        db.session.commit()
