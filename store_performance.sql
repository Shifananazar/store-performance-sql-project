---Store Performance

select i.store_id,
SUM(p.amount)as total_revenue,
count(r.rental_id )as total_rental
from payment p 
join rental r on p.rental_id =r.rental_id 
join inventory i on r.inventory_id =i.inventory_id 
group by i.store_id ;

select count (distinct store_id) from inventory i ;

--- Top Cities by Revenue 

SELECT c.city,
SUM(p.amount) AS total_revenue
FROM payment p
JOIN customer cu ON p.customer_id = cu.customer_id
JOIN address a ON cu.address_id = a.address_id
JOIN city c ON a.city_id = c.city_id
GROUP BY c.city
ORDER BY total_revenue DESC
LIMIT 5;

--- Customer Rental Frequency

SELECT r.customer_id,
COUNT(r.rental_id) AS total_rentals,
CASE 
    WHEN COUNT(r.rental_id) > 30 THEN 'High'
    WHEN COUNT(r.rental_id) BETWEEN 10 AND 30 THEN 'Medium'
    ELSE 'Low'
END AS rental_category
FROM rental r
GROUP BY r.customer_id;

--- Top Customers by Revenue 

SELECT p.customer_id,
SUM(p.amount) AS total_payment
FROM payment p
GROUP BY p.customer_id
ORDER BY total_payment DESC
LIMIT 10;

--- Category-wise Rentals

SELECT c.name AS category,
COUNT(r.rental_id) AS total_rentals
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

--- Monthly Revenue 

SELECT 
EXTRACT(MONTH FROM p.payment_date) AS month,
SUM(p.amount) AS total_revenue
FROM payment p
GROUP BY month
ORDER BY month;

SELECT DISTINCT EXTRACT(MONTH FROM payment_date) AS month
FROM payment
ORDER BY month;


--- Films Not Rented

SELECT f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL;

--- Above Average Revenue Films 

SELECT f.title,
SUM(p.amount) AS total_revenue
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY f.title
HAVING SUM(p.amount) > (
    SELECT AVG(film_revenue)
    FROM (
        SELECT 
            SUM(p.amount) AS film_revenue
        FROM film f
        JOIN inventory i ON f.film_id = i.film_id
        JOIN rental r ON i.inventory_id = r.inventory_id
        JOIN payment p ON r.rental_id = p.rental_id
        GROUP BY f.film_id
    ) AS avg_table
);

--- Customer Activity Check

SELECT customer_id,
COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY customer_id
HAVING COUNT(rental_id) > 20;


---Peak Rental Day 

SELECT DATE(rental_date) AS day,
COUNT(rental_id) AS total_rentals
FROM rental
GROUP BY day
ORDER BY total_rentals DESC
LIMIT 1;