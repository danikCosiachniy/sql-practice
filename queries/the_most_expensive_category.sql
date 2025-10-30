SELECT c.category_id, c.name, sum(p.amount) AS price
FROM category as c
JOIN film_category as fc ON c.category_id = fc.category_id
JOIN inventory as i ON fc.film_id = i.film_id
JOIN rental as r ON i.inventory_id = r.inventory_id
JOIN payment as p ON r.rental_id = p.rental_id
WHERE p.amount > 0
GROUP BY c.category_id, c.name
ORDER BY price DESC
LIMIT 1;