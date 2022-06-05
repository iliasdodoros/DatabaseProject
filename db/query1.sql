select p.title as title_of_project                                                                                  
from project p 
inner join stelehos s on p.stelehos_id = s.stelehos_id 
where s.name like '%' and p.duration > 0 and ((p.beginning < current_date())  and (p.ending > current_date()));


select name_of_researcher from (
(select concat(r.last_name," ", r.first_name) as name_of_researcher, p.title 
from Researcher r 
inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
inner join Project p on wip.project_id = p.project_id
order by name_of_researcher)
union 
(select concat(r.last_name," ", r.first_name) as name_of_researcher, p.title 
from Researcher r 
inner join Project p on r.researcher_id = p.supervisor_id 
order by name_of_researcher)) A
where A.title = '%';