-- Create a database called `credit_card_classification`
use credit_card_classification;

-- Create a table `credit_card_data` with the same columns as given in the csv file. Please make sure you use the correct data types for each of the columns
-- Import the data from the csv file into the table. Before you import the data into the empty table, make sure that you have deleted the headers from the csv file. To not modify the original data, if you want you can create a copy of the csv file as well. Note you might have to use the following queries to give permission to SQL to import data from csv files in bulk:
drop table credit_card_data;

create table credit_card_data  (
	Customer_Number	int,
    Offer_Accepted varchar(255),
	Reward_Type varchar(255),  
	Mailer_Type varchar(255),
    Income_Level varchar(255),
    Bank_Accounts_Open int,
    Overdraft_Protection varchar(255) ,
    Credit_Rating varchar(255),
    Credit_Cards_Held int,
    Homes_Owned int,
    Household_Size int,
    Own_Your_Home varchar(255),
    Average_Balance float,
    Q1 float,
    Q2 float,
    Q3 float,
    Q4 float,
    primary key (Customer_Number)
    );

-- - **Customer Number**: A sequential number assigned to the customers (this column is hidden and excluded – this unique identifier will not be used directly).
-- **Offer Accepted**: Did the customer accept (Yes) or reject (No) the offer. Reward: The type of reward program offered for the card.
-- **Mailer Type**: Letter or postcard.
-- **Income Level**: Low, Medium or High.
-- **#Bank Accounts Open**: How many non-credit-card accounts are held by the customer.
-- **Overdraft Protection**: Does the customer have overdraft protection on their checking account(s) (Yes or No).
-- **Credit Rating**: Low, Medium or High.
-- **#Credit Cards Held**: The number of credit cards held at the bank.
-- **#Homes Owned**: The number of homes owned by the customer.
-- **Household Size**: Number of individuals in the family.
-- **Own Your Home**: Does the customer own their home? (Yes or No).
-- **Average Balance**: Average account balance (across all accounts over time). **Q1, Q2, Q3 and Q4**
-- **Balance**: Average balance for each quarter in the last year

select * from credit_card_data;

-- 5.Use the alter table command to drop the column q4_balance from the database, as we would not use it in the analysis with SQL. 
-- Select all the data from the table to verify if the command worked. Limit your returned results to 10.
ALTER TABLE credit_card_data
DROP COLUMN Q4;



-- 6.  Use sql query to find how many rows of data you have.
select count(*) from credit_card_data;

-- 7.Now we will try to find the unique values in some of the categorical columns:
-- What are the unique values in the column Offer_accepted?
-- What are the unique values in the column Reward?
-- What are the unique values in the column mailer_type?
-- What are the unique values in the column credit_cards_held?
-- What are the unique values in the column household_size?
select distinct Offer_Accepted from credit_card_data;
select distinct Reward_Type from credit_card_data;
select distinct Mailer_Type from credit_card_data;
select distinct Credit_Cards_Held from credit_card_data;
select distinct Household_Size from credit_card_data;

-- 8.Arrange the data in a decreasing order by the average_balance of the house. 
-- Return only the customer_number of the top 10 customers with the highest average_balances in your data.
select Customer_Number from credit_card_data
order by Average_Balance desc
limit 10;

-- 9.What is the average balance of all the customers in your data?
select avg(Average_Balance) from credit_card_data;

 -- 10
 -- What is the average balance of the customers grouped by `Income Level`? The returned result should have only two columns, income level and `Average balance` of the customers. Use an alias to change the name of the second column.
select Income_Level, avg(Average_Balance) as "Average Balance" from credit_card_data
group by Income_Level;
-- What is the average balance of the customers grouped by `number_of_bank_accounts_open`? The returned result should have only two columns, `number_of_bank_accounts_open` and `Average balance` of the customers. Use an alias to change the name of the second column.
select Bank_Accounts_Open, avg(Average_Balance) as "Average Balance" from credit_card_data
group by Bank_Accounts_Open;
-- What is the average number of credit cards held by customers for each of the credit card ratings? The returned result should have only two columns, rating and average number of credit cards held. Use an alias to change the name of the second column.
select Credit_Rating, avg(Credit_Cards_Held) from credit_card_data
group by Credit_Rating;
-- Is there any correlation between the columns `credit_cards_held` and `number_of_bank_accounts_open`? You can analyse this by grouping the data by one of the variables and then aggregating the results of the other column. Visually check if there is a positive correlation or negative correlation or no correlation between the variables.
select Credit_Cards_Held, Bank_Accounts_Open from credit_card_data
group by Credit_Cards_Held
order by Credit_Cards_Held;

-- 11. Your managers are only interested in the customers with the following properties:
select Customer_Number, Credit_Rating, Credit_Cards_Held, Own_Your_Home, Household_Size from credit_card_data
where Credit_Rating <> "Low" and Credit_Cards_Held < 3 and Own_Your_Home = "Yes" and Household_Size >= 3 and Offer_Accepted = "Yes" ;

-- 12. Your managers want to find out the list of customers whose average balance is less than the average balance of all the customers in the database. Write a query to show them the list of such customers. You might need to use a subquery for this problem.
select Customer_Number, Average_Balance from credit_card_data
where Average_Balance < (select avg(Average_Balance) from credit_card_data);

-- 13. Since this is something that the senior management is regularly interested in, create a view of the same query.
create view Lower_Than_Average as 
select Customer_Number, Average_Balance from credit_card_data
where Average_Balance < (select avg(Average_Balance) from credit_card_data)
;

-- 14. What is the number of people who accepted the offer vs number of people who did not?
select  count(c.Offer_Accepted)/d.cnt
from credit_card_data c
join (
	select  count(Offer_Accepted) as cnt from credit_card_data
	where Offer_Accepted = "Yes"
    ) as d
where c.Offer_Accepted = "No";

-- 15. Your managers are more interested in customers with a credit rating of high or medium. What is the difference in average balances of the customers with high credit card rating and low credit card rating?
select  -avg(c.Average_Balance)+d.rat 
from credit_card_data c
join (
	select  avg(Average_Balance) as rat from credit_card_data
	where Credit_Rating = "High"
    ) as d
where c.Credit_Rating = "Low";

-- 16. In the database, which all types of communication (`mailer_type`) were used and with how many customers?
select Mailer_Type, count(distinct Customer_Number) as count  from credit_card_data
group by Mailer_Type;

-- 17. Provide the details of the customer that is the 11th least `Q1_balance` in your database.
select * from credit_card_data 
order by Q1 asc 
limit 10,1;
