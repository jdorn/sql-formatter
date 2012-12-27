<?php
/**
 * SQL Formatter is a collection of utilities for debugging SQL queries.
 * It includes methods for formatting, syntax highlighting, removing comments, etc.
 *
 * @package    SqlFormatter
 * @author     Jeremy Dorn <jeremy@jeremydorn.com>
 * @author     Florin Patan <florinpatan@gmail.com>
 * @copyright  2012 Jeremy Dorn
 * @license    http://www.opensource.org/licenses/lgpl-license.php LGPL
 * @link       http://github.com/jdorn/sql-formatter
 * @version    1.2.2
 */
class SqlFormatter
{
    // Reserved words (for syntax highlighting)
    protected static $reserved = array(
        'ACCESSIBLE', 'ACTION', 'AGAINST', 'AGGREGATE', 'ALGORITHM', 'ALL', 'ALTER', 'ANALYSE', 'ANALYZE', 'AND', 'AS', 'ASC',
        'AUTOCOMMIT', 'AUTO_INCREMENT', 'BACKUP', 'BEGIN', 'BETWEEN', 'BINLOG', 'BOTH', 'CASCADE', 'CASE', 'CHANGE', 'CHANGED',
        'CHARSET', 'CHECK', 'CHECKSUM', 'COLLATE', 'COLLATION', 'COLUMN', 'COLUMNS', 'COMMENT', 'COMMIT', 'COMMITTED', 'COMPRESSED', 'CONCURRENT',
        'CONSTRAINT', 'CONTAINS', 'CONVERT', 'COUNT', 'CREATE', 'CROSS', 'CURRENT_TIMESTAMP', 'DATABASE', 'DATABASES', 'DAY', 'DAY_HOUR', 'DAY_MINUTE',
        'DAY_SECOND', 'DEFAULT', 'DEFINER', 'DELAYED', 'DELETE', 'DESC', 'DESCRIBE', 'DETERMINISTIC', 'DISTINCT', 'DISTINCTROW', 'DIV',
        'DO', 'DROP', 'DUMPFILE', 'DUPLICATE', 'DYNAMIC', 'ELSE', 'ENCLOSED', 'END', 'ENGINE', 'ENGINE_TYPE', 'ENGINES', 'ESCAPE', 'ESCAPED', 'EVENTS', 'EXECUTE',
        'EXISTS', 'EXPLAIN', 'EXTENDED', 'FAST', 'FIELDS', 'FILE', 'FIRST', 'FIXED', 'FLUSH', 'FOR', 'FORCE', 'FOREIGN', 'FULL', 'FULLTEXT',
        'FUNCTION', 'GLOBAL', 'GRANT', 'GRANTS', 'GROUP_CONCAT', 'HEAP', 'HIGH_PRIORITY', 'HOSTS', 'HOUR', 'HOUR_MINUTE',
        'HOUR_SECOND', 'IDENTIFIED', 'IF', 'IGNORE', 'IN', 'INDEX', 'INDEXES', 'INFILE', 'INSERT', 'INSERT_ID', 'INSERT_METHOD', 'INTERVAL',
        'INTO', 'INVOKER', 'IS', 'ISOLATION', 'KEY', 'KEYS', 'KILL', 'LAST_INSERT_ID', 'LEADING', 'LEVEL', 'LIKE', 'LINEAR',
        'LINES', 'LOAD', 'LOCAL', 'LOCK', 'LOCKS', 'LOGS', 'LOW_PRIORITY', 'MARIA', 'MASTER', 'MASTER_CONNECT_RETRY', 'MASTER_HOST', 'MASTER_LOG_FILE',
        'MATCH', 'MEDIUM', 'MERGE', 'MINUTE', 'MINUTE_SECOND', 'MIN_ROWS', 'MODE', 'MODIFY',
        'MONTH', 'MRG_MYISAM', 'MYISAM', 'NAMES', 'NATURAL', 'NOT', 'NOW', 'NULL', 'OFFSET', 'ON', 'OPEN', 'OPTIMIZE', 'OPTION', 'OPTIONALLY', 'OR',
        'ON UPDATE', 'ON DELETE', 'OUTFILE', 'PACK_KEYS', 'PAGE', 'PARTIAL', 'PARTITION', 'PARTITIONS', 'PASSWORD', 'PRIMARY', 'PRIVILEGES', 'PROCEDURE',
        'PROCESS', 'PROCESSLIST', 'PURGE', 'QUICK', 'RANGE', 'READ', 'READ_ONLY',
        'READ_WRITE', 'REFERENCES', 'REGEXP', 'RELOAD', 'RENAME', 'REPAIR', 'REPEATABLE', 'REPLACE', 'REPLICATION', 'RESET', 'RESTORE', 'RESTRICT',
        'RETURN', 'RETURNS', 'REVOKE', 'RLIKE', 'ROLLBACK', 'ROW', 'ROWS', 'ROW_FORMAT', 'SECOND', 'SECURITY', 'SEPARATOR',
        'SERIALIZABLE', 'SESSION', 'SET', 'SHARE', 'SHOW', 'SHUTDOWN', 'SLAVE', 'SONAME', 'SOUNDS', 'SQL',
        'SQL_CACHE', 'SQL_NO_CACHE', 'START', 'STARTING', 'STATUS', 'STOP', 'STORAGE',
        'STRAIGHT_JOIN', 'STRING', 'SUPER', 'TABLE', 'TABLES', 'TEMPORARY', 'TERMINATED', 'THEN', 'TO', 'TRAILING', 'TRANSACTIONAL',
        'TRUNCATE', 'TYPE', 'TYPES', 'UNCOMMITTED', 'UNION', 'UNIQUE', 'UNLOCK', 'UNSIGNED', 'USAGE', 'USE', 'USING', 'VARIABLES',
        'VIEW', 'WHEN', 'WITH', 'WORK', 'WRITE', 'XOR', 'YEAR_MONTH'
    );

