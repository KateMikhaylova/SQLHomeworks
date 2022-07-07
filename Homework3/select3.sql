-- название и год выхода альбомов, вышедших в 2018 году
SELECT	name AS "Название", 
		release_year AS "Год выхода"
FROM 	albums 
WHERE 	release_year = 2018;

-- название и продолжительность самого длительного трека

-- вариант 1
SELECT 	 name AS "Название", 
		 duration / 60 AS "Продолжительность, мин",
	 	 duration % 60 AS "сек"
FROM 	 tracks 
ORDER BY duration DESC 
LIMIT 	 1;

-- вариант 2
SELECT 	name AS "Название",
		duration / 60 AS "Продолжительность, мин",
		duration % 60 AS "сек"
FROM 	tracks 
WHERE 	duration = (SELECT	MAX(duration) 
					  FROM 	tracks);

-- название треков, продолжительность которых не менее 3,5 минуты
SELECT 	name AS "Название"
FROM 	tracks 
WHERE 	duration >= 210;

-- названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT 	name AS "Название" 
FROM 	compilations
WHERE 	release_year BETWEEN 2018 AND 2020;

-- исполнители, чье имя состоит из 1 слова
SELECT 	name AS "Исполнитель"
FROM 	musicians
WHERE 	name NOT LIKE '% %';

-- название треков, которые содержат слово "мой"/"my"

/*вариант 1, есть риск подхватить песни со словами, 
в состав которых входит заданное слово*/
SELECT 	name AS "Название"
FROM 	tracks
WHERE 	name ILIKE '%my%' 
		OR 
		name ILIKE '%mein%';

-- вариант 2
SELECT 	name AS "Название"
FROM 	tracks
WHERE 	name ~* '\mmy\M' 
		OR 
		name ~* '\mmein\M';



