select 
    li.order_id,
    o.created_timestamp,
    i.display_name,
    li.price,
    u.email_address
from sqlps.line_items li
left join sqlps.orders o
    on li.order_id = o.id
left join sqlps.items i
    on li.item_id = i.id
left join sqlps.users u
    on o.user_id = u.id
;