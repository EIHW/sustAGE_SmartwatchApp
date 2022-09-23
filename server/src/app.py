## Import necessary packages
from flask import Flask, request, send_file, after_this_request, make_response
from flask_restful import Resource, reqparse, Api  # Instantiate a flask object
import os
import time
import pdb

app = Flask(__name__)
# Instantiate Api object
api = Api(app)
# Setting the location for the sqlite database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///base.db'
# Adding the configurations for the database
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['PROPAGATE_EXCEPTIONS'] = True  

# Import necessary classes from base.py
from base import Garmin_User_Data, db

# Link the app object to the database
db.init_app(app)
app.app_context().push()
# Create the databases
db.create_all()  # Creating a class to create get, post, put & delete methods


class Data_list(Resource):
    # Instantiating a parser object to hold data from message payload
    parser = reqparse.RequestParser()
    parser.add_argument('D', type=str, required=True, help='Device ID')
    parser.add_argument('T', action='append', required=True, help="Timestamp")
    parser.add_argument('H', action='append', required=True, help='Heart Rate')
    parser.add_argument('V', action='append', required=True, help='HRV')
    parser.add_argument('S', action='append', required=True, help='Steps')
    parser.add_argument('X', action='append', required=True, help='Acceleration X')
    parser.add_argument('Y', action='append', required=True, help='Acceleration Y')
    parser.add_argument('Z', action='append', required=True, help='Acceleration Z')

    # Creating the get method
    def get(self):
        return {'Message': 'Nothing to return'}

    # Creating the post method
    def post(self):

        args = Data_list.parser.parse_args()

        item = Garmin_User_Data(args['D'], args['T'], args['H'], args['V'], args['S'], args['X'], args['Y'], args['Z']) 
        
        item.save_to()
        return {'Message': 'OK'}, 200

    def delete(self):
        return {'Message': 'Not implemented'}, 404


# Creating a class to get all the instances from the database.
class All_Data(Resource):  # Defining the get method
    def get(self):
        data_list = list(Garmin_User_Data.query.limit(1000).all())
        json_to_return = {'Data': list(map(lambda x: x.json(), data_list))}

        for entry in data_list:
            entry.delete_()

        return json_to_return


api.add_resource(All_Data, '/')
api.add_resource(Data_list, '/api')


if __name__ == '__main__':
    
    # Run the applications
    app.run(host="0.0.0.0", port="5000", debug=False)

