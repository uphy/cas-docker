create database cas;

CREATE TABLE cas_users (
   username VARCHAR(255) NOT NULL, 
   password VARCHAR(255) PRIMARY KEY 
);

INSERT INTO cas_users (username, password) VALUES ('guest', 'guest');
