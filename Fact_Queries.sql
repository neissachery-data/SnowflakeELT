--My Queries using my Fact Table

--BSQ1: Which artists have the most popular songs in each genre?
WITH BSQ1 AS
(SELECT 
        genre,
        artist_list,
        track_name,
        track_popularity,
        RANK() OVER (PARTITION BY genre ORDER BY track_popularity DESC) AS popularity_rank
    FROM SpotifyPlaylists_Track
)
SELECT * FROM BSQ1
WHERE popularity_rank <= 10;

--BSQ2: On average,how long are songs with high popularity in each genre?
SELECT
    genre,
    round(avg(track_length_min),2) as avg_song_length
FROM SpotifyPlaylists_Track
WHERE track_popularity >= 50
GROUP BY genre;

--BSQ3 Does the total number of songs in a genre's playlist correlate to the follower count and average popularity of songs in the playlist?

SELECT
    genre,
    playlist_name,
    playlist_followers,
    tracks_total,
    round(avg(track_popularity),2) as avg_popularity
FROM SPOTIFYPLAYLISTS_TRACK
GROUP BY genre, playlist_name, playlist_followers, tracks_total;

 SELECT * FROM SPOTIFYPLAYLISTS_TRACK LIMIT 10;