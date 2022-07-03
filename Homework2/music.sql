CREATE TABLE IF NOT EXISTS Genres (
	id SERIAL PRIMARY KEY,
	name VARCHAR(80) UNIQUE NOT NULL
);


CREATE TABLE IF NOT EXISTS Musicians (
	id SERIAL PRIMARY KEY,
	name VARCHAR(400) NOT NULL	
);

CREATE TABLE IF NOT EXISTS MusicianGenre (
	musician_id INTEGER REFERENCES Musicians(id),
	genre_id INTEGER REFERENCES Genres(id),
	CONSTRAINT pkmusiciangenre PRIMARY KEY (musician_id, genre_id)
);

CREATE TABLE IF NOT EXISTS Albums (
	id SERIAL PRIMARY KEY,
	name VARCHAR(1000) NOT NULL,
	releaseyear INTEGER NOT NULL CHECK(releaseyear>1000)
);

CREATE TABLE IF NOT EXISTS AlbumMusician (
	album_id INTEGER REFERENCES Albums(id),
	musician_id INTEGER REFERENCES Musicians(id),
	CONSTRAINT pkalbummusician PRIMARY KEY (album_id, musician_id)
);

CREATE TABLE IF NOT EXISTS Tracks (
	id SERIAL PRIMARY KEY,
	name VARCHAR(1000) NOT NULL,
	duration TIME NOT NULL,
	album_id INTEGER NOT NULL REFERENCES Albums(id)
);

CREATE TABLE IF NOT EXISTS Compilations (
	id  SERIAL PRIMARY KEY,
	name VARCHAR(1000) NOT NULL,
	releaseyear INTEGER NOT NULL CHECK(releaseyear>1000)

);

CREATE TABLE IF NOT EXISTS CompilationTrack (
	compilation_id INTEGER REFERENCES Compilations(id),
	track_id INTEGER REFERENCES Tracks(id),
	CONSTRAINT pkcompilationtrack PRIMARY KEY (compilation_id, track_id)
)