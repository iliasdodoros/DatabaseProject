CREATE VIEW PAIR_OF_FIELDS AS
select a.project_id, a.Research_Field, b.Research_Field as Research_Field1 from project_Research_Field a, project_Research_Field b
where a.project_id = b.project_id and a.Research_Field < b.Research_Field;

select Research_Field, Research_Field1, count() from pair_of_fields group by Research_Field, Research_Field1 order by count() desc limit 3;