    // For SQL formatting
    // These keywords will all be on their own line
    protected static $special_reserved = array(
        'SELECT', 'FROM', 'WHERE', 'SET', 'ORDER BY', 'GROUP BY', 'LEFT JOIN', 'OUTER JOIN', 'INNER JOIN', 'RIGHT JOIN', 'JOIN', 'LIMIT',
        'VALUES', 'UPDATE', 'HAVING', 'ADD', 'AFTER', 'ALTER TABLE', 'DELETE FROM'
    );

    // Punctuation that can be used as a boundary between other tokens
    protected static $boundaries = array(',', ';', ')', '(', '.', '=', '<', '>', '+', '-', '*', '/', '!', '^', '%', '|', '&');

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
   
    // Regular expressions for tokenizing
    protected static $regex_boundaries;
    protected static $regex_reserved;
    protected static $regex_special_reserved;

    // Cache variables
    // Only tokens shorter than this size will be cached.  Somewhere between 10 and 20 seems to work well for most cases.
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
     * Stuff that only needs to be done once.  Builds regular expressions and sorts the reserved words.
     */
    protected static function init() {
        if(self::$init) return;
       
        // Sort reserved word list from longest word to shortest
        usort(self::$reserved, array('SqlFormatter', 'sortLength'));

        // Set up regular expressions
        self::$regex_boundaries = '('.implode('|',array_map(array('SqlFormatter', 'quote_regex'),self::$boundaries)).')';
        self::$regex_reserved = '('.implode('|',array_map(array('SqlFormatter', 'quote_regex'),self::$reserved)).')';
        self::$regex_special_reserved = str_replace(' ','\\s+','('.implode('|',array_map(array('SqlFormatter', 'quote_regex'),self::$special_reserved)).')');

        self::$init = true;
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
        // Whitespace
        if (preg_match('/^\s+/',$string,$matches)) {
            return array(
                'token' => $matches[0],
                'type'=>'whitespace'
            );
        }
       
        // Comment
        if ($string[0] === '#' || (isset($string[1])&&($string[0]==='-'&&$string[1]==='-') || ($string[0]==='/'&&$string[1]==='*'))) {
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

        // Quoted String
        if($string[0]==='"' || $string[0]==='\'' || $string[0]==='`') {
            // This checks for the following patterns:
            // 1. backtick quoted string using `` to escape
            // 2. double quoted string using "" or \" to escape
            // 3. single quoted string using '' or \' to escape
            if( preg_match('/^((`(?:[^`]|``)*`)|("((?:[^"\\\\]|"")|(?:[^"\\\\]|\\\\.))*")|(\'((?:[^\'\\\\]|\'\')|(?:[^\'\\\\]|\\\\.))*\'))/', $string, $matches)) {
                if($string[0]==='`') {
                    return array(
                        'token'=>$matches[1],
                        'type'=>'backtick quote'
                    );
                }
                else {
                    return array(
                        'token'=>$matches[1],
                        'type'=>'quote'
                    );
                }
            }
        }
       
        // Number
        if(preg_match('/^([0-9]+(\.[0-9]+)?)($|\s|"\'`|'.self::$regex_boundaries.')/',$string,$matches)) {
            return array(
                'token' => $matches[1],
                'type'=>'number'
            );
        }

        // Boundary Character (punctuation and symbols)
        if(preg_match('/^('.self::$regex_boundaries.')/',$string,$matches)) {           
            return array(
                'token' => $matches[1],
                'type'  => 'boundary'
            );
        }

        // A reserved word cannot be preceded by a '.'
        // this makes it so in "mytable.from", "from" is not considered a reserved word
        if (!$previous || !isset($previous['token']) || $previous['token'] !== '.') {
            $upper = strtoupper($string);
            // Special Reserved Word
            if(preg_match('/^('.self::$regex_special_reserved.')($|\s|'.self::$regex_boundaries.')/', $upper,$matches)) {
                return array(
                    'type'=>'special reserved',
                    'token'=>substr($string,0,strlen($matches[1]))
                );
            }
            // Other Reserved Word
            if(preg_match('/^('.self::$regex_reserved.')($|\s|'.self::$regex_boundaries.')/', $upper,$matches)) {
                return array(
                    'type'=>'reserved',
                    'token'=>substr($string,0,strlen($matches[1]))
                );
            }
        }

        // Non reserved word
        preg_match('/^(.*?)($|\s|["\'`]|'.self::$regex_boundaries.')/',$string,$matches);

        return array(
            'token' => $matches[1],
            'type'  => 'word'
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
        self::init();
       
        $tokens = array();

        // Used for debugging if there is an error while tokenizing the string
        $original_length = strlen($string);

        // Used to make sure the string keeps shrinking on each iteration
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
                // Retrieve from cache
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

            // Advance the string
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
    public static function format($string, $highlight=true) {
        // This variable will be populated with formatted html
        $return = '';

        // Use an actual tab while formatting and then switch out with self::$tab at the end
        $tab = "\t";

        $indent_level = 0;
        $newline = false;
        $inline_parentheses = false;
        $increase_special_indent = false;
        $increase_block_indent = false;
        $indent_types = array();
        $added_newline = false;

        // Tokenize String
        $tokens = self::tokenize($string);

        // Format token by token
        foreach ($tokens as $i=>$token) {
            // Don't process whitespace
            if ($token['type'] === 'whitespace') {
                continue;
            }
            
            // Get highlighted token if doing syntax highlighting
            if ($highlight) {
                $highlighted = self::highlightToken($token);
            } else { // If returning raw text
                $highlighted = $token['token'];
            }

            // If we are increasing the special indent level now
            if($increase_special_indent) {
                $indent_level++;
                $increase_special_indent = false;
                array_unshift($indent_types,'special');
            }
            // If we are increasing the block indent level now
            if($increase_block_indent) {
                $indent_level++;
                $increase_block_indent = false;
                array_unshift($indent_types,'block');
            }
           
            // Display comments directly where they appear in the source
            if ($token['type'] === 'comment' || $token['type'] === 'block comment') {
                if ($token['type'] === 'block comment') {
                    $return .= "\n" . str_repeat($tab,$indent_level);
                }

                $return .= $highlighted;
                $newline = true;
                continue;
            }
           
            // If we need a new line before the token
            if ($newline) {
                $return .= "\n" . str_repeat($tab, $indent_level);
                $newline = false;
                $added_newline = true;
            }
            else {
                $added_newline = false;
            }

            // Opening parentheses increase the block indent level and start a new line
            if ($token['token'] === '(') {
                // First check if this should be an inline parentheses block
                // Examples are "NOW()", "COUNT(*)", "int(10)", key(`somecolumn`), DECIMAL(7,2)
                // Allow up to 3 non-whitespace tokens inside inline parentheses
                $nonwhitespace = 0;
                for($j=1;$j<=8;$j++) {
                    // Reached end of string
                    if(!isset($tokens[$i+$j])) break;
                    
                    $next = $tokens[$i+$j];
                    
                    // Ignore whitespace
                    if($next['type']==='whitespace') {
                        continue;
                    }
                   
                    // Reached closing parentheses
                    if($next['token'] === ')') {
                        $inline_parentheses = true;
                        break;
                    }
                    
                    // Reached an invalid token for inline parentheses
                    if ($next['token']===';' || $next['token']==='(') {
                        break;
                    }
                    
                    // Reached an invalid token type for inline parentheses
                    if ($next['type']==='special reserved' || $next['type']==='comment' || $next['type']==='block comment') {
                        break;
                    }
                    
                    // Too many tokens for inline parentheses
                    if ($nonwhitespace >= 3) {
                        break;
                    }
                    
                    $nonwhitespace++;
                }
               
                // Take out the preceding space unless there was whitespace there in the original query
                if (isset($tokens[$i-1]) && $tokens[$i-1]['type'] !== 'whitespace') {
                    $return = rtrim($return,' ');
                }
               
                if(!$inline_parentheses) {
                    $increase_block_indent = true;
                    // Add a newline after the parentheses
                    $newline = true;
                }
                
            }
           
            // Closing parentheses decrease the block indent level
            elseif ($token['token'] === ')') {
                // Remove whitespace before the closing parentheses
                $return = rtrim($return,' ');
                   
                // If we are in an inline parentheses section
                if($inline_parentheses) {
                    $inline_parentheses = false;
                }
                else {
                    $indent_level--;
           
                    // Reset indent level
                    while($j=array_shift($indent_types)) {
                        if($j==='special') {
                            $indent_level--;
                        }
                        else {
                            break;
                        }
                    }
                   
                    if($indent_level < 0) {
                        // This is an error
                        $indent_level = 0;
                       
                        if ($highlight) {
                            $return .= "\n".self::highlightError($token['token']);
                            continue;
                        }
                    }
                   
                    // Add a newline before the closing parentheses (if not already added)
                    if(!$added_newline) {
                        $return .= "\n" . str_repeat($tab, $indent_level);
                    }
                }
               
            }
           
            // Commas start a new line (unless within inline parentheses)
            elseif ($token['token'] === ',' && !$inline_parentheses) {
                $newline = true;
            }
           
            // Special reserved words start a new line and increase the special indent level
            elseif ($token['type'] === 'special reserved') {
                $increase_special_indent = true;
               
                // If the last indent type was 'special', decrease the special indent for this round
                reset($indent_types);
                if(current($indent_types)==='special') {
                    $indent_level--;
                    array_shift($indent_types);
                }
               
                // Add a newline after the special reserved word
                $newline = true;
                // Add a newline before the special reserved word (if not already added)
                if(!$added_newline) {
                    $return .= "\n" . str_repeat($tab, $indent_level);
                }

                // If the token may have extra whitespace
                if (strpos($token['token'],' ')!==false || strpos($token['token'],"\n")!==false || strpos($token['token'],"\t")!==false) {
                    $highlighted = preg_replace('/\s+/',' ',$highlighted);
                }
            }

            // If the token shouldn't have a space before it
            if ($token['token'] === '.' || $token['token'] === ',' || $token['token'] === ';') {
                $return = rtrim($return, ' ');
            }
           
            $return .= $highlighted.' ';

            // If the token shouldn't have a space after it
            if ($token['token'] === '(' || $token['token'] === '.') {
                $return = rtrim($return,' ');
            }
        }

        // If there are unmatched parentheses
        if ($highlight && array_search('block',$indent_types) !== false) {
            $return .= "\n".self::highlightError("WARNING: unclosed parentheses or section");
        }
       
        // Replace tab characters with the configuration tab character
        $return = trim(str_replace("\t",self::$tab,$return));

        if ($highlight) {
            $return = "<pre style='background:white;'>" . $return . "</pre>";
        }

        return $return;       
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

        if($type==='boundary') {
            return self::highlightBoundary($token);
        }
        elseif($type==='word') {
            return self::highlightDefault($token);
        }
        elseif($type==='backtick quote') {
            return self::highlightQuote($token, $type);
        }
        elseif($type==='quote') {
            return self::highlightQuote($token, $type);
        }
        elseif($type==='reserved') {
            return self::highlightReservedWord($token);
        }
        elseif($type==='special reserved') {
            return self::highlightReservedWord($token);
        }
        elseif($type==='number') {
            return self::highlightNumber($token);
        }
        elseif($type==='comment' || $type==='block comment') {
            return self::highlightComment($token);
        }
        
        return $token;
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
            return '<span style=\'' . self::$backtick_quote_style . '\'>' . $value . "</span>";
        }

        return '<span style=\'' . self::$quote_style . '\'>' . $value . "</span>";
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
        return '<span style=\'' . self::$reserved_style . '\'>' . $value . "</span>";
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
        if($value==='(' || $value===')') return $value;
        
        return '<span style=\'' . self::$boundary_style . '\'>' . $value . "</span>";
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
        return '<span style=\'' . self::$number_style . '\'>' . $value . "</span>";
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
        return '<span style=\'' . self::$error_style . '\'>' . $value . "</span>";
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
        return '<span style=\'' . self::$comment_style . '\'>' . $value . "</span>";
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
        return '<span style=\'' . self::$default_style . '\'>' . $value . "</span>";
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
   
    /**
     * Helper function for building regular expressions for reserved words and boundary characters
     *
     * @param String $a The string to be quoted
     *
     * @return String The quoted string
     */
    private static function quote_regex($a) {
        return preg_quote($a,'/');
    }
}
