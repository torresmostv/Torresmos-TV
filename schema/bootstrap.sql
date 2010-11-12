
CREATE DATABASE IF NOT EXISTS ttv
  CHARACTER SET utf8
  COLLATE utf8_general_ci;

GRANT select, update, insert, delete
   ON ttv.*
   TO 'ttv'@'localhost'
   IDENTIFIED BY '$password_goes_here$';
