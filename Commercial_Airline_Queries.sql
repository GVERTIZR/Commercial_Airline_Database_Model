--1
SELECT COUNT(*) as Total_Flights FROM (SELECT f.flight_id, count(*) as quantity, p.capacity
FROM tickets t JOIN flights f ON 
f.flight_id = t.flight_id JOIN
planes p ON p.plane_id = f.plane_id
WHERE YEAR(f.date) = 2016 --year 2016
GROUP BY f.flight_id, p.capacity
HAVING COUNT(*)>(p.capacity*0.5)) F -- for more than half of the capacity
;
--2
SELECT COUNT(*) Total_Flights FROM (SELECT fl.flight_id, count(*) quantity, pl.capacity
FROM tickets ti JOIN
flights fl ON fl.flight_id = ti.flight_id JOIN
planes pl ON pl.plane_id = fl.plane_id
WHERE year(fl.date) = 2017
GROUP BY fl.flight_id, pl.capacity
HAVING count(*) < (pl.capacity*0.25)) c --for less than 25% capacity
;
--3
SELECT	f.route_id, sum(t.final_price) AS total_revenue -- rename the sum
FROM    flights as f JOIN
		tickets as t on f.flight_id=t.flight_id JOIN
		routes as r on r.route_id=f.route_id 
WHERE	year(t.purchase_date)=2017 --isolate for the year 2017
GROUP BY f.route_id 
ORDER BY total_revenue DESC --order by renamed sum
;
--4.1
SELECT	count(*) AS 'Elderly Discount', sum(total_discount) AS total_discount
FROM	(SELECT (final_price*(SELECT percentage 
							 FROM discounts	
								WHERE name='Elderly Discount')) as total_discount
		FROM tickets as t
		WHERE t.customer_id IN (SELECT customer_id
								 FROM customers
								 WHERE	DATEDIFF(year, birth_date, purchase_date) >= 65)--just for the case it doesn't apply for the time of the purchase
								)a
;
--4.2
SELECT	  count(*) 'Student Discount', sum(total_discount) total_discount
FROM	 (SELECT (final_price* (SELECT percentage 
								FROM discounts
								WHERE name='Student Discount')) total_discount
		 FROM tickets ti
		 WHERE ti.customer_id IN (SELECT customer_id 
								 FROM customers 
		 						WHERE DATEDIFF(year,birth_date,purchase_date)between 16 and 23)--difference set, because it may not apply at the moment of the purchase
			)a --given name
;
--5
SELECT  T.Year,  T.Month,  T.Total_passengers,  R.Registered_passengers, (T.Total_passengers - R.Registered_passengers) as Not_registered,  (T.Total_passengers - R.Registered_passengers)/R.Registered_passengers  as Ratio 

FROM (SELECT YEAR(f.date) as Year, MONTH(f.date) as Month, COUNT(*) as Total_passengers  
	FROM flights as f, tickets as t 
    WHERE f.flight_id = t.flight_id AND (YEAR(f.date) = 2016 OR YEAR(f.date) = 2017) 
    GROUP BY YEAR(f.date), MONTH(f.date)) as T, --renaming as T: QUERY FOR TOTAL PASSENGERS GROUPED BY YEAR AND MONTH FOR 2016 and 2017
( 
    SELECT YEAR(f.date) as Year, MONTH(f.date) as Month, COUNT(*) as Registered_passengers  
    FROM flights as f, tickets as t 
    WHERE f.flight_id = t.flight_id AND t.customer_id IS NOT NULL AND (YEAR(f.date) = 2016 OR YEAR(f.date) = 2017) 
    GROUP BY YEAR(f.date), MONTH(f.date)) as R --renaming as R:  QUERY FOR REGISTERED PASSENGERS GROUPED BY YEAR AND MONTH FOR 2016 and 2017
WHERE T.Year = R.Year AND T.Month = R.Month 
ORDER BY T.Year, T.Month
;
--6
SELECT  COUNT(t.ticket_id) tickets_sold, r.route_id route, w.name week_day --couldn't nest to find MAX values per day, as there where two highests for saturday
FROM tickets t, flights f, routes r, weekdays w
WHERE t.flight_id=f.flight_id AND f.route_id=r.route_id AND r.weekday_id=w.weekday_id AND 
r.city_state_id_origin IN (SELECT oc.city_state_id
		            FROM cities_states oc --ORIGIN CITY
		            WHERE oc.name='TAMPA') AND
 r.city_state_id_destination IN (SELECT dc.city_state_id
		                     FROM cities_states dc --DESTINATION CITY
			      WHERE dc.name='ORLANDO')
