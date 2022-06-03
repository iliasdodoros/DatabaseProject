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
    mycursor.execute('''create view orgs_projects_per_year as
                        select name, extract( year from beginning) as yearr, count(*) as got_projects from (
                        select o.name, p.project_id , p.beginning
                        from Organisation o 
                        inner join Project p on p.organisation_id = o.organisation_id ) A
                        group by  yearr, name ;''')
    mycursor.execute('''select name, a_year, next_year, a_got_projects as number_of_projects  from (
                        select a.name, a.yearr as a_year, a.got_projects as a_got_projects, b.yearr as next_year, b.got_projects as other_year_got_projects 
                        from orgs_projects_per_year a
                        inner join orgs_projects_per_year b on a.name = b.name
                        where a.yearr != b.yearr and a.yearr < b.yearr) A 
                        where (next_year - a_year = 1) and a_got_projects = other_year_got_projects and a_got_projects >= 10;''')
    result2 = mycursor.fetchall()
    listed2 = list(result2)
    mycursor.execute('drop view orgs_projects_per_year;')
    return render_template("Organismos.html", result2=listed2, rows=len(result2), columns=len(result2[0]), boolean=True)


@views.route('/Researcher')
def Research():

    return render_template("Researcher.html",  boolean=True)


@views.route('/Researcher/Researchers_under_40')
def Researchers_under_40():
    mycursor.execute('''create view active_projects as
                        select * from Project p 
                        where ((p.beginning < current_date())  and (p.ending > current_date()));''')
    mycursor.execute('''(select r.last_name, r.first_name, count(*) as projects_working_on 
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
                        order by projects_working_on desc ;''')
    result = mycursor.fetchall()

    listed = list(result)
    mycursor.execute('drop view active_projects;')
    return render_template("Researchers_under_40.html", result=listed, rows=len(result), columns=len(result[0]), boolean=True)


@views.route('/Researcher/Researchers_working_on')
def Researchers_working_on():
    mycursor.execute('''select * from (
                        select concat(last_name, " ", first_name) as name_of_researcher, count(*) as projects_working_on  from (
                        (select r.last_name, r.first_name
                        from Researcher r 
                        inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
                        inner join Project p on wip.project_id = p.project_id 
                        left join Delivered d on p.project_id = d.project_id 
                        where d.title is null )
                        union all
                        (select r.last_name, r.first_name
                        from Researcher r 
                        inner join Project p on r.researcher_id  = p.supervisor_id
                        left join Delivered d on p.project_id = d.project_id 
                        where d.title is null  ) ) A
                        group by A.last_name ) B
                        where projects_working_on >= 5
                        order by projects_working_on desc;''')
    result6 = mycursor.fetchall()
    listed6 = list(result6)
    return render_template("Researchers_working_on.html", result6=listed6, rows=len(result6), columns=len(result6[0]), boolean=True)


@views.route('/Stelehos')
def Stelehos():
    mycursor.execute('''create view projects_of_companies as
                        select sum(p.amount) as total_amount, p.title, p.project_id, p.stelehos_id, p.programm_id, p.organisation_id, o.name 
                        from Project p inner join Company c on p.organisation_id = c.organisation_id 
                        inner join Organisation o on o.organisation_id = c.organisation_id 
                        group by p.stelehos_id, o.name;''')
    mycursor.execute('''select s.name, pc.name, pc.total_amount  
                        from projects_of_companies pc 
                        inner join Stelehos s on pc.stelehos_id = s.stelehos_id 
                        order by pc.total_amount desc 
                        limit 5;''')
    result1 = mycursor.fetchall()
    listed1 = list(result1)
    mycursor.execute('drop view projects_of_companies;')
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
            mycursor2.execute(f'''(select p.title, r.last_name, r.first_name
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
                              and ((p.beginning < current_date())  and (p.ending > current_date())));''')
            results = mycursor2.fetchall()
            return render_template("Research_Field.html", fields=fields, choice=choice, results=results, rows=len(results), columns=len(results[0]), boolean=True)
    else:
        return render_template("Research_Field.html", fields=fields)


@views.route('/Project')
def Project():

    return render_template("Project.html",  boolean=True)


@views.route('/Project/Projects_per_researcher')
def Projects_per_researcher():
    mycursor.execute('''create view projects_per_researcher as
                         (select concat( r.last_name," ", r.first_name ) as researcher_name, p.title as project_title 
                         from Researcher r 
                         inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
                         inner join Project p on wip.project_id = p.project_id  )
                         union all 
                         (select concat(r.last_name," ", r.first_name) as researcher_name, p.title as project_title 
                         from Researcher r 
                         inner join Project p on r.researcher_id = p.supervisor_id )
                         order by researcher_name ;''')
    mycursor.execute('select * from projects_per_researcher;')
    result4 = mycursor.fetchall()
    listed4 = list(result4)
    mycursor.execute('drop view projects_per_researcher;')
    return render_template("Projects_per_researcher.html", result4=listed4, rows=len(result4), columns=len(result4[0]), boolean=True)


@views.route('/Project/Projects_per_organisation')
def Projects_per_organisation():
    mycursor.execute('''create view projects_per_organisation as 
                         select o.name as organisation_name, p.title as project_title 
                         from Organisation o 
                         inner join Project p on o.organisation_id = p.organisation_id 
                         order by organisation_name ;''')
    mycursor.execute('select * from projects_per_organisation;')
    result5 = mycursor.fetchall()
    listed5 = list(result5)
    mycursor.execute('drop view projects_per_organisation;')
    return render_template("Projects_per_organisation.html", result5=listed5, rows=len(result5), columns=len(result5[0]), boolean=True)


@views.route('/Project/Top_3__Research_Field_Duos')
def Top_3__Research_Field_Duos():

    mycursor.execute('''create view project_and_rf as
                        select p.title, p.project_id, prf.name  
                        from Project p 
                        inner join Project_Research_Field prf on p.project_id = prf.project_id 
                        order by p.project_id ;''')
    mycursor.execute('''select title, project_id, rf_duo, count(*) as counter from (
                        select prf1.title, prf1.project_id, concat (prf1.name," ", prf2.name) rf_duo
                        from project_and_rf prf1 
                        inner join project_and_rf prf2 on prf1.title = prf2.title
                        where prf1.name != prf2.name and prf1.name < prf2.name) A 
                        group by rf_duo
                        order by counter desc
                        limit 3;''')
    result7 = mycursor.fetchall()
    listed7 = list(result7)
    mycursor.execute('drop view project_and_rf;')
    return render_template("Top_3__Research_Field_Duos.html", result7=listed7, rows=len(result7), columns=len(result7[0]), boolean=True)


@views.route('/Project/Edit_Project', methods=['GET', 'POST'])
def Edit_Project():
    
    mycursor.execute("""SELECT DISTINCT title,project_id from Project""")
    projects = mycursor.fetchall()

    if request.method=='POST':
        if 'project' in request.form:
            project=request.form['project']
            mycursor.execute(f'select * from Project where title ="{project}"')
            data=mycursor.fetchall()
            return render_template("Edit_Project.html", projects=projects, data=data[0],columns=len(data[0]),boolean=True)
        if 'title' in request.form:
            title=request.form['title']
            projectid=request.form['project']
            mycursor.execute(f'update Project set title="{title}" where project_id="{projectid}"')
            ourdb.commit()
            return render_template("Edit_Project.html", projects=projects,boolean=True)
        return render_template("Edit_Project.html", projects=projects, boolean=True)
    return render_template("Edit_Project.html", projects=projects, boolean=True)
     

   