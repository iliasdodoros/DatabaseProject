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

@views.route('/Organismos')
def Organismos():
    wow = mycursor.execute('''
                            select name, a_year, next_year, a_got_projects as number_of_projects  from (
                            select a.name, a.yearr as a_year, a.got_projects as a_got_projects, b.yearr as next_year, b.got_projects as other_year_got_projects 
                            from orgs_projects_per_year a
                            inner join orgs_projects_per_year b on a.name = b.name
                            where a.yearr != b.yearr and a.yearr < b.yearr) A 
                            where (next_year - a_year = 1) and a_got_projects = other_year_got_projects and a_got_projects >= 10; 

                            ''')
    result2 = mycursor.fetchall()
    listed2 = list(result2)
    return render_template("Organismos.html", result2=listed2, rows=len(result2), columns=len(result2[0]), boolean=True)

@views.route('/Researcher')
def Research():
   
    return render_template("Researcher.html",  boolean=True)

@views.route('/Researcher/Researchers_under_40')
def Researchers_under_40():
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
    
    return render_template("Researchers_under_40.html", result=listed, rows=len(result), columns=len(result[0]), boolean=True)

@views.route('/Researcher/Researchers_working_on')
def Researchers_working_on():
    lol = mycursor.execute('''select * from (
                                (select r.last_name, r.first_name, count(*) as projects_working_on
                                from researcher r 
                                inner join works_in_project wip on r.researcher_id = wip.researcher_id 
                                inner join project p on wip.project_id = p.project_id 
                                left join delivered d on p.project_id = d.project_id 
                                where d.title is null 
                                group by r.last_name)
                                union
                                (select r.last_name, r.first_name, count(*) as projects_working_on 
                                from researcher r 
                                inner join project p on r.researcher_id  = p.supervisor_id
                                left join delivered d on p.project_id = d.project_id 
                                where d.title is null 
                                group by r.last_name ) 
                                order by projects_working_on desc) A 
                                where projects_working_on >= 2;


                            ''')
    result6 = mycursor.fetchall()
    listed6 = list(result6)
    
    return render_template("Researchers_working_on.html", result=listed6, rows=len(result6), columns=len(result6[0]), boolean=True)


@views.route('/Stelehos')
def Stelehos():
    wow = mycursor.execute('''
                            select s.name, pc.name, pc.total_amount  
                            from projects_of_companies pc 
                            inner join Stelehos s on pc.stelehos_id = s.stelehos_id 
                            order by pc.total_amount desc 
                            limit 5;

                            ''')
    result1 = mycursor.fetchall()
    listed1 = list(result1)
    return render_template("Stelehos.html", result1=listed1, rows=len(result1), columns=len(result1[0]), boolean=True)

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
            return render_template("Research_Field.html", fields=fields, choice=choice, results=results, rows=len(results), columns=len(results[0]), boolean=True)
    else:
        return render_template("Research_Field.html", fields=fields)

@views.route('/Project')
def Project():
   
    return render_template("Project.html",  boolean=True)

@views.route('/Project/Project_by_researchers')
def Project_by_researchers():
    wow = mycursor.execute('''
                            (select concat( r.last_name," ", r.first_name ) as researcher_name, p.title as project_title 
                            from researcher r 
                            inner join works_in_project wip on r.researcher_id = wip.researcher_id 
                            inner join project p on wip.project_id = p.project_id  )
                            union all 
                            (select concat(r.last_name," ", r.first_name) as researcher_name, p.title as project_title 
                            from researcher r 
                            inner join project p on r.researcher_id = p.supervisor_id )
                            order by researcher_name ;
                            ''')
    result4 = mycursor.fetchall()
    listed4 = list(result4)
    return render_template("Project_by_researchers.html", result4=listed4, rows=len(result4), columns=len(result4[0]), boolean=True)


@views.route('/Project/Project_by_organisations')
def Project_by_organisations():
    wow = mycursor.execute('''
                           select o.name as organisation_name, p.title as project_title 
                            from organisation o 
                            inner join project p on o.organisation_id = p.organisation_id 
                            order by organisation_name ;
                            ''')
    result5 = mycursor.fetchall()
    listed5 = list(result5)
    return render_template("Project_by_organisations.html", result5=listed5, rows=len(result5), columns=len(result5[0]), boolean=True)






    