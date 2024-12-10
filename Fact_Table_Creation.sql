CREATE SEQUENCE fact_seq START = 1 INCREMENT = 1;
CREATE OR REPLACE TABLE SpotifyPlaylists_Track (
    spotifyplaylists_track_key INT PRIMARY KEY, 
    playlist_id STRING NOT NULL,
    playlist_name STRING,
    playlist_description STRING,
    playlist_version STRING,
    track_id STRING NOT NULL,
    track_name STRING,
    track_added DATE, 
    track_year INT,
    track_month_year STRING,
    weekday_added STRING,
    release_date DATE,
    release_year INT,
    markets_available STRING, 
    track_explicit BOOLEAN,
    artist_list STRING, 
    track_popularity INT,
    track_length_min FLOAT, 
    playlist_followers INT,
    market_count INT, 
    artist_count INT, 
    genre STRING,
    tracks_total INT
);

INSERT INTO SpotifyPlaylists_Track (
    spotifyplaylists_track_key,
    playlist_id,
    playlist_name,
    playlist_description,
    playlist_version,
    track_id,
    track_name,
    track_added,
    track_year,
    track_month_year,
    weekday_added,
    release_date,
    release_year,
    markets_available,
    track_explicit,
    artist_list,
    track_popularity,
    track_length_min,
    playlist_followers,
    market_count,
    artist_count,
    genre,
    tracks_total
)
SELECT
    fact_seq.nextval,  
    playlist_id,
    playlist_name,
    playlist_description,
    playlist_version,
    track_id,
    track_name,
    track_added,
    track_year,
    track_month_year,
    weekday_added,
    release_date,
    release_year,
    markets_available,
    track_explicit,
    artist_list,
    track_popularity,
    track_length_min,
    playlist_followers,
    market_count,
    artist_count,
    genre,
    tracks_total
FROM SpotifyPlaylists_Track_Stage;