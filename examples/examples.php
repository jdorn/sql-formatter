<!DOCTYPE html>
<html>
<head>
    <title>SqlFormatter Examples</title>
    <style>
        body {
            font-family: arial;
        }

        table, td, th {
            border: 1px solid #aaa;
        }

        table {
            border-width: 1px 1px 0 0;
            border-spacing: 0;
        }

        td, th {
            border-width: 0 0 1px 1px;
            padding: 5px 10px;
            vertical-align: top;
        }

        pre {
            padding: 0;
            margin: 0;
        }
    </style>
</head>
<body>
<?php

require_once('../lib/SqlFormatter.php');

// Example statements for formatting and highlighting
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

// Example statements for splitting SQL strings into individual queries
$split_statements = array(
    "DROP TABLE IF EXISTS MyTable;
    CREATE TABLE MyTable ( id int );
    INSERT INTO MyTable    (id)
        VALUES
        (1),(2),(3),(4);
    SELECT * FROM MyTable;",

    "SELECT \";\"; SELECT \";\\\"; a;\";
    SELECT \";
        abc\";
    SELECT a,b #comment;
    FROM test;",
);

// Example statements for removing comments
$comment_statements = array(
    "-- This is a comment
    SELECT
    /* This is another comment
    On more than one line */
    Id #This is one final comment
    as temp, DateCreated as Created FROM MyTable;",
);
?>


<h1>Formatting</h1>

<div>
    Usage:
    <pre>
    <?php highlight_string('<?php' . "\n" . '$formatted = SqlFormatter::format($sql);' . "\n" . '?>'); ?>
    </pre>
</div>
<table>
    <tr>
        <th>Original</th>
        <th>Formatted</th>
    </tr>
    <?php foreach ($statements as $sql) { ?>
    <tr>
        <td>
            <pre><?php echo $sql; ?></pre>
        </td>
        <td><?php echo SqlFormatter::format($sql); ?></td>
    </tr>
    <?php }    ?>
</table>


<h1>Syntax Highlighting Only</h1>

<div>
    Usage:
    <pre>
    <?php highlight_string('<?php' . "\n" . '$highlighted = SqlFormatter::highlight($sql);' . "\n" . '?>'); ?>
    </pre>
</div>
<table>
    <tr>
        <th>Original</th>
        <th>Highlighted</th>
    </tr>
    <?php foreach ($statements as $sql) { ?>
    <tr>
        <td>
            <pre><?php echo $sql; ?></pre>
        </td>
        <td><?php echo SqlFormatter::highlight($sql); ?></td>
    </tr>
    <?php }    ?>
</table>


<h1>Splitting SQL Strings Into Individual Queries</h1>

<div>
    Usage:
    <pre>
    <?php highlight_string('<?php' . "\n" . '$queries = SqlFormatter::splitQuery($sql);' . "\n" . '?>'); ?>
    </pre>
</div>
<table>
    <tr>
        <th>Original</th>
        <th>Split</th>
    </tr>
    <?php foreach ($split_statements as $sql) { ?>
    <tr>
        <td>
            <pre><?php echo SqlFormatter::highlight($sql); ?></pre>
        </td>
        <td><?php
            $queries = SqlFormatter::splitQuery($sql);
            echo "<ol>";
            foreach ($queries as $query) {
                echo "<li><pre>" . SqlFormatter::highlight($query) . "</pre></li>";
            }
            echo "</ol>";
            ?></td>
    </tr>
    <?php }    ?>
</table>


<h1>Removing Comments</h1>

<div>
    Usage:
    <pre>
    <?php highlight_string('<?php' . "\n" . '$nocomments = SqlFormatter::removeComments($sql);' . "\n" . '?>'); ?>
    </pre>
</div>
<table>
    <tr>
        <th>Original</th>
        <th>Comments Removed</th>
    </tr>
    <?php foreach ($comment_statements as $sql) { ?>
    <tr>
        <td>
            <pre><?php echo SqlFormatter::highlight($sql); ?></pre>
        </td>
        <td>
            <pre><?php echo SqlFormatter::highlight(SqlFormatter::removeComments($sql)) ?></pre>
        </td>
    </tr>
    <?php }    ?>
</table>

</body>
</html>
