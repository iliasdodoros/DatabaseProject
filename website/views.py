from datetime import date
from flask import Blueprint, render_template
import mysql.connector

ourdb = mysql.connector.connect(
    host="localhost", user="root", password="", database="elidek")


mycursor = ourdb.cursor()
data= mycursor.execute("SELECT * FROM Programm")
mytable= mycursor.fetchall()

views = Blueprint('views', __name__)


@views.route('/')
def home():
    return render_template("home.html")


@views.route('/Organismos')
def Organismos():
    return render_template("Organismos.html")

@views.route('/Stelehos')
def Stelehos():
    return render_template("Stelehos.html",data=mytable)