SELECT c.name AS category, COUNT(fc.film_id) AS amount
FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
GROUP BY c.name
ORDER BY amount DESC;