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

```php
<?php
require_once('SqlFormatter.php');

echo SqlFormatter::format("SELECT * FROM MyTable LIMIT 10");
```

Sample output:

![](http://github.com/jdorn/sql-formatter/raw/master/examples/SqlFormatterExample.png)

Syntax Highlighting Only
-------------------------

There is also a static method 'highlight' that only does syntax highlighting 
and preserves all original whitespace.

This is useful for sql that is already well formatted and just needs to be a little
easier to read.

```php
<?php
echo SqlFormatter::highlight("SELECT * FROM MyTable LIMIT 10");
```

Split SQL String into Queries
--------------------------

Another feature, which is unrelated to formatting, is the ability to break up a SQL string into multiple queries.  

For Example:

```sql
DROP TABLE IF EXISTS MyTable;
CREATE TABLE MyTable ( id int );
INSERT INTO MyTable	(id)
	VALUES
	(1),(2),(3),(4);
SELECT * FROM MyTable;
```

```php
$queries = SqlFormatter::splitQuery($sql);
```
$queries is now an array of the 4 queries without trailing semicolons.

Why not just use explode(';',$sql) or regular expressions?  The following example sql and others like it
are impossible to split correctly using regular expressions.

```sql
SELECT ";"; SELECT ";\"; a;";
SELECT ";
    abc";
SELECT a,b #comment;
FROM test;
```

The splitQuery method will still fail in the following cases:
*    The DELIMITER command can be used to change the delimiter from the default ';' to something else.  
*    The CREATE PROCEDURE command
