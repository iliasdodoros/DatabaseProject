use elidek;

(select p.title, r.last_name, r.first_name  
from Researcher r 
inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
inner join Project p on wip.project_id = p.project_id 
inner join Project_Research_Field prf on p.project_id = prf.project_id
where (prf.name = 'History')
and ((p.beginning < current_date())  and (p.ending > current_date())))
union 
(select p.title, r.last_name, r.first_name  
from Researcher r 
inner join Project p on r.researcher_id = p.supervisor_id 
inner join Project_Research_Field prf on p.project_id = prf.project_id 
where (prf.name = 'History')
and ((p.beginning < current_date())  and (p.ending > current_date())));


