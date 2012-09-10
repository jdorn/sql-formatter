<?php

/**
 * SQL Formatter providing utilities for formatting and syntax highlighting of SQL queries.
 *
 * @package    SqlFormatter
 * @author     Jeremy Dorn <jeremy@jeremydorn.com>
 * @copyright  2012 Jeremy Dorn
 * @license    http://www.opensource.org/licenses/lgpl-license.php LGPL
 * @link       http://github.com/jdorn/sql-formatter
 * @version    1.0.0
 */
class SqlFormatter
{
    // Reserved words (for syntax highlighting)
    protected static $reserved = array(
        'ACCESSIBLE', 'ACTION', 'ADD', 'AFTER', 'AGAINST', 'AGGREGATE', 'ALGORITHM', 'ALL', 'ALTER', 'ANALYSE', 'ANALYZE', 'AND', 'AS', 'ASC',
        'AUTOCOMMIT', 'AUTO_INCREMENT', 'AVG_ROW_LENGTH', 'BACKUP', 'BEGIN', 'BETWEEN', 'BINLOG', 'BOTH', 'BY', 'CASCADE', 'CASE', 'CHANGE', 'CHANGED',
        'CHARSET', 'CHECK', 'CHECKSUM', 'COLLATE', 'COLLATION', 'COLUMN', 'COLUMNS', 'COMMENT', 'COMMIT', 'COMMITTED', 'COMPRESSED', 'CONCURRENT',
        'CONSTRAINT', 'CONTAINS', 'CONVERT', 'COUNT', 'CREATE', 'CROSS', 'CURRENT_TIMESTAMP', 'DATABASE', 'DATABASES', 'DAY', 'DAY_HOUR', 'DAY_MINUTE',
        'DAY_SECOND', 'DEFINER', 'DELAYED', 'DELAY_KEY_WRITE', 'DELETE', 'DESC', 'DESCRIBE', 'DETERMINISTIC', 'DISTINCT', 'DISTINCTROW', 'DIV',
        'DO', 'DROP', 'DUMPFILE', 'DUPLICATE', 'DYNAMIC', 'ELSE', 'ENCLOSED', 'END', 'ENGINE', 'ENGINES', 'ESCAPE', 'ESCAPED', 'EVENTS', 'EXECUTE',
        'EXISTS', 'EXPLAIN', 'EXTENDED', 'FAST', 'FIELDS', 'FILE', 'FIRST', 'FIXED', 'FLUSH', 'FOR', 'FORCE', 'FOREIGN', 'FROM', 'FULL', 'FULLTEXT',
        'FUNCTION', 'GEMINI', 'GEMINI_SPIN_RETRIES', 'GLOBAL', 'GRANT', 'GRANTS', 'GROUP', 'GROUP_CONCAT', 'GROUP BY', 'HAVING', 'HEAP', 'HIGH_PRIORITY', 'HOSTS', 'HOUR', 'HOUR_MINUTE',
        'HOUR_SECOND', 'IDENTIFIED', 'IF', 'IGNORE', 'IN', 'INDEX', 'INDEXES', 'INFILE', 'INNER', 'INNER JOIN', 'INSERT', 'INSERT_ID', 'INSERT_METHOD', 'INTERVAL',
        'INTO', 'INVOKER', 'IS', 'ISOLATION', 'JOIN', 'KEY', 'KEYS', 'KILL', 'LAST_INSERT_ID', 'LEADING', 'LEFT', 'LEFT JOIN', 'LEVEL', 'LIKE', 'LIMIT', 'LINEAR',
        'LINES', 'LOAD', 'LOCAL', 'LOCK', 'LOCKS', 'LOGS', 'LOW_PRIORITY', 'MARIA', 'MASTER', 'MASTER_CONNECT_RETRY', 'MASTER_HOST', 'MASTER_LOG_FILE',
        'MASTER_LOG_POS', 'MASTER_PASSWORD', 'MASTER_PORT', 'MASTER_USER', 'MATCH', 'MAX_CONNECTIONS_PER_HOUR', 'MAX_QUERIES_PER_HOUR',
        'MAX_ROWS', 'MAX_UPDATES_PER_HOUR', 'MAX_USER_CONNECTIONS', 'MEDIUM', 'MERGE', 'MINUTE', 'MINUTE_SECOND', 'MIN_ROWS', 'MODE', 'MODIFY',
        'MONTH', 'MRG_MYISAM', 'MYISAM', 'NAMES', 'NATURAL', 'NOT', 'NULL', 'OFFSET', 'ON', 'OPEN', 'OPTIMIZE', 'OPTION', 'OPTIONALLY', 'OR',
        'ORDER', 'ORDER BY', 'OUTER', 'OUTER JOIN', 'OUTFILE', 'PACK_KEYS', 'PAGE', 'PARTIAL', 'PARTITION', 'PARTITIONS', 'PASSWORD', 'PRIMARY', 'PRIVILEGES', 'PROCEDURE',
        'PROCESS', 'PROCESSLIST', 'PURGE', 'QUICK', 'RAID0', 'RAID_CHUNKS', 'RAID_CHUNKSIZE', 'RAID_TYPE', 'RANGE', 'READ', 'READ_ONLY',
        'READ_WRITE', 'REFERENCES', 'REGEXP', 'RELOAD', 'RENAME', 'REPAIR', 'REPEATABLE', 'REPLACE', 'REPLICATION', 'RESET', 'RESTORE', 'RESTRICT',
        'RETURN', 'RETURNS', 'REVOKE', 'RIGHT', 'RIGHT JOIN', 'RLIKE', 'ROLLBACK', 'ROW', 'ROWS', 'ROW_FORMAT', 'SECOND', 'SECURITY', 'SELECT', 'SEPARATOR',
        'SERIALIZABLE', 'SESSION', 'SET', 'SHARE', 'SHOW', 'SHUTDOWN', 'SLAVE', 'SONAME', 'SOUNDS', 'SQL', 'SQL_AUTO_IS_NULL', 'SQL_BIG_RESULT',
        'SQL_BIG_SELECTS', 'SQL_BIG_TABLES', 'SQL_BUFFER_RESULT', 'SQL_CACHE', 'SQL_CALC_FOUND_ROWS', 'SQL_LOG_BIN', 'SQL_LOG_OFF',
        'SQL_LOG_UPDATE', 'SQL_LOW_PRIORITY_UPDATES', 'SQL_MAX_JOIN_SIZE', 'SQL_NO_CACHE', 'SQL_QUOTE_SHOW_CREATE', 'SQL_SAFE_UPDATES',
        'SQL_SELECT_LIMIT', 'SQL_SLAVE_SKIP_COUNTER', 'SQL_SMALL_RESULT', 'SQL_WARNINGS', 'START', 'STARTING', 'STATUS', 'STOP', 'STORAGE',
        'STRAIGHT_JOIN', 'STRING', 'STRIPED', 'SUPER', 'TABLE', 'TABLES', 'TEMPORARY', 'TERMINATED', 'THEN', 'TO', 'TRAILING', 'TRANSACTIONAL',
        'TRUNCATE', 'TYPE', 'TYPES', 'UNCOMMITTED', 'UNION', 'UNIQUE', 'UNLOCK', 'UPDATE', 'USAGE', 'USE', 'USING', 'VALUES', 'VARIABLES',
        'VIEW', 'WHEN', 'WHERE', 'WITH', 'WORK', 'WRITE', 'XOR', 'YEAR_MONTH'
    );

