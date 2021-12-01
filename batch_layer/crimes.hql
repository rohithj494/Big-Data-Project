DROP TABLE IF EXISTS rohithj_crimes_csv;
CREATE EXTERNAL TABLE rohithj_crimes_csv(
    id string,
    case_number string,
    crime_date timestamp,
    block string,
    iucr string,
    primary_type string,
    description string,
    location_desc string,
    arrest boolean,
    domestic boolean,
    beat int,
    district int,
    ward int,
    community_area int,
    fbi_code string,
    xcoord bigint,
    ycoord bigint,
    crime_year int,
    updated_on timestamp,
    latitude decimal(10, 8),
    longitude decimal(10, 8),
    crime_location string

)
    ROW FORMAT serde 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = "\,",
    "quoteChar"     = "\"",
    "timestamp.formats" = "MM/dd/yyyy hh:mm:ss a"
)
STORED AS TEXTFILE
LOCATION '/tmp/rohithj'
TBLPROPERTIES("skip.header.line.count"="1");

-- Making an orc table

-- Create an ORC table to hold data
DROP TABLE IF EXISTS rohithj_crimes;
CREATE EXTERNAL TABLE rohithj_crimes(
    id string,
    case_number string,
    crime_date timestamp,
    block string,
    iucr string,
    primary_type string,
    description string,
    location_desc string,
    arrest boolean,
    domestic boolean,
    beat int,
    district int,
    ward int,
    community_area int,
    fbi_code string,
    xcoord bigint,
    ycoord bigint,
    crime_year int,
    updated_on timestamp,
    latitude decimal(10, 8),
    longitude decimal(10, 8),
    crime_location string
)
    stored as orc;

    -- transfer data to orc table

INSERT OVERWRITE TABLE rohithj_crimes
SELECT

    id,
    case_number,
    from_unixtime(unix_timestamp(crime_date,"MM/dd/yyyy hh:mm:ss a")),
    block,
    iucr,
    primary_type,
    description,
    location_desc,
    CAST(arrest='true' AS unsigned),
    CAST(domestic='true' AS unsigned),
    beat,
    district,
    ward,
    community_area,
    fbi_code,
    xcoord,
    ycoord,
    crime_year,
    from_unixtime(unix_timestamp(updated_on,"MM/dd/yyyy hh:mm:ss a")),
    latitude,
    longitude,
    crime_location

FROM rohithj_crimes_csv
WHERE crime_date is not null and block is not null
    and arrest is not null and domestic is not null
    and crime_year is not null;
