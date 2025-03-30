#!/usr/bin/env python3
import sys
from flask import Flask, jsonify, abort, request, make_response, session
from flask_restful import reqparse, Resource, Api
from flask_session import Session
import json
from ldap3 import Server, Connection, ALL
from ldap3.core.exceptions import *
import pymysql
import pymysql.cursors
import ssl #include ssl libraries
from getUsers import getUsers

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
		return app.send_static_file('index.html')

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
			response = {'status': 'success'}
			responseCode = 200
		else:
			try:
				ldapServer = Server(host=settings.LDAP_HOST)
				ldapConnection = Connection(ldapServer,
					raise_exceptions=True,
					user='uid='+request_params['username']+', ou=People,ou=fcs,o=unb',
					password = request_params['password'])
				ldapConnection.open()
				ldapConnection.start_tls()
				ldapConnection.bind()
				session['username'] = request_params['username']
                # Stuff in here to find the esiting userId or create a use and get the created userId
				response = {'status': 'success', 'user_id':'1' }
				responseCode = 201
			except LDAPException:
				response = {'status': 'Access denied'}
				print(response)
				responseCode = 403
			finally:
				ldapConnection.unbind()

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
				abort(400) # bad request
			if '@' not in request_params['email']:
				abort(400)
			if len(request_params['username']) > 50 or len(request_params['username']) == 0:
				abort(400)
			if len(request_params['password']) > 255 or len(request_params['username']) < 8:
				abort(400)

class getUsers(Resource):
	def get(self):
		l=1


api = Api(app)
api.add_resource(Root,'/')
api.add_resource(SignIn, '/login')
api.add_resource(logout, '/logout')
api.add_resource(signUp, '/signup')
api.add_resource(getUsers, '/users')

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