use elidek;

create temporary table equal_org
(org_id int);

declare @Counter int, @Maxid int, @Projects2020 int, @Projects2021 int ;
select @counter = min(organisation_id) , @maxid = max(organisation_id)
from project  
 
while(@counter is not null and @counter <= @maxid)
begin 
	select @projects2020 = count(project.project_id) 
	from project where (project.organisation_id = @counter) and (project.beginning > '2019-12-31' and project.beginning < '2021-01-01')
	select @projects2021 = count(project.project_id) 
	from project where (project.organisation_id = @counter) and (project.beginning > '2020-12-31' and project.beginning < '2022-01-01')
	if @projects2020 != @projects2021 
	begin 
		set @counter = @counter + 1
		continue 
	end
		insert into equal_org (org_id) values (@counter)
		set @counter = @counter + 1
end;



select organisation.name, project.project_id, project.beginning  from organisation inner join project on organisation.organisation_id = project.organisation_id
where (beginning > '2019-12-31' and beginning < '2021-01-01') ;

with projects_2020(org_name, value) as 
	(select o.name, count(project_id)
	from organisation o 
	inner join project p on p.organisation_id = o.organisation_id 
	where beginning > '2019-12-31' and beginning < '2021-01-01';),
projects_2021(org_name, value) as
	(select distinct o.name, count(project_id)
	from organisation o 
	inner join project p on p.organisation_id = o.organisation_id 
	where beginning > '2020-12-31' and beginning < '2022-01-01')
select org_name 
from projects_2020 
inner join projects_2021 on projects_2020.org_name = projects_2021.org_name 
where projects_2020.value = projects_2021.value ;
	