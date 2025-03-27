import pymysql
import settings
import os
import json

dbConnection = pymysql.connect(host=settings.DB_HOST,
                                user=settings.DB_USER,
                                password=settings.DB_PASSWD,
                                database=settings.DB_DATABASE,
                                charset='utf8mb4',
                                cursorclass= pymysql.cursors.DictCursor)


class getUsers():
    def main(self):
        sqlProc = 'getUsers'

        try:
            cursor = dbConnection.cursor()
            cursor.callproc(sqlProc, "")
            dbConnection.commit()
            results = cursor.fetchall()
            return results
        except pymysql.MySQLError as e:
            return {'status': 500, 'message': 'Error within MySQL has occured', 'Error Message':e}
        except Exception as e:
            return {'status': 500, 'message': 'An error has occured', 'Error Message':e}