USE vbay;
go

SELECT	item_id, item_name, 
		dense_rank() over ( partition by item_name order by bid_datetime) as bid_order, 
		bid_amount, 
		lag(user_firstname + ' ' + user_lastname) over (partition by item_name order by bid_datetime) as prev_bidder, 
		user_firstname + ' ' + user_lastname as bidder, 
		lead (user_firstname + ' '  + user_lastname) over (partition by item_name order by bid_datetime) as next_bidder 
FROM	dbo.vb_items 
INNER	JOIN dbo.vb_bids on item_id = bid_item_id 
INNER	JOIN DBO.vb_users on bid_user_id = user_id 
WHERE	bid_status = 'ok';
go

DROP INDEX IF EXISTS dbo.vb_bids.ix_bids_bid_status;
go

CREATE INDEX ix_bids_bid_status ON dbo.vb_bids (bid_item_id, bid_user_id, bid_status) INCLUDE (bid_datetime)
go

