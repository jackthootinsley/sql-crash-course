-- Day 6: Security & Restricted Views
-- Dataset: Kaggle Ecommerce Dataset

-- Step 1: Set Up Roles & Users
-- data_engineer -> full database access
-- analyst -> full access to cleaned tables
-- business_user -> access only to restricted views

-- Create base roles
CREATE ROLE data_engineer NOLOGIN;
CREATE ROLE analyst NOLOGIN;
CREATE ROLE business_user NOLOGIN;

-- Create individual users and assign roles
CREATE USER liz_engineer WITH PASSWORD 'strongpassword';
CREATE USER jack_analyst WITH PASSWORD 'strongpassword';
CREATE USER neil_biz WITH PASSWORD 'strongpassword';

GRANT data_engineer TO liz_engineer;
GRANT analyst TO jack_analyst;
GRANT business_user TO neil_biz;
