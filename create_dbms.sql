use elidek;
show tables;

CREATE TABLE Stelehos
(
  name VARCHAR(45)NOT NULL,
  stelehos_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (stelehos_id)
);

CREATE TABLE Research_Field
(
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (name)
);

CREATE TABLE Programm
(
  name VARCHAR(45) NOT NULL,
  address VARCHAR(45) NOT NULL,
  programm_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (programm_id)
);

CREATE TABLE Organisation
(
  name VARCHAR(45) NOT NULL,
  postcode INT DEFAULT NULL,
  street VARCHAR(45) DEFAULT NULL,
  city VARCHAR(45) NOT NULL,
  short VARCHAR(15) DEFAULT NULL,
  organisation_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (organisation_id)
);

alter table Organisation add constraint check(postcode > 0); 

CREATE TABLE Company
(
  idia_kefalaia INT NOT NULL,
  organisation_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (organisation_id),
  CONSTRAINT `fk_company_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

alter table Company add constraint check(idia_kefalaia > 0); 

CREATE TABLE University
(
  Proupologismos_apo_Ypourgeio_Paideias INT NOT NULL,
  organisation_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (organisation_id),
  CONSTRAINT `fk_university_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

alter table University add constraint check(Proupologismos_apo_Ypourgeio_Paideias > 0); 


CREATE TABLE Research_Center
(
  Proupologismos_apo_Idiotikes_draseis INT NOT NULL,
  Proupologismos_apo_Ypourgeio_Paideias INT NOT NULL,
  organisation_id SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (organisation_id),
  CONSTRAINT `fk_research_center_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

alter table Research_center add constraint check(Proupologismos_apo_Ypourgeio_Paideias > 0); 
alter table Research_center add constraint check(Proupologismos_apo_Idiotikes_draseis > 0); 


CREATE TABLE Organisation_Phones
(
  phones VARCHAR(20) NOT NULL,
  organisation_id SMALLINT unsigned NOT NULL,
  PRIMARY KEY (phones, organisation_id),
  CONSTRAINT `fk_phone_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Researcher
(
  sex VARCHAR(10) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  date_of_birth VARCHAR(20) NOT NULL,
  name VARCHAR(45) NOT NULL,
  researcher_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT NOT NULL,
  organisation_id SMALLINT unsigned NULL,
  PRIMARY KEY (researcher_id),
  CONSTRAINT `fk_researcher_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE set NULL ON UPDATE CASCADE
);

CREATE TABLE Project
(
  amount INT NOT NULL,
  title VARCHAR(45) NOT NULL,
  beginning VARCHAR(20) NOT NULL,
  summary VARCHAR(45) NOT NULL,
  ending VARCHAR(20) NOT NULL,
  project_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  grade INT NOT NULL,
  date VARCHAR(20) NOT NULL,
  stelehos_id SMALLINT UNSIGNED NULL,
  programm_id SMALLINT unsigned NULL,
  supervisor_id SMALLINT UNSIGNED NULL,
  grader_id SMALLINT UNSIGNED NULL,
  organisation_id SMALLINT unsigned NULL,
  PRIMARY KEY (project_id),
  CONSTRAINT `fk_project_stelehos` FOREIGN KEY (stelehos_id) REFERENCES Stelehos(stelehos_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_programm` FOREIGN KEY (programm_id) REFERENCES Programm(programm_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_supervisor` FOREIGN KEY (supervisor_id) REFERENCES Researcher(researcher_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_grader` FOREIGN KEY (grader_id) REFERENCES Researcher(researcher_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE set NULL ON UPDATE CASCADE
);

CREATE TABLE Delivered
(
  title VARCHAR(45) NOT NULL,
  summary VARCHAR(45) NOT NULL,
  delivered_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  project_id SMALLINT unsigned NOT NULL ,
  PRIMARY KEY (delivered_id),
  CONSTRAINT `fk_delivered_project` FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Project_Research_Field
(
  project_id SMALLINT UNSIGNED NOT NULL ,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (project_id, name),
  CONSTRAINT `fk_pr_research_field_project` FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE ON UPDATE cascade,
  CONSTRAINT `fk_pr_research_field_research_field` FOREIGN KEY (name) REFERENCES Research_Field(name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Works_in_Project
(
  project_id SMALLINT UNSIGNED NOT NULL ,
  researcher_id SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (project_id, researcher_id),
  CONSTRAINT `fk_works_in_project_project` FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE ON UPDATE cascade,
  CONSTRAINT `fk_works_in_project_researcher` FOREIGN KEY (researcher_id) REFERENCES Researcher(researcher_id) ON DELETE CASCADE ON UPDATE cascade
);

alter table Project add constraint check(amount between 100000 and 1000000);

alter table Project add constraint check(beginning < ending);

alter table Project add constraint check(grade > 0);




INSERT INTO Programm
	(`Name`,`Address`,`Programm_id`) 
VALUES 
	('αναδάσωση','διευθυνση','01');

INSERT INTO Stelehos 
	(`name`,`stelehos_id`) 
VALUES 
	('john marakis','1'),
	('katy vlacha','2'),
	('perry platipodas','3'),
	('nick thegreek','4'),
	('vikaki glampidaki','5'),
	('marios nananis','6'),
	('captain ntontoros','7'),
	('giannis kitsis','8'),
	('iliana chatzi','9'),
	('pinelopi katsarea','10'),
	('manos chatzak','11'),
	('oraia koimomeni','12'),
	('kiki kotoula','13'),
	('loula kaloula','14'),
	('peggy gou','15');

INSERT INTO Research_field
	(`name`) 
VALUES 
	('mathematics'),
	('history'),
	('physics'),
	('economics'),
	('chemistry'),
	('sociology'),
	('polics'),
	('astrology');


INSERT INTO Organisation 
	(`name`,`postcode`,`street`,`city`,`short`,`organisation_id`) 
VALUES 
	

INSERT INTO Company
	(`idia_kefalaia`,`organisation_id`) 
VALUES 


INSERT INTO University
	(`Proupologismos_apo_Ypourgeio_Paideias`,`organisation_id`) 
VALUES 


INSERT into Research_center 
	(` Proupologismos_apo_Idiotikes_draseis`,`Proupologismos_apo_Ypourgeio_Paideias`,`organisation_id`) 
VALUES 

INSERT into Organisation_phones  
	(` phones`,`organisation_id`) 
VALUES 

INSERT into Researcher
	(` sex`,`last_name`,`date_of_birth`,`name`,`researcher_id`,`organisation_id`) 
VALUES 
	('male','Papadopoulos','01-03-1970','Petros','1','1'),
	('male','Snoop','04-04-1974','Dog','2','1'),
	('male','Leventis','13-01-1980','Alekos','3','1'),
	('male','Mitsotakis','05-03-1990','Koulis','4','1'),
	('male','Tsipras','23-03-1987','Alex','5','1'),
	('male','Koutsoubas','12-02-1950','Mitsos','6','1'),
	('male','Arrow','01-10-1963','Nikolas','7','1'),
	('male','Man','01-05-1969','Bat','8','1'),
	('male','Tiesto','04-08-1982','Giorgos','9','1'),
	('male','Road','01-01-1997','Runner','10','1'),
	('male','Panos','01-11-1911','Panagiotis','11','1'),
	('male','Crazy','09-09-1990','Thomas','12','1'),
	('male','Persis','01-01-2001','Propersis','13','1'),
	('male','Kamir','22-01-2001','Omar','14','1'),
	('male','Gravanis','05-02-1996','Marios','15','1'),
	('male','Kitsakos','01-03-1970','Theo','16','1'),
	('male','Maggouras','01-03-1970','Stavros','17','1'),
	('male','Kostadaras','01-03-1970','Petros','18','1'),
	('male','Variabasis','01-03-1970','Lampros','19','1'),
	('male','Kapetanakis','01-03-1970','Mimis','20','1'),
	('male','Mitropanos','01-03-1970','Mitsos','21','1'),
	('male','Kouridakis','01-03-1970','Leonardo','22','1'),
	('male','Kiamos','01-03-1970','Panagiotis','23','1'),
	('male','Vertis','01-03-1970','Nikolaos','24','1'),
	('male','Tsiknakis','01-03-1970','Emanouil','25','1'),
	('female','Anyfanti','01-03-1970','Xenia','26','1'),
	('female','Kiori','01-03-1970','Sara','27','1'),
	('female','Tsagri','01-03-1970','Efro','28','1'),
	('female','Katsarea','01-03-1970','Milena','29','1'),
	('female','Paparizoy','01-03-1970','Elena','30','1'),
	('female','Kalifoni','01-03-1970','Garifalia','31','1'),
	('female','Salamouri','01-03-1970','Liana','32','1'),
	('female','Miziou','01-03-1970','Keisi','33','1'),
	('female','Spinoula','01-03-1970','Sofiana','34','1'),
	('female','Mouse','01-03-1970','Mini','35','1'),
	('female','Hadid','01-03-1970','Bella','36','1'),
	('female','Hadid','01-03-1970','Gigi','37','1'),
	('female','Kardasian','01-03-1970','Kim','38','1'),
	('female','Kendall','01-03-1970','Jenner','39','1'),
	('female','Queen','01-03-1970','Viktoria','40','1'),
	('female','Diva','01-03-1970','Konstantina','41','1'),
	('female','Barbenia','01-03-1970','Barbie','42','1'),
	('female','Klouni','01-03-1970','Georgia','43','1'),
	('female','Ronaldo','01-03-1970','Christiana','44','1'),
	('female','Kennedy','01-03-1970','Ioanna','45','1'),
	('female','Vern','01-03-1970','Ioulia','46','1'),
	('female','Romea','01-03-1970','Ioulieta','47','1'),
	('female','Pedozali','01-03-1970','Koula','48','1'),
	('female','Kritikia','01-03-1970','Stefania','49','1'),
	('female','Aggelidou','01-03-1970','Aggeliki','50','1'),
	

INSERT into Project
	(` amount`,`title`,`beginning`,`summary`,`ending`,`project_id`,`grade`,`date`,`stelehos_id`,`programm_id`,`supervisor_id`,`grader_id`,`organisation_id`) 
VALUES 
	('200.000','τιτλοσ εργου','01-01-2020','περιληψη γραψε μαλακιεσ φαση ωβηξωβηθσωψσξψ','01-01-2023','1','7','03-12-2019','1','1','1','1','1'),
	
INSERT into Delivered
	(`title`,`summary`,`delivered_id`,`project_id`) 
VALUES 

INSERT into Project_research_field 
	(`project_id`,`name`) 
VALUES 

INSERT into Works_in_project  
	(`project_id`,`researcher_id`) 
VALUES 







