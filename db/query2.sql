create view projects_per_researcher as
(select concat( r.last_name," ", r.first_name ) as researcher_name, p.title as project_title 
from researcher r 
inner join works_in_project wip on r.researcher_id = wip.researcher_id 
inner join project p on wip.project_id = p.project_id  )
union all 
(select concat(r.last_name," ", r.first_name) as researcher_name, p.title as project_title 
from researcher r 
inner join project p on r.researcher_id = p.supervisor_id )
order by researcher_name ;

create view projects_per_organisation as 
select o.name as organisation_name, p.title as project_title 
from organisation o 
inner join project p on o.organisation_id = p.organisation_id 
order by organisation_name ;

