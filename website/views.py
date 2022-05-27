from datetime import date
from flask import Blueprint, render_template  , request 
import mysql.connector

ourdb = mysql.connector.connect(
    host="localhost", user="root", password="", database="elidek")


mycursor = ourdb.cursor()
datau= mycursor.execute("SELECT * FROM Programm")
mytable= mycursor.fetchall()
mytable=list(mytable[0])

views = Blueprint('views', __name__)


@views.route('/')
def home():
    return render_template("home.html")


@views.route('/Organismos', methods=['GET','POST'])
def Organismos():
    data = request.form['i']
    lost=mycursor.execute(f'SELECT * FROM {data}')
    table=mycursor.fetchall()
    return render_template("Organismos.html" ,table=table, boolean=True)

@views.route('/Stelehos')
def Stelehos():
    return render_template("Stelehos.html",data=mytable) 

@views.route('/Researcher')
def Researcher():
    return render_template("Researcher.html",data=mytable) 

@views.route('/Science_field')
def Science_Field():
     return render_template("Science_field.html",data=mytable) 