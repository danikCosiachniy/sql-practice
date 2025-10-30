SELECT DISTINCT ON (c.city)
       cat.name AS category,
       c.city,
       SUM(EXTRACT(EPOCH FROM (r.return_date - r.rental_date)))/3600.0 AS hours_total
FROM category as cat
JOIN film_category as fc ON cat.category_id = fc.category_id
JOIN inventory as i ON fc.film_id = i.film_id
JOIN rental as r ON i.inventory_id = r.inventory_id
JOIN customer as cus ON r.customer_id = cus.customer_id
JOIN address as a ON cus.address_id = a.address_id
JOIN city as c ON a.city_id = c.city_id
WHERE cat.name ILIKE 'a%' OR c.city LIKE '%-%'
GROUP BY c.city, cat.name
ORDER BY c.city,
         hours_total DESC,
         cat.name;
