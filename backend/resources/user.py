from flask_restful import Resource

class User(Resource):
    __tablename__ = 'users'
    __table_args__ = tuple(db.UniqueConstraint('userid', 'email', name='my_2uniq'))

    userid = db.Column(db.Integer(12), primary_key=True)
    apikey = db.Column(db.String, unique=True)
    email = db.Column(db.String(50), nullable=False)
    username = db.Column(db.String(25), nullable=False)
    password = db.Column(db.String(25), nullable=False)

    def __init__(self, userid, apikey, email, username, password):
        self.userid = userid
        self.apikey = apikey
        self.email = email
        self.username = username
        self.password = password
    
    def __repr__(self):
        return '<userid {}>'.format(self.userid)

    def serialize(self):
        return{
            'userid': self.userid
            'apikey': self.apikey
            'email': self.email
            'username': self.username
            'password': self.password
        }
    
    def get(self):
        return {"message": "yo LoSEr"}