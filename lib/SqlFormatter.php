<?php
/**
 * SQL Formatter is a collection of utilities for debugging SQL queries.
 * It includes methods for formatting, syntax highlighting, removing comments, etc.
 *
 * @package    SqlFormatter
 * @author     Jeremy Dorn <jeremy@jeremydorn.com>
 * @copyright  2012 Jeremy Dorn
 * @license    http://www.opensource.org/licenses/lgpl-license.php LGPL
 * @link       http://github.com/jdorn/sql-formatter
 * @version    1.2.0
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
        'MONTH', 'MRG_MYISAM', 'MYISAM', 'NAMES', 'NATURAL', 'NOT', 'NOW', 'NULL', 'OFFSET', 'ON', 'OPEN', 'OPTIMIZE', 'OPTION', 'OPTIONALLY', 'OR',
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
    protected static $boundaries = array(',', ';', ')', '(', '.', '=', '<', '>', '+', '-', '*', '/', '!', '^', '%', '|', '&');

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
    public static $tab = '  ';

    // This flag tells us if SqlFormatted has been initialized
    protected static $init;

    // This is a combination of all the boundary characters and all the whitespace characters
    protected static $all_boundaries;

    //cache variables
    //Only tokens shorter than this size will be cached.  Somewhere between 10 and 20 seems to work well for most cases.
    public static $max_cachekey_size = 15;
    protected static $token_cache = array();
    protected static $cache_hits = 0;
    protected static $cache_misses = 0;
    
    /**
     * Get stats about the token cache
     * @return Array An array containing the keys 'hits', 'misses', 'entries', and 'size' in bytes
     */
    public static function getCacheStats() {
        return array(
            'hits'=>self::$cache_hits,
            'misses'=>self::$cache_misses,
            'entries'=>count(self::$token_cache),
            'size'=>strlen(serialize(self::$token_cache))
        );
    }
    
    /**
     * Return the next token and token type in a SQL string.
     * Quoted strings, comments, reserved words, whitespace, and punctuation are all their own tokens.
     *
     * @param String $string The SQL string
     * @param array $previous The result of the previous getNextToken() call
     *
     * @return Array An associative array containing a 'token' and 'type' key.
     */
    protected static function getNextToken($string, $previous = null)
    {
        // If the next token is a comment
        if ($string[0] === '#' || substr($string, 0, 2) === '--' || substr($string, 0, 2) === '/*') {
            // Comment until end of line
            if ($string[0] === '-' || $string[0] === '#') {
                $last = strpos($string, "\n");
                $type = 'comment';
            } else { // Comment until closing comment tag
                $last = strpos($string, "*/", 2) + 2;
                $type = 'block comment';
            }

            if ($last === false) {
                $last = strlen($string);
            }

            return array(
                'token' => substr($string, 0, $last),
                'type'  => $type
            );
        }

        // If the next item is a string
        if (in_array($string[0], self::$quotes)) {
            $quote = $string[0];
            for ($i = 1, $length = strlen($string); $i < $length; $i++) {
                $next_char = null;
                if (isset($string[$i + 1])) {
                    $next_char = $string[$i + 1];
                }

                // Escaped (either backslash or backtick escaped)
                if (($quote !== '`' && $string[$i] === '\\') || ($quote === '`' && $string[$i] === '`' && $next_char === '`')) {
                    $i++;
                } elseif ($string[$i] === $quote) {
                    break;
                }
            }
            if ($quote === '`') {
                $type = 'backtick quote';
            } else {
                $type = 'quote';
            }

            return array(
                'token' => substr($string, 0, $i + 1),
                'type'  => $type
            );
        }

        // Separators
        if (in_array($string[0], self::$boundaries)) {
            // If it is a simple string or empty between the parentheses, just count as a word
            // this makes it so we don't split things like NOW() or COUNT(*) into separate lines
            if ($string[0] === '(') {
                // "()"
                if (isset($string[1]) && $string[1] === ')') {
                    return array(
                        'token' => '()',
                        'type'  => 'word'
                    );
                }

                // "(word/whitespace/boundary)"
                $next_token = self::getNextToken(substr($string, 1));
                $length = strlen($next_token['token']);
                if (isset($string[$length + 1]) && $string[$length + 1] === ')') {
                    if ($next_token['type'] === 'word' || $next_token['type'] === 'whitespace' || $next_token['type'] === 'boundary') {
                        return array(
                            'token' => '(' . $next_token['token'] . ')',
                            'type'  => 'word'
                        );
                    }
                }
            }

            //return single parentheses as their own token
            if ($string[0] === '(' || $string[0] === ')') {
                return array(
                    'token' => $string[0],
                    'type'  => $string[0]
                );
            }


            // If there are 1 or more boundary characters together, return as a single word
            $next_token = self::getNextToken(substr($string, 1));
            if ($next_token['type'] === 'boundary') {
                return array(
                    'token' => $string[0].$next_token['token'],
                    'type'  => 'boundary'
                );
            }

            // Otherwise, just return the single boundary character
            if ($string[0] === '.' || $string[0] === ',') {
                $type = $string[0];
            } else {
                $type = 'boundary';
            }

            return array(
                'token' => $string[0],
                'type'  => $type
            );
        }

        // Whitespace
        if (in_array($string[0], self::$whitespace)) {
            for ($i = 1, $length = strlen($string); $i < $length; $i++) {
                if (!in_array($string[$i], self::$whitespace)) {
                    break;
                }
            }

            return array(
                'token' => substr($string, 0, $i),
                'type'  => 'whitespace'
            );
        }

        if (!self::$init) {
            //Sort reserved word list from longest word to shortest
            usort(self::$reserved, array('SqlFormatter', 'sortLength'));

            //Combine boundary characters and whitespace
            self::$all_boundaries = array_merge(self::$boundaries, self::$whitespace);

            self::$init = true;
        }

        //a reserved word cannot be preceded by a '.'
        //this makes it so in "mytable.from", "from" is not considered a reserved word
        if (!$previous || !isset($previous['token']) || $previous['token'] !== '.') {
            // Reserved word
            $test = strtoupper($string);
            foreach (self::$reserved as $word) {
                $length = strlen($word);
                if (substr($test, 0, $length) === $word) {
                    if (isset($string[$length]) && !in_array($string[$length], self::$all_boundaries)) {
                        continue;
                    }

                    if (in_array($word, self::$special_reserved)) {
                        $type = 'special reserved';
                    } else {
                        $type = 'reserved';
                    }

                    return array(
                        'token' => substr($string, 0, $length),
                        'type'  => $type
                    );
                }
            }
        }

        // Look for first word separator
        for ($i = 1, $length = strlen($string); $i < $length; $i++) {
            if (in_array($string[$i], self::$all_boundaries)) {
                break;
            }
        }

        $ret = substr($string, 0, $i);
        if (is_numeric($ret)) {
            $type = 'number';
        } else {
            $type = 'word';
        }

        return array(
            'token' => $ret,
            'type'  => $type
        );
    }

    /**
     * Takes a SQL string and breaks it into tokens.
     * Each token is an associative array with a 'token' and 'type' key.
     *
     * @param String $string The SQL string
     *
     * @throws Exception when there is a problem tokenizing the input string
     *
     * @return Array An array of tokens.
     */
    protected static function tokenize($string)
    {
        $tokens = array();

        //used for debugging if there is an error while tokenizing the string
        $original_length = strlen($string);

        //used to make sure the string keeps shrinking on each iteration
        $old_string_len = strlen($string) + 1;

        $token = null;
        
        $current_length = strlen($string);

        // Keep processing the string until it is empty
        while ($current_length) {
            // If the string stopped shrinking, there was a problem
            if ($old_string_len <= $current_length) {
                throw new Exception("SQL Parse Error - Unable to tokenize string at character ".($original_length - $old_string_len));
            }
            $old_string_len =  $current_length;

            // Determine if we can use caching
            if($current_length >= self::$max_cachekey_size) {
                $cacheKey = substr($string,0,self::$max_cachekey_size);
            }
            else {
                $cacheKey = false;
            }

            // See if the token is already cached
            if($cacheKey && isset(self::$token_cache[$cacheKey])) {
                //retrieve from cache
                $token = self::$token_cache[$cacheKey];
                $token_length = strlen($token['token']);
                self::$cache_hits++;
            }
            else {
                // Get the next token and the token type
                $token = self::getNextToken($string, $token);
                $token_length = strlen($token['token']);
                self::$cache_misses++;
                
                // If the token is shorter than the max length, store it in cache
                if($cacheKey && $token_length < self::$max_cachekey_size) {
                    self::$token_cache[$cacheKey] = $token;
                }
            }
            
            $tokens[] = $token;

            //advance the string
            $string = substr($string, $token_length);
            
            $current_length -= $token_length;
        }

        return $tokens;
    }

    /**
     * Format the whitespace in a SQL string to make it easier to read.
     *
     * @param String  $string    The SQL string
     * @param boolean $highlight If true, syntax highlighting will also be performed
     *
     * @throws Exception when there is a problem tokenizing the input string
     *
     * @return String The SQL string with HTML styles and formatting wrapped in a <pre> tag
     */
    public static function format($string, $highlight=true)
    {
        // This variable will be populated with formatted html
        $return = '';

        // Configuration values
        $tab = self::$tab;

        // Starting values
        $indent = 1;
        $newline = false;
        $indented = false;
        $extra_indent = 0;

        // Tokenize String
        $tokens = self::tokenize($string);

        foreach ($tokens as $i=>$token) {
            // Get highlighted token if doing syntax highlighting
            if ($highlight) {
                $highlighted = self::highlightToken($token);
            } else { // If returning raw text
                $highlighted = $token['token'];
            }

            // Don't process whitespace
            if ($token['type'] === 'whitespace') {
                continue;
            }

            // Display comments directly where they appear in the source
            if ($token['type'] === 'comment' || $token['type'] === 'block comment') {
                if ($token['type'] === 'block comment') {
                    $return .= "\n" . str_repeat($tab, $indent);
                }

                $return .= $highlighted;
                $newline = true;
                continue;
            }

            // If this token decreases the indent level
            if ($token['type'] === 'special reserved' || $token['type'] === ')') {
                if ($indented) {
                    ++$extra_indent;
                } elseif ($indent && ($token['type'] === 'special reserved' || $indent > 1)) {
                    --$indent;

                    if ($token['type'] === ')' && $extra_indent) {
                        $indent -= $extra_indent;
                        $extra_indent = 0;
                    }
                } else { // If there are mismatched parentheses
                    if ($highlight) {
                        $return .= self::highlightError(htmlentities($token['token'])).' ';
                    } else {
                        $return .= $highlighted;
                    }

                    continue;
                }
            }

            // If we need a new line before the token
            if ($newline || ($token['type'] === ')' || $token['type'] === 'special reserved')) {
                $newline = false;
                $return .= "\n" . str_repeat($tab, $indent);
            }

            // If we need a new line after the token
            if ($token['type'] === ',' || $token['type'] === '(' || $token['type'] === 'special reserved') {
                $newline = true;
            }

            // If this token increases the indent level
            if ($token['type'] === 'special reserved' || $token['type'] === '(') {
                ++$indent;
                $indented = true;
            } else {
                $indented = false;
            }

            // If the token shouldn't have a space before it
            if ($token['token'] === '.' || $token['token'] === ',' || $token['token'] === ';') {
                $return = rtrim($return, ' ');
            }

            //if this is an opening parentheses, take out the preceding space unless there was whitespace there in the
            //original query
            if ($token['token'][0] === '(' && isset($tokens[$i-1]) && $tokens[$i-1]['type'] !== 'whitespace') {
                $return = rtrim($return,' ');
            }

            $return .= $highlighted.' ';

            // If the token shouldn't have a space after it
            if ($token['token'] === '(' || $token['token'] === '.') {
                $return = rtrim($return,' ');
            }
        }

        // If there are unmatched parentheses
        if ($highlight && $indent !== 1) {
            $return .= "\n".self::highlightError("WARNING: unclosed parentheses or section");
        }

        if ($highlight) {
            return "<pre style='background:white;'>" . trim($return) . "</pre>";
        }

        return trim($return);
    }

    /**
     * Add syntax highlighting to a SQL string
     *
     * @param String $string The SQL string
     *
     * @throws Exception when there is a problem tokenizing the input string
     *
     * @return String The SQL string with HTML styles applied
     */
    public static function highlight($string)
    {
        $tokens = self::tokenize($string);

        $return = '';

        foreach ($tokens as $token) {
            $return .= self::highlightToken($token);
        }

        return "<pre style='background:white;'>" . trim($return) . "</pre>";
    }

    /**
     * Split a SQL string into multiple queries.
     * Uses ";" as a query delimiter.
     *
     * @param String $string The SQL string
     *
     * @throws Exception when there is a problem tokenizing the input string
     *
     * @return Array An array of individual query strings without trailing semicolons
     */
    public static function splitQuery($string)
    {
        // Comments between queries cause problems, so remove them first
        $string = self::removeComments($string);

        $queries = array();
        $current_query = '';

        $tokens = self::tokenize($string);

        foreach ($tokens as $token) {
            // If this is a query separator
            if ($token['token'] === ';') {
                if (trim($current_query)) {
                    $queries[] = trim($current_query);
                }
                $current_query = '';
                continue;
            }

            $current_query .= $token['token'];
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
     * @throws Exception when there is a problem tokenizing the input string
     *
     * @return String The SQL string without comments
     */
    public static function removeComments($string)
    {
        $result = '';

        $tokens = self::tokenize($string);

        foreach ($tokens as $token) {
            // Skip comment tokens
            if ($token['type'] === 'comment' || $token['type'] === 'block comment') {
                continue;
            }

            $result .= $token['token'];
        }

        return $result;
    }

    /**
     * Highlights a token depending on its type.
     *
     * @param Array $token An associative array containing 'token' and 'type' keys.
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightToken($token)
    {
        $type = $token['type'];
        $token = htmlentities($token['token']);

        switch ($type) {
                case 'backtick quote':
                case 'quote':
                    return self::highlightQuote($token, $type);
                case 'reserved':
                case 'special reserved':
                    return self::highlightReservedWord($token);
                case '(':
                case ')':
                    return $token;
                case 'number':
                    return self::highlightNumber($token);
                case 'boundary':
                case '.':
                case ',':
                    return self::highlightBoundary($token);
                case 'comment':
                case 'block comment':
                    return self::highlightComment($token);
                default:
                    return self::highlightDefault($token);
            }
    }

    /**
     * Highlights a quoted string
     *
     * @param String $value The token's value
     * @param String $type  The token's type
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightQuote($value, $type)
    {
        if ($type === 'backtick quote') {
            return "<span style='" . self::$backtick_quote_style . "'>" . $value . "</span>";
        }

        return "<span style='" . self::$quote_style . "'>" . $value . "</span>";
    }

    /**
     * Highlights a reserved word
     *
     * @param String $value The token's value
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightReservedWord($value)
    {
        return "<span style='" . self::$reserved_style . "'>" . $value . "</span>";
    }

    /**
     * Highlights a boundary token
     *
     * @param String $value The token's value
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightBoundary($value)
    {
        return "<span style='" . self::$boundary_style . "'>" . $value . "</span>";
    }

    /**
     * Highlights a number
     *
     * @param String $value The token's value
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightNumber($value)
    {
        return "<span style='" . self::$number_style . "'>" . $value . "</span>";
    }

    /**
     * Highlights an error
     *
     * @param String $value The token's value
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightError($value)
    {
        return "<span style='" . self::$error_style . "'>" . $value . "</span>";
    }

    /**
     * Highlights a comment
     *
     * @param String $value The token's value
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightComment($value)
    {
        return "<span style='" . self::$comment_style . "'>" . $value . "</span>";
    }

    /**
     * Highlights a generic token
     *
     * @param String $value The token's value
     *
     * @return String HTML code of the highlighted token.
     */
    protected static function highlightDefault($value)
    {
        return "<span style='" . self::$default_style . "'>" . $value . "</span>";
    }

    /**
     * Helper function for sorting the list of reserved words by length
     *
     * @param String $a The first string
     * @param String $b The second string
     *
     * @return int The comparison of the string lengths
     */
    private static function sortLength($a, $b)
    {
        return strlen($b) - strlen($a);
    }
}