    // For SQL formatting
    // These keywords will all be on their own line
    protected static $special_reserved = array(
        'SELECT', 'FROM', 'WHERE', 'SET', 'ORDER BY', 'GROUP BY', 'LEFT JOIN', 'OUTER JOIN', 'INNER JOIN', 'RIGHT JOIN', 'JOIN', 'LIMIT', 'VALUES', 'UPDATE', 'HAVING'
    );

    // Punctuation that can be used as a boundary between other tokens
    protected static $boundaries = array(',', ';', ')', '(', '.', '=', '<', '>', '+', '-', '*', '/');

    // White space characters.  These can also be used as a boundary between other tokens
    protected static $whitespace = array(' ', "\n", "\t", "\r");

    // Start of quoted strings
    protected static $quotes = array('"', "'", '`');

    // For syntax highlighting
    // Styles applied to different token types
    public static $quote_style = 'color: blue;';
    public static $backtick_quote_style = 'color: purple;';
    public static $reserved_style = 'color:black; font-weight:bold;';
    public static $boundary_style = 'color:black;';
    public static $number_style = 'color: green;';
    public static $default_style = 'color: #333;';
    public static $error_style = 'background-color: red; color: black;';
    public static $comment_style = 'color: #aaa;';

    // The tab character to use when formatting SQL
    public static $tab = '&nbsp;&nbsp;';


