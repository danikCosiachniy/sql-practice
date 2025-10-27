SELECT
    city.city,
    SUM(customer.active) AS active_count,
    COUNT(*) - SUM(customer.active) AS inactive_count
FROM city
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
GROUP BY city.city
ORDER BY inactive_count DESC;