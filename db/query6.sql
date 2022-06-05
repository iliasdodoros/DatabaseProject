select last_name, first_name, count(*) as projects_working_on from (
(select r.last_name, r.first_name 
from researcher r 
inner join works_in_project wip on r.researcher_id = wip.researcher_id 
inner join active_projects ap on wip.project_id = ap.project_id 
where r.date_of_birth > '1981-12-31')
union all
(select r.last_name, r.first_name
from researcher r 
inner join active_projects ap on r.researcher_id  = ap.supervisor_id
where r.date_of_birth > '1981-12-31') ) A
group by last_name 
order by projects_working_on desc ;



