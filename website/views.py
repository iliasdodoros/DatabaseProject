from dataclasses import field, fields
from datetime import date, datetime

import mysql.connector
from dateutil import relativedelta
from flask import Blueprint, render_template, request, session
from requests import session

ourdb = mysql.connector.connect(
    host="localhost", user="root", password="", database="elidek")


mycursor = ourdb.cursor()
mycursor2 = ourdb.cursor(named_tuple=True)
mycursor3 = ourdb.cursor(named_tuple=True)

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
    mycursor.execute('''select name_of_executive, name_of_company, total_amount from (
                        select s.name as name_of_executive, pc.name as name_of_company, pc.total_amount, row_number() over (partition by s.name order by pc.total_amount desc) as seqnum  
                        from projects_of_companies pc 
                        inner join Stelehos s on pc.stelehos_id = s.stelehos_id 
                        order by pc.total_amount desc ) A
                        where seqnum = 1
                        limit 5;''')
    result1 = mycursor.fetchall()
    listed1 = list(result1)
    mycursor.execute('drop view projects_of_companies;')
    return render_template("Stelehos.html", result1=listed1, rows=len(result1), columns=len(result1[0]), boolean=True)


@views.route('/Programm')
def Researcher():
    mycursor.execute('select name from Programm')
    programms = mycursor.fetchall()
    return render_template("Programm.html", programms=programms)


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

    mycursor3.execute("""SELECT DISTINCT title from Project""")
    projects = mycursor3.fetchall()
    if request.method == 'POST':
        if 'project' in request.form:
            project = request.form["project"]
            mycursor2.execute(
                f'select project_id from Project where title="{project}"')
            project_id = mycursor2.fetchall()
            mycursor3.execute(
                f'select title,amount,stelehos_id,summary,project_id from Project where project_id="{project_id[0][0]}"')
            data = mycursor3.fetchall()
            return render_template("Edit_Project.html", data=data, projectid=project_id, projects=projects, boolean=True)
        if 'project_id' in request.form:
            project_idd = request.form['project_id']
            title = request.form['title']
            amount = request.form['amount']
            stelehos_id = request.form['stelehos_id']
            summary = request.form['summary']
            mycursor3.execute(
                f'update Project set title ="{title}",amount="{amount}",stelehos_id="{stelehos_id}",summary="{summary}" where project_id="{project_idd}"')
            ourdb.commit()
            return render_template("Edit_Project.html", projects=projects, boolean=True)

    return render_template("Edit_Project.html", projects=projects, boolean=True)


@views.route('/Project/Add_Project', methods=['GET', 'POST'])
def Add_Project():
    if request.method == 'POST':
        amount = request.form['amount']
        title = request.form['title']
        beginning = request.form['beginning']
        ending = request.form['ending']

        date1 = datetime.strptime(beginning, '%Y-%M-%d')
        date2 = datetime.strptime(ending, '%Y-%M-%d')
        delta = relativedelta.relativedelta(date2, date1)
        duration = delta.months + (12*delta.years)
        summary = request.form['summary']
        grade = request.form['grade']
        date_of_grading = request.form['date_of_grading']
        stelehos_id = request.form['stelehos_id']
        programm_id = request.form['programm_id']
        supervisor_id = request.form['supervisor_id']
        grader_id = request.form['grader_id']
        organisation_id = request.form['organisation_id']
        mycursor3.execute( f'''insert into Project (amount,title,beginning,ending,duration,summary,grade,date_of_grading,stelehos_id,programm_id,supervisor_id,grader_id,organisation_id) values ("{amount}","{title}","{beginning}","{ending}","{duration}","{summary}","{grade}","{date_of_grading}","{stelehos_id}","{programm_id}","{supervisor_id}","{grader_id}","{organisation_id}") ''')
        ourdb.commit()
    return render_template("Add_Project.html", boolean=True)


