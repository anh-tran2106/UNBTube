#!/usr/bin/env python3
import datetime
from hashlib import sha1
import os
from flask import Flask, jsonify, abort, request, make_response, session, render_template, redirect, url_for
from flask_restful import reqparse, Resource, Api
from flask_session import Session
import ssl #include ssl libraries
import verifyUser
import createUser
import signIn
import uploadVideosDB
import getUserID
import getAllVideosDB
import getVideo
import addComments
import getAllComments
import getUserVideos
import findVideos
from werkzeug.utils import secure_filename

import settings # Our server and db settings, stored in settings.py

app = Flask(__name__)
#CORS(app)
# Set Server-side session config: Save sessions in the local app directory.
app.config['SECRET_KEY'] = settings.SECRET_KEY
app.config['SESSION_TYPE'] = 'filesystem'
app.config['SESSION_COOKIE_NAME'] = 'peanutButter'
app.config['SESSION_COOKIE_DOMAIN'] = settings.APP_HOST

Session(app)


####################################################################################
#
# Error handlers
#
@app.errorhandler(400) # decorators to add to 400 response
def not_found(error):
	return make_response(jsonify( { 'status': 'Bad request' } ), 400)

@app.errorhandler(401) # decorators to add to 401 response
def not_found(error):
	return make_response(jsonify( { 'status': 'Bad request' } ), 401)

@app.errorhandler(403) # decorators to add to 403 response
def not_found(error):
	return make_response(jsonify( { 'status': 'Bad request' } ), 403)

@app.errorhandler(404) # decorators to add to 404 response
def not_found(error):
	return make_response(jsonify( { 'status': 'Resource not found' } ), 404)

@app.errorhandler(500) # decorators to add to 500 response
def not_found(error):
	return make_response(jsonify( { 'status': 'Internal server error' } ), 500)

class Root(Resource):
	def get(self):
		hashString = request.args.get('v')
		return verifyUser.verifyUser(hashString)

class SignIn(Resource):
	def post(self):

		if not request.json:
			abort(400) # bad request

		# Parse the json
		parser = reqparse.RequestParser()
		try:
 			# Check for required attributes in json document, create a dictionary
			parser.add_argument('username', type=str, required=True)
			parser.add_argument('password', type=str, required=True)
			request_params = parser.parse_args()
		except:
			abort(400) # bad request
		if request_params['username'] in session:
			response = {'status': 'Success'}
			responseCode = 200
		else:
			validate = signIn.signin(request_params['username'], request_params['password'])
			if (validate):
				session['username'] = request_params['username']
				response = {'status': 'success'}
				return make_response(jsonify(response), 201)
			else:
				response = {'status': 'Invalid Login Information', 'user_id':request_params['userId'] }
				return make_response(jsonify(response), 400)

		return make_response(jsonify(response), responseCode)

	# GET: Check Cookie data with Session data
	def get(self):
		if 'username' in session:
			username = session['username']
			response = {'status': 'success'}
			responseCode = 200
		else:
			response = {'status': 'fail'}
			responseCode = 403

		return make_response(jsonify(response), responseCode)


class logout(Resource):
	def delete(self):
		if 'username' in session:
			session.pop('username', None)
			response = {'status': 'success'}
			responseCode = 200
		else:
			response = {'status': 'fail'}
			responseCode = 400
		return make_response(jsonify(response), responseCode)
	
class signUp(Resource):
	def post(self):
			if not request.json:
				abort(400) # bad request

		# Parse the json
			parser = reqparse.RequestParser()
   
			try:
				# Check for required attributes in json document, create a dictionary
				parser.add_argument('username', type=str, required=True)
				parser.add_argument('password', type=str, required=True)
				parser.add_argument('email', type = str, required=True)
				request_params = parser.parse_args()
			except:
				abort(400)
			if '@' not in request_params['email']:
				abort(400)
			if len(request_params['username']) > 50 or len(request_params['username']) == 0:
				abort(400)
			if len(request_params['password']) > 255 or len(request_params['password']) < 8:
				abort(400)
			return make_response(jsonify(createUser.CreateUser(request_params["username"], request_params["email"], request_params["password"])))

class search(Resource):
	def get(self):
		if not request.json:
			abort(400)
		parser = reqparse.RequestParser()
		try:
			parser.add_argument('searchTerm', type=str, required=True)
			request_parms = parser.parse_args()
			retVal = findVideos.findVideos(request_parms['searchTerm'])
		except:
			abort(400)


class getUsers(Resource):
	def get(self):
		l=1
