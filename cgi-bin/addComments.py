import pymysql
import settings

def addComment(userID, vidID, subCommentID, comment):
    dbConnection = pymysql.connect(host=settings.DB_HOST,
                            user=settings.DB_USER,
                            password=settings.DB_PASSWD,
                            database=settings.DB_DATABASE,
                            charset='utf8mb4',
                            cursorclass= pymysql.cursors.DictCursor)
    retVal = ""
    if subCommentID == None:
        sqlProc = "createComment"
        sqlArgs = [userID, vidID, comment,]
        try:
            cursor = dbConnection.cursor()
            cursor.callproc(sqlProc, sqlArgs)
            dbConnection.commit()
            retVal = {"Status": "Success", "Message": "Comment Created Successfully"}
        except pymysql.MySQLError as e:
            retVal = {"Status": 400, "Message": "A MySQL Error has occured", "Error Message": e}
        except Exception as e:
            retVal = {"Status": 500, "Message": "A general error has occured", "Error Message": e}
        finally:
            cursor.close()
            dbConnection.close()
            return retVal
    else:
        sqlProc = "createReply"
        sqlArgs = [userID, vidID, subCommentID, comment,]
        try:
            cursor = dbConnection.cursor()
            cursor.callproc(sqlProc, sqlArgs)
            dbConnection.commit()
            retVal = {"Status": "Success", "Message": "Comment Created Successfully"}
        except pymysql.MySQLError as e:
            retVal = {"Status": 400, "Message": "A MySQL Error has occured", "Error Message": e}
        except Exception as e:
            retVal = {"Status": 500, "Message": "A general error has occured", "Error Message": e}
        finally:
            cursor.close()
            dbConnection.close()
            return retVal
        