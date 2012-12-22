<?php
require '../lib/SqlFormatter.php';
//this is the default value
//set to '0' to disable caching
//a value between 10 and 20 seems to give the best result
SqlFormatter::$max_cachekey_size = 15;

$contents = file('sql.sql');

//track time and memory usage
$start = microtime(true);
$ustart = memory_get_usage(true);

//track number of queries and size of queries
$queries = 0;
$bytes = 0;

//format each query 3 times
for ($i =0; $i<3; $i++) {
    foreach ($contents as $query) {
		//this tries to mix up the queries so we aren't just running the same thing a bunch of times
        $query = str_replace('tablename', rand(1, 10000), $query);

		//do formatting and highlighting
        SqlFormatter::format($query);
        
        $queries++;
        $bytes += strlen($query);
    }
}

$uend = memory_get_usage(true);
$end = microtime(true);

echo "<p>Formatted $queries queries.</p>";

echo "<p>Average query length of ".number_format($bytes/$queries,5)." characters</p>";

echo "<p>Took ".number_format($end-$start,5)." seconds total, ".number_format(($end-$start)/$queries,5)." seconds per query, ".number_format(1000*($end-$start)/$bytes,5)." seconds per 1000 characters</p>";

echo "<p>Used ".number_format($uend-$ustart)." bytes of memory</p>";

echo "<h3>Cache Stats</h3><pre>".print_r(SqlFormatter::getCacheStats(),true)."</pre>";

