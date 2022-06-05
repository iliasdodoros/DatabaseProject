# ELIDEK

## Contributors

1. Ntontoros Ilias
3. Chatzilia Iliana
4. Kitsis Theodoros Ioannis

## [Requirements]

- MariaDB
- Flask 
- requests
- python-dateutil
- mysql-connector-python 

## ER-Diagram

![](https://github.com/nickbel7/hotel-management/blob/main/Diagrams(ERD%2CRelational)/ERD.jpg)

## Relational Model

![](https://github.com/nickbel7/hotel-management/blob/main/Diagrams(ERD%2CRelational)/RelationalDiagram.png?raw=true)
![](https://github.com/nickbel7/hotel-management/blob/main/Diagrams(ERD%2CRelational)/RelationalDiagram.jpg)

## Installation
1. At first, make sure you have installed MariaDB on your computer. [Download page](https://mariadb.org/download/?t=mariadb&p=mariadb&r=10.6.8&os=windows&cpu=x86_64&pkg=msi&m=nxtHost#entry-header)
2. Then, connect to the server throught a DBMS (DBeaver).

### Run the following sql queries inside the DMBS (at this spesific order !).

3. [create_db.sql](db/create_db.sql) to create the database,the tables and the indexes .
4. [insert_data.sql](db/insert_data.sql) to insert data .
5. [triggers.sql](db/triggers.sql) to create triggers .

### Download and run the web-app 
7. Run,

```bash
	$ git clone https://github.com/nickbel7/hotel-management.git
	$ cd hotel-management
```

9. Add your database credentials (preferably use sa user to have all privileges) at the top of the [app.py](Project/app.py) file,
```bash
	ql_user = '**'
	sql_password = '****'
	sql_server_name = '*******'
	sql_database_name = 'HotelManagement'
```
10. Run the following script to download all required libraries,

```bash
	$ pip install -r requirements.txt
```

11. Run the following script to enter the Project folder and start the web-server,

```bash
	$ cd Project
	$ python -m flask run
```

12. Open your browser and type <http://127.0.0.1:5000/> to preview the website.

## SQL Queries

Here we show all the [Queries](SQL_Code/PROJECT_QUERIES.sql) used in the site at each page.
Find the questions for the queries attached to the file [Εκφωνήσεις](Docs/Εκφώνηση.pdf)

## YouTube
Explaining in Greek language how to use our wep application and what queries are used in each page.<br />
<https://youtu.be/qY2IX3AB5gI>
