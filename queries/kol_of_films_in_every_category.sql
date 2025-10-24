SELECT category.name, COUNT(*) AS kol FROM film JOIN (
    film_category JOIN category ON film_category.category_id = category.category_id
) ON film.film_id = film_category.film_id
GROUP BY category.name, film_category.category_id ORDER BY kol DESC;