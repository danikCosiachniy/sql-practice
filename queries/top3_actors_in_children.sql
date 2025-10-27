WITH counts AS (
   SELECT
    a.actor_id,
    CONCAT(a.last_name, ' ', a.first_name) AS actor_name,
    COUNT(fa.actor_id) AS films_cnt
  FROM actor a
  JOIN film_actor fa   ON a.actor_id = fa.actor_id
  JOIN film_category fc ON fa.film_id = fc.film_id
  JOIN category c       ON fc.category_id = c.category_id
  WHERE c.name = 'Children'
  GROUP BY a.actor_id, actor_name
), ranked AS (
    SELECT *, dense_rank() OVER (ORDER BY films_cnt DESC) AS rnk
           FROM counts
)

SELECT actor_id, actor_name, films_cnt
FROM ranked
WHERE rnk <= 3
ORDER BY films_cnt DESC, actor_name;