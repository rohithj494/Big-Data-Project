val delays_total = spark.sql("""
select block as block, count(1) as total_crimes,
  count(if(arrest, 1, null)) as total_arrests,
  count(if(domestic, 1, null)) as total_domestic
  from rohithj_crimes
  group by block""");
  
import org.apache.spark.sql.SaveMode
delays_total.write.mode(SaveMode.Overwrite).saveAsTable("rohithj_total_hive")

val delays_yearly = spark.sql("""
select block as block, count(1) as total_crimes,
  count(if(arrest, 1, null)) as total_arrests,
  count(if(domestic, 1, null)) as total_domestic,
  year as year
  from rohithj_crimes
  group by block, year""");
  
  delays_yearly.write.mode(SaveMode.Overwrite).saveAsTable("rohithj_yearly_hive")
