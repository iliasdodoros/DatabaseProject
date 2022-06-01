create view projects_per_researcher as
(select concat( r.last_name," ", r.first_name ) as researcher_name, p.title as project_title 
from Researcher r 
inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
inner join Project p on wip.project_id = p.project_id  )
union all 
(select concat(r.last_name," ", r.first_name) as researcher_name, p.title as project_title 
from Researcher r 
inner join Project p on r.researcher_id = p.supervisor_id )
order by researcher_name ;

select * from projects_per_researcher;

create view projects_per_organisation as 
select o.name as organisation_name, p.title as project_title 
from Organisation o 
inner join Project p on o.organisation_id = p.organisation_id 
order by organisation_name ;

select * from projects_per_organisation;

drop view projects_per_researcher;
drop view projects_per_organisation;
