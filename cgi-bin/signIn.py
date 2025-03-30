import pymysql
import settings
from hashlib import sha256

def signin(username, password):
    dbConnection = pymysql.connect(host=settings.DB_HOST,
                                user=settings.DB_USER,
                                password=settings.DB_PASSWD,
                                database=settings.DB_DATABASE,
                                charset='utf8mb4',
                                cursorclass= pymysql.cursors.DictCursor)
    
    sqlProc = "getUser"
    sqlArgs = [username,]
    userInfo = ""
    try:
        cursor = dbConnection.cursor()
        cursor.callproc(sqlProc, sqlArgs)
        dbConnection.commit()
        userInfo = cursor.fetchone()
    except pymysql.MySQLError as e:
        return {"Status": 400, "Message": "A MySQL Error has occured", "Error Message": e}
    except Exception as e:
        return {"Status": 500, "Message": "A general error has occured.\nError message: {e}"}
    finally:
        cursor.close()
        dbConnection.close()
    if (userInfo == None):
        return False
    verifyHash = sha256((userInfo["salt"].encode('utf-8') + password.encode('utf-8'))).hexdigest()
    return (userInfo["pswd"] == verifyHash)
