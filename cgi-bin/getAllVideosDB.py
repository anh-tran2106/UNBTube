import pymysql
import settings

def getAllVideos():
    dbConnection = pymysql.connect(host=settings.DB_HOST,
                        user=settings.DB_USER,
                        password=settings.DB_PASSWD,
                        database=settings.DB_DATABASE,
                        charset='utf8mb4',
                        cursorclass= pymysql.cursors.DictCursor)
    sqlProc = "getVideos"
    data = ""
    try:
        cursor = dbConnection.cursor()
        cursor.callproc(sqlProc)
        dbConnection.commit()
        data = cursor.fetchall()
    except pymysql.MySQLError as e:
        return {"Status": 400, "Message": "A MySQL Error has occured", "Error Message": e}
    except Exception as e:
        return {"Status": 500, "Message": "A general error has occured.\nError message: {e}"}
    finally:
        cursor.close()
        dbConnection.close()
    return data
