SELECT
  a.actor_id,
  concat(a.last_name, ' ', a.first_name) AS actor_name,
  COUNT(*) AS amount
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN inventory   AS i  ON fa.film_id = i.film_id
JOIN rental      AS r  ON i.inventory_id = r.inventory_id
GROUP BY a.actor_id, actor_name
ORDER BY amount DESC, actor_name
LIMIT 10;