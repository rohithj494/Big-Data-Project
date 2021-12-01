#!/bin/bash
options="jdbc:hive2://localhost:10000/default -n hadoop -d org.apache.hive.jdbc.HiveDriver"
beeline -u ${options} -f crimes.hql