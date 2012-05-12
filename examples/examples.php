<?php
require_once('../SqlFormatter.php');

$statements = array(
	"SELECT * FROM MyTable WHERE id = 46",
	
	"SELECT count(*),`Column1`,`Testing`, `Testing Three` FROM `Table1`
	WHERE Column1 = 'testing' AND ( (`Column2` = `Column3` OR Column4 >= NOW()) )
	GROUP BY Column1 ORDER BY Column3 DESC LIMIT 5,10",
	
	"select * from `Table`, (SELECT group_concat(column1) as col FROM Table2 GROUP BY category) 
	Table2, Table3 where Table2.col = (Table3.col2 - `Table`.id)",
	
	"insert ignore into Table3 (column1, column2) VALUES ('test1','test2'), ('test3','test4');",
	
	"UPDATE MyTable SET name='sql', category='databases' WHERE id > '65'",
	
	"delete from MyTable WHERE name LIKE \"test%\"",
	
	"SELECT * FROM UnmatchedParens WHERE ( A = B)) AND (((Test=1)",
	
	"-- This is a comment
	SELECT
	/* This is another comment
	On more than one line */ 
	Id #This is one final comment
	as temp, DateCreated as Created FROM MyTable;",
);

echo "<h1>Formatting</h1>";
foreach($statements as $sql) {
	echo "<hr />";
	echo SqlFormatter::format($sql);
}

echo "<h1>Syntax Highlighting Only</h1>";
foreach($statements as $sql) {
	echo "<hr />";
	echo SqlFormatter::highlight($sql);
}
?>
