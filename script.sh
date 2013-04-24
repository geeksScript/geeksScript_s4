#!/bin/bash
#**************************************
# This Bash Script accomplishes the following task:
#------------------------------------
# Refer below tables:
# Table1:
# Device	Interface               Specified
#------------------------------------------------------
# HDC-TBONE-P1	PO9/0/0-pos		121.36
# ocb-pe1	Gi5/2-ethernetCsmacd	0.17
#______________________________________________________
# Table2:
# CID		Device		Interface	Avgin
#------------------------------------------------------
# HDC-HKG-R01	HDC-TBONE-P1	PO9/0/0	 
# OCB-OCD-R01	OCB-PE1	Gi5/2	 
# HDC-BSA-R01	HDC-TBONE-P1	Se9/2/0
#_____________________________________________________
# 1. It matches the row with this condition: Common values of Device columns AND first three chars of Interface column from both tables. 
# 2. Then the row which matched the above condition from Table1, retrieve the value of Specified column and store it in the Avgin column of the Table2 in the row where above condition matched. 
#------------------------------------
# Tested on Fedora with MySQL version 14.14.
# Created by geeksScript | Sanchit (http://geeksScript.com), Dated: 07-04-2013.
#**************************************

main_block()
{
	echo
	echo -n "Enter MySQL username(eg. root):"
	read username;
	echo -n "Enter MySQL password:"
	stty -echo
	read password;
	stty echo
	echo
	echo -n "Enter Hostname(Enter localhost, if MySQL is on your local system):"
	read host;
	echo -n "Enter MySQL Database Name:"
	read db;
	echo -n "Enter Table Name(With 'Specified' Column):"
	read table1;
	echo -n "Enter Table Name(With 'Avgin' Column):"
	read table2;

	mysql -u $username -p$password -h $host $db -Bse "UPDATE $table2 SET avgin=ifnull((SELECT Specified FROM $table1 WHERE $table1.Device=$table2.Device AND substring($table1.Interface,1,3)=substring($table2.Interface,1,3) LIMIT 1),'---');" 2>/dev/null 

if [ ! $? = 0 ]; then
	echo -n "Wrong Credentials/Details Provided. Try again..";
	echo;main_block;
else
	echo "'Avgin' Column Updated."
fi
}

main_block;
