import pymysql
import settings
import os
import json
import random
from hashlib import sha256
from createVerificationRecord import createVRec



def CreateUser(username, email, password):
    dbConnection = pymysql.connect(host=settings.DB_HOST,
                            user=settings.DB_USER,
                            password=settings.DB_PASSWD,
                            database=settings.DB_DATABASE,
                            charset='utf8mb4',
                            cursorclass= pymysql.cursors.DictCursor)
    salt = ""
    chars=[]
    alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    for i in range(16):
        chars.append(random.choice(alphabet))
        salt = "".join(chars)
    hashPass = sha256((salt.encode('utf-8') + password.encode('utf-8'))).hexdigest()
    sqlProc = 'createUser'
    sqlArgs = [username, email, hashPass, salt,]
    try:
        cursor = dbConnection.cursor()
        cursor.callproc(sqlProc, sqlArgs)
        dbConnection.commit()
        print(createVRec(email))
    except pymysql.MySQLError as e:
        return {"Status": 400, "Message": "A MySQL Error has occured\nSQL Error Message: {e}"}
    except Exception as e:
        return {"Status": 500, "Message": "A general error has occured.\nError message: {e}"}
    finally:
        cursor.close()
        dbConnection.close()



