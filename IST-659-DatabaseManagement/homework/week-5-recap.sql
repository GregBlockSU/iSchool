USE vbay;
go

SELECT bid_amount, COUNT(*)
FROM dbo.vb_bids
GROUP BY bid_amount;

SELECT MAX(bid_amount) OVER (PARTITION BY bid_item_id) AS max_bid_amount_per_item
FROM dbo.vb_bids;


SELECT bid_item_id, MAX(bid_amount) AS max_bid_amount_per_item
FROM dbo.vb_bids
GROUP BY bid_item_id

SELECT * FROM dbo.vb_bids


SELECT item_type, item_name, item_enddate, 
		ROW_NUMBER() OVER (PARTITION BY item_type ORDER BY item_enddate),
		DENSE_RANK() OVER (PARTITION BY item_type ORDER BY item_enddate)
FROM dbo.vb_items
ORDER BY item_type, item_enddate;


SELECT USR.user_firstname, USR.user_lastname,[bid_item_id],[bid_datetime],
	  LEAD([bid_datetime]) OVER (PARTITION BY bid_item_id ORDER BY bid_datetime) AS next_bid_datetime,
      [bid_amount],
	  LEAD([bid_amount]) OVER (PARTITION BY bid_item_id ORDER BY bid_amount) AS next_bid_amount,
      [bid_status]
  FROM [dbo].[vb_bids] AS BID
  INNER JOIN dbo.vb_users AS USR ON USR.user_id = BID.bid_user_id


