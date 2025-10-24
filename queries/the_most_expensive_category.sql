SELECT category.category_id, category.name, sum(payment.amount) AS price
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN payment ON rental.rental_id = payment.rental_id
WHERE payment.amount > 0
GROUP BY category.category_id, category.name
ORDER BY price DESC
LIMIT 1;