GROUP BY w.weekday_id, w.name, r.route_id
ORDER BY w.weekday_id, tickets_sold DESC --shows entire list of demands per route per day, ordering helps identifying the routes with the most demand
;
--7
SELECT TOP 1 DATEPART(hour,t.purchase_time) hour_with_the_most_demand, COUNT(t.ticket_id) AS tickets_sold --top 1 to select first row
FROM tickets t, flights f, routes r, weekdays w
WHERE t.flight_id=f.flight_id AND f.route_id=r.route_id AND r.weekday_id=w.weekday_id AND 
r.city_state_id_origin IN (SELECT oc.city_state_id
							FROM cities_states oc --ORIGIN CITY
							WHERE oc.name='ORLANDO')
AND
 r.city_state_id_destination IN (SELECT dc.city_state_id
								FROM cities_states dc --DESTINATION CITY
								WHERE dc.name='TAMPA')
GROUP BY DATEPART(hour, t.purchase_time)--grouped by hour to be able to count the amount of tickets sold per hour
Order By tickets_sold DESC --to show the hour with the most demand in the first row
;
--8
SELECT COUNT(t.ticket_id) tickets_sold, p.capacity, f.flight_id
 FROM planes p, flights f, tickets t
 WHERE f.plane_id=p.plane_id AND t.flight_id=f.flight_id AND YEAR(f.date)=2017 --year constrained to be only 2017
 GROUP BY f.flight_id, p.capacity
 HAVING COUNT(t.ticket_id)<(0.25*p.capacity) --constraint to have the total amount of tickets being less than 1/4 of the capacity
 ORDER BY f.flight_id ASC
;
--9
SELECT*
FROM (SELECT  TOP 1 MONTH(t2.purchase_date) month_number, COUNT(t2.ticket_id) tickets_sold
			FROM tickets t2
			WHERE YEAR(t2.purchase_date)=2017
			GROUP BY MONTH(t2.purchase_date)
			ORDER BY tickets_sold ASC) as Month_with_the_least_demand --TOP 1 and ASC combination to show the month with the least sales
UNION ALL			
SELECT *
FROM (
		SELECT  TOP 1 MONTH(t.purchase_date) month, COUNT(t.ticket_id) tickets_sold
			FROM tickets t
			WHERE YEAR(t.purchase_date)=2017
			GROUP BY MONTH(t.purchase_date)
			ORDER BY tickets_sold DESC) as Month_with_the_most_demand --TOP 1 and DESC combination to show the month with the mostsales
;
--10
SELECT TOP 3 COUNT(t.ticket_id) tickets_sold, t.employee_id --top three used to display first three rows 
FROM tickets t, employees e
WHERE t.employee_id=e.employee_id
GROUP BY t.employee_id --group by employee to count tickets sold per employee
ORDER BY COUNT(t.ticket_id) DESC
;

--FULL LIST:
--SELECT COUNT(t.ticket_id) tickets_sold, t.employee_id 
--FROM tickets t, employees e
--WHERE t.employee_id=e.employee_id
--GROUP BY t.employee_id
--ORDER BY COUNT(t.ticket_id) DESC;     --SHOWS A TIE BETWEEN EMPLOYEE 106 and 93 with 576 TICKETS SOLD (3rd and 4th)

