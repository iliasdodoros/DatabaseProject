
select * from (
(select r.last_name, r.first_name, count(*) as projects_working_on
from Researcher r 
inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
inner join Project p on wip.project_id = p.project_id 
left join Delivered d on p.project_id = d.project_id 
where d.title is null 
group by r.last_name)
union
(select r.last_name, r.first_name, count(*) as projects_working_on 
from Researcher r 
inner join Project p on r.researcher_id  = p.supervisor_id
left join Delivered d on p.project_id = d.project_id 
where d.title is null 
group by r.last_name ) 
order by projects_working_on desc) A
where projects_working_on >= 5;
