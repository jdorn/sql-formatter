<?php
require_once(__DIR__.'/../lib/SqlFormatter.php');

echo SqlFormatter::format("-- This is a cool query\nSELECT `Column1`, 'test' FROM Mytable WHERE (id >= 8); (test))(((");
