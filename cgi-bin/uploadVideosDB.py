import pymysql
import settings

def uploadVideo(fileURL, title, description, userId):
    dbConnection = pymysql.connect(host=settings.DB_HOST,
                        user=settings.DB_USER,
                        password=settings.DB_PASSWD,
                        database=settings.DB_DATABASE,
                        charset='utf8mb4',
                        cursorclass= pymysql.cursors.DictCursor)
    sqlProc = "createVideo"
    sqlArgs = [userId, title, description,fileURL,]
    retVal = ""
    try:
        cursor = dbConnection.cursor()
        cursor.callproc(sqlProc, sqlArgs)
        dbConnection.commit()
        retVal = {"Status": 200, "Message": "Success"}
    except pymysql.MySQLError as e:
        retVal = {"Status": 400, "Message": "A MySQL Error has occured"}
    except Exception as e:
        retVal = {"Status": 500, "Message": "A general error has occured.\nError message: {e}"}
    finally:
        cursor.close()
        dbConnection.close()
        return retVal
