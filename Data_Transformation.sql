CREATE OR REPLACE VIEW SpotifyPlaylists_Track_Stage AS
SELECT
    playlist_data:id::string AS playlist_id,
    playlist_data:name::string AS playlist_name,
    playlist_data:description::string AS playlist_description,
    playlist_data:snapshot_id::string AS playlist_version,
    tracks.value:track:id::string AS track_id,
    tracks.value:track:name::string AS track_name,
    (tracks.value:track:added_at) AS track_added, 
    YEAR(TRY_CAST(tracks.value:track:added_at::string AS DATE)) AS track_year,  
    CONCAT(MONTHNAME(TRY_CAST(tracks.value:track:added_at::string AS DATE)), '-', YEAR(TRY_CAST(tracks.value:track:added_at::string AS DATE))) AS track_month_year,
    DAYNAME(TRY_CAST(tracks.value:track:added_at::string AS DATE)) AS weekday_added,
    TRY_CAST(tracks.value:track:release_date::string AS DATE) AS release_date,  -- Handle string-to-date conversion
    YEAR(TRY_CAST(tracks.value:track:release_date::string AS DATE)) AS release_year,
    ARRAY_TO_STRING(tracks.value:track:available_markets, ',') AS markets_available,
    tracks.value:track:explicit::boolean AS track_explicit,
    ARRAY_TO_STRING(ARRAY_AGG(DISTINCT artists.value:name), ', ') AS artist_list,
    tracks.value:track:popularity::int AS track_popularity,
    ROUND(tracks.value:track:duration_ms::int / 60000, 2) AS track_length_min,
    playlist_data:followers:total::int AS playlist_followers,
    COUNT(DISTINCT market.value::string) AS market_count, 
    COUNT(DISTINCT artists.value:name) AS artist_count,
    playlist_data:tracks:total as tracks_total,
    CASE 
            WHEN lower(playlist_data:name) LIKE '%soca%' THEN 'Soca'
            WHEN lower(playlist_data:name) LIKE '%dancehall%' THEN 'Dancehall'
            WHEN lower(playlist_data:name) LIKE '%kompa%' OR lower(playlist_data:name) LIKE '%haitian%' THEN 'Konpa'
            ELSE 'Other'
        END AS genre

FROM 
    Spotify_Playlist_DL,
    LATERAL FLATTEN(input => playlist_data:tracks:items) AS tracks,
    LATERAL FLATTEN(input => tracks.value:track:artists) AS artists,
    LATERAL FLATTEN(input => tracks.value:track:available_markets) AS market 

GROUP BY 
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
    track_popularity,
    track_length_min,
    playlist_followers,
    genre,
    tracks_total;

select * from spotifyplaylists_track_stage limit 100;

select count(tracks.value:track:id::string)
from Spotify_Playlist_DL,
    LATERAL FLATTEN(input => playlist_data:tracks:items) AS tracks;