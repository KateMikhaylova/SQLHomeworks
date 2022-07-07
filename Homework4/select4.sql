-- ���������� ������������ � ������ �����
SELECT 		g.name 			AS 	"����", 
			COUNT(m.name) 	AS 	"���������� ������������"
FROM 		musicians 		AS 	m
INNER JOIN 	musician_genre 	AS 	mg
ON 			m.id = mg.musician_id 
INNER JOIN 	genres 			AS 	g
ON 			mg.genre_id = g.id 
GROUP BY 	g.name
ORDER BY 	COUNT(m.name) DESC; 

-- ���������� ������, �������� � ������� 2019-2020 �����
SELECT 		COUNT(t.name) 	AS 	"���������� ������"
FROM 		tracks 			AS 	t
INNER JOIN 	albums 			AS 	a 
ON 			t.album_id = a.id 
WHERE 		a.release_year 	BETWEEN 2019 AND 2020;

-- ������� ����������������� ������ �� ������� �������
SELECT 		a.name 	AS 	"������", 
			ROUND((AVG(t.duration)/60)::NUMERIC,0) AS "��. ���������. ������, ���", 
			ROUND((AVG(t.duration)%60)::NUMERIC,0) % 60 AS "���"
FROM 		tracks 	AS 	t
INNER JOIN 	albums 	AS 	a 
ON 			t.album_id = a.id 
GROUP BY 	a.name;

-- ��� �����������, ������� �� ��������� ������� � 2020 ����;
SELECT 	name AS "�����������"
FROM 	musicians
WHERE 	name NOT IN (SELECT		m.name 
					FROM 		musicians 		AS 	m
					INNER JOIN 	album_musician 	AS 	am 
					ON 			m.id = am.musician_id 
					INNER JOIN 	albums 			AS 	a 
					ON 			a.id = am.album_id 
					WHERE a.release_year = 2020
					GROUP BY m.name);

-- �������� ���������, � ������� ������������ ���������� ����������� (�������� ����);
SELECT 		c.name 				AS 	"�������� Eminem"
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

-- �������� ��������, � ������� ������������ ����������� ����� 1 �����;
SELECT 		DISTINCT a.name AS 	"������"
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

-- ������������ ������, ������� �� ������ � ��������;
SELECT 		t.name 				AS 	"����"
FROM 		tracks 				AS 	t
LEFT JOIN 	compilation_track 	AS ct
ON 			t.id = ct.track_id 
WHERE 		ct.track_id 		IS NULL; 

-- �����������(-��), ����������� ����� �������� �� ����������������� ���� (������������ ����� ������ ����� ���� ���������);
SELECT 		m.name 			AS 	"�����������"
FROM 		musicians 		AS 	m 
INNER JOIN 	album_musician 	AS 	am 
ON 			m.id = am.musician_id 
INNER JOIN 	albums 			AS 	a 
ON 			a.id = am.album_id 
INNER JOIN 	tracks 			AS 	t
ON 			t.album_id = a.id 
WHERE 		t.duration = (SELECT MIN(duration) FROM tracks);

-- �������� ��������, ���������� ���������� ���������� ������.

-- ������� 1
SELECT 		a.name 	AS 	"������"
FROM 		albums 	AS 	a 
INNER JOIN 	tracks 	AS 	t
ON 			a.id = t.album_id 
GROUP BY 	a.name 
ORDER BY COUNT(t.name)
LIMIT 1;


-- ������� 2
SELECT 		a.name 	AS 	"������"
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





