USE vbay;

go

-- 1. How many item types are there? Perform an analysis of each item type. 
-- For each item type, provide the count of items in that type and the minimum, average, 
-- and maximum item reserve prices for that type. Sort the output by item type. 
SELECT ITEM.item_type,
       Count(item_id)              AS item_rsv_count,
       Min(item_reserve)           AS item_rsv_min,
       Max(item_reserve)           AS item_rsv_max,
       Round(Avg(item_reserve), 2) AS item_rsv_avg
FROM   vb_items AS ITEM
INNER OIN vb_item_types_lookup AS ITEML ON ITEM.item_type = ITEML.item_type
GROUP  BY ITEM.item_type;

go 

-- 2. Perform an analysis of each item in the “Antiques” and “Collectables” item types. 
-- For each item, display the name, item type, and item reserve. Include the minimum, 
-- maximum, and average item reserve over each item type so that the current item 
-- reserve can be compared to these values.

WITH temp_item_type
AS 
(
	SELECT item_type,
        Min(item_reserve)           AS item_rsv_min,
        Max(item_reserve)           AS item_rsv_max,
        Round(Avg(item_reserve), 2) AS item_rsv_avg
    FROM   vb_items AS item
    GROUP  BY item.item_type
)
SELECT item_name,
       ITMS.item_type,
       ITMS.item_reserve,
       item_rsv_min,
       item_rsv_max,
       item_rsv_avg
FROM   vb_items AS ITMS
INNER JOIN temp_item_type AS TEMP
        ON ITMS.item_type = TEMP.item_type
WHERE  TEMP.item_type IN ('Antiques', 'Collectables')
ORDER  BY ITMS.item_type;

go 

-- 3. Write a query to include the names, counts (number of ratings), and average 
-- seller ratings (as a decimal) of users. For reference, User Carrie Dababbi has 
-- four seller ratings and an average rating of 4.75. 

WITH temp_rating
AS 
(
	SELECT rating_for_user_id,
           Count(rating_for_user_id) AS number_of_ratings,
           ROUND(AVG(CAST(rating_value AS FLOAT)), 2) AS avg_rating
     FROM   vb_user_ratings AS RATE
     GROUP  BY RATE.rating_for_user_id
)
SELECT USERS.user_firstname,
       USERS.user_lastname,
       number_of_ratings,
       avg_rating
FROM   vb_users AS USERS
INNER JOIN temp_rating AS TEMP ON USERS.user_id = TEMP.rating_for_user_id;

go 

-- 4. Create a list of “Collectable” item types with more than one bid. Include 
-- the name of the item and the number of bids, making sure the item with 
-- the most bids appear first.

SELECT item_name,
       Count(*) AS number_of_bids
FROM   vb_items AS ITEMS
       INNER JOIN vb_bids BIDS
               ON ITEMS.item_id = BIDS.bid_item_id
WHERE  ITEMS.item_type = 'Collectables'
GROUP  BY ITEMS.item_name
HAVING Count(*) > 1
ORDER  BY number_of_bids DESC;

go 

-- 5. Generate a valid bidding history for any given item of your choice. Display the 
-- item ID, item name, a number representing the order the bid was placed, 
-- the bid amount, and the bidder’s name. Here’s an example showing the 
-- first three bids on item 11: 
WITH temp
AS 
(
	SELECT BIDS.bid_user_id,
            ITEMS.item_id,
            ITEMS.item_name,
            BIDS.bid_amount,
            Row_number()
                OVER (
                partition BY BIDS.bid_item_id
                ORDER BY BIDS.bid_datetime) AS bid_order
    FROM   vb_bids AS BIDS
            INNER JOIN vb_items AS ITEMS ON BIDS.bid_item_id = ITEMS.item_id
	WHERE  BIDS.bid_status = 'ok'
)
SELECT temp.item_id,
       temp.item_name,
       bid_order,
       temp.bid_amount,
       Concat(USERS.user_firstname, ' ', USERS.user_lastname) AS bidder
FROM   vb_users AS USERS
       INNER JOIN temp
               ON USERS.user_id = temp.bid_user_id
ORDER  BY temp.item_name,
          temp.bid_order;

go 

-- 6. Rewrite your query in the previous question to include the names of the 
-- next and previous bidders, like this example, again showing the first three bids 
-- for item 11.
WITH temp
AS 
(
	SELECT BIDS.bid_user_id,
            ITEMS.item_id,
            ITEMS.item_name,
            BIDS.bid_amount,
            Row_number() OVER (partition BY BIDS.bid_item_id ORDER BY BIDS.bid_datetime) AS bid_order,
            Lead(BIDS.bid_user_id, 1) OVER (partition BY BIDS.bid_item_id ORDER BY BIDS.bid_datetime) AS next_bidder,
            Lag(BIDS.bid_user_id, 1) OVER (partition BY BIDS.bid_item_id ORDER BY BIDS.bid_datetime) AS last_bidder
	FROM   vb_bids AS BIDS
    INNER JOIN vb_items AS ITEMS ON BIDS.bid_item_id = ITEMS.item_id
	WHERE  BIDS.bid_status = 'ok'
)
SELECT temp1.item_name,
       temp1.bid_order,
       temp1.bid_amount,
       Concat(USERS3.user_firstname, ' ', USERS3.user_lastname) AS previous_bidder,
       Concat(USERS.user_firstname, ' ', USERS.user_lastname)   AS bidder,
       Concat(USERS2.user_firstname, ' ', USERS2.user_lastname) AS next_bidder
