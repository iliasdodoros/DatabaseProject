from datetime import date
from flask import Blueprint, render_template   
import mysql.connector

ourdb = mysql.connector.connect(
    host="localhost", user="root", password="", database="elidek")


mycursor = ourdb.cursor()
data= mycursor.execute("SELECT * FROM Research_Field")
mytable= mycursor.fetchall()

researcher = Blueprint('researcher', __name__)

@researcher.route('Researcher/young_researchers')
def home():
    return render_template("young_researchers.html")