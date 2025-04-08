import pymysql
import settings

def incrementViews(vidId):
    dbConnection = pymysql.connect(host=settings.DB_HOST,
                        user=settings.DB_USER,
                        password=settings.DB_PASSWD,
                        database=settings.DB_DATABASE,
                        charset='utf8mb4',
                        cursorclass= pymysql.cursors.DictCursor)
    sqlProc = "increaseViews"
    sqlArgs = [vidId,]
    retVal = ''
    try:
        cursor = dbConnection.cursor()
        cursor.callproc(sqlProc, sqlArgs)
        dbConnection.commit()
        retVal = {"Status": 200, "Message": "Account Created Successfully"}
    except pymysql.MySQLError as e:
        retVal = {"Status": 400, "Message": "A MySQL Error has occured", "Error Message": e}
    except Exception as e:
        retVal = {"Status": 500, "Message": "A general error has occured", "Error message": e}
    finally:
        cursor.close()
        dbConnection.close()
    return retVal


