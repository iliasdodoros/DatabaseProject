DELIMITER $$

create trigger insert_in_project
before insert on Project  
for each row 
begin 
	if(new.supervisor_id not in (select researcher_id 
	from Researcher 
	where organisation_id = new.organisation_id) 
	or 
	new.grader_id  in (select researcher_id 
	from Researcher 
	where organisation_id = new.organisation_id))
	then 
	signal sqlstate '45000' set MESSAGE_TEXT = 'Wrong data input. Supervisor must work in the organisation that handles the project and the grader must be from a different organisation.';  
	end if;	
end $$

delimiter ;
-------------------------------------------------

DELIMITER $$

create trigger update_in_project
before update on Project  
for each row 
begin 
	if(new.supervisor_id not in (select researcher_id 
	from Researcher 
	where organisation_id = new.organisation_id) 
	or 
	new.grader_id  in (select researcher_id 
	from Researcher 
	where organisation_id = new.organisation_id)
	or
	new.supervisor_id not in (select researcher_id 
	from Works_in_Project
	where project_id = new.project_id ))
	then 
	signal sqlstate '45000' set MESSAGE_TEXT = 'Wrong data input. Supervisor must work in the organisation that handles the project and the grader must be from a different organisation.';  
	end if;	
end $$

delimiter ;

------------------------------------------------------------------------

DELIMITER $$

create trigger ins_in_wip
before insert on Works_in_Project 
for each row 
begin 
	if(new.researcher_id in (select p.supervisor_id 
	from Project p 
	inner join Works_in_Project wip on p.project_id = wip.project_id 
	where p.project_id = new.project_id)
	or
	new.researcher_id not in (select r.researcher_id 
	from Researcher r
	inner join Project p2 on r.organisation_id = p2.organisation_id
	where p2.project_id = new.project_id))
	then 
	signal sqlstate '45000' set MESSAGE_TEXT = 'Wrong data input. Researcher must work in the organisation that handles the project and should not be supervisor of that project.';  
end if;
end $$

delimiter ;

----------------------------------------------------------------

DELIMITER $$

create trigger update_in_wip
before update on Works_in_Project 
for each row 
begin 
	if(new.researcher_id in (select p.supervisor_id 
	from Project p 
	inner join Works_in_Project wip on p.project_id = wip.project_id 
	where p.project_id = new.project_id)
	or
	new.researcher_id not in (select r.researcher_id 
	from Researcher r
	inner join Project p2 on r.organisation_id = p2.organisation_id
	where p2.project_id = new.project_id))
	then 
	signal sqlstate '45000' set MESSAGE_TEXT = 'Wrong data input. Researcher must work in the organisation that handles the project and should not be supervisor of that project.';  
end if;
end $$

delimiter ;