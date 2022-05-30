create view active_projects as
select * from project p 
where ((p.beginning < current_date())  and (p.ending > current_date()));

-- name of young researchers and project_id of the project they are working on
(select r.last_name, r.first_name, ap.project_id, count(*) as projects_working_on 
from researcher r 
inner join works_in_project wip on r.researcher_id = wip.researcher_id 
inner join active_projects ap on wip.project_id = ap.project_id 
where r.date_of_birth > '1981-12-31'
group by r.last_name)
union 
(select r.last_name, r.first_name, ap.project_id, count(*) as projects_working_on 
from researcher r 
inner join active_projects ap on r.researcher_id  = ap.supervisor_id
where r.date_of_birth > '1981-12-31' 
group by r.last_name ) 
order by projects_working_on  ;