    // This flag tells us if the reserved word list is sorted already
    protected static $reserved_sorted;

    /**
     * Return the next token and token type in a SQL string.
     * Quoted strings, comments, reserved words, and punctuation are all their own tokens.
     *
     * @param String $string The SQL string
     * @param String $type Will be populated with the type of token
     *
     * @return String The next token
     */
    protected static function getNextToken($string, &$type)
    {
        // If the next token is a comment
        if (substr($string, 0, 2) === '--' || $string[0] === '#' || substr($string, 0, 2) === '/*') {

            // Comment until end of line
            if (in_array($string[0], array('-', '#'))) {
                $last = strpos($string, "\n");
                $type = 'comment';
            } // Comment until closing comment tag
            else {
                $last = strpos($string, "*/", 2) + 2;
                $type = 'block comment';
            }

            return substr($string, 0, $last);
        }

        // If the next item is a string
        if (in_array($string[0], self::$quotes)) {
            $quote = $string[0];
            for ($i = 1; $i < strlen($string); $i++) {
                // Escaped (either backslash or backtick escaped)
                if (($quote != '`' && $string[$i] === '\\') || ($quote === '`' && $string[$i] === '`' && $string[$i + 1] === '`')) {
                    $i++;
                } elseif ($string[$i] === $quote) {
                    break;
                }
            }
            if ($quote === '`') $type = 'backtick quote';
            else $type = 'quote';

            return substr($string, 0, $i + 1);
        } // Separators
        elseif (in_array($string[0], self::$boundaries)) {
            // If it is a simple string or empty between the parentheses, just count as a word
            // this makes it so we don't split things like NOW() or COUNT(*) into separate lines
            if ($string[0] === '(') {
                if ($string[1] === ')') {
                    $type = 'word';
                    return '()';
                }
                $type2 = null;
                $next_token = self::getNextToken(substr($string, 1), $type2);
                if ($string[strlen($next_token) + 1] === ')') {
                    if (in_array($type2, array('word', 'whitespace', 'boundary'))) {
                        $type = 'word';
                        return '(' . $next_token . ')';
                    }
                }
            }

            if (in_array($string[0], array('(', ')'))) {
                $type = $string[0];
                return $string[0];
            }

            $type2 = null;
            $next_token = self::getNextToken(substr($string, 1), $type2);

            // If there are 1 or more boundary characters together, return as a single word
            if ($type2 === 'boundary') {
                $type = 'boundary';
                return $string[0] . $next_token;
            }

            // Otherwise, just return the single boundary character
            if (in_array($string[0], array('.', ','))) $type = $string[0];
            else $type = 'boundary';

            return $string[0];
        } // Whitespace
        elseif (in_array($string[0], self::$whitespace)) {
            for ($i = 1; $i < strlen($string); $i++) {
                if (!in_array($string[$i], self::$whitespace)) {
                    break;
                }
            }

            $type = 'whitespace';
            return substr($string, 0, $i);
        }

        // Sort reserved word list from longest word to shortest
        if (!self::$reserved_sorted) {
            usort(self::$reserved, function ($a, $b) {
                return strlen($b) - strlen($a);
            });
            self::$reserved_sorted = true;
        }

        $all_boundaries = array_merge(self::$boundaries, self::$whitespace);

        // Reserved word
        $test = strtoupper($string);
        foreach (self::$reserved as $word) {
            // If(strlen($test < strlen($word))) continue;
            if (substr($test, 0, strlen($word)) === $word) {
                if (isset($string[strlen($word)]) && !in_array($string[strlen($word)], $all_boundaries)) continue;

                if (in_array($word, self::$special_reserved)) $type = 'special reserved';
                else $type = 'reserved';

                return substr($string, 0, strlen($word));
            }
        }

        // Look for first word separator
        for ($i = 1; $i < strlen($string); $i++) {
            if (in_array($string[$i], $all_boundaries)) {
                break;
            }
        }

        $ret = substr($string, 0, $i);
        if (is_numeric($ret)) $type = 'number';
        else $type = 'word';

        return $ret;
    }

