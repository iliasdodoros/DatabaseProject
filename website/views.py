from flask import Blueprint, render_template
import mysql.connector

ourdb= mysql.connector.connect(host="localhost",user="root",password="",database="elidek")


mycursor=ourdb.cursor()
mycursor.execute("show tables")

views = Blueprint('views', __name__)

@views.route('/')
def home():
    return render_template("home.html")

@views.route('/Organismos')
def Organismos():
    return render_template("Organismos.html", mycursor)
