from flask_restful import Resource
from flask import request
from Model import db, User
import random
import string

class Register(Resource):
    
    def get(self):
        users = User.query.all()
        user_list = []
        for i in range(0, len(users)):
            user_list.append(users[i].serialize())
        return { "status" : str(user_list)}, 200

    def post(self):
        json_data = request.get_json(force=True)
        if not json_data:
            return {'message' : 'No input data provided'}, 400
        
        user = User.query.filter_by(email=json_data['email']).first()
        if user:
           return {'message' : 'Email has already been registered'}, 400
        user = User.query.filter_by(handle=json_data['handle']).first()
        if user:
           return {'message' : 'Handle is not available'}, 400

        apikey=self.generate_key()

        user = User.query.filter_by(apikey=apikey).first()
        if user:
            return {'message' : 'API Key already exists'}, 400

        user = User(
            apikey=apikey,
            email=json_data['email'],
            handle=json_data['handle'],
            username=json_data['username'],
            password=json_data['password']
        )

        db.session.add(user)
        db.session.commit()

        result = User.serialize(user)

        return { 'status' : 'success', 'data': result}, 201

    def generate_key(self):
        return ''.join(random.choice(string.ascii_letters + string.digits) for _ in range(50))