FROM   temp AS temp1
LEFT JOIN vb_users AS USERS
        ON USERS.user_id = temp1.bid_user_id
LEFT JOIN vb_users AS USERS2
        ON USERS2.user_id = temp1.next_bidder
LEFT JOIN vb_users AS USERS3
        ON USERS3.user_id = temp1.last_bidder
ORDER  BY temp1.item_name,
          temp1.bid_order;

go   

-- 7. Find the names and emails of the users who give out the worst ratings (lower 
-- than the overall average rating) to either buyers or sellers (no need to 
-- differentiate whether the user rated a buyer or seller), and include only those 
-- users who have submitted more than one rating.

WITH temp_rating
AS 
(
	SELECT rating_for_user_id,
            Count(rating_for_user_id) AS number_of_ratings
    FROM   vb_user_ratings AS RATE
    GROUP  BY RATE.rating_for_user_id
    HAVING ( Count(rating_for_user_id) > 1 )
        AND ( Avg(rating_value) < (SELECT Avg(rating_value)
                                    FROM   vb_user_ratings) )
)
SELECT USERS.user_firstname,
       USERS.user_lastname,
       USERS.user_email
FROM   vb_users AS USERS
INNER JOIN temp_rating AS TEMP
        ON USERS.user_id = TEMP.rating_for_user_id;

go 

-- 8. Produce a report of the KPI (key performance indicator) user bids per item. 
-- Show the user’s name and email, total number of valid bids, total 
-- count of items bid upon, and then the ratio of bids to items. As a check, Anne Dewey’s bids per item ratio is 1.666666.

WITH test 
AS 
(
	SELECT bid_id, bid_user_id 
	FROM vb_bids 
	where bid_status = 'ok'
)
SELECT USERS.user_firstname,
       USERS.user_lastname,
	   USERS.user_email,
	   count(test.bid_user_id),
       Count(bid_id) AS num_bids_per_item,
       Cast(Count(*) / Count(item_id) AS DECIMAL(4, 3)) AS ratio
FROM   vb_bids b
INNER JOIN vb_users AS USERS ON USERS.user_id = b.bid_user_id
INNER JOIN vb_items AS test ON test.item_id = b.bid_item_id		
GROUP  BY USERS.user_firstname,
          USERS.user_lastname,
		  USERS.user_email


go

-- 9. Among items not sold, show highest bidder name and the highest bid for 
-- each item. Make sure to include only valid bids.

WITH temp_higest_bids
 AS 
 (
	SELECT bid_user_id,
            Max(BID.bid_amount) AS highest_bids
    FROM   vb_items AS ITM
    INNER JOIN vb_bids AS BID ON BID.bid_item_id = ITM.item_id
	WHERE  ITM.item_sold = 0
	AND BID.bid_status = 'ok'
	GROUP  BY BID.bid_user_id
)
SELECT Concat(USERS.user_firstname, ' ', USERS.user_lastname) AS user_names,
       USERS.user_email,
       highest_bids
FROM   vb_users AS USERS
INNER JOIN temp_higest_bids
        ON USERS.user_id = temp_higest_bids.bid_user_id 
ORDER BY highest_bids DESC;

go

--10
-- 10. Write a query with output similar to Question 3, but also includes 
-- the overall average seller rating and the difference between each user’s 
-- average rating and the overall average. For reference, the overall average seller 
-- rating should be 3.2.

WITH temp_rating
AS 
(
	SELECT rating_for_user_id,
            Count(rating_for_user_id)                  AS number_of_ratings,
            Round(Avg(Cast(rating_value AS FLOAT)), 2) AS avg_rating
    FROM   vb_user_ratings AS RATE
    GROUP  BY RATE.rating_for_user_id
)
SELECT USERS.user_firstname,
       USERS.user_lastname,
       number_of_ratings,
       (SELECT Round(Avg(Cast(rating_value AS FLOAT)), 2)
        FROM   vb_user_ratings
        WHERE  rating_astype = 'seller') AS avg_of_all_ratings,
       avg_rating,
       avg_rating - 3.2                  AS diff_btw_ovr_and_each_user_ratings
FROM   vb_users AS USERS
       INNER JOIN temp_rating AS TEMP
               ON USERS.user_id = TEMP.rating_for_user_id;

go 
