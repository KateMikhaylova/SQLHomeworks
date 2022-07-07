-- количество исполнителей в каждом жанре
SELECT 		g.name 			AS 	"Жанр", 
			COUNT(m.name) 	AS 	"Количество исполнителей"
FROM 		musicians 		AS 	m
INNER JOIN 	musician_genre 	AS 	mg
ON 			m.id = mg.musician_id 
INNER JOIN 	genres 			AS 	g
ON 			mg.genre_id = g.id 
GROUP BY 	g.name
ORDER BY 	COUNT(m.name) DESC; 

-- количество треков, вошедших в альбомы 2019-2020 годов
SELECT 		COUNT(t.name) 	AS 	"Количество треков"
FROM 		tracks 			AS 	t
INNER JOIN 	albums 			AS 	a 
ON 			t.album_id = a.id 
WHERE 		a.release_year 	BETWEEN 2019 AND 2020;

-- средняя продолжительность треков по каждому альбому
SELECT 		a.name 	AS 	"Альбом", 
			ROUND((AVG(t.duration)/60)::NUMERIC,0) AS "Ср. продолжит. треков, мин", 
			ROUND((AVG(t.duration)%60)::NUMERIC,0) % 60 AS "сек"
FROM 		tracks 	AS 	t
INNER JOIN 	albums 	AS 	a 
ON 			t.album_id = a.id 
GROUP BY 	a.name;

-- все исполнители, которые не выпустили альбомы в 2020 году;
SELECT 	name AS "Исполнитель"
FROM 	musicians
WHERE 	name NOT IN (SELECT		m.name 
					FROM 		musicians 		AS 	m
					INNER JOIN 	album_musician 	AS 	am 
					ON 			m.id = am.musician_id 
					INNER JOIN 	albums 			AS 	a 
					ON 			a.id = am.album_id 
					WHERE a.release_year = 2020
					GROUP BY m.name);

-- названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
SELECT 		c.name 				AS 	"Сборники Eminem"
FROM 		compilations 		AS 	c 
INNER JOIN 	compilation_track 	AS 	ct 
ON 			c.id = ct.compilation_id 
INNER JOIN 	tracks 				AS 	t 
ON 			t.id = ct.track_id 
INNER JOIN 	albums 				AS 	a 
ON 			a.id = t.album_id 
INNER JOIN 	album_musician 		AS 	am 
ON 			a.id = am.album_id 
INNER JOIN 	musicians 			AS 	m 
ON 			m.id = am.musician_id 
WHERE 		m.name = 'Eminem'
GROUP BY 	c.name;

-- название альбомов, в которых присутствуют исполнители более 1 жанра;
SELECT 		DISTINCT a.name AS 	"Альбом"
FROM 		albums 			AS 	a
INNER JOIN 	album_musician 	AS 	am 
ON 			a.id = am.album_id 
INNER JOIN 	musicians 		AS 	m 
ON 			m.id = am.musician_id
INNER JOIN 	musician_genre 	AS 	mg 
ON 			mg.musician_id = m.id 
INNER JOIN 	genres 			AS 	g 
ON 			g.id = mg.genre_id 
GROUP BY 	a.name, 
			m.name
HAVING 		COUNT(DISTINCT g.name) > 1;

-- наименование треков, которые не входят в сборники;
SELECT 		t.name 				AS 	"Трек"
FROM 		tracks 				AS 	t
LEFT JOIN 	compilation_track 	AS ct
ON 			t.id = ct.track_id 
WHERE 		ct.track_id 		IS NULL; 

-- исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
SELECT 		m.name 			AS 	"Исполнитель"
FROM 		musicians 		AS 	m 
INNER JOIN 	album_musician 	AS 	am 
ON 			m.id = am.musician_id 
INNER JOIN 	albums 			AS 	a 
ON 			a.id = am.album_id 
INNER JOIN 	tracks 			AS 	t
ON 			t.album_id = a.id 
WHERE 		t.duration = (SELECT MIN(duration) FROM tracks);

-- название альбомов, содержащих наименьшее количество треков.

-- Вариант 1
SELECT 		a.name 	AS 	"Альбом"
FROM 		albums 	AS 	a 
INNER JOIN 	tracks 	AS 	t
ON 			a.id = t.album_id 
GROUP BY 	a.name 
ORDER BY COUNT(t.name)
LIMIT 1;


-- Вариант 2
SELECT 		a.name 	AS 	"Альбом"
FROM 		albums 	AS 	a 
INNER JOIN 	tracks 	AS 	t
ON 			a.id = t.album_id 
GROUP BY 	a.name 
HAVING 		COUNT(t.name) = (SELECT MIN(quantity) FROM (SELECT 		COUNT(t.name) 	AS 	quantity
														FROM 		albums 			AS 	a 
														INNER JOIN 	tracks 			AS 	t
														ON 			a.id = t.album_id 
														GROUP BY 	a.name) 		
												  AS 	foo)





