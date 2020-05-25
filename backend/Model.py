from flask import Flask
from marshmallow import Schema, fields, pre_load, validates
from flask_marshmallow import Marshmallow
from flask_sqlalchemy import SQLAlchemy


ma = Marshmallow()
db = SQLAlchemy()


class User(db.Model):
    __tablename__ = 'users'

    userid = db.Column(db.Integer(), primary_key=True)
    apikey = db.Column(db.String, unique=True)
    email = db.Column(db.String(50), nullable=False)
    handle = db.Column(db.String(50), nullable=False) 
    username = db.Column(db.String(25), nullable=False)
    password = db.Column(db.String(25), nullable=False)

    def __init__(self, apikey, email, handle, username, password):
        #self.userid = userid
        self.apikey = apikey
        self.email = email
        self.handle = handle
        self.username = username
        self.password = password
    
    def __repr__(self):
        return '<userid {}>'.format(self.userid)

    def serialize(self):
        return{
            'userid': self.userid,
            'apikey': self.apikey,
            'email': self.email,
            'handle': self.handle,
            'username': self.username,
            'password': self.password
        }
