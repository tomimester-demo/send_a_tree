-- SEND A TREE PROJECT --

----------------- 
-- DATA DISCOVERY
-----------------

-- registration by sources

SELECT source, COUNT(*)
FROM registrations
GROUP BY source;

-- activity by sources

SELECT source, COUNT(*)
FROM super_tree
JOIN registrations
ON super_tree.user_id = registrations.user_id
GROUP BY source;

-- micro segmentation

SELECT source, phone_type, location, COUNT(*)
FROM registrations
GROUP BY source, phone_type, location
ORDER BY count;

-------------------
-- REVENUE ANALYSIS
-------------------

-- total revenue by source

SELECT source,
       SUM(revenue)
FROM (SELECT registrations.user_id,
             registrations.source,
             COUNT(*) - 1 AS revenue
      FROM super_tree
        JOIN registrations ON super_tree.user_id = registrations.user_id
      GROUP BY registrations.user_id,
               registrations.source) AS rev_table
GROUP BY source;

--- daily revenue

SELECT
  (
    SELECT
      COUNT(*) - COUNT(DISTINCT(user_id))
    FROM
      super_tree
    WHERE
      my_date < (
        SELECT
          current_date as today
      )
  ) - (
    SELECT
      COUNT(*) - COUNT(DISTINCT(user_id))
    FROM
      super_tree
    WHERE
      my_date < (
        SELECT
          current_date -1 as yesterday
      )
  );


-------------------
-- FUNNEL ANALYSIS
-------------------

SELECT reg.my_date,
       reg.source,
       reg.phone_type,
       reg.reg,
       free_users.free_users,
       super_users.super_users,
       paying_users.paying_users
FROM
    --step #1 - regs
    (SELECT my_date,
            source,
            phone_type,
            COUNT(*) AS reg
     FROM registrations
     GROUP BY my_date,
              source,
              phone_type
     ORDER BY my_date) AS reg
LEFT JOIN
    --step #2 - number of users (unique free_tree_sends)
   (SELECT registrations.my_date,
           registrations.source,
           registrations.phone_type,
           COUNT(DISTINCT (free_tree.user_id)) AS free_users
    FROM free_tree
      JOIN registrations ON registrations.user_id = free_tree.user_id
    GROUP BY registrations.my_date,
             registrations.source,
             registrations.phone_type
    ORDER BY registrations.my_date) AS free_users
ON reg.my_date = free_users.my_date
   AND reg.source = free_users.source
   AND reg.phone_type = free_users.phone_type
LEFT JOIN
    --step #3 - number of premium users (unique super_tree_sends)
   (SELECT registrations.my_date,
           registrations.source,
           registrations.phone_type,
           COUNT(DISTINCT (super_tree.user_id)) AS super_users
    FROM super_tree
      JOIN registrations ON registrations.user_id = super_tree.user_id
    GROUP BY registrations.my_date,
             registrations.source,
             registrations.phone_type
    ORDER BY registrations.my_date) AS super_users
ON reg.my_date = super_users.my_date
   AND reg.source = super_users.source
   AND reg.phone_type = super_users.phone_type
LEFT JOIN
   --step #4 - number of paying users (unique paid super_tree_sends)
   (SELECT registrations.my_date,
           registrations.source,
           registrations.phone_type,
           COUNT(paying_users.user_id) AS paying_users
    FROM (SELECT user_id,
                 COUNT(*)
          FROM super_tree
          GROUP BY user_id
          HAVING COUNT(*) > 1) AS paying_users
      JOIN registrations ON registrations.user_id = paying_users.user_id
    GROUP BY registrations.my_date,
             registrations.source,
             registrations.phone_type
    ORDER BY registrations.my_date) AS paying_users
ON reg.my_date = paying_users.my_date
   AND reg.source = paying_users.source
   AND reg.phone_type = paying_users.phone_type;


-------------------------------------------
-- CREATING THE LOOKER DASHBOARD SQL TABLES
-------------------------------------------
CREATE TABLE daily_active_users_kpi (my_date DATE, kpi INTEGER);

--insert data
INSERT INTO daily_active_users_kpi
  (SELECT (SELECT current_date-1 as yesterday) AS my_date,
         COUNT(DISTINCT(user_id)) AS kpi
         FROM (
    SELECT * FROM free_tree
    UNION ALL
    SELECT * FROM super_tree) as free_and_super
  WHERE my_date=(SELECT current_date-1 as yesterday));
