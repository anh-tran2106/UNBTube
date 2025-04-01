import pymysql
import settings
import os
import json
import random
from hashlib import sha256
from sendVerificationEmail import telMail



def createVRec(email):
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
    
    hashEmail = sha256((salt.encode('utf-8') + email.encode('utf-8'))).hexdigest()
    sqlProc = 'getUID'
    sqlArgs = [email,]
    try:
        cursor = dbConnection.cursor()
        cursor.callproc(sqlProc, sqlArgs)
        dbConnection.commit()
        data = cursor.fetchone()
        uid = data["userID"]
        sqlProc = 'createemail'
        sqlArgs = [uid,hashEmail,]
        cursor.callproc(sqlProc,sqlArgs,)
        dbConnection.commit()
        telMail(email, "https://cs3103.cs.unb.ca:8026/verify?v="+hashEmail)
        return {"Status": 200, "Message": "Success"}
    except pymysql.MySQLError as e:
        return {"Status": 400, "Message": "A MySQL Error has occured"}
    except Exception as e:
        return {"Status": 500, "Message": "A general error has occured.\nError message: {e}"}
    finally:
        cursor.close()
        dbConnection.close()