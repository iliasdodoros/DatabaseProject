select s.name, pc.name, pc.total_amount  
from projects_of_companies pc 
inner join stelehos s on pc.stelehos_id = s.stelehos_id 
order by pc.total_amount desc 
limit 5;