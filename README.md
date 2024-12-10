# SnowflakeELT

ELT using Snowflake. I extracted data from using Spotify API. The JSON responses were then dropped into Snowflake stages. From the Stages, the Data was placed into a internal table as their raw data format. This table aimed to serve as a raw data lake since each row represented a raw form of data. From there a view was created that transformed the semi-structured data utlizing the flatten function to create a more relational model that could then be loaded into a fact table.
