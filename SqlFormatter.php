<?php
class SqlFormatter {
	private static $reserved = array (
		'ACCESSIBLE', 'ACTION', 'ADD', 'AFTER', 'AGAINST', 'AGGREGATE', 'ALGORITHM', 'ALL', 'ALTER', 'ANALYSE', 'ANALYZE', 'AND', 'AS', 'ASC',
		'AUTOCOMMIT', 'AUTO_INCREMENT', 'AVG_ROW_LENGTH', 'BACKUP', 'BEGIN', 'BETWEEN', 'BINLOG', 'BOTH', 'BY', 'CASCADE', 'CASE', 'CHANGE', 'CHANGED',
		'CHARSET', 'CHECK', 'CHECKSUM', 'COLLATE', 'COLLATION', 'COLUMN', 'COLUMNS', 'COMMENT', 'COMMIT', 'COMMITTED', 'COMPRESSED', 'CONCURRENT', 
		'CONSTRAINT', 'CONTAINS', 'CONVERT', 'COUNT', 'CREATE', 'CROSS', 'CURRENT_TIMESTAMP', 'DATABASE', 'DATABASES', 'DAY', 'DAY_HOUR', 'DAY_MINUTE', 
		'DAY_SECOND', 'DEFINER', 'DELAYED', 'DELAY_KEY_WRITE', 'DELETE', 'DESC', 'DESCRIBE', 'DETERMINISTIC', 'DISTINCT', 'DISTINCTROW', 'DIV',
		'DO', 'DROP', 'DUMPFILE', 'DUPLICATE', 'DYNAMIC', 'ELSE', 'ENCLOSED', 'END', 'ENGINE', 'ENGINES', 'ESCAPE', 'ESCAPED', 'EVENTS', 'EXECUTE',
		'EXISTS', 'EXPLAIN', 'EXTENDED', 'FAST', 'FIELDS', 'FILE', 'FIRST', 'FIXED', 'FLUSH', 'FOR', 'FORCE', 'FOREIGN', 'FROM', 'FULL', 'FULLTEXT',
		'FUNCTION', 'GEMINI', 'GEMINI_SPIN_RETRIES', 'GLOBAL', 'GRANT', 'GRANTS', 'GROUP', 'GROUP BY', 'HAVING', 'HEAP', 'HIGH_PRIORITY', 'HOSTS', 'HOUR', 'HOUR_MINUTE',
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
	
	private static $special_reserved = array(
		'SELECT','FROM','WHERE','SET','ORDER BY','GROUP BY','LEFT JOIN','OUTER JOIN','INNER JOIN','RIGHT JOIN','JOIN','LIMIT'
	);
	
	private static $boundaries = array(',',';',')','(','.');

	private static $whitespace = array(' ',"\n","\t","\r");
	
	private static $quotes = array('"',"'",'`');

	//this flag tells us if the reserved word list is sorted already
	private static $reserved_sorted;


	protected static function getNextToken($string,&$type) {
		//if the next item is a string
		if(in_array($string[0],self::$quotes)) {
			$quote = $string[0];
			for($i=1;$i<strlen($string);$i++) {
				//escaped (either backslash or backtick escaped)
				if(($quote != '`' && $string[$i] === '\\') || ($quote === '`' && $string[$i] === '`' && $string[$i+1] === '`')) {
					$i++;
				}
				elseif($string[$i] === $quote) {
					break;
				}
			}
			if($quote === '`') $type = 'backtick quote';
			else $type = 'quote';
			
			return substr($string,0,$i+1);
		}
		//separators
		elseif(in_array($string[0],self::$boundaries)) {
			//if it is a simple string or empty between the parentheses, just count as a word
			//this makes it so we don't split things like NOW() or COUNT(*) into separate lines
			if($string[0] === '(') {
				if($string[1] === ')') {
					$type = 'word';
					return '()';
				}
				$type2 = null;
				$next_token = self::getNextToken(substr($string,1),$type2);
				if($string[strlen($next_token)+1] === ')') {
					if($type2 === 'word') {
						$type = 'word';
						return '('.$next_token.')';
					}
					elseif($type2 === 'whitespace') {
						$type = 'word';
						return '('.$next_token.')';
					}
				}
			}
		
		
			$type = $string[0];
			return $string[0];
		}
		//whitespace
		elseif(in_array($string[0],self::$whitespace)) {
			for($i=1;$i<strlen($string);$i++) {
				if(!in_array($string[$i],self::$whitespace)) {
					break;
				}
			}
		
			$type = 'whitespace';
			return substr($string,0,$i);
		}
		
		//sort reserved word list from longest word to shortest
		if(!self::$reserved_sorted) {
			usort(self::$reserved,function($a,$b) {
				return strlen($b) - strlen($a);
			});
			self::$reserved_sorted = true;
		}
		
		$all_boundaries = array_merge(self::$boundaries, self::$whitespace);
		
		//reserved word
		$test = strtoupper($string);
		foreach(self::$reserved as $word) {
			//if(strlen($test < strlen($word))) continue;
			if(substr($test,0,strlen($word)) === $word) {
				if(isset($string[strlen($word)]) && !in_array($string[strlen($word)],$all_boundaries)) continue;
			
				if(in_array($word,self::$special_reserved)) $type = 'special reserved';
				else $type = 'reserved';
				
				return $word;
			}
		}
		
		//look for first word separator
		for($i=1;$i<strlen($string);$i++) {	
			if(in_array($string[$i],$all_boundaries)) {
				break;
			}
		}
		$ret = substr($string,0,$i);
		if(is_numeric($ret)) $type = 'number';
		else $type = 'word';
		return $ret;
	}
	
	public static function format($string) {
		//this variable will be populated with formatted html
		$return = '';
	
		//configuration values
		$tab = "&nbsp;&nbsp;";
	
		//starting values
		$i = 0;
		$indent = 1;
		$newline = false;
		$first = true;
		$old_string_len = strlen($string) + 1;
		
		//keep processing the string until it is empty
		while(strlen($string)) {
			//if the string stopped shrinking, there was a problem
			if($old_string_len <= strlen($string)) {
				throw new Exception("SQL PARSE ERROR");
			}
			$old_string_len = strlen($string);
			
			//get the next token and the token type
			$type = null;
			$raw_token = self::getNextToken($string,$type);
			$next_token = htmlentities($raw_token);
			
			//don't process whitespace
			if($type === 'whitespace') {
				$string = substr($string,strlen($raw_token));
				continue;
			}
			
			//if the previous token requires a newline following it
			if($newline) {
				$newline = false;
				$has_newline = true;
				$return .= "\n".str_repeat($tab,$indent);
			}
			else {
				$has_newline = false;
			}
			
			switch($type) {
				case 'backtick quote':
					$return .= "<span style='color:purple;'>".$next_token."</span> ";
					break;
				case 'quote':
					$return .= "<span style='color:blue;'>".$next_token."</span> ";
					break;
				case 'reserved':
					$return .= "<span style='font-weight:bold;'>".$next_token."</span> ";
					break;
				//these are reserved words that are on their own line
				case 'special reserved':
					$newline = true;
					if(!$first && !$has_newline) $return .= "\n".str_repeat($tab,$indent? $indent-1 : 0);
					elseif(!$first) $return = substr($return,0,-1*(strlen($tab)));
					$return .= "<span style='font-weight:bold;'>".$next_token."</span> ";
					break;
				case '(':
					$indent++;
					$newline = true;
					$return .= '(';
					break;
				case ')':
					if($indent > 1) {
						$indent--;
						$return .= "\n".str_repeat($tab,$indent).") ";
					}
					//unmatching parentheses
					else {
						$return .= "\n".str_repeat($tab,$indent)."<span style='background:red; color:black; font-weight:bold;'>)</span> ";
					}
					break;
				case 'number':
					$return .= "<span style='color: green;'>".$next_token."</span> ";
					break;
				default:
					$return .= "<span style='color: #555;'>".$next_token."</span> ";
			}
			
			//advance the string forward
			$string = substr($string,strlen($raw_token));
			$first = false;
		}
		
		//if there are unmatched parentheses
		if($indent !== 1) {
			$return .= "\n<span style='color:red;'>WARNING: unmatched parentheses</span>";
		}
		
		return "<pre style='background:white;'>".$return."</pre>";
	}
}
?>
