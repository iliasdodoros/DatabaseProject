create view equal as
	(select o.name, o.organisation_id, count(*) as number_of_projects
	from organisation o 
	inner join project p on p.organisation_id = o.organisation_id 
	where beginning > '2019-12-31' and beginning < '2021-01-01'
	group by o.organisation_id ) 
	intersect
	(select o.name, o.organisation_id, count(*) as number_of_projects
	from organisation o 
	inner join project p on p.organisation_id = o.organisation_id 
	where beginning > '2020-12-31' and beginning < '2022-01-01'
	group by o.organisation_id );

select name, organisation_id from equal where number_of_projects >= 10;
