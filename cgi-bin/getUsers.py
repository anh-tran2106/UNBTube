import pymysql
import settings
import os

dbConnection = pymysql.connect(host=settings.DB_HOST,
                                user=settings.DB_USER,
                                password=settings.DB_PASSWD,
                                database=settings.DB_DATABASE,
                                charset='utf8mb4',
                                cursorclass= pymysql.cursors.DictCursor)

sqlProc = 'getUsers'

try:
    cursor = dbConnection.cursor()
    cursor.callproc(sqlProc, "")
    dbConnection.commit()
    results = cursor.fetchall()