--11
SELECT TOP 1  ---Select the first row of the table
ct.name AS CabinType,
COUNT(t.ticket_id) AS TotalTickets 
FROM tickets t
JOIN cabin_types ct ON t.cabin_type_id = ct.cabin_type_id  ---Connect the tables cabin types with tickets
WHERE YEAR(t.purchase_date) = 2017 ---constrain to specify the year
GROUP  BY ct.name
ORDER BY TotalTickets DESC ---descending order to have the highest total tickets in the 1st row
;
--12
SELECT TOP 1 l.name AS purchase_location, COUNT(t.ticket_id) AS ticket_count --select the highest count of tickets_id
FROM tickets t
JOIN locations l ON t.purchase_location_id = l.location_id ---connect tables of locations and tickets
WHERE YEAR(t.purchase_date) = 2016 ---constrain to select the year 2016
GROUP BY l.name
ORDER BY ticket_count DESC ---order by descending to have the highest ticket count on the first row
;
--13
SELECT f.flight_id---show the flight with full capacity sold
FROM flights f
JOIN planes p ON f.plane_id = p.plane_id---conect the plane id from flights table to plane table
JOIN (SELECT flight_id, COUNT(customer_id) AS sold_tickets
	FROM tickets
	GROUP BY flight_id)---count how many tickets sold in each flight by counting the customer ids
   t ON f.flight_id = t.flight_id
WHERE p.capacity = t.sold_tickets; ---constrain to connect total capacity with tickets sold
;
--14
SELECT TOP 1 pt.name AS PaymentType, COUNT(*) AS TotalCount ---Selecting the Top 1 payment type and total count
FROM tickets t
JOIN payment_types pt ON t.payment_type_id = pt.payment_type_id  ---join the tables to be able to connect payment type with payment id from tickets
WHERE YEAR(t.purchase_date) = 2017
GROUP BY pt.name ---group by payment type to be able to select the highest 
ORDER BY COUNT(*) DESC
;
--15
SELECT TOP 1 purchase_date, SUM(final_price) AS total_revenue -- Select the highest total revenue 
FROM tickets
WHERE YEAR(purchase_date) = 2017
GROUP BY purchase_date ---By selecting the year and grouping by we can order them in descending order.
ORDER BY total_revenue DESC
;
--16
SELECT purchase_time AS hour_of_day, COUNT(*) AS ticket_count -- Selecting purchase time and counting tickets
FROM tickets -- Filtering tickets bought in 2017
WHERE YEAR(purchase_date) = 2017
GROUP BY purchase_time -- Grouping by purchase time
ORDER BY ticket_count DESC
; -- Sorting ticket count in descending order

--17
SELECT cs.name AS City_Name, Count(*) AS Customers_Quantity -- Selecting city names and counting the number of customers
FROM Customers c -- Starting with the Customers table
JOIN cities_states cs ON c.city_state_id = cs.city_state_id -- Joining with the cities_states table to get city names
WHERE c.city_state_id is not null -- Filtering out null city_state_id values
GROUP BY cs.name -- Grouping the results by city names
ORDER BY Customers_Quantity desc; -- Sorting the results by the count of customers in descending order

--18
SELECT Zipcode_id, COUNT(*) AS Employee_Quantity -- Selecting Zipcode_id and counting the number of employees
FROM Employees -- Starting with the Employees table
WHERE Zipcode_id IS NOT NULL -- Filtering out null Zipcode_id values
GROUP BY Zipcode_id -- Grouping the results by Zipcode_id
ORDER BY Employee_Quantity DESC; -- Sorting the results by the count of employees in descending order

--19
SELECT Customer_id, COUNT(*) AS Customer_Quantity -- Selecting Customer_id and counting the number of tickets
FROM Tickets -- Starting with the Tickets table
WHERE YEAR(Purchase_Date) = 2017 AND Customer_id IS NOT NULL -- Filtering tickets purchased in 2017 and excluding null Customer_id values
GROUP BY Customer_id -- Grouping the results by Customer_id
ORDER BY Customer_Quantity DESC; -- Sorting the results by the count of tickets in descending order

--20
SELECT r.route_id, COUNT(*) AS tickets_sold -- Selecting route_id and counting the number of tickets sold
FROM tickets t -- Starting with the Tickets table
    JOIN flights f ON f.flight_id = t.flight_id -- Joining with the Flights table
    JOIN routes r ON r.route_id = f.route_id -- Joining with the Routes table
WHERE YEAR(t.purchase_date) = 2017 -- Filtering tickets purchased in 2017
    AND (r.weekday_id = 6 OR r.weekday_id = 7) -- Filtering for Saturday 6 or Sunday7
GROUP BY r.route_id -- Grouping the results by route_id
ORDER BY tickets_sold DESC; -- Sorting the results by the count of tickets sold in descending order



