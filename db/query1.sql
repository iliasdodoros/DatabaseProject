select name from Programm;
-------------------------------------------------------------
select title_of_project, name_of_researcher  from (
(select concat(r.last_name," ", r.first_name) name_of_researcher, p.title as title_of_project, p.duration, p.stelehos_id  
from Researcher r 
inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
inner join Project p on wip.project_id = p.project_id
order by title_of_project )
union 
(select concat(r.last_name," ", r.first_name) name_of_researcher, p.title as title_of_project, p.duration, p.stelehos_id  
from Researcher r 
inner join Project p on r.researcher_id = p.supervisor_id 
order by title_of_project)) A
where A.duration = 24
order by title_of_project ;
------------------------------------------------------------------------
select title_of_project , name_of_researcher  from (
(select concat(r.last_name," ", r.first_name) name_of_researcher, p.title as title_of_project,  s.name 
from Researcher r 
inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
inner join Project p on wip.project_id = p.project_id
inner join Stelehos s on p.stelehos_id = s.stelehos_id 
order by title_of_project )
union 
(select concat(r.last_name," ", r.first_name) name_of_researcher, p.title as title_of_project, s.name  
from Researcher r 
inner join Project p on r.researcher_id = p.supervisor_id 
inner join Stelehos s on p.stelehos_id = s.stelehos_id 
order by title_of_project)) A   
where A.name = "Johnny Depp";
order by title_of_project ;