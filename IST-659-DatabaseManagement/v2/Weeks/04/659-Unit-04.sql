-- 1. Sales would like to send mailings to users who live in a Zip code that starts with “13,” 
-- for example, 13244, so that they can be notified of their new contact in that region.
SELECT	*
FROM	vb_users USR
WHERE	USR.user_zip_code LIKE '13%';
GO

-- 2. Find all the users from the state of New York. 
-- Print their names and emails 
-- along with their city, state, and Zip code. Sort by city, then by user’s last /first name.
SELECT USR.user_firstname, USR.user_lastname, USR.user_email,
		ZIP.zip_city, ZIP.zip_state, ZIP.zip_code
FROM	vb_users USR
LEFT	JOIN vb_zip_codes ZIP ON USR.user_zip_code = ZIP.zip_code
WHERE	ZIP.zip_state = 'NY'
ORDER	BY ZIP.zip_city, USR.user_lastname, USR.user_firstname;
GO

-- 3. High-priced items: Return the ID, name, type, and reserve of items that 
-- have not been sold and have a reserve of 250 or higher. 
-- Sort the output so that the largest reserve items are first.
SELECT	item_id, item_name, item_type, item_reserve
FROM	vb_items
WHERE	item_sold = 0 AND 
		item_reserve >= 250
ORDER	BY item_reserve DESC;
GO

-- 4. Reserve item categories. 
-- Include the ID, name, type, and reserve price of the item. 
-- Do not include items of type “All Other”. 
-- Create a category column based on item reserve price.
-- When the item is 250 or more, it is a high-priced item. 
-- When the item is 50 or less, it is a low-priced item.
-- Everything else is an average-priced item.
SELECT	item_id, item_name, item_type, item_reserve,
		CASE 
			WHEN item_reserve >= 250
				THEN 'high-priced item'
			WHEN item_reserve <= 50
				THEN 'low-priced item'
			ELSE 'average-priced item'
        END AS category
FROM	vb_items
WHERE	item_type <> 'All Other';
GO

-- 5. Bidder list. Write a query that displays the 
-- valid user bids (bid status of ‘ok’) for a given item_id.  
-- This would commonly be displayed on the website for the chosen item. 
-- You select the item ID to display and show the bid ID, bid user’s name, 
-- bid user email, bid date, and bid amount. 
-- Put the most recent bids at the top.
SELECT	BID.bid_id,
		USR.user_firstname,
		USR.user_lastname,
		USR.user_email,
		BID.bid_datetime,
		BID.bid_amount,
		ITM.item_id
FROM	vb_users AS USR
JOIN	vb_bids AS BID ON USR.[user_id] = BID.bid_user_id
JOIN	vb_items AS ITM ON ITM.item_id = BID.bid_item_id
WHERE	BID.bid_status = 'ok'
ORDER	BY BID.bid_datetime DESC;
GO

-- 6 The bad bidder list. Write query to help the security audit team find fraudulent activity. 
-- For any bid that does not have a status of ‘ok’, include the date of the bid, name, email, 
-- and ID of the bidder and the name and ID of the item bid upon. 
-- Also include the amount of the bid and bid status. 
-- Sort the output by the user name (last, then first) and 
-- then by bid date for users with multiple bad bids.
SELECT BID.bid_datetime,
		USR.user_lastname,
		USR.user_firstname,
		USR.user_email,
		BID.bid_user_id,
		ITM.item_name,
		ITM.item_id,
		BID.bid_amount,
		BID.bid_status
FROM	vb_users AS USR
INNER	JOIN vb_bids AS BID ON USR.user_id = BID.bid_user_id
INNER	JOIN vb_items AS ITM ON ITM.item_id = BID.bid_item_id
WHERE	BID.bid_status <> 'ok'
ORDER BY USR.user_lastname, USR.user_firstname, BID.bid_datetime;
GO

-- 7. Produce a report of items that do not contain a bid. 
-- Include the item ID, item name, item type, seller’s name, and item reserve.
SELECT	ITM.item_id,
		ITM.item_name,
		ITM.item_type,
		USR.user_firstname AS [SELLER FN],
		USR.user_lastname AS [SELLER LN],
		ITM.item_reserve
FROM	vb_bids AS BID
RIGHT	JOIN vb_items AS ITM ON BID.bid_item_id = ITM.item_id
LEFT	JOIN vb_users AS USR ON USR.user_id = ITM.item_seller_user_id
WHERE	BID.bid_id IS NULL
GO

-- 8. Produce list of seller ratings. Include the name of the user who gave the rating,
-- the name of the user the rating was for, the rating value, and rating comment.
-- Include ratings of only sellers.
SELECT	USRB.user_firstname AS [From User FN],
		USRB.user_lastname AS [From User LN],
		RAT.rating_value AS [Rating],
		RAT.rating_comment AS [Comment],
		USRF.user_firstname AS [To User FN],
		USRF.user_lastname AS [To User LN]
FROM	vb_user_ratings AS RAT
INNER	JOIN vb_users AS USRB ON USRB.user_id = RAT.rating_by_user_id
INNER	JOIN vb_users AS USRF ON RAT.rating_for_user_id = USRF.user_id
WHERE	rating_astype ='Seller';
GO

-- 9. For items that were sold, generate a report that includes the locations (city and state)
-- of the buyer and seller. Include item ID, item name, item type item sold amount, name of seller,
-- seller's city/state, name of buyer, and buyer's city/state
SELECT	ITM.item_id, ITM.item_name, ITM.item_type, ITM.item_soldamount,
		USR.user_firstname AS [Item Seller FN],
		USR.user_lastname AS [Item Seller LN],
		SZIP.zip_city AS [Item Seller City],
		SZIP.zip_state AS [Item Seller State],
		BUY.user_firstname AS [Item Buyer FN],
		BUY.user_lastname AS [Item Buyer LN],
		BZIP.zip_state AS [Item Buyer State],
		BZIP.zip_city AS [Item Buyer City]
FROM	vb_users AS USR
RIGHT	JOIN vb_items AS ITM ON USR.user_id = ITM.item_seller_user_id
LEFT	JOIN vb_users AS BUY ON BUY.user_id = ITM.item_buyer_user_id
LEFT	JOIN vb_zip_codes SZIP ON SZIP.zip_code = USR.user_zip_code
LEFT	JOIN vb_zip_codes AS BZIP ON BZIP.zip_code = BUY.user_zip_code
WHERE	item_sold = 1;
go

-- 10. Users with no activity. Find the names and emails of any users who have never posted an item
-- for bid or have never bought the item or have never placed a bid.
SELECT	DISTINCT USR.user_id, USR.user_firstname, USR.user_lastname,
		USR.user_email,
		CASE 
        WHEN SELL.item_seller_user_id IS NULL
            AND BUY.item_buyer_user_id IS NULL
            AND BID.bid_user_id IS NULL
            THEN 'No Activity'
        WHEN BUY.item_buyer_user_id = 0
            THEN 'Never Bought and Item'
        WHEN BID.bid_item_id IS NULL
            THEN 'Never Bid on Item'
        WHEN SELL.item_seller_user_id IS NULL
            THEN 'Never Posted Item for Bid'
        ELSE 'Active'
        END AS [Check]
FROM	vb_users AS USR
LEFT	JOIN vb_bids BID ON BID.bid_user_id = USR.user_id
LEFT	JOIN vb_items SELL ON SELL.item_seller_user_id = USR.user_id
LEFT	JOIN vb_items BUY ON BUY.item_buyer_user_id = USR.user_id;
GO


