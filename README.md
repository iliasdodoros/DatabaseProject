# ELIDEK

## Partners 

1. Ntontoros Ilias
3. Chatzilia Iliana
4. Kitsis Theodoros Ioannis

## Requirements

- MariaDB
- Flask 
- requests
- python-dateutil
- mysql-connector-python 

## ER-Diagram

![](https://github.com/iliasdodoros/DatabaseProject/blob/main/Diagrams/ER%20diagram.jpg)

## Relational Model

![](https://github.com/iliasdodoros/DatabaseProject/blob/main/Diagrams/relational.png)

## Installation
1. At first, make sure you have installed MariaDB on your computer. [Download page](https://mariadb.org/download/?t=mariadb&p=mariadb&r=10.6.8&os=windows&cpu=x86_64&pkg=msi&m=nxtHost#entry-header)
2. Then, connect to the server throught a DBMS (DBeaver).

### Run the following sql queries inside the DMBS (at this order ).

3. [triggers.sql](db/triggers.sql) to create triggers .
4. [create_db.sql](db/create_db.sql) to create the database,the tables and the indexes .
5. [insert_data.sql](db/insert_data.sql) to insert data .


### Download and run the web-app 
6. Run,

```bash
	$ git clone https://github.com/iliasdodoros/DatabaseProject.git
	$ cd DatabaseProject 
```

7. Run the following to download all required libraries,

```bash
	$ pip install mysql-connector-python
	$ pip install Flask 
	$ pip install requests
	$ pip install python-dateutil

```

8. Run the following script to enter the Project folder and start the web-server,

```bash
	$ cd website
	$ python main.py
```

9. Open your browser and type <http://127.0.0.1:5000/> to preview the website.

## SQL Queries

Here we show all the [Queries](db/all_queries.sql) used in the site at each page.
Find the questions for the queries attached to the file [Εκφωνήσεις](Documents/Εκφώνηση.pdf)
