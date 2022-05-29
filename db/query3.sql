select p.title, r.last_name, r.name  
from researcher r 
inner join works_in_project wip on r.researcher_id = wip.researcher_id 
inner join project p on wip.project_id = p.project_id 
inner join project_research_field prf on p.project_id = prf.project_id 

where (prf.name =  )
