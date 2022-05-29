use elidek;

(select p.title, r.last_name, r.first_name  
from researcher r 
inner join works_in_project wip on r.researcher_id = wip.researcher_id 
inner join project p on wip.project_id = p.project_id 
inner join project_research_field prf on p.project_id = prf.project_id
where (prf.name = 'History')
and ((p.beginning < current_date())  and (p.ending > current_date())))
union 
(select p.title, r.last_name, r.first_name  
from researcher r 
inner join project p2 on r.researcher_id = p2.supervisor_id 
inner join project_research_field prf on p.project_id = prf.project_id 
where (prf.name = 'History')
and ((p.beginning < current_date())  and (p.ending > current_date())));


