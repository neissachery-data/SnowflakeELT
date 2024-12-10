-- Create a table to store metadata along with playlist data
CREATE OR REPLACE TABLE Spotify_Meta (
    playlist_data VARIANT,
    file_name STRING,
    file_type STRING,
    date_ingested TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Load data into Spotify_Meta table while dynamically including metadata
COPY INTO Spotify_Meta (playlist_data, file_name, file_type)
FROM (
    SELECT
        $1 AS playlist_data,
        METADATA$FILENAME AS file_name, -- Extract file name
        CASE
            WHEN METADATA$FILENAME ILIKE '%.json' THEN 'JSON'
            ELSE 'UNKNOWN' 
        END AS file_type
    FROM @spotify_stage
)
FILE_FORMAT = (TYPE = JSON);

-- Verify the loaded data with metadata
SELECT * FROM Spotify_Meta;