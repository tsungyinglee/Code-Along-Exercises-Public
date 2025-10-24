-- identify items frequently ordered together
WITH ordered_items AS (
select
    item_id,
    order_id
from sqlps.line_items
)
select
    oi1.item_id as ordered_item_id,
    oi2.item_id as coodered_item_id,
    count(*) as times_ordered_together,
    row_number() over (
        partition by oi1.item_id
        order by count(*) desc
    ) as coorder_rank
from ordered_items oi1
join ordered_items oi2
    on oi1.order_id = oi2.order_id
    and oi1.item_id <> oi2.item_id
group by
    oi1.item_id,
    oi2.item_id
;