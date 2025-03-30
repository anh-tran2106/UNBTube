#/usr/bin/env python
import pymysql
import settings
import datetime


def verifyUser(hash):
    dbConnection = pymysql.connect(host=settings.DB_HOST,
                                user=settings.DB_USER,
                                password=settings.DB_PASSWD,
                                database=settings.DB_DATABASE,
                                charset='utf8mb4',
                                cursorclass= pymysql.cursors.DictCursor)
    sqlProc = "getUser"
    sqlArgs = [hash,]
    try:
        cursor = dbConnection.cursor()
        cursor.callproc(sqlProc, sqlArgs)
        dbConnection.commit()
        data = cursor.fetchone()
        if (data == None):
            return {"Status": 400, "Message": "Invalid Link"}
        time = data["created"].timestamp()
        currentTime = datetime.datetime.now().timestamp()
        if (currentTime - time <= 900):
            sqlProc = "makeVerified"
            sqlArgs = [data["userId"],]
            cursor = dbConnection.cursor()
            cursor.callproc(sqlProc, sqlArgs)
            dbConnection.commit()
            sqlProc = "removeEmail"
            cursor.callproc(sqlProc, sqlArgs)
            dbConnection.commit()
            return {"Status": 200, "Message":"Success"}
        else:
            return {"Status": 400, "Message": "Expired Link"}
    except pymysql.MySQLError as e:
        return {"Status": 400, "Message": "A MySQL Error has occured\nSQL Error Message: {e}"}
    except Exception as e:
        return {"Status": 500, "Message": "A general error has occured.", "Error Message": e}
    finally:
        cursor.close()
        dbConnection.close()
        