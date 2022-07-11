#!/bin/bash
##############################
# @file create_db_mysql.sh
# @brief create database and tables in mysql
# @author Mingxing LAI
# @version 0.1
# @date 2013-01-20
##############################
USER="root"
DATABASE="students"
TABLE="students"
######################
#crate database
mysql -u $USER << EOF 2>/dev/null
CREATE DATABASE $DATABASE
EOF
[ $? -eq 0 ] && echo "created DB" || echo DB already exists
######################
#create table
mysql -u $USER $DATABASE << EOF 2>/dev/null
CREATE TABLE $TABLE(
id int,
name varchar(100),
mark int,
dept varchar(4)
);
EOF
[ $? -eq 0 ] && echo "Created table students" || echo "Table students already exist" 
######################
#delete data
mysql -u $USER $DATABASE << EOF 2>/dev/null
DELETE FROM $TABLE;
EOF