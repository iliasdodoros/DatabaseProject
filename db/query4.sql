create view orgs_projects_per_year as
select name, extract( year from beginning) as yearr, count(*) as got_projects from (
select o.name, p.project_id , p.beginning
from Organisation o 
inner join Project p on p.organisation_id = o.organisation_id ) A
group by  yearr, name ;

select name, a_year, next_year, a_got_projects as number_of_projects  from (
select a.name, a.yearr as a_year, a.got_projects as a_got_projects, b.yearr as next_year, b.got_projects as other_year_got_projects 
from orgs_projects_per_year a
inner join orgs_projects_per_year b on a.name = b.name
where a.yearr != b.yearr and a.yearr < b.yearr) A 
where (next_year - a_year = 1) and a_got_projects = other_year_got_projects and a_got_projects >= 10; 

drop view orgs_projects_per_year;