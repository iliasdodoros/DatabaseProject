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

alter table Research_Center add constraint check(Proupologismos_apo_Ypourgeio_Paideias > 0); 
alter table Research_Center add constraint check(Proupologismos_apo_Idiotikes_draseis > 0); 


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
  date_of_birth date NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  researcher_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT NOT NULL,
  organisation_id SMALLINT unsigned NULL,
  PRIMARY KEY (researcher_id),
  CONSTRAINT `fk_researcher_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE set NULL ON UPDATE CASCADE
);

CREATE TABLE Project
(
  amount INT NOT NULL,
  title VARCHAR(45) NOT NULL,
  beginning date NOT NULL,
  ending date NOT NULL,
  duration SMALLINT NOT NULL,
  summary VARCHAR(200) NOT NULL,
  project_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  grade INT NOT NULL,
  date_of_grading date NOT NULL,
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

-- alter table Project add constraint check(beginning < ending);

alter table Project add constraint check(grade > 0);



INSERT INTO Programm
	(`Name`,`Address`,`Programm_id`) 
VALUES 
	('Simple Solution','Science','1'),
	('Bean Blowers','Science','2'),
	('Milk Science','Science','3'),
	('Octopusus','Science','4'),
	('The Fig Neutrons','Science','5'),
	('Guardian Team','Science','6'),
	('Great Society','Society','7'),
	('Bilingual Education Act','Society','8'),
	('DC Commission on the Arts and Humanities','Society','9'),
	('Economic Opportunity Act of 1964','Society','10'),
	('Elementary and Secondary Education Act','Society','11'),
	('Higher Education Act of 1965','Society','12'),
	('Support Central','Administration services','13'),
	('The Office Management Team','Administration services','14'),
	('Office Agents','Administration services','15'),
	('Better Business Assistants','Administration services','16'),
	('Smooth Operators','Administration services','17'),
	('Agents of Reception','Administration services','18'),
	('Pillar Staff','Administration services','19'),
	('Secureoffice','Administration services','20'),
	('Amazon Lab126','Research & Innovation Center','21'),
	('Verizon 5G Labs','Research & Innovation Center','22'),
	('Volkswagen Automative Innovation Lab','Research & Innovation Center','23'),
	('Capital One Labs','Research & Innovation Center','24'),
	('Canadian Food Inspection Agency','Research & Innovation Center','25'),
	('Palo Alto Research Center ','Research & Innovation Center','26'),
	('AT&T Research','Research & Innovation Center','27'),
	('MIT Media Lab','Research & Innovation Center','28'),
	('Boston Dynamics','Research & Innovation Center','29'),
	('IBM Research','Research & Innovation Center','30');

INSERT INTO Stelehos 
	(`name`,`stelehos_id`) 
VALUES 
	('Johnny Depp','1'),
	('Katy Vlacha','2'),
	('Perry Platipodas','3'),
	('Nick Thegreek','4'),
	('Vikaki Glampidaki','5'),
	('Marios Nananis','6'),
	('Captain Ntontoros','7'),
	('Giannis Kitsis','8'),
	('Iliana Chatzi','9'),
	('Pinelopi Katsarea','10'),
	('Manos Chatzak','11'),
	('Oraia Koimomeni','12'),
	('Kiki Kotoula','13'),
	('loula Kaloula','14'),
	('Peggy Gou','15');

INSERT INTO Research_Field
	(`name`) 
VALUES 
	('Mathematics'),
	('History'),
	('Physics'),
	('Economics'),
	('Chemistry'),
	('Sociology'),
	('Polics'),
	('Astrology');


INSERT INTO Organisation 
	(`name`,`postcode`,`street`,`city`,`short`,`organisation_id`) 
VALUES 
	('Adidas','34521','Armatolwn&klefton 55','Athens','Adi','1'),
	('Nike','43564','Aleksandrou Palli 16','Ioannina','N','2'), 
	('Adobe','12345','Oropos 43','Tokyo','Ado','3'),
	('Amazon','76890','Themistoklhs 76','Milan','Am','4'), 
	('AMC Theaters','37896','Clean 98','Barcelona','AMC','5'), 
	('Arbys','14567','Kapodistrias 111','London','Ar','6') ,
	('ArmHammer','25432','Kitsis 23','Rome','Arm','7'),
	('Atari','45333','kyknos 45','Liverpool','At','8'), 
	('Audi','21212','Gonzeght 58','Munchen','A','9') ,
	('Canon','86535','Arsher 90','Rio','C','10'),
	('Coca-Cola','55555','Lex 200','Larisa','C&C','11') ,
	('ConocoPhillips','67765','DojaCat 54','Chios','C&P','12'), 
	('eBay','21777','Kapodistrias 1','Madrid','e','13'),
	('Garmin','61000','Papandreou 2','New York','G','14'),
	('Geico','50912','Kwlokotronis 3','Los Angeles','G','15'),
	('Hasbro','44309','Ntontoros 69','Salonica','Adi','16') ,
	('IBM','10753','Hawkeye 32','Sevilla','IBM','17'),
	('Ikea','11259','Geror 32-34','Paris','Ikea','18') ,
	('Kia','34768','Armetit 21','Mexico city','Kia','19') ,
	('Lego','27190','Armadilo 56','Miami','Lego','20'),
	('Nikon','32567','Elephant 77','Lyon','Nik','21') ,
	('Nintendo','71811','Pekintot 22','Peking','Nit','22') ,
	('Nissan','12678','Mpakou 23','Kalamata','Nis','23'), 
	('Pepsi','15023','Themistokleous 33','Athens','Pep','24'), 
	('Qualcomm','07652','Downhill 45-46','Lyon','Q','25'),
	('Reebok','45003','Streetman 41','Miami','R','26') ,
	('Saab','17754','Mpsotriker 2','Cairo','S','27'),
	('Sega','66654','Yodaryot','New York','Sega','28') ,
	('Sony','20202','Aouts 33','Athens','Sony','29') ,
	('Starbucks','29298','Priceless 44','Tokyo','Star','30');
	

INSERT INTO Company
	(`idia_kefalaia`,`organisation_id`) 
VALUES 
	('1000000','1'),
	('2000000','2'),
	('1200000','3'),
	('4380000','4'),
	('5400000','5'),
	('6532000','6'),
	('7899000','7'),
	('1222000','8'),
	('5420000','9'),
	('6580000','10');

INSERT INTO University
	(`Proupologismos_apo_Ypourgeio_Paideias`,`organisation_id`) 
VALUES 
	('6444000','11'),
	('1000000','12'),
	('5500000','13'),
	('1420000','14'),
	('2580000','15'),
	('2100000','16'),
	('3090000','27'),
	('2016000','28'),
	('6260000','29'),
	('1112000','30');

INSERT into Research_Center 
	(`Proupologismos_apo_Idiotikes_draseis`,`Proupologismos_apo_Ypourgeio_Paideias`,`organisation_id`) 
VALUES 
	('2445000','3874209','17'),
	('2000700','1000000','18'),
	('2100000','9283000','19'),
	('1190000','3000000','20'),
	('2110000','2000000','21'),
	('7700000','1000000','22'),
	('2445000','9999999','23'),
	('2000700','1234567','24'),
	('2100000','987654','25'),
	('1190000','8000000','26');

INSERT into Organisation_Phones  
	(`phones`,`organisation_id`) 
VALUES 
	('(802) 898-8461','1'),
	('(338) 302-6974','2'),
	('(474) 993-6962','3'),
	('(735) 587-7459','4'),
	('(220) 551-9007','5'),
	('(845) 409-4381','6'),
	('(296) 743-5326','7'),
	('(994) 202-9026','8'),
	('(870) 591-9632','9'),
	('(569) 487-2723','10'),
	('(432) 253-6502','11'),
	('(911) 560-4301','12'),
	('(576) 926-4811','13'),
	('(539) 981-5542','14'),
	('(712) 951-7958','15'),
	('(491) 928-3296','16'),
	('(659) 917-1478','17'),
	('(390) 780-3535','18'),
	('(864) 305-1398','19'),
	('(817) 778-2763','20'),
	('(528) 219-2927','21'),
	('(607) 625-1524','22'),
	('(502) 522-2287','23'),
	('(615) 688-0270','24'),
	('(220) 698-3130','25'),
	('(497) 934-9029','26'),
	('(474) 864-5314','27'),
	('(610) 548-6189','28'),
	('(649) 564-7200','29'),
	('(253) 207-8495','30'),
	('(591) 416-7969','2'),
	('(399) 895-4995','2'),
	('(776) 850-7974','5'),
	('(634) 988-0225','6'),
	('(237) 462-4545','10'),
	('(562) 754-9733','10'),
	('(423) 581-7906','14'),
	('(359) 866-1105','17'),
	('(596) 841-4948','18'),
	('(574) 542-7174','19'),
	('(814) 778-6656','19'),
	('(877) 830-5668','27'),
	('(367) 694-9211','27'),
	('(373) 377-7789','30'),
	('(678) 801-0357','30'),
	('(301) 912-5633','22'),
	('(934) 336-3549','21'),
	('(300) 408-3092','20'),
	('(445) 807-4497','4'),
	('(516) 978-4903','4');

INSERT into Researcher
	(`sex`,`last_name`,`date_of_birth`,`first_name`,`researcher_id`,`organisation_id`) 
VALUES 
	('male','Papadopoulos','1970-01-03','Petros','1','1'),
	('male','Snoop','1974-04-04','Dog','2','2'),
	('male','Leventis','1980-12-01','Alekos','3','3'),
	('male','Mitsotakis','1990-05-03','Koulis','4','4'),
	('male','Tsipras','1987-03-04','Alex','5','5'),
	('male','Koutsoubas','1950-12-02','Mitsos','6','6'),
	('male','Arrow','1963-01-10','Nikolas','7','7'),
	('male','Man','1969-01-05','Bat','8','8'),
	('male','Tiesto','1982-04-08','Giorgos','9','9'),
	('male','Road','1997-01-01','Runner','10','10'),
	('male','Panos','1931-01-11','Panagiotis','11','11'),
	('male','Crazy','1990-09-09','Thomas','12','12'),
	('male','Persis','2001-01-01','Propersis','13','13'),
	('male','Kamir','2001-11-08','Omar','14','14'),
	('male','Gravanis','1996-05-02','Marios','15','15'),
	('male','Kitsakos','1977-08-03','Theo','16','16'),
	('male','Maggouras','1980-01-06','Stavros','17','17'),
	('male','Kostadaras','1984-11-03','Petros','18','18'),
	('male','Variabasis','1980-05-03','Lampros','19','19'),
	('male','Kapetanakis','1999-07-03','Mimis','20','20'),
	('male','Mitropanos','1990-09-03','Mitsos','21','21'),
	('male','Kouridakis','1988-01-15','Leonardo','22','22'),
	('male','Kiamos','1976-04-13','Panagiotis','23','23'),
	('male','Vertis','1970-05-09','Nikolaos','24','24'),
	('male','Tsiknakis','1976-02-03','Emanouil','25','25'),
	('female','Anyfanti','1984-01-06','Xenia','26','26'),
	('female','Kiori','1990-01-08','Sara','27','27'),
	('female','Tsagri','1993-01-11','Efro','28','28'),
	('female','Katsarea','1970-04-03','Milena','29','29'),
	('female','Paparizoy','1979-11-08','Elena','30','30'),
	('female','Kalifoni','1971-01-03','Garifalia','31','1'),
	('female','Salamouri','1990-07-07','Liana','32','2'),
	('female','Miziou','1992-04-03','Keisi','33','3'),
	('female','Spinoula','1980-05-03','Sofiana','34','4'),
	('female','Mouse','1978-08-23','Mini','35','5'),
	('female','Hadid','1970-06-06','Bella','36','6'),
	('female','Hadid','1978-05-05','Gigi','37','7'),
	('female','Kardasian','1999-01-03','Kim','38','8'),
	('female','Kendall','1973-07-26','Jenner','39','9'),
	('female','Queen','1979-01-24','Viktoria','40','10'),
	('female','Diva','1980-01-03','Konstantina','41','11'),
	('female','Barbenia','1993-05-07','Barbie','42','12'),
	('female','Klouni','1990-06-12','Georgia','43','13'),
	('female','Ronaldo','1987-05-13','Christiana','44','14'),
	('female','Kennedy','1976-05-12','Ioanna','45','15'),
	('female','Vern','1979-06-15','Ioulia','46','16'),
	('female','Romea','1982-12-04','Ioulieta','47','17'),
	('female','Pedozali','1976-07-17','Koula','48','18'),
	('female','Kritikia','1988-07-12','Stefania','49','19'),
	('female','Aggelidou','1994-01-05','Aggeliki','50','20'),
	('male','Georgoulas','1990-11-08','Petros','51','21'),
	('male','Patsiouras','1974-04-04','Dog','52','22'),
	('male','Muska','1980-13-01','Alekos','53','23'),
	('male','Mitsotakis','1990-05-03','Giannis','54','24'),
	('male','Georgiou','1987-23-03','Alex','55','25'),
	('male','Koutsoubas','1950-12-02','Dimitris','56','26'),
	('male','Mac','1963-01-10','Nikolas','57','27'),
	('male','Man','1969-01-05','Bat','58','28'),
	('male','Tiesto','1982-04-08','Giorgos','59','29'),
	('male','Mpimpos','1997-01-01','Runner','60','30'),
	('male','Panos','1911-01-11','Babis','61','1'),
	('male','Devil','1990-09-09','Thomas','62','2'),
	('male','Persis','2001-01-01','Jackson','63','3'),
	('male','Kamir','2001-12-01','Omar','64','4'),
	('male','Gravanis','1996-05-02','Marios','65','5'),
	('male','Kitsis','1974-14-05','Theo','66','6'),
	('male','Maggouras','1978-01-08','Stavros','67','7'),
	('male','Kostadaras','1980-05-05','Petros','68','8'),
	('male','Vasis','1971-11-01','Lampros','69','9'),
	('male','kapetanos','1979-10-06','Mimis','70','10'),
	('male','Panos','1980-06-06','Mitsos','71','11'),
	('male','Di Vinci','1990-01-05','Leonardo','72','12'),
	('male','Kiamos','1975-05-05','Panos','73','13'),
	('male','Motsis','1988-11-08','Nikolaos','74','14'),
	('male','Tsiknakis','1988-02-04','Emanouil','75','15'),
	('female','Maria','1970-01-12','Xenia','76','16'),
	('female','Paparizoy','1975-05-03','Sara','77','17'),
	('female','Tsagri','1950-04-03','Ioanna','78','18'),
	('female','Iiadou','1972-21-12','Milena','79','19'),
	('female','Kiori','1971-21-03','Elena','80','20'),
	('female','Kalifoni','1980-11-10','Maria','81','21'),
	('female','Liatsou','1972-02-12','Liana','82','22'),
	('female','Miziou','1971-04-04','Keisi','83','23'),
	('female','Pianou','1971-11-11','Nicky','84','24'),
	('female','Mouse','1973-15-03','Mini','85','25'),
	('female','Hadid','1979-01-08','Bella','86','26'),
	('female','Hadid','1978-01-08','Gigi','87','27'),
	('female','Kardasian','1970-10-05','Kim','88','28'),
	('female','Kendall','1976-06-06','Jenner','89','29'),
	('female','Queen','1975-01-25','Viktoria','90','30'),
	('female','Diva','1999-03-03','Konstantina','91','1'),
	('female','Barbenia','1971-11-21','Barbie','92','2'),
	('female','Klouni','1972-01-02','Georgia','93','3'),
	('female','Ronaldo','1977-01-15','Christin','94','4'),
	('female','Kennedy','1978-01-07','Ioanna','95','5'),
	('female','Vern','1977-02-13','Ioulia','96','6'),
	('female','Romea','1970-08-12','Ioulieta','97','7'),
	('female','Delaporta','1970-01-13','Koula','98','8'),
	('female','Kirki','1972-01-04','Kleopatra','99','9'),
	('female','Aggeliou','1974-01-04','Aggeliki','100','10');
	

INSERT into Project
	(`amount`,`title`,`beginning`,`ending`,`duration`,`summary`,`project_id`,`grade`,`date_of_grading`,`stelehos_id`,`programm_id`,`supervisor_id`,`grader_id`,`organisation_id`) 
VALUES 
	('200.000','Mopping the sea','01-01-2020','01-01-2023','3','lorem ipsum','1','1','1','1','1','1'),
	
-- INSERT into Delivered
-- 	(`title`,`summary`,`delivered_id`,`project_id`) 
-- VALUES 

-- INSERT into Project_research_field 
-- 	(`project_id`,`name`) 
-- VALUES 

-- INSERT into Works_in_project  
-- 	(`project_id`,`researcher_id`) 
-- VALUES 







