UPDATE dbo.[Zomato Asia]
SET City = 'Istanbul'
WHERE City= 'ÛÁstanbul'
UPDATE dbo.[Zomato SAM]
SET City = 'São Paulo'
WHERE City = 'Sí£o Paulo';
UPDATE dbo.[Zomato NAM]
SET City = 'Cedar Rapids'
WHERE City = 'Cedar Rapids/Iowa City';


SELECT * INTO forasia from (SELECT *, LEFT([Restaurant Name,Address],CHARINDEX(',',[Restaurant Name,Address])-1) as Restaurant_Name,
RIGHT([Restaurant Name,Address],LEN([Restaurant Name,Address])-CHARINDEX(',',[Restaurant Name,Address])) as Restaurant_Address
FROM dbo.[Zomato Asia]) fa

SELECT * FROM forasia

ALTER TABLE forasia DROP COLUMN [Restaurant Name,Address]

SELECT * INTO forafrica from (SELECT *, LEFT([Restaurant Name,Address],CHARINDEX(',',[Restaurant Name,Address])-1) as Restaurant_Name,
RIGHT([Restaurant Name,Address],LEN([Restaurant Name,Address])-CHARINDEX(',',[Restaurant Name,Address])) as Restaurant_Address
FROM dbo.[Zomato Africa]) faf

SELECT * FROM forafrica

ALTER TABLE forafrica DROP COLUMN [Restaurant Name,Address]

SELECT * INTO foreurope from (SELECT *, LEFT([Restaurant Name,Address],CHARINDEX(',',[Restaurant Name,Address])-1) as Restaurant_Name,
RIGHT([Restaurant Name,Address],LEN([Restaurant Name,Address])-CHARINDEX(',',[Restaurant Name,Address])) as Restaurant_Address
FROM dbo.[Zomato Europe]) fe

SELECT * FROM foreurope

ALTER TABLE foreurope DROP COLUMN [Restaurant Name,Address]

SELECT * INTO fornam from (SELECT *, LEFT([Restaurant Name,Address],CHARINDEX(',',[Restaurant Name,Address])-1) as Restaurant_Name,
RIGHT([Restaurant Name,Address],LEN([Restaurant Name,Address])-CHARINDEX(',',[Restaurant Name,Address])) as Restaurant_Address
FROM dbo.[Zomato NAM]) fn

SELECT * FROM fornam

ALTER TABLE fornam DROP COLUMN [Restaurant Name,Address]

SELECT * INTO foroceania from (SELECT *, LEFT([Restaurant Name,Address],CHARINDEX(',',[Restaurant Name,Address])-1) as Restaurant_Name,
RIGHT([Restaurant Name,Address],LEN([Restaurant Name,Address])-CHARINDEX(',',[Restaurant Name,Address])) as Restaurant_Address
FROM dbo.[Zomato Oceania]) fo

SELECT * FROM foroceania

ALTER TABLE foroceania DROP COLUMN [Restaurant Name,Address]

SELECT * INTO forsam from (SELECT *, LEFT([Restaurant Name,Address],CHARINDEX(',',[Restaurant Name,Address])-1) as Restaurant_Name,
RIGHT([Restaurant Name,Address],LEN([Restaurant Name,Address])-CHARINDEX(',',[Restaurant Name,Address])) as Restaurant_Address
FROM dbo.[Zomato SAM]) fs

SELECT * FROM forsam

ALTER TABLE forsam DROP COLUMN [Restaurant Name,Address]

SELECT * INTO Zomatoasia_africa_Europe_nam_Oceania_sam from (SELECT * FROM forasia
UNION  
SELECT * FROM forafrica 
UNION
SELECT * FROM foreurope
UNION 
SELECT * FROM fornam
UNION
SELECT * FROM foroceania
UNION
SELECT * FROM forsam) forall

SELECT * FROM Zomatoasia_africa_Europe_nam_Oceania_sam

SELECT * INTO lcs
FROM Zomatoasia_africa_Europe_nam_Oceania_sam

SELECT * FROM lcs

ALTER TABLE lcs DROP COLUMN [Country Code],[City],[Locality],[Locality Verbose],[Longitude],[Latitude],[Restaurant_Address]

SELECT * INTO listofcuisines from
(SELECT * FROM lcs 
CROSS APPLY string_split(Cuisines,',')) AS lc

SELECT * FROM listofcuisines

ALTER TABLE listofcuisines DROP COLUMN [Cuisines]

SELECT * INTO CCO from (SELECT DISTINCT[Country Code],[Country]
FROM dbo.[Country Master] WHERE [Country Code] IS NOT NULL) AS cc 

SELECT * FROM CCO

SELECT * INTO CounrtyCode From (SELECT *,
CASE
   WHEN Country = 'South Africa' THEN 'Africa' 
   WHEN Country = 'United Kingdom' THEN 'Europe' 
   WHEN Country = 'United States' THEN 'North America'
   WHEN Country = 'Canada' THEN 'North America'
   WHEN Country = 'Australia' THEN 'Oceania'
   WHEN Country = 'New Zealand' THEN 'Oceania'
   WHEN Country = 'Brazil' THEN 'South America'
   ELSE 'Asia'
END AS Continent
FROM CCO) As ccod

SELECT * FROM CounrtyCode

 
SELECT * INTO CountryMaster from (SELECT c.[Country Code],c.[Country],c.[Continent],z.[City] from CounrtyCode as c
LEFT JOIN Zomatoasia_africa_Europe_nam_Oceania_sam  as z
ON c.[Country Code] = z.[Country Code] ) as a

SELECT * FROM CountryMaster

SELECT * FROM dbo.KPIs

SELECT * INTO allRestaurant FROM (SELECT *, 
CASE 
    WHEN [Aggregate rating] >= 4.5 THEN 'Dark Green' 
	WHEN [Aggregate rating] >= 4 THEN 'Green'
	WHEN [Aggregate rating] >= 3.5 THEN 'Yellow'
	WHEN [Aggregate rating] >= 2.5 THEN 'Orange'
	WHEN [Aggregate rating] >= 1.8 THEN 'Red'
	ELSE 'White'
END AS Rating_Color
FROM dbo.KPIs) as ab

SELECT * FROM allRestaurant

