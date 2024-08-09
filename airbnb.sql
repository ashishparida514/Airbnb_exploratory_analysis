# All the SQL Query used in this project

# Q1 what is the Data type of each column in all the 3 table.

#column - airbnb_last_review :

select column_name ,data_type
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'airbnb'
and table_name ='airbnb_last_review' ;

# column - airbnb_price:

select column_name ,data_type
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'airbnb'
and table_name ='airbnb_price' ;

column - airbnb_room_type:

select column_name ,data_type
from INFORMATION_SCHEMA.COLUMNS
where table_schema = 'airbnb'
and table_name ='airbnb_room_type' ;


/*
 count the number of unique airbnb present in 
different district and town of new york. */

select count( distinct(nbhood_full)) as no_of_district , 
	   count(distinct(State)) as no_of_town  
from airbnb_price ;


# Based on room type how many airbnb are present in whole new york.

select Room_type , 
	   count(listing_id) 
from airbnb_room_type
group by Room_type
having count(listing_id) > 1


/*
Monthly seasonality in terms of no of booking is 
done. ( so it will give at what time the booking are in peak) */

select last_review_Mons , 
	   count(listing_id) as no_of_booking
from airbnb_last_review
group  by last_review_Mons
order by no_of_booking desc ;


/*
 what is the average, expensive and cheap cost airbnb present 
 in new york city based on district.  */


select nbhood_full , 
       avg(price) as average_price , 
       max(price) as highest_price , 
       min(price) as lowest_price 
from airbnb_price
where price != 0
group by nbhood_full ;




# How the airbnb host are distributed all across the new york city.

select distinct nbhood_full ,
       count(listing_id) over (partition by nbhood_full) as no_of_host
from airbnb_price ;

# what are the top 5 expensive airbnb and top 5 cheap airbnb based on state.

( select nbhood_full , 
	     State , 
		 listing_id ,
		 'Expensive' as expensive_or_cheap, 
		 max(price) as expensive_airbnb
from airbnb_price 
group by nbhood_full , State ,listing_id
order by expensive_airbnb desc
limit 5  )

union 

(select nbhood_full ,
	    State , 
	    listing_id ,
	    'Cheap' as expensive_or_cheap,
	    min(price) as expensive_airbnb
from airbnb_price 
where price != 0
group by nbhood_full , State ,listing_id
order by expensive_airbnb asc
limit 5 )


# what is the average airbnb in different district of new york 

select nbhood_full, 
	   State , 
	   listing_id ,  
	   avg(price) as average_cost_airbnb
from airbnb_price 
group by nbhood_full , State ,listing_id


# based on room type what is the average , highest and lowest price airbnb available in new york

select Room_type , avg(price) as average_price , max(price) as highest_price , min(price) as lowest_price 
from airbnb_price a
join airbnb_room_type  b
on a.listing_id = b.listing_id
where price != 0
group by Room_type
limit 3 ;