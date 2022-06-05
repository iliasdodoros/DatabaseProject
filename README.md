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
1. At first, make sure you have installed sql server 2019 (express) on your computer. [Download page](https://www.microsoft.com/en-us/download/details.aspx?id=101064)
2. Then, connect to the server throught a DBMS (preferably Microsoft SQL Management Studio) with sa (system administrator) credentials.

### Run the following sql queries inside the DMBS (at this spesific order !).

3. [CREATE_tables.sql](SQL_Code/CREATE_tables.sql) to create the database and the tables.
4. [CREATE_indexes.sql](SQL_Code/CREATE_indexes.sql) to create the indexes.
5. [CREATE_views_1.sql](SQL_Code/CREATE_views_1.sql) and [CREATE_views_2.sql](SQL_Code/CREATE_views_2.sql) to create the required views.

### Insert Mock Data in the database

6. Insert Data from the excel [HotelManagement-Data.xlsx](Mock_Data/HotelManagement_V2.xlsx) throught the Import / Export wizard of Microsoft Management Studio <br />
##### (Attention !) - Insert the data table by table with strictly the following order and by enabling the identity insert in the "Edit mappings" option for each table.
	Reservations
	Reservations
	HotelServices
	HotelLocations
	Doors
	HotelRooms
	ReservationCustomers
	ReservationServices
	ReservationRooms
	DoorAccessLog
OR <br />
Directly insert the Backup (.bak file) of the database with all the data located here [HotelManagement.bak](DB-Backup/HotelManagement_V2.bak)
```bash
	Databases (Right-click) > Restore Database..
```

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
