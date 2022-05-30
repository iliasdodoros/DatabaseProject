select Researcher.last_name,Researcher.first_name,count(Works_in_Project.project_id) from Researcher
inner join Works_in_Project on Works_in_Project.researcher_id = Researcher.researcher_id
where Works_in_Project.project_id not in (select project_id from Delivered)
having count(Works_in_Project.project_id)>4