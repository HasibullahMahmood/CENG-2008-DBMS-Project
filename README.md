# DBMS-Project

       (CPS) 
Chicago Public Schools      
2013-2014 Academic Year


1) Team members: 

Ahmed Hassan M. H. Ibrahim  
Hasibullah Mahmood          

2) Data explanation:

. Brief description: 
CPS schools for the 2013-2014 academic year database includes various identifiers used to identify school districts, including names; local, state, and federal IDs; and geographic descriptions on the location of each school.


.	The purpose of your project:
To learn how to create databases, manage and query them. Also, to get our hands dirty with MySQL workbench and querying in SQL.

•	Number of existing files :
     		12 files
Name of files	Number of rows	Number of columns
address	672	17
charter_type	4	2
community	77	2
geographic_area	30	2
governance	3	2
grades	1337	4
NCES	672	4
program_types	33	2
school_category	3	2
school_program_types	878	2
school_type	11	4
schools	672	11
.      Kaggle address of the raw data:
           https://www.kaggle.com/chicago/chicago-cps-schools-2013-2014-academic-year
•       Bitbucket URL of the ER diagram (.mwb file)
https://bitbucket.org/U160709073/database_project/src/ 

3) 10 English questions to query the database system: 

1.	Show the schools full name which exist in “Bronzeville” Geographic
Area?
2.	Show the ES schools in “Logan square” community area?
3.	Show the HS schools which has a contract type?
4.	Show the schools which have PK-8th attending grades and Early_Childhood_Program in 2th US Congressional District? 
5.	Show the community area that has the most schools in it?
6.	Show the community area that has the least schools in it?
7.	Show the average number of schools according to geographic area?
8.	Show all the ES schools, community area west town and located in ward 1?
9.	Which school has the most programs?
10.	What is the popular program in schools?



4) Relational data model (ER diagram):


 











5) The SQL statements that will implement the English questions:

1.	SELECT full_name
From schools 
WHERE cps_unit in (SELECT cps_unit 
FROM address JOIN geographic_area USING(geographic_area_number)
WHERE geographic_area_name = "Bronzeville");

     2. SELECT full_name
FROM schools JOIN school_category
WHERE schools.school_category_id = school_category.id
AND school_category.name = "ES" AND cps_unit IN (SELECT cps_unit
FROM address JOIN community USING(community_area_number)
WHERE community_area_name = "Logan square");

     3. SELECT full_name
FROM schools JOIN school_category
			JOIN school_type
WHERE schools.school_category_id = school_category.id
AND	schools.school_type_id = school_type.id
AND school_category.name = "HS"
AND school_type_name = "contract";

       4. SELECT full_name
FROM schools JOIN grades USING(cps_unit)
WHERE grades.from = "PK"
AND grades.upto = "8th"
AND cps_unit IN (SELECT cps_unit
FROM school_program_type JOIN schools USING(cps_unit)
					JOIN program_types
WHERE school_program_type.program_types_id = program_types.id
AND program_types.name = "Early_Childhood_Program"
AND cps_unit IN (SELECT cps_unit
FROM schools JOIN address USING(cps_unit)
WHERE us_congressional_district = 2));


 5. SELECT community_area_name, COUNT(*) AS count
FROM address JOIN community USING(community_area_number)
GROUP BY community_area_name
ORDER BY count DESC
LIMIT 1;

    6. SELECT community_area_name, COUNT(*) AS count
FROM address JOIN community USING(community_area_number)
GROUP BY community_area_name
ORDER BY count 
LIMIT 3;

    7. SELECT ROUND(AVG(counts)) AS average
FROM (
SELECT COUNT(*) AS counts
FROM address JOIN geographic_area USING(geographic_area_number)
GROUP BY geographic_area_name) AS counts;


    8. SELECT full_name
FROM schools JOIN school_category 
ON schools.school_category_id = school_category.id
WHERE school_category.name = "ES"
AND cps_unit IN (SELECT cps_unit
FROM address JOIN schools USING(cps_unit)
			 JOIN community USING(community_area_number)
WHERE community_area_name = "west town"
AND ward = 1);

    9. 	SELECT full_name
