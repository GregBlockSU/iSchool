SELECT	[seller_email] = SLR.[user_email], 
		[seller_user_name] = CONCAT(SLR.[user_firstname], ' ', SLR.[user_lastname]),
		ITM.[item_name], ITM.[item_type],
		[buyer_email] = BYR.[user_email], 
		[buyer_user_name] = CONCAT(BYR.[user_firstname], ' ', BYR.[user_lastname])
		
FROM	[vb_users] AS SLR
INNER	JOIN [vb_items] AS ITM ON ITM.[item_seller_user_id] = SLR.[user_id]
LEFT	OUTER JOIN [vb_users] AS BYR ON BYR.[user_id] = BYR.[user_id]
WHERE	ITM.[item_type] != 'Antiques'
ORDER	BY SLR.[user_email], ITM.[item_name]
