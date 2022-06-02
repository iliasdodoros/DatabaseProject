select * from (
select concat(last_name, " ", first_name) as name_of_researcher, count(*) as projects_working_on  from (
(select r.last_name, r.first_name
from Researcher r 
inner join Works_in_Project wip on r.researcher_id = wip.researcher_id 
inner join Project p on wip.project_id = p.project_id 
left join Delivered d on p.project_id = d.project_id 
where d.title is null )
union all
(select r.last_name, r.first_name
from Researcher r 
inner join Project p on r.researcher_id  = p.supervisor_id
left join Delivered d on p.project_id = d.project_id 
where d.title is null  ) ) A
group by A.last_name ) B
where projects_working_on >= 5
order by projects_working_on desc;