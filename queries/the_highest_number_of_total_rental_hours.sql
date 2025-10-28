SELECT DISTINCT ON (city.city)
       category.name AS category,
       city.city,
       SUM(EXTRACT(EPOCH FROM (rental.return_date - rental.rental_date)))/3600.0 AS hours_total
FROM category
JOIN film_category ON category.category_id = film_category.category_id
JOIN film ON film_category.film_id = film.film_id
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
WHERE category.name ILIKE 'a%' OR city.city LIKE '%-%'
GROUP BY city.city, category.name
ORDER BY city.city,
         hours_total DESC,
         category.name;