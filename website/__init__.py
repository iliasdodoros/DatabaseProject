from flask import Flask

def create_app():
    app = Flask(__name__)
    app.config['SECRET_KEY'] = 'Database'

    from .views import views 
    from .researcher import researcher 

    app.register_blueprint(views,url_prefix='/')

    return app
