create external table rohithj_yearly (
  blockyear string, total_crime bigint,
  total_arrests bigint, total_domestic bigint)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,crimes:total_crimes,crimes:total_arrests,crimes:total_domestic')
TBLPROPERTIES ('hbase.table.name' = 'rohithj_yearly');


insert overwrite table rohithj_yearly
select concat(block, cast(year as string)),
total_crimes,
total_arrests,
total_domestic
from rohithj_yearly_hive;


create external table rohithj_total (
  block string, total_crime bigint,
  total_arrests bigint, total_domestic bigint)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ('hbase.columns.mapping' = ':key,crimes:total_crimes,crimes:total_arrests,crimes:total_domestic')
TBLPROPERTIES ('hbase.table.name' = 'rohithj_total');

insert overwrite table rohithj_total
select block,
total_crimes,
total_arrests,
total_domestic
from rohithj_total_hive;
