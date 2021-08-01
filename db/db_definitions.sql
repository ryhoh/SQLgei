--------------------
-- Role Definition
--------------------

CREATE ROLE bot WITH
	NOSUPERUSER
	NOCREATEDB
	NOCREATEROLE
	INHERIT
	LOGIN
	NOREPLICATION
	NOBYPASSRLS
	CONNECTION LIMIT -1;


--------------------
-- DataBase Definition
--------------------
CREATE DATABASE sandbox WITH
	OWNER = bot;
