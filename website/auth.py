from flask import Blueprint 

auth = Blueprint('auth' , __name__)






@auth.route('/Program')
def Programs():
        return "<p>Programs</p>"

@auth.route('/Project')
def Project():
        return "<p>Project</p>"

@auth.route('/Science_Field')
def Science_Field():
        return "<p>Science Field</p>"

@auth.route('/Organismos')
def Organismos():
        return "<p>Organismos</p>"

@auth.route('/Stelehos')
def Stelehos():
        return "<p>Stelehos</p>"

@auth.route('/Researcher')
def Researcher():
        return "<p>Researcher</p>" 