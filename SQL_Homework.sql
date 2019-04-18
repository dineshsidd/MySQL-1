use sakila;

#1a. Display the first and last names of all actors from the table actor.
select FIRST_NAME, LAST_NAME from actor;
#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
select FIRST_NAME, LAST_NAME,CONCAT(upper(FIRST_NAME) ," ", UPPER(LAST_NAME)) as ACTOR_NAME from actor;
#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name,
# "Joe." What is one query would you use to obtain this information?.
select ACTOR_ID, FIRST_NAME, LAST_NAME from actor WHERE upper(FIRST_NAME) = 'JOE';
#2b. Find all actors whose last name contain the letters GEN:
select FIRST_NAME,LAST_NAME from actor where LAST_NAME like '%GEN%';
#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
select FIRST_NAME, LAST_NAME from actor where LAST_NAME like '%LI%' order by LAST_NAME, FIRST_NAME;
#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
select COUNTRY_ID, COUNTRY from country where country in ('Afghanistan', 'Bangladesh', 'China');
#3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
#so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, 
#as the difference between it and VARCHAR are significant).
alter table actor add( description blob);
select * from actor;
#3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
alter table actor drop description ;
select * from actor;
#4a. List the last names of actors, as well as how many actors have that last name.
select last_name, count(1) as name_count from actor group by last_name ;
#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
select last_name, count(1) as name_count from actor group by last_name 
having name_count > 1;
#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
update actor
set first_name = 'HARPO'
where first_name= 'GROUCHO' and last_name = 'WILLIAMS' ;
select * from actor where first_name = 'HARPO';
#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, 
#if the first name of the actor is currently HARPO, change it to GROUCHO.
update actor
set first_name = 'GROUCHO'
where first_name= 'HARPO' and last_name = 'WILLIAMS' ;
select * from actor where first_name = 'GROUCHO' and last_name = 'WILLIAMS';
#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
create table address_new (id int, full_name varchar(500), 
street varchar(100), 
city varchar(100), 
state varchar(100), 
postal_code int, 
primary key (id)) ;
select * from address_new;
#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
select first_name, last_name, address  from staff st left outer join address ad on st.address_id = ad.address_id ;
#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
select st.staff_id, first_name, last_name, sum(amount) as total_amount_aug_2005
from staff st left outer join payment py on st.staff_id = py.staff_id 
where concat(year(payment_date),month(payment_date))  = '20058'
group by staff_id, first_name, last_name;
#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
select title, description , count(actor_id) as number_of_actors
from film_actor fa inner join film fm on fa.film_id = fm.film_id
group by title, description;
#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select title, description , count(inventory_id) as number_of_copies
 from film fm inner join inventory inv on fm.film_id = inv.film_id  where title = 'Hunchback Impossible';
#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
select first_name, last_name , sum(amount) as total_paid  from customer cs left outer join payment py on 
cs.customer_id = py.customer_id 
group by first_name , last_name 
order by last_name ;

#7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, 
#films starting with the letters `K` and `Q` have also soared in popularity. 
#Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

select title, description , name from film fl
inner join language lg
on fl.language_id = lg.language_id 
where  title like 'Q%' or title like 'K%'   
and name = 'ENGLISH';

 #7b. Use subqueries to display all actors who appear in the film `Alone Trip`.
select first_name,last_name, title, description from film fm 
inner join film_actor fa on fm.film_id = fa.film_id 
inner join actor ac on ac.actor_id = fa.actor_id
where title = 'Alone Trip';

#* 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses 
#of all Canadian customers. Use joins to retrieve this information.

select   first_name, last_name , email, ct.city , country
from customer cs inner join address ad on cs.address_id = ad.address_id 
inner join city ct on  ct.city_id = ad.city_id 
inner join country ctr on ctr.country_id = ct.country_id
where country = 'canada' ;

#* 7d. Sales have been lagging among young families, and you wish to target all 
#family movies for a promotion. Identify all movies categorized as _family_ films.
select title, description ,name  from film fm 
inner join film_category fc on fm.film_id = fc.film_id 
inner join category cat on cat.category_id = fc.category_id
where name = 'family' ;

#7e. Display the most frequently rented movies in descending order.
select title, description , count(rental_date)  as no_of_times_rented   
from film fm inner join inventory inv on fm.film_id  = inv.film_id 
inner join rental rn on rn.inventory_id = inv.inventory_id
group by title, description
order by no_of_times_rented desc ;

#* 7f. Write a query to display how much business, in dollars, each store brought in.
select  store_id , sum( amount) as revenue_dollars
 from inventory inv inner join rental rnt on inv.inventory_id = rnt.inventory_id
 inner join payment py  on py.rental_id = rnt.rental_id
 group  by  store_id;
 
 #* 7g. Write a query to display for each store its store ID, city, and country.
select store_id, address , city, country from 
store st inner join address ad on st.address_id = ad.address_id 
inner join city ct  on ct.city_id = ad.city_id 
inner join country ctr on ctr.country_id = ct.country_id ;
 
#* 7h. List the top five genres in gross revenue in descending order. 
#(**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select ct.category_id , ct.name,  sum(amount) total_revenue
from inventory inv inner join rental rnt on inv.inventory_id = rnt.inventory_id
inner join  film_category fm on inv.film_id = fm.film_id
inner join category ct on ct.category_id = fm.category_id 
inner join payment py on py.rental_id = rnt.rental_id
group by ct.name, ct.category_id 
order by total_revenue desc limit 5;

#* 8a. In your new role as an executive, you would like to have an easy way of viewing the 
#Top five genres by gross revenue. Use the solution from the problem above to create a view. 
#If you haven't solved 7h, you can substitute another query to create a view.

create view top_five_genres as 
select ct.category_id , ct.name,  sum(amount) total_revenue
from inventory inv inner join rental rnt on inv.inventory_id = rnt.inventory_id
inner join  film_category fm on inv.film_id = fm.film_id
inner join category ct on ct.category_id = fm.category_id 
inner join payment py on py.rental_id = rnt.rental_id
group by ct.name, ct.category_id 
order by total_revenue desc limit 5;

#8b. How would you display the view that you created in 8a?
select * from top_five_genres;

#* 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
drop view top_five_genres;

