select * from (
(select r.last_name, r.first_name, count(*) as projects_working_on
from researcher r 
inner join works_in_project wip on r.researcher_id = wip.researcher_id 
inner join project p on wip.project_id = p.project_id 
left join delivered d on p.project_id = d.project_id 
where d.title is null 
group by r.last_name)
union
(select r.last_name, r.first_name, count(*) as projects_working_on 
from researcher r 
inner join project p on r.researcher_id  = p.supervisor_id
left join delivered d on p.project_id = d.project_id 
where d.title is null 
group by r.last_name ) 
order by projects_working_on desc) A
where projects_working_on >= 5;
