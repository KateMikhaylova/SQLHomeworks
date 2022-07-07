-- �������� � ��� ������ ��������, �������� � 2018 ����
SELECT	name AS "��������", 
		release_year AS "��� ������"
FROM 	albums 
WHERE 	release_year = 2018;

-- �������� � ����������������� ������ ����������� �����

-- ������� 1
SELECT 	 name AS "��������", 
		 duration / 60 AS "�����������������, ���",
	 	 duration % 60 AS "���"
FROM 	 tracks 
ORDER BY duration DESC 
LIMIT 	 1;

-- ������� 2
SELECT 	name AS "��������",
		duration / 60 AS "�����������������, ���",
		duration % 60 AS "���"
FROM 	tracks 
WHERE 	duration = (SELECT	MAX(duration) 
					  FROM 	tracks);

-- �������� ������, ����������������� ������� �� ����� 3,5 ������
SELECT 	name AS "��������"
FROM 	tracks 
WHERE 	duration >= 210;

-- �������� ���������, �������� � ������ � 2018 �� 2020 ��� ������������
SELECT 	name AS "��������" 
FROM 	compilations
WHERE 	release_year BETWEEN 2018 AND 2020;

-- �����������, ��� ��� ������� �� 1 �����
SELECT 	name AS "�����������"
FROM 	musicians
WHERE 	name NOT LIKE '% %';

-- �������� ������, ������� �������� ����� "���"/"my"

/*������� 1, ���� ���� ���������� ����� �� �������, 
� ������ ������� ������ �������� �����*/
SELECT 	name AS "��������"
FROM 	tracks
WHERE 	name ILIKE '%my%' 
		OR 
		name ILIKE '%mein%';

-- ������� 2
SELECT 	name AS "��������"
FROM 	tracks
WHERE 	name ~* '\mmy\M' 
		OR 
		name ~* '\mmein\M';