class getAllVideos(Resource):
    def get(self):
        return make_response(jsonify(getAllVideosDB.getAllVideos()), 200)
class getVideoDB(Resource):
	def get(self):
		if not request.json:
			abort(400) # bad request
		# Parse the json
		parser = reqparse.RequestParser()
		try:
 			# Check for required attributes in json document, create a dictionary
			parser.add_argument('vidID', type=str, required=True)
			request_params = parser.parse_args()
		except:
			abort(400)
		return make_response(jsonify(getVideoDB.getVideo(request_params['vidID'])))

class uploadVideo(Resource):
	def post(self):
		if 'username' in session:
			uploaded_file = request.files['file']
			filename = secure_filename(uploaded_file.filename)
			if filename != '':
				file_ext = os.path.splitext(filename)[1]
				if file_ext not in app.config['UPLOAD_EXTENSIONS']:
					abort(400)
				otherDir = app.config['UPLOAD_PATH'] + session.get("username") + "/" + sha1(((datetime.datetime.now()).isoformat()).encode('utf-8')).hexdigest() + "/"
				os.makedirs(otherDir)
				uploaded_file.save(os.path.join(otherDir ,filename))
				videoInfo = request.form.to_dict()
				uploadVideosDB.uploadVideo(otherDir + filename, videoInfo['title'], videoInfo['desc'], getUserID.getUserID(session.get('username')))
				return redirect('/')

class comments(Resource):
	def get(self):
		if not request.json:
			abort(400)
		parser = reqparse.RequestParser()
		try:
			parser.add_argument('vidID', type=str, required=True)
			request_parms = parser.parse_args()
			retVal = getAllComments.getAllComments(request_parms)
		except:
			abort(400)
	def post(self):
		if not request.json:
			abort(400)
		parser = reqparse.RequestParser()
		try:
			parser.add_argument('vidID', type=str, required=True)
			parser.add_argument('userID', type=str, required=True)
			parser.add_argument('parentID', type=str, required=False)
			parser.add_argument('comment', type=str, required=True)
			request_parms = parser.parse_args()
			retval = addComments.addComment(request_parms['userID'],request_parms['parentID'],request_parms['comment'])
			make_response(jsonify(retval, 200))
		except:
			abort(400)
   
class userVideos(Resource):
	def get(self):
		if not request.json:
			abort(400)
		parser = reqparse.RequestParser()
		try:
 			# Check for required attributes in json document, create a dictionary
			parser.add_argument('userID', type=str, required=True)
			request_params = parser.parse_args()
			retVal = getUserVideos.getAllVideos(request_params["userID"])
			return make_response(jsonify(retVal), 200)
		except:
			abort(400)
			
class getVideoDB(Resource):
	def get(self):
		if not request.json:
			abort(400) # bad request
		# Parse the json
		parser = reqparse.RequestParser()
		try:
 			# Check for required attributes in json document, create a dictionary
			parser.add_argument('vidID', type=str, required=True)
			request_params = parser.parse_args()
		except:
			abort(400)
		return make_response(jsonify(getVideo.getVideo(request_params['vidID'])), 200)
   
app.config['UPLOAD_EXTENSIONS'] = ['.mp4', 'WebM'] 
app.config['UPLOAD_PATH'] = "static/videosTest/"
api = Api(app)
api.add_resource(Root,'/verify')
api.add_resource(SignIn, '/login')
api.add_resource(logout, '/logout')
api.add_resource(signUp, '/signup')
api.add_resource(getUsers, '/users')
api.add_resource(uploadVideo, '/upload')
api.add_resource(getAllVideos, '/videos')
api.add_resource(getVideoDB, '/watch')
api.add_resource(comments, '/comments')
api.add_resource(userVideos, '/user', '/user/<userID>')
api.add_resource(search, '/search')

@app.route("/")
def frontend():
	if 'username' in session:
		return render_template("index.html")  # Show homepage for logged-in users
	else:
		return render_template("login.html")  # Show login page for guests

@app.route("/signup")
def signup_frontend():
 	return render_template("signup.html")

@app.route("/upload")
def uploadPage():
	if 'username' in session:
		return render_template("upload.html") 
	else:
		abort(401)



if __name__ == "__main__":
	#
	# You need to generate your own certificates. To do this:
	#	1. cd to the directory of this app
	#	2. run the makeCert.sh script and answer the questions.
	#	   It will by default generate the files with the same names specified below.
	#
	context = ('cert.pem', 'key.pem') # Identify the certificates you've generated.
	app.run(
		host=settings.APP_HOST,
		port=settings.APP_PORT,
		ssl_context=context,
		debug=settings.APP_DEBUG)
