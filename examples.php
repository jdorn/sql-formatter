<?php
require_once('SqlFormatter.php');

$sql = "SELECT count(*),`Column1`,`Testing`, `Testing Three` FROM `Table1`
WHERE Column1 = 'testing' AND ( (`Column2` = `Column3` OR Column4 >= NOW()) )
ORDER BY Column3 DESC GROUP BY Column1 LIMIT 5,10";

echo SqlFormatter::format($sql);
?>
