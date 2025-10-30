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
)

SELECT
  'starts_with_a' AS bucket,
  a.city,
  a.category,
  a.hours_total
FROM a_city AS a
WHERE a.hours_total = (
  SELECT MAX(a2.hours_total)
  FROM a_city AS a2
  WHERE a2.city = a.city
)

UNION ALL

SELECT
  'has_dash' AS bucket,
  d.city,
  d.category,
  d.hours_total
FROM dash_city AS d
WHERE d.hours_total = (
  SELECT MAX(d2.hours_total)
  FROM dash_city AS d2
  WHERE d2.city = d.city
)

ORDER BY bucket, city, category;