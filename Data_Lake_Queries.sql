--Answering Questions Using my Spotify Datalake

--BSQ1: Which artists have the most popular songs in each genre?

WITH BSQ1 AS (
    SELECT 
        tracks.value:track:name::string AS track_name,
        tracks.value:track:popularity::int AS track_popularity,
        array_to_string(array_agg(artists.value:name), ', ') AS artist_names,
        CASE 
            WHEN lower(playlist_data:name) LIKE '%soca%' THEN 'Soca'
            WHEN lower(playlist_data:name) LIKE '%dancehall%' THEN 'Dancehall'
            WHEN lower(playlist_data:name) LIKE '%kompa%' OR lower(playlist_data:name) LIKE '%haitian%' THEN 'Konpa'
            ELSE 'Other'
        END AS genre
    FROM Spotify_Playlist_DL,
    LATERAL FLATTEN(input => playlist_data:tracks:items) AS tracks,
    LATERAL FLATTEN(input => tracks.value:track.artists) AS artists
    WHERE tracks.value:track:popularity IS NOT NULL
    GROUP BY track_name,track_popularity,genre
),

song_ranking AS (
    SELECT 
        genre,
        artist_names,
        track_name,
        track_popularity,
        RANK() OVER (PARTITION BY genre ORDER BY track_popularity DESC) AS popularity_rank
    FROM BSQ1
)
SELECT * FROM song_ranking
WHERE popularity_rank <= 10;


--BSQ2: On average,how long are songs with high popularity in each genre?
WITH BSQ2 AS (
    SELECT 
        round(avg(tracks.value:track:duration_ms::int/60000),2) AS avg_track_length,
        CASE 
            WHEN lower(playlist_data:name) LIKE '%soca%' THEN 'Soca'
            WHEN lower(playlist_data:name) LIKE '%dancehall%' THEN 'Dancehall'
            WHEN lower(playlist_data:name) LIKE '%kompa%' OR lower(playlist_data:name) LIKE '%haitian%' THEN 'Konpa'
            ELSE 'Other'
        END AS genre
    FROM Spotify_Playlist_DL,
    LATERAL FLATTEN(input => playlist_data:tracks:items) AS tracks
    WHERE tracks.value:track:popularity >= 50
    
    GROUP BY genre  
)
SELECT * FROM BSQ2;
--BSQ3: Does the total number of songs in a genre's playlist correlate to the follower count and average popularity of songs in the playlist?
WITH BSQ3 AS(
    SELECT 
        playlist_data:tracks:total::int AS total_songs,
        playlist_data:name::string AS playlist,
        playlist_data:followers:total::int AS follower_count,
        round(avg(tracks.value:track:popularity::int),2) AS avg_song_popularity,
        CASE 
            WHEN lower(playlist_data:name) LIKE '%soca%' THEN 'Soca'
            WHEN lower(playlist_data:name) LIKE '%dancehall%' THEN 'Dancehall'
            WHEN lower(playlist_data:name) LIKE '%kompa%' OR lower(playlist_data:name) LIKE '%haitian%' THEN 'Konpa'
            ELSE 'Other'
        END AS genre
    FROM Spotify_Playlist_DL,
    LATERAL FLATTEN(input => playlist_data:tracks:items) AS tracks
    GROUP BY total_songs, playlist, follower_count, genre        
)
SELECT * FROM BSQ3;

SELECT array_to_string(array_agg(artists.value:name), ', ') AS artist_names

FROM Spotify_Playlist_DL,
    LATERAL FLATTEN(input => playlist_data:tracks:items) AS tracks,
    LATERAL FLATTEN(input => tracks.value:track.artists) AS artists;