    /**
     * Format the whitespace in a SQL string and add syntax highlighting
     *
     * @param String $string The SQL string
     *
     * @throws Exception when we can't remove parts of the initial query
     *
     * @return String The SQL string with HTML styles and formatting wrapped in a <pre> tag
     */
    public static function format($string)
    {
        // This variable will be populated with formatted html
        $return = '';

        // Configuration values
        $tab = self::$tab;

        // Starting values
        $i = 0;
        $indent = 1;
        $newline = false;
        $indented = false;
        $extra_indent = 0;
        $old_string_len = strlen($string) + 1;

        // Keep processing the string until it is empty
        while (strlen($string)) {
            // If the string stopped shrinking, there was a problem
            if ($old_string_len <= strlen($string)) {
                throw new Exception("SQL PARSE ERROR");
            }
            $old_string_len = strlen($string);

            // Get the next token and the token type
            $type = null;
            $raw_token = self::getNextToken($string, $type);
            $next_token = htmlentities($raw_token);

            // Advance the string forward
            $string = substr($string, strlen($raw_token));

            // Don't process whitespace
            if ($type === 'whitespace') {
                continue;
            } // Display comments directly where they appear in the source
            elseif (in_array($type, array('comment', 'block comment'))) {
                if ($type === 'block comment') {
                    $return .= "\n" . str_repeat($tab, $indent);
                }

                $return .= '<span style="' . self::$comment_style . '">' . $next_token . '</span> ';
                $newline = true;
                continue;
            }

            // If this token decreases the indent level
            if (in_array($type, array('special reserved', ')'))) {
                if ($indented) {
                    $extra_indent++;
                } elseif ($indent && ($type === 'special reserved' || $indent > 1)) {
                    $indent--;

                    if ($type === ')' && $extra_indent) {
                        $indent -= $extra_indent;
                        $extra_indent = 0;
                    }
                } else {
                    $return .= '<span style="' . self::$error_style . '">' . $next_token . '</span> ';
                    continue;
                }
            }

            // If we need a new line before the token
            if ($newline || in_array($type, array(')', 'special reserved'))) {
                $newline = false;
                $return .= "\n" . str_repeat($tab, $indent);
            }

            // If we need a new line after the token
            if (in_array($type, array(',', '(', 'special reserved'))) {
                $newline = true;
            }

            // If this token increases the indent level
            if (in_array($type, array('special reserved', '('))) {
                $indent++;
                $indented = true;
            } else {
                $indented = false;
            }

            switch ($type) {
                case 'backtick quote':
                    $return .= "<span style='" . self::$backtick_quote_style . "'>" . $next_token . "</span> ";
                    break;
                case 'quote':
                    $return .= "<span style='" . self::$quote_style . "'>" . $next_token . "</span> ";
                    break;
                case 'reserved':
                case 'special reserved':
                    $return .= "<span style='" . self::$reserved_style . "'>" . $next_token . "</span> ";
                    break;
                case '(':
                    $return .= '(';
                    break;
                case ')':
                    $return .= ") ";
                    break;
                case 'number':
                    $return .= "<span style='" . self::$number_style . "'>" . $next_token . "</span> ";
                    break;
                case 'boundary':
                case '.':
                case ',':
                    if (in_array($next_token, array('.', ',', ';'))) {
                        $return = rtrim($return, ' ');
                    }

                    $return .= "<span style='" . self::$boundary_style . "'>" . $next_token . "</span> ";

                    if (in_array($next_token, array('.'))) {
                        $return = rtrim($return, ' ');
                    }

                    break;
                default:
                    $return .= "<span style='" . self::$default_style . "'>" . $next_token . "</span> ";
            }
        }

        // If there are unmatched parentheses
        if ($indent !== 1) {
            $return .= "\n<span style='color:red;'>WARNING: unmatched parentheses</span>";
        }

        return "<pre style='background:white;'>" . trim($return) . "</pre>";
    }

