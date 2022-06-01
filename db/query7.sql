create view projects_of_companies as
select sum(p.amount) as total_amount, p.title, p.project_id, p.stelehos_id, p.programm_id, p.organisation_id, o.name 
from Project p inner join Company c on p.organisation_id = c.organisation_id 
inner join Organisation o on o.organisation_id = c.organisation_id 
group by p.stelehos_id, o.name;

select s.name, pc.name, pc.total_amount  
from projects_of_companies pc 
inner join Stelehos s on pc.stelehos_id = s.stelehos_id 
order by pc.total_amount desc 
limit 5;

drop view projects_of_companies;