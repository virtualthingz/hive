set hive.mapred.mode=nonstrict;
set hive.optimize.skewjoin.compiletime = true;

CREATE TABLE T1_n101(key STRING, val STRING)
SKEWED BY (key) ON ((2)) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/T1.txt' INTO TABLE T1_n101;

CREATE TABLE T2_n64(key STRING, val STRING)
SKEWED BY (key) ON ((3)) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/T2.txt' INTO TABLE T2_n64;

-- a simple join query with skew on both the tables on the join key
-- adding a order by at the end to make the results deterministic

EXPLAIN
SELECT a.*, b.* FROM T1_n101 a JOIN T2_n64 b ON a.key = b.key;

SELECT a.*, b.* FROM T1_n101 a JOIN T2_n64 b ON a.key = b.key
ORDER BY a.key, b.key, a.val, b.val;

-- test outer joins also

EXPLAIN
SELECT a.*, b.* FROM T1_n101 a RIGHT OUTER JOIN T2_n64 b ON a.key = b.key;

SELECT a.*, b.* FROM T1_n101 a RIGHT OUTER JOIN T2_n64 b ON a.key = b.key
ORDER BY a.key, b.key, a.val, b.val;

-- an aggregation at the end should not change anything

EXPLAIN
SELECT count(1) FROM T1_n101 a JOIN T2_n64 b ON a.key = b.key;

SELECT count(1) FROM T1_n101 a JOIN T2_n64 b ON a.key = b.key;

EXPLAIN
SELECT count(1) FROM T1_n101 a RIGHT OUTER JOIN T2_n64 b ON a.key = b.key;

SELECT count(1) FROM T1_n101 a RIGHT OUTER JOIN T2_n64 b ON a.key = b.key;
