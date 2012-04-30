SqlFormatter
=============

A lightweight php class for formatting sql statements.  Handles automatic
indentation and syntax highlighting.

History
============

I found myself having to debug auto-generated SQL statements all the time and
wanted some way to easily output formatted HTML without having to include a 
huge library or copy and paste into online formatters.

I was originally planning to extract the formatting code from PhpMyAdmin,
but that was 10,000+ lines of code and used global variables.

I saw that other people had the same problem and used Stack Overflow user 
losif's answer as a starting point.  http://stackoverflow.com/a/3924147

Usage
============

The SqlFormatter class has a static method 'format' which takes a SQL string  
as input and returns a formatted HTML block inside a pre tag. 

Sample usage:

    <?php
    require_once('SqlFormatter.php');
    
    echo SqlFormatter::format("SELECT * FROM Table LIMIT 10");
    ?>
