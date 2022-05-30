from curses import raw
from dataclasses import field, fields
from datetime import date
from flask import Blueprint, render_template, request
import mysql.connector

ourdb = mysql.connector.connect(
    host="localhost", user="root", password="", database="elidek")


mycursor = ourdb.cursor()
mycursor2 = ourdb.cursor()

views = Blueprint('views', __name__)


@views.route('/')
def home():
    return render_template("home.html")


@views.route('/Organismos', methods=['GET', 'POST'])
def Organismos():
    if request.method == 'POST':
        data = request.form["i"]
        if data:
            lost = mycursor.execute(f'SELECT * FROM {data}')
            table = mycursor.fetchall()
            listed = list(table)
            return render_template("Organismos.html", table=listed, rows=len(table), columns=len(table[0]), boolean=True)
    else:
        return render_template("Organismos.html", boolean=True)


@views.route('/Stelehos')
def Stelehos():

    return render_template("Stelehos.html",)


@views.route('/Researcher')
def Research():
    lol = mycursor.execute('''(select r.last_name, r.first_name, count(*) as projects_working_on 
                            from Researcher r 
                            inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
                            inner join active_projects ap on wip.project_id = ap.project_id 
                            where r.date_of_birth > '1981-12-31'
                            group by r.last_name)
                            union 
                            (select r.last_name, r.first_name, count(*) as projects_working_on 
                            from Researcher r 
                            inner join active_projects ap on r.researcher_id  = ap.supervisor_id
                            where r.date_of_birth > '1981-12-31' 
                            group by r.last_name ) 
                            order by projects_working_on desc ;

                            ''')
    result = mycursor.fetchall()
    listed = list(result)
    return render_template("Researcher.html", result=listed, rows=len(result), columns=len(result[0]), boolean=True)


@views.route('/Programm')
def Researcher():
    found = mycursor.execute('SELECT * FROM Stelehos')
    researchers = mycursor.fetchall()
    vlaka = mycursor.execute('SELECT * FROM Research_Field')
    fields = mycursor.fetchall()
    return render_template("Programm.html", researchers=researchers, fields=fields)


@views.route('/Research_Field', methods=['GET', 'POST'])
def Research_Field():

    lost = mycursor.execute(f'SELECT * FROM Research_Field')
    fields = mycursor.fetchall()
    if request.method == 'POST':
        choice = request.form["resfield"]
        if choice:
            script = f'''(select p.title, r.last_name, r.first_name
                                    from Researcher r
                                    inner join Works_in_Project wip on r.researcher_id = wip.researcher_id
                                    inner join Project p on wip.project_id = p.project_id
                                    inner join Project_Research_Field prf on p.project_id = prf.project_id
                                    where (prf.name = '{choice}')
                                    and ((p.beginning < current_date())  and (p.ending > current_date())))
                                    union
                                    (select p.title, r.last_name, r.first_name
                                    from Researcher r
                                    inner join Project p on r.researcher_id = p.supervisor_id
                                    inner join Project_Research_Field prf on p.project_id = prf.project_id
                                    where (prf.name = '{choice}')
                                    and ((p.beginning < current_date())  and (p.ending > current_date())));'''
            lost = mycursor2.execute(script)
            results = mycursor2.fetchall()
            return render_template("Research_Field.html", fields=fields, choice=choice, results=results, rows=len(results), columns=len(results), boolean=True)
    else:
        return render_template("Research_Field.html", fields=fields)