    /**
     * Add syntax highlighting to a SQL string
     *
     * @param String $string The SQL string
     *
     * @throws Exception when we coudn't remove parts of the initial query
     *
     * @return String The SQL string with HTML styles applied
     */
    public static function highlight($string)
    {
        $old_string_len = strlen($string) + 1;

        $return = '';

        // Keep processing the string until it is empty
        while (strlen($string)) {
            // If the string stopped shrinking, there was a problem
            if ($old_string_len <= strlen($string)) {
                throw new Exception("SQL PARSE ERROR");
            }
            $old_string_len = strlen($string);

            // Get the next token and the token type
            $type = null;
            $raw_token = self::getNextToken($string, $type);
            $next_token = htmlentities($raw_token);

            // Advance the string forward
            $string = substr($string, strlen($raw_token));

            switch ($type) {
                case 'backtick quote':
                    $return .= "<span style='" . self::$backtick_quote_style . "'>" . $next_token . "</span>";
                    break;
                case 'quote':
                    $return .= "<span style='" . self::$quote_style . "'>" . $next_token . "</span>";
                    break;
                case 'reserved':
                case 'special reserved':
                    $return .= "<span style='" . self::$reserved_style . "'>" . $next_token . "</span>";
                    break;
                case '(':
                    $return .= '(';
                    break;
                case ')':
                    $return .= ")";
                    break;
                case 'number':
                    $return .= "<span style='" . self::$number_style . "'>" . $next_token . "</span>";
                    break;
                case 'boundary':
                case '.':
                case ',':
                    $return .= "<span style='" . self::$boundary_style . "'>" . $next_token . "</span>";
                    break;
                case 'comment':
                case 'block comment':
                    $return .= "<span style='" . self::$comment_style . "'>" . $next_token . "</span>";
                    break;
                default:
                    $return .= "<span style='" . self::$default_style . "'>" . $next_token . "</span>";
            }
        }

        return "<pre style='background:white;'>" . trim($return) . "</pre>";
    }

    /**
     * Split a SQL string into multiple queries.
     * Uses ";" as a query delimiter.
     *
     * @param String $string The SQL string
     *
     * @throws Exception when we can't remove query parts of the initial string
     *
     * @return Array An array of individual query strings without trailing semicolons
     */
    public static function splitQuery($string)
    {
        // Comments between queries cause problems, so remove them first
        $string = self::removeComments($string);

        $queries = array();

        $current_query = '';

        $old_string_len = strlen($string) + 1;

        // Keep processing the string until it is empty
        while (strlen($string)) {
            // If the string stopped shrinking, there was a problem
            if ($old_string_len <= strlen($string)) {
                throw new Exception("SQL PARSE ERROR");
            }
            $old_string_len = strlen($string);

            // Get the next token and the token type
            $type = null;
            $raw_token = self::getNextToken($string, $type);
            $next_token = $raw_token;

            // Advance the string forward
            $string = substr($string, strlen($raw_token));

            // If this is a query separator
            if ($next_token === ';') {
                if (trim($current_query)) $queries[] = trim($current_query);
                $current_query = '';
                continue;
            }

            $current_query .= $next_token;
        }

        if (trim($current_query)) {
            $queries[] = trim($current_query);
        }

        return $queries;
    }

    /**
     * Remove all comments from a SQL string
     *
     * @param String $string The SQL string
     *
     * @throws Exception when we can't properly remove the comments
     *
     * @return String The SQL string without comments
     */
    public static function removeComments($string)
    {
        $result = '';

        $old_string_len = strlen($string) + 1;

        // Keep processing the string until it is empty
        while (strlen($string)) {
            // If the string stopped shrinking, there was a problem
            if ($old_string_len <= strlen($string)) {
                throw new Exception("SQL PARSE ERROR");
            }
            $old_string_len = strlen($string);

            // Get the next token and the token type
            $type = null;
            $raw_token = self::getNextToken($string, $type);
            $next_token = $raw_token;

            // Advance the string forward
            $string = substr($string, strlen($raw_token));

            // Skip comment tokens
            if (in_array($type, array('comment', 'block comment'))) {
                continue;
            }

            $result .= $next_token;
        }

        return $result;
    }

}
