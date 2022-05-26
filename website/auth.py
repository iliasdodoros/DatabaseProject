from flask import Blueprint ,render_template

auth = Blueprint('auth' , __name__)

@auth.route('/Program')
def Programs():
        return "<p>Programs</p>"

@auth.route('/Project')
def Project():
        return "<p>Project</p>"

@auth.route('/Science_Field')
def Science_Field():
        return "<p>Science_Field</p>"

@auth.route('/Organismos')
def Organismos():
        return render_template("Organismos.html" )
@auth.route('/Stelehos')
def Stelehos():
        return "<p>Stelehos</p>"
@auth.route('/Researcher')
def Researcher():
        return "<p>Researcher</p>" 