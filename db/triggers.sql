DELIMITER $$

create trigger insert_in_project_1
before insert on Project  
for each row 
begin 
	if(new.supervisor_id in (select researcher_id 
	from researcher 
	where organisation_id = new.organisation_id) 
	and 
	new.grader_id not in (select researcher_id 
	from researcher 
	where organisation_id = new.organisation_id)
	and
	new.supervisor_id not in (select researcher_id 
	from works_in_project
	where project_id = new.project_id ))
	then 
	INSERT INTO elidek.Project (amount,title,beginning,ending,duration,summary,grade,date_of_grading,stelehos_id,programm_id,supervisor_id,grader_id,organisation_id) VALUES
	  (new.amount,new.title ,new.beginning ,new.ending ,new.duration ,new.summary ,new.grade ,new.date_of_grading,new.stelehos_id,new.programm_id,new.supervisor_id,new.grader_id,new.organisation_id);
	end if;	
end $$

delimiter ;


-- drop trigger ins_in_project_1 ;
-- INSERT INTO elidek.Project (amount,title,beginning,ending,duration,summary,grade,date_of_grading,stelehos_id,programm_id,supervisor_id,grader_id,organisation_id) VALUES
	-- (100009,'lol' ,'2000-01-01' ,'2001-01-01' ,12 ,'lllllll' ,5 ,'1999-02-02',6,3,3,1,1);
-- delete from project where grader_id =1 and organisation_id =1;
	
--------------------------------------------------------------------------------------------------------------

DELIMITER $$

create trigger ins_in_wip
before insert on Works_in_Project 
for each row 
begin 
	if(new.researcher_id not in (select p.supervisor_id 
	from project p 
	inner join works_in_project wip on p.project_id = wip.project_id 
	where p.project_id = new.project_id)
	and
	new.researcher_id in (select r.researcher_id 
	from researcher r
	inner join project p2 on r.organisation_id = p2.organisation_id
	where p2.project_id = new.project_id))
	then 
	insert into works_in_project(`project_id`,`researcher_id`) values(new.project_id, new.researcher_id);
end if;
end $$

delimiter ;

-- drop trigger ins_in_wip ;

-- insert into works_in_project 
-- 	(`project_id`,`researcher_id`) 
-- VALUES
-- 	('1','1')
	
-- delete from works_in_project where project_id =1 and researcher_id =1;
