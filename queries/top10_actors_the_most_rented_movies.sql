SELECT
    actor.actor_id,
    CONCAT(actor.last_name, ' ', actor.first_name) AS actor_name,
    COUNT(*) AS kol
FROM actor
    JOIN film_actor ON actor.actor_id = film_actor.actor_id
    JOIN film f ON film_actor.film_id = f.film_id
    JOIN inventory i ON f.film_id = i.film_id
    JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.return_date IS NOT NULL
GROUP BY actor.actor_id, actor_name
ORDER BY kol DESC
LIMIT 10;
