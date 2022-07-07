CREATE TABLE IF NOT EXISTS Genres (
	id 		SERIAL 		PRIMARY KEY,
	name 	VARCHAR(80) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS Musicians (
	id 		SERIAL 			PRIMARY KEY,
	name 	VARCHAR(200) 	NOT NULL	
);

CREATE TABLE IF NOT EXISTS Musician_Genre (
	musician_id 	INTEGER 			REFERENCES Musicians(id),
	genre_id 		INTEGER 			REFERENCES Genres(id),
	CONSTRAINT 		pk_musician_genre 	PRIMARY KEY (musician_id, genre_id)
);

CREATE TABLE IF NOT EXISTS Albums (
	id 				SERIAL 			PRIMARY KEY,
	name 			VARCHAR(200) 	NOT NULL,
	release_year 	INTEGER 		NOT NULL 
									CHECK(release_year BETWEEN 1000 AND 3000)
);

CREATE TABLE IF NOT EXISTS Album_Musician (
	album_id 		INTEGER 			REFERENCES Albums(id),
	musician_id 	INTEGER 			REFERENCES Musicians(id),
	CONSTRAINT 		pk_album_musician 	PRIMARY KEY (album_id, musician_id)
);

CREATE TABLE IF NOT EXISTS Tracks (
	id 			SERIAL 			PRIMARY KEY,
	name 		VARCHAR(200) 	NOT NULL,
	duration 	INTEGER 		NOT NULL,
	album_id 	INTEGER 		NOT NULL REFERENCES Albums(id)
);

CREATE TABLE IF NOT EXISTS Compilations (
	id  			SERIAL 			PRIMARY KEY,
	name 			VARCHAR(200) 	NOT NULL,
	release_year 	INTEGER 		NOT NULL 
									CHECK(release_year BETWEEN 1000 AND 3000)

);

CREATE TABLE IF NOT EXISTS Compilation_Track (
	compilation_id 	INTEGER 				REFERENCES Compilations(id),
	track_id 		INTEGER 				REFERENCES Tracks(id),
	CONSTRAINT 		pk_compilation_track 	PRIMARY KEY (compilation_id, track_id)
);


