FROM schools JOIN 
(
SELECT cps_unit, count(cps_unit) counts
FROM schools JOIN school_program_type USING(cps_unit)
ORDER BY counts DESC
LIMIT 1) AS NEWTABLE USING(cps_unit);

10.  	SELECT *
FROM program_types JOIN 
(SELECT program_types_id AS id, count(program_types_id) counts
FROM school_program_type JOIN schools USING(cps_unit)
GROUP BY program_types_id) AS program_type_count USING(id)
ORDER BY counts DESC;


 VIEW:
CREATE VIEW schools_per_geogrphic_area AS 
SELECT geographic_area_name, COUNT(*) AS counts
FROM address JOIN geographic_area USING(geographic_area_number)
GROUP BY geographic_area_name
ORDER BY counts DESC;

 STORED PROCEDURES:

CREATE DEFINER=`root`@`localhost` PROCEDURE `SchoolsForGivenCategory`(IN category CHAR(2))
BEGIN
SELECT full_name
FROM schools JOIN school_category ON school_category_id = id
WHERE name = category
ORDER BY full_name;
END
CALL SchoolsForGivenCategory('MS');
--------------------------------------------------------------------------------------------------------------------------------------------

CREATE DEFINER=`root`@`localhost` PROCEDURE `GovernanceForGivenCPSunit `(IN cps SMALLINT, OUT governance_type VARCHAR(15))
BEGIN
SELECT name INTO governance_type
FROM schools JOIN governance ON governance_id = id
WHERE cps_unit=cps;
END

CALL GovernanceForGivenCPSunit(1105, @governanceType);
SELECT @governanceType;


CREATE DEFINER=`root`@`localhost` PROCEDURE ` school_with_most_programs`(OUT schoolName VARCHAR(100))
BEGIN
SELECT full_name INTO schoolName
FROM schools JOIN 
(
SELECT cps_unit, count(cps_unit) counts
FROM schools JOIN school_program_type USING(cps_unit)
ORDER BY counts DESC
LIMIT 1) AS NEWTABLE USING(cps_unit);
END

CALL school_with_most_programs(@schoolName);
SELECT @schoolName;





6) The way of loading the database with values: 

Dataset were downloaded from Kaggle website. Then, it was cleaned by coding some python scripts. After learning the data, the ER diagram was created. Then, CSV file was created for each entity. Data was inserted by using MySQL workbench (import records from external file) in the inserts choice for each entity and then forward engineering was used to take the script and the empty entries replaced by null and then the script was executed to create the database. 


7) GUI:

Creating a map which will take each longitude and latitude of every school and make a pointer on the place of each school then when the user click on the pointer it will show to them a summary of each school. An enabling GPS location to measure the distance between the user and specific school.

8) The database platform we plan to use: 

MySQL 8.0 ON PC LAPTOP INTEL CORE i5, RAM 4 GB, 500 HDD  


9) OUTPUTS:
OUTPUT OF VIEW:
SELECT *
FROM schools_per_geogrphic_area;
View output.csv
Output of first stored procedure:
	CALL SchoolsForGivenCategory('MS');
first_procedure_output.csv
Output of second stored procedure:
	CALL school_governance(1105, @governanceType);
SELECT @governanceType;
		'Charter'
Output of third stored procedure:
	CALL school_with_most_programs(@schoolName);
SELECT @schoolName;
'Collins Academy High School'

10) System’s limitations and suggested improvement:
The CPS dataset entries are not too large so our system works fine. If the data entries were very large then it was need to improve the ram or other components of the system hardware or search for better ways to load and query the data. For example, loading data by using “(import records from external file) in the inserts choice” takes lots of time and workbench may crush but loading by script is much faster.

load data local infile "file location"
into table tablename fields terminated by ',' enclosed by '"';

Full relational table specification (SQL):
For full relational table specification of our database in DDL please click the following link.
school_db.sql.txt

Codes for acquiring data:
The python codes which were used for cleaning data, is provided in the bellow link.
Python_codes.docx

SQL_CODES:
Sql_codes.docx

