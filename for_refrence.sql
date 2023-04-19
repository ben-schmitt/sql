--SQL commands for refrence


\l       -- list databases

\q       -- quit

\dt      -- List relations (tables)


---The following code is adapted for Dr. Charles Severance PostgreSQL for Everybody course material
-- avaliable at https://www.pg4e.com/

-- delete records
DELETE FROM some_table WHERE some_column='something';
-- update column
UPDATE some_table SET another_col="x" WHERE some_column='something';
-- select all records from a table
SELECT * FROM some_table;
-- select all records with where clause
SELECT * FROM some_table WHERE some_column='something';
-- sort results
SELECT * FROM some_table ORDER BY some_column;
-- sort results
SELECT * FROM some_table ORDER BY another_col DESC;
-- select records with like clause
SELECT * FROM some_table WHERE another_col LIKE '%x%';
-- select results with a limit
SELECT * FROM some_table ORDER BY some_column DESC LIMIT 2;
SELECT * FROM some_table ORDER BY some_column OFFSET 1 LIMIT 2;
-- get count of records
SELECT COUNT(*) FROM some_table;
SELECT COUNT(*) FROM some_table WHERE some_col='somthing';

DROP TABLE some_table;


--make related tables
CREATE TABLE artist (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE album (
  id SERIAL,
  title VARCHAR(128) UNIQUE,
  artist_id INTEGER REFERENCES artist(id) ON DELETE CASCADE,
  PRIMARY KEY(id)
);

CREATE TABLE genre (
  id SERIAL,
  name VARCHAR(128) UNIQUE,
  PRIMARY KEY(id)
);

CREATE TABLE track (
    id SERIAL,
    title VARCHAR(128),
    len INTEGER, rating INTEGER, count INTEGER,
    album_id INTEGER REFERENCES album(id) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES genre(id) ON DELETE CASCADE,
    UNIQUE(title, album_id),
    PRIMARY KEY(id)
);

-- Read csv and inset into table

\copy track_raw(title, artist, album, count, rating, len ) FROM 'music_library.csv' WITH DELIMITER ',' CSV;
INSERT INTO album (title) SELECT DISTINCT album FROM track_raw;
INSERT INTO track (title) SELECT title FROM track_raw;
INSERT INTO track ( len) SELECT len FROM track_raw;
INSERT INTO track (rating) SELECT rating FROM track_raw;
INSERT INTO track (count) SELECT count FROM track_raw;
INSERT INTO track (len, rating, count) SELECT len, rating, count FROM track_raw;
UPDATE track SET len = (SELECT track_raw.len FROM track_raw WHERE track.title = track_raw.title);
UPDATE track SET rating = (SELECT track_raw.rating FROM track_raw WHERE track.title = track_raw.title);
UPDATE track SET count = (SELECT track_raw.count FROM track_raw WHERE track.title = track_raw.title);
UPDATE track SET album_id = (SELECT track_raw.album_id FROM track_raw WHERE track.title = track_raw.title);

--Join tables
SELECT album.title, artist.name FROM album JOIN artist 
    ON album.artist_id = artist.id;

SELECT album.title, album.artist_id, artist.id, artist.name 
    FROM album INNER JOIN artist ON album.artist_id = artist.id;

SELECT track.title, track.genre_id, genre.id, genre.name 
    FROM track CROSS JOIN genre;

SELECT track.title, genre.name FROM track JOIN genre 
    ON track.genre_id = genre.id;

SELECT track.title, artist.name, album.title, genre.name 
FROM track 
    JOIN genre ON track.genre_id = genre.id 
    JOIN album ON track.album_id = album.id 
    JOIN artist ON album.artist_id = artist.id;






