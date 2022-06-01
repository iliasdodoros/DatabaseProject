create view project_and_rf as
select p.title, p.project_id, prf.name  
from project p 
inner join project_research_field prf on p.project_id = prf.project_id 
order by p.project_id ;

select title, project_id, rf_duo, count(*) as counter from (
select prf1.title, prf1.project_id, concat (prf1.name," ", prf2.name) rf_duo
from project_and_rf prf1 
inner join project_and_rf prf2 on prf1.title = prf2.title
where prf1.name != prf2.name and prf1.name < prf2.name) A 
group by rf_duo
order by counter desc
limit 3;

