<?php
require '../lib/SqlFormatter.php';

//the sample query file is filled with install scripts for PrestaShop
//and some sample catalog data from Magento
$contents = file_get_contents('sql.sql');

//queries are separated by 2 new lines
$queries = explode("\n\n",$contents);

$output = "";

foreach ($queries as $query) {
	//do formatting and highlighting
	$output .= SqlFormatter::format($query);
	$output .= "\n";
}

$expected = file_get_contents('expected.html');

if($expected === $output) echo "Got expected output.  No changes found.";
else echo $output;