@views.route('/Project/Projectsfilters', methods=['GET', 'POST'])
def Projectsfilters():
    mycursor.execute("select name from Stelehos")
    stelehoi = mycursor.fetchall()
    if request.method == 'POST':
        if 'date' in request.form:
            date1='2099-01-01'
            date2='1900-01-01'
            stelehos='%'
            duration='%'
            if not request.form['date']=='':
                date1 = request.form["date"]
                date2 = request.form["date"]
            if not request.form['stelehos']=='-':
                stelehos = request.form["stelehos"]
            if not request.form['duration']=='-':
                duration = request.form["duration"]
            mycursor2.execute(f'''  select p.title as title_of_project                                                                                  
                                    from Project p 
                                    inner join Stelehos s on p.stelehos_id = s.stelehos_id 
                                    where s.name like "{stelehos}" and p.duration like "{duration}" and ((p.beginning < "{date1}")  and (p.ending > "{date2}"))''')
            data = mycursor2.fetchall()
            return render_template("Projectsfilters.html", stelehoi=stelehoi, data=data, boolean=True)
        if 'project' in request.form:
            project=request.form['project']
            mycursor3.execute(f'''  select name_of_researcher from (
                                    (select concat(r.last_name," ", r.first_name) as name_of_researcher, p.title 
                                    from Researcher r 
                                    inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
                                    inner join Project p on wip.project_id = p.project_id
                                    order by name_of_researcher)
                                    union 
                                    (select concat(r.last_name," ", r.first_name) as name_of_researcher, p.title 
                                    from Researcher r 
                                    inner join Project p on r.researcher_id = p.supervisor_id 
                                    order by name_of_researcher)) A
                                    where A.title = "{project}"''')
            projects=mycursor.fetchall()
            return render_template("Projectsfilters.html", projects=projects,project=project, stelehoi=stelehoi, boolean=True)
    return render_template("Projectsfilters.html", stelehoi=stelehoi, boolean=True)



@views.route('/Researcher/Edit_Researcher', methods=['GET', 'POST'])
def Edit_Researcher():

    mycursor3.execute(
        """ select concat(last_name, " ", first_name) as full_name from Researcher""")
    researchers = mycursor3.fetchall()
    if request.method == 'POST':
        if 'researcher' in request.form:
            researcher = request.form["researcher"]
            mycursor2.execute(
                f'''select researcher_id from Researcher where concat(last_name, " ", first_name) = "{researcher}"''')
            researcher_id = mycursor2.fetchall()
            mycursor3.execute(
                f'select sex,last_name ,date_of_birth,first_name,researcher_id from Researcher where researcher_id ="{researcher_id[0][0]}"')
            data = mycursor3.fetchall()
            return render_template("Edit_Researcher.html", data=data, researcher_id=researcher_id, researchers=researchers, boolean=True)
        if 'researcher_id' in request.form:
            researcher_idd = request.form['researcher_id']
            last_name = request.form['last_name']
            first_name = request.form['first_name']
            date_of_birth = request.form['date_of_birth']
            mycursor2.execute(
                f'''update Researcher set first_name="{first_name}",last_name="{last_name}",date_of_birth="{date_of_birth}" where researcher_id="{researcher_idd}"''')
            ourdb.commit()
            return render_template("Edit_Researcher.html", researchers=researchers, boolean=True)

    return render_template("Edit_Researcher.html", researchers=researchers, boolean=True)


@views.route('/Researcher/Add_Researcher', methods=['GET', 'POST'])
def Add_Researcher():
    if request.method == 'POST':
        sex = request.form['sex']
        date_of_birth = request.form['date_of_birth']
        last_name = request.form['last_name']
        first_name = request.form['first_name']
        organisation_id = request.form['organisation_id']
        mycursor3.execute(
            f'''insert into Researcher (sex,last_name,date_of_birth,first_name,organisation_id) values ("{sex}","{last_name}","{date_of_birth}","{first_name}","{organisation_id}") ''')
        ourdb.commit()
    return render_template("Add_Researcher.html", boolean=True)




@views.route('/Viewdelete', methods=['GET', 'POST'])
def Viewdelete():
    mycursor2.execute('show tables')
    tables= mycursor2.fetchall()

    if request.method == 'POST':
        if 'tabletoview' in request.form:
            tabletoview=request.form['tabletoview']
            mycursor.execute(f'select * from {tabletoview}')
            table=mycursor.fetchall()
            mycursor3.execute(f'show columns from {tabletoview}')
            colnames= mycursor3.fetchall()
            if 'tabletodelete' in request.form:
                if tabletoview=='Organisation'|'Programm'|'Stelehos' :
                    tabletodelete=request.form['tabletodelete']
                    mycursor2.execute(f'delete from "{tabletoview}" where name="{tabletodelete}"')
                    ourdb.commit()
                if tabletoview=='Project' :
                    tabletodelete=request.form['tabletodelete']
                    mycursor2.execute(f'delete from Project where name="{tabletodelete}"')
                    ourdb.commit()
                if tabletoview=='Researcher' :
                    tabletodelete=request.form['tabletodelete']
                    mycursor2.execute(f'delete from Researcher where name="{tabletodelete}" ')
                    ourdb.commit()    
            return render_template("Viewdelete.html",tables=tables,colnames=colnames, table=table,rows=len(table),col=len(table[0]), boolean=True)

    return render_template("Viewdelete.html",tables=tables, boolean=True)
