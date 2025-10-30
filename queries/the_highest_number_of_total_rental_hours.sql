WITH a_city AS (
  SELECT
    c.city,
    cat.name AS category,
    SUM(EXTRACT(EPOCH FROM (r.return_date - r.rental_date)))/3600.0 AS hours_total
  FROM category AS cat
  JOIN film_category AS fc ON cat.category_id = fc.category_id
  JOIN inventory     AS i  ON fc.film_id = i.film_id
  JOIN rental        AS r  ON i.inventory_id = r.inventory_id
  JOIN customer      AS cu ON r.customer_id = cu.customer_id
  JOIN address       AS a  ON cu.address_id = a.address_id
  JOIN city          AS c  ON a.city_id = c.city_id
  WHERE cat.name ILIKE 'a%'
  GROUP BY c.city, cat.name
),
dash_city AS (
  SELECT
    c.city,
    cat.name AS category,
    SUM(EXTRACT(EPOCH FROM (r.return_date - r.rental_date)))/3600.0 AS hours_total
  FROM category AS cat
  JOIN film_category AS fc ON cat.category_id = fc.category_id
  JOIN inventory     AS i  ON fc.film_id = i.film_id
  JOIN rental        AS r  ON i.inventory_id = r.inventory_id
  JOIN customer      AS cu ON r.customer_id = cu.customer_id
  JOIN address       AS a  ON cu.address_id = a.address_id
  JOIN city          AS c  ON a.city_id = c.city_id
  WHERE c.city LIKE '%-%'
  GROUP BY c.city, cat.name
),
a_ranked AS (
  SELECT
    city, category, hours_total,
    RANK() OVER (PARTITION BY city ORDER BY hours_total DESC) AS rnk
  FROM a_city
),
dash_ranked AS (
  SELECT
    city, category, hours_total,
    RANK() OVER (PARTITION BY city ORDER BY hours_total DESC) AS rnk
  FROM dash_city
)
SELECT
  'starts_with_a' AS bucket,
  city,
  category,
  hours_total
FROM a_ranked
WHERE rnk = 1

UNION ALL

SELECT
  'has_dash' AS bucket,
  city,
  category,
  hours_total
FROM dash_ranked
WHERE rnk = 1

ORDER BY bucket, city, category;