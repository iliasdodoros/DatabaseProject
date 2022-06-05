DROP SCHEMA IF EXISTS elidek;
CREATE SCHEMA elidek;
use elidek;

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
  PRIMARY KEY (organisation_id),
  KEY idx_name (name)
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
  KEY idx_fk_organisation_id (organisation_id),
  KEY idx_date_of_birth (date_of_birth),
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
  KEY idx_fk_stelehos_id (stelehos_id),
  KEY idx_fk_programm_id (programm_id),
  KEY idx_fk_supervisor_id (supervisor_id),
  KEY idx_fk_grader_id (grader_id),
  KEY idx_fk_organisation_id (organisation_id),
  KEY idx_title (title),
  KEY idx_beginning (beginning),
  KEY idx_ending (ending),
  KEY idx_duration (duration),
  CONSTRAINT `fk_project_stelehos` FOREIGN KEY (stelehos_id) REFERENCES Stelehos(stelehos_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_programm` FOREIGN KEY (programm_id) REFERENCES Programm(programm_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_supervisor` FOREIGN KEY (supervisor_id) REFERENCES Researcher(researcher_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_grader` FOREIGN KEY (grader_id) REFERENCES Researcher(researcher_id) ON DELETE set NULL ON UPDATE cascade,
  CONSTRAINT `fk_project_organisation` FOREIGN KEY (organisation_id) REFERENCES Organisation(organisation_id) ON DELETE set NULL ON UPDATE CASCADE
);

alter table Project add constraint check(amount between 100000 and 1000000);

alter table Project add constraint check(beginning < ending);

alter table project add constraint check(date_of_grading < beginning);

alter table Project add constraint check(grade between 0 and 10);

alter table Project add constraint check(duration between 12 and 48); 

CREATE TABLE Delivered
(
  title VARCHAR(45) NOT NULL,
  summary VARCHAR(45) NOT NULL,
  delivered_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  project_id SMALLINT unsigned NOT NULL ,
  PRIMARY KEY (delivered_id),
  KEY idx_fk_project_id (project_id),
  CONSTRAINT `fk_delivered_project` FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Project_Research_Field
(
  project_id SMALLINT UNSIGNED NOT NULL ,
  name VARCHAR(45) NOT NULL,
  PRIMARY KEY (project_id, name),
  CONSTRAINT `fk_pr_research_field_project` FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pr_research_field_research_field` FOREIGN KEY (name) REFERENCES Research_Field(name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Works_in_Project
(
  project_id SMALLINT UNSIGNED NOT NULL ,
  researcher_id SMALLINT UNSIGNED NOT NULL ,
  PRIMARY KEY (project_id, researcher_id),
  CONSTRAINT `fk_works_in_project_project` FOREIGN KEY (project_id) REFERENCES Project(project_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_works_in_project_researcher` FOREIGN KEY (researcher_id) REFERENCES Researcher(researcher_id) ON DELETE CASCADE ON UPDATE CASCADE
);
