if(!String.prototype.repeat) {
  String.prototype.repeat = function(count) {
    'use strict';
    if(this == null) {
      throw new TypeError('can\'t convert ' + this + ' to object');
    }
    var str = '' + this;
    count = +count;
    if(count != count) {
      count = 0;
    }
    if(count < 0) {
      throw new RangeError('repeat count must be non-negative');
    }
    if(count == Infinity) {
      throw new RangeError('repeat count must be less than infinity');
    }
    count = Math.floor(count);
    if(str.length == 0 || count == 0) {
      return '';
    }
    // Ensuring count is a 31-bit integer allows us to heavily optimize the
    // main part. But anyway, most current (August 2014) browsers can't handle
    // strings 1 << 28 chars or longer, so:
    if(str.length * count >= 1 << 28) {
      throw new RangeError('repeat count must not overflow maximum string size');
    }
    var rpt = '';
    for(;;) {
      if((count & 1) == 1) {
        rpt += str;
      }
      count >>>= 1;
      if(count == 0) {
        break;
      }
      str += str;
    }
    return rpt;
  }
}


(function(self) {
  function escapeRegExp(string) {
    return string.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
  }

  var SqlFormatter = {
    reserved: [
      'ACCESSIBLE', 'ACTION', 'AGAINST', 'AGGREGATE', 'ALGORITHM', 'ALL', 'ALTER', 'ANALYSE', 'ANALYZE', 'AS', 'ASC',
      'AUTOCOMMIT', 'AUTO_INCREMENT', 'BACKUP', 'BEGIN', 'BETWEEN', 'BINLOG', 'BOTH', 'CASCADE', 'CASE', 'CHANGE', 'CHANGED', 'CHARACTER SET',
      'CHARSET', 'CHECK', 'CHECKSUM', 'COLLATE', 'COLLATION', 'COLUMN', 'COLUMNS', 'COMMENT', 'COMMIT', 'COMMITTED', 'COMPRESSED', 'CONCURRENT',
      'CONSTRAINT', 'CONTAINS', 'CONVERT', 'CREATE', 'CROSS', 'CURRENT_TIMESTAMP', 'DATABASE', 'DATABASES', 'DAY', 'DAY_HOUR', 'DAY_MINUTE',
      'DAY_SECOND', 'DEFAULT', 'DEFINER', 'DELAYED', 'DELETE', 'DESC', 'DESCRIBE', 'DETERMINISTIC', 'DISTINCT', 'DISTINCTROW', 'DIV',
      'DO', 'DUMPFILE', 'DUPLICATE', 'DYNAMIC', 'ELSE', 'ENCLOSED', 'END', 'ENGINE', 'ENGINE_TYPE', 'ENGINES', 'ESCAPE', 'ESCAPED', 'EVENTS', 'EXEC',
      'EXECUTE', 'EXISTS', 'EXPLAIN', 'EXTENDED', 'FAST', 'FIELDS', 'FILE', 'FIRST', 'FIXED', 'FLUSH', 'FOR', 'FORCE', 'FOREIGN', 'FULL', 'FULLTEXT',
      'FUNCTION', 'GLOBAL', 'GRANT', 'GRANTS', 'GROUP_CONCAT', 'HEAP', 'HIGH_PRIORITY', 'HOSTS', 'HOUR', 'HOUR_MINUTE',
      'HOUR_SECOND', 'IDENTIFIED', 'IF', 'IFNULL', 'IGNORE', 'IN', 'INDEX', 'INDEXES', 'INFILE', 'INSERT', 'INSERT_ID', 'INSERT_METHOD', 'INTERVAL',
      'INTO', 'INVOKER', 'IS', 'ISOLATION', 'KEY', 'KEYS', 'KILL', 'LAST_INSERT_ID', 'LEADING', 'LEVEL', 'LIKE', 'LINEAR',
      'LINES', 'LOAD', 'LOCAL', 'LOCK', 'LOCKS', 'LOGS', 'LOW_PRIORITY', 'MARIA', 'MASTER', 'MASTER_CONNECT_RETRY', 'MASTER_HOST', 'MASTER_LOG_FILE',
      'MATCH', 'MAX_CONNECTIONS_PER_HOUR', 'MAX_QUERIES_PER_HOUR', 'MAX_ROWS', 'MAX_UPDATES_PER_HOUR', 'MAX_USER_CONNECTIONS',
      'MEDIUM', 'MERGE', 'MINUTE', 'MINUTE_SECOND', 'MIN_ROWS', 'MODE', 'MODIFY',
      'MONTH', 'MRG_MYISAM', 'MYISAM', 'NAMES', 'NATURAL', 'NOT', 'NOW()', 'NULL', 'OFFSET', 'ON', 'OPEN', 'OPTIMIZE', 'OPTION', 'OPTIONALLY',
      'ON UPDATE', 'ON DELETE', 'OUTFILE', 'PACK_KEYS', 'PAGE', 'PARTIAL', 'PARTITION', 'PARTITIONS', 'PASSWORD', 'PRIMARY', 'PRIVILEGES', 'PROCEDURE',
      'PROCESS', 'PROCESSLIST', 'PURGE', 'QUICK', 'RANGE', 'RAID0', 'RAID_CHUNKS', 'RAID_CHUNKSIZE', 'RAID_TYPE', 'READ', 'READ_ONLY',
      'READ_WRITE', 'REFERENCES', 'REGEXP', 'RELOAD', 'RENAME', 'REPAIR', 'REPEATABLE', 'REPLACE', 'REPLICATION', 'RESET', 'RESTORE', 'RESTRICT',
      'RETURN', 'RETURNS', 'REVOKE', 'RLIKE', 'ROLLBACK', 'ROW', 'ROWS', 'ROW_FORMAT', 'SECOND', 'SECURITY', 'SEPARATOR',
      'SERIALIZABLE', 'SESSION', 'SHARE', 'SHOW', 'SHUTDOWN', 'SLAVE', 'SONAME', 'SOUNDS', 'SQL', 'SQL_AUTO_IS_NULL', 'SQL_BIG_RESULT',
      'SQL_BIG_SELECTS', 'SQL_BIG_TABLES', 'SQL_BUFFER_RESULT', 'SQL_CALC_FOUND_ROWS', 'SQL_LOG_BIN', 'SQL_LOG_OFF', 'SQL_LOG_UPDATE',
      'SQL_LOW_PRIORITY_UPDATES', 'SQL_MAX_JOIN_SIZE', 'SQL_QUOTE_SHOW_CREATE', 'SQL_SAFE_UPDATES', 'SQL_SELECT_LIMIT', 'SQL_SLAVE_SKIP_COUNTER',
      'SQL_SMALL_RESULT', 'SQL_WARNINGS', 'SQL_CACHE', 'SQL_NO_CACHE', 'START', 'STARTING', 'STATUS', 'STOP', 'STORAGE',
      'STRAIGHT_JOIN', 'STRING', 'STRIPED', 'SUPER', 'TABLE', 'TABLES', 'TEMPORARY', 'TERMINATED', 'THEN', 'TO', 'TRAILING', 'TRANSACTIONAL', 'TRUE',
      'TRUNCATE', 'TYPE', 'TYPES', 'UNCOMMITTED', 'UNIQUE', 'UNLOCK', 'UNSIGNED', 'USAGE', 'USE', 'USING', 'VARIABLES',
      'VIEW', 'WHEN', 'WITH', 'WORK', 'WRITE', 'YEAR_MONTH'
    ],
    reserved_toplevel: ['SELECT', 'FROM', 'WHERE', 'SET', 'ORDER BY', 'GROUP BY', 'LIMIT', 'DROP',
      'VALUES', 'UPDATE', 'HAVING', 'ADD', 'AFTER', 'ALTER TABLE', 'DELETE FROM', 'UNION ALL', 'UNION', 'EXCEPT', 'INTERSECT'
    ],
    reserved_newline: ['LEFT OUTER JOIN', 'RIGHT OUTER JOIN', 'LEFT JOIN', 'RIGHT JOIN', 'OUTER JOIN', 'INNER JOIN', 'JOIN', 'XOR', 'OR', 'AND'],
    functions: ['ABS', 'ACOS', 'ADDDATE', 'ADDTIME', 'AES_DECRYPT', 'AES_ENCRYPT', 'AREA', 'ASBINARY', 'ASCII', 'ASIN', 'ASTEXT', 'ATAN', 'ATAN2',
      'AVG', 'BDMPOLYFROMTEXT', 'BDMPOLYFROMWKB', 'BDPOLYFROMTEXT', 'BDPOLYFROMWKB', 'BENCHMARK', 'BIN', 'BIT_AND', 'BIT_COUNT', 'BIT_LENGTH',
      'BIT_OR', 'BIT_XOR', 'BOUNDARY', 'BUFFER', 'CAST', 'CEIL', 'CEILING', 'CENTROID', 'CHAR', 'CHARACTER_LENGTH', 'CHARSET', 'CHAR_LENGTH',
      'COALESCE', 'COERCIBILITY', 'COLLATION', 'COMPRESS', 'CONCAT', 'CONCAT_WS', 'CONNECTION_ID', 'CONTAINS', 'CONV', 'CONVERT', 'CONVERT_TZ',
      'CONVEXHULL', 'COS', 'COT', 'COUNT', 'CRC32', 'CROSSES', 'CURDATE', 'CURRENT_DATE', 'CURRENT_TIME', 'CURRENT_TIMESTAMP', 'CURRENT_USER',
      'CURTIME', 'DATABASE', 'DATE', 'DATEDIFF', 'DATE_ADD', 'DATE_DIFF', 'DATE_FORMAT', 'DATE_SUB', 'DAY', 'DAYNAME', 'DAYOFMONTH', 'DAYOFWEEK',
      'DAYOFYEAR', 'DECODE', 'DEFAULT', 'DEGREES', 'DES_DECRYPT', 'DES_ENCRYPT', 'DIFFERENCE', 'DIMENSION', 'DISJOINT', 'DISTANCE', 'ELT', 'ENCODE',
      'ENCRYPT', 'ENDPOINT', 'ENVELOPE', 'EQUALS', 'EXP', 'EXPORT_SET', 'EXTERIORRING', 'EXTRACT', 'EXTRACTVALUE', 'FIELD', 'FIND_IN_SET', 'FLOOR',
      'FORMAT', 'FOUND_ROWS', 'FROM_DAYS', 'FROM_UNIXTIME', 'GEOMCOLLFROMTEXT', 'GEOMCOLLFROMWKB', 'GEOMETRYCOLLECTION', 'GEOMETRYCOLLECTIONFROMTEXT',
      'GEOMETRYCOLLECTIONFROMWKB', 'GEOMETRYFROMTEXT', 'GEOMETRYFROMWKB', 'GEOMETRYN', 'GEOMETRYTYPE', 'GEOMFROMTEXT', 'GEOMFROMWKB', 'GET_FORMAT',
      'GET_LOCK', 'GLENGTH', 'GREATEST', 'GROUP_CONCAT', 'GROUP_UNIQUE_USERS', 'HEX', 'HOUR', 'IF', 'IFNULL', 'INET_ATON', 'INET_NTOA', 'INSERT', 'INSTR',
      'INTERIORRINGN', 'INTERSECTION', 'INTERSECTS', 'INTERVAL', 'ISCLOSED', 'ISEMPTY', 'ISNULL', 'ISRING', 'ISSIMPLE', 'IS_FREE_LOCK', 'IS_USED_LOCK',
      'LAST_DAY', 'LAST_INSERT_ID', 'LCASE', 'LEAST', 'LEFT', 'LENGTH', 'LINEFROMTEXT', 'LINEFROMWKB', 'LINESTRING', 'LINESTRINGFROMTEXT', 'LINESTRINGFROMWKB',
      'LN', 'LOAD_FILE', 'LOCALTIME', 'LOCALTIMESTAMP', 'LOCATE', 'LOG', 'LOG10', 'LOG2', 'LOWER', 'LPAD', 'LTRIM', 'MAKEDATE', 'MAKETIME', 'MAKE_SET',
      'MASTER_POS_WAIT', 'MAX', 'MBRCONTAINS', 'MBRDISJOINT', 'MBREQUAL', 'MBRINTERSECTS', 'MBROVERLAPS', 'MBRTOUCHES', 'MBRWITHIN', 'MD5', 'MICROSECOND',
      'MID', 'MIN', 'MINUTE', 'MLINEFROMTEXT', 'MLINEFROMWKB', 'MOD', 'MONTH', 'MONTHNAME', 'MPOINTFROMTEXT', 'MPOINTFROMWKB', 'MPOLYFROMTEXT', 'MPOLYFROMWKB',
      'MULTILINESTRING', 'MULTILINESTRINGFROMTEXT', 'MULTILINESTRINGFROMWKB', 'MULTIPOINT', 'MULTIPOINTFROMTEXT', 'MULTIPOINTFROMWKB', 'MULTIPOLYGON',
      'MULTIPOLYGONFROMTEXT', 'MULTIPOLYGONFROMWKB', 'NAME_CONST', 'NULLIF', 'NUMGEOMETRIES', 'NUMINTERIORRINGS', 'NUMPOINTS', 'OCT', 'OCTET_LENGTH',
      'OLD_PASSWORD', 'ORD', 'OVERLAPS', 'PASSWORD', 'PERIOD_ADD', 'PERIOD_DIFF', 'PI', 'POINT', 'POINTFROMTEXT', 'POINTFROMWKB', 'POINTN', 'POINTONSURFACE',
      'POLYFROMTEXT', 'POLYFROMWKB', 'POLYGON', 'POLYGONFROMTEXT', 'POLYGONFROMWKB', 'POSITION', 'POW', 'POWER', 'QUARTER', 'QUOTE', 'RADIANS', 'RAND',
      'RELATED', 'RELEASE_LOCK', 'REPEAT', 'REPLACE', 'REVERSE', 'RIGHT', 'ROUND', 'ROW_COUNT', 'RPAD', 'RTRIM', 'SCHEMA', 'SECOND', 'SEC_TO_TIME',
      'SESSION_USER', 'SHA', 'SHA1', 'SIGN', 'SIN', 'SLEEP', 'SOUNDEX', 'SPACE', 'SQRT', 'SRID', 'STARTPOINT', 'STD', 'STDDEV', 'STDDEV_POP', 'STDDEV_SAMP',
      'STRCMP', 'STR_TO_DATE', 'SUBDATE', 'SUBSTR', 'SUBSTRING', 'SUBSTRING_INDEX', 'SUBTIME', 'SUM', 'SYMDIFFERENCE', 'SYSDATE', 'SYSTEM_USER', 'TAN',
      'TIME', 'TIMEDIFF', 'TIMESTAMP', 'TIMESTAMPADD', 'TIMESTAMPDIFF', 'TIME_FORMAT', 'TIME_TO_SEC', 'TOUCHES', 'TO_DAYS', 'TRIM', 'TRUNCATE', 'UCASE',
      'UNCOMPRESS', 'UNCOMPRESSED_LENGTH', 'UNHEX', 'UNIQUE_USERS', 'UNIX_TIMESTAMP', 'UPDATEXML', 'UPPER', 'USER', 'UTC_DATE', 'UTC_TIME', 'UTC_TIMESTAMP',
      'UUID', 'VARIANCE', 'VAR_POP', 'VAR_SAMP', 'VERSION', 'WEEK', 'WEEKDAY', 'WEEKOFYEAR', 'WITHIN', 'X', 'Y', 'YEAR', 'YEARWEEK'
    ],
    boundaries: [',', ';', ':', ')', '(', '.', '=', '<', '>', '+', '-', '*', '/', '!', '^', '%', '|', '&', '#'],
    token_cache: {},
    cache_hits: 0,
    cache_missed: 0,

    _init: false,
    options: {
      max_cachekey_size: 15,
      tab: "  ",
      max_line_length: 30,

      mismatched_parentheses: "WARNING: unclosed parentheses or section",
      attr_quote: 'class="sql-quote"',
      attr_backtick_quote: 'class="sql-backtick-quote"',
      attr_reserved: 'class="sql-reserved"',
      attr_boundary: '',
      attr_number: 'class="sql-number"',
      attr_word: 'class="sql-word"',
      attr_error: 'class="sql-error"',
      attr_comment: 'class="sql-comment"',
      attr_variable: 'class="sql-variable"',
      attr_function: 'class="sql-function"',
      attr_error: 'class="sql-error"'
    },

    init: function() {
      if(SqlFormatter._init) return;
      SqlFormatter._init = true;

      // Sort reserved words from longest to shortest
      SqlFormatter.reserved = SqlFormatter.reserved.sort(function(a, b) {
        return b.length - a.length;
      });


      // Strings for use in regular expressions
      var boundaries = '(' + SqlFormatter.boundaries.map(escapeRegExp).join('|') + ')';
      var reserved = '(' + SqlFormatter.reserved.map(escapeRegExp).join('|') + ')';
      var reserved_toplevel = '(' + SqlFormatter.reserved_toplevel.map(escapeRegExp).join('|').replace(/\s+/g, '\\s+') + ')';
      var reserved_newline = '(' + SqlFormatter.reserved_newline.map(escapeRegExp).join('|').replace(/\s+/g, '\\s+') + ')';
      var functions = '(' + SqlFormatter.functions.map(escapeRegExp).join('|') + ')';


      // Regular expressions
      SqlFormatter.regex_number = new RegExp('^([0-9]+(\\.[0-9]+)?|0x[0-9a-fA-F]+|0b[01]+)($|\\s|"\'`|' + boundaries + ')');
      SqlFormatter.regex_boundaries = new RegExp('^(' + boundaries + ')');
      SqlFormatter.regex_reserved_toplevel = new RegExp('^(' + reserved_toplevel + ')($|\\s|' + boundaries + ')');
      SqlFormatter.regex_reserved_newline = new RegExp('^(' + reserved_newline + ')($|\\s|' + boundaries + ')');
      SqlFormatter.regex_reserved = new RegExp('^(' + reserved + ')($|\\s|' + boundaries + ')');
      SqlFormatter.regex_function = new RegExp('^' + functions + '\\(');
      SqlFormatter.regex_word = new RegExp('^(.*?)($|\\s|["\'`]|' + boundaries + ')');
    },
    getQuotedString: function(string) {

    },
    getNextToken: function(string, previous) {
      var matches, k, v, i, j, l, t, c0, c1, upper;
      // Whitespace
      if(matches = string.match(/^\s+/)) {
        return {
          v: matches[0],
          t: 'ws'
        };
      }

      // Comment
      if(matches = string.match(/^(\#|--|\/\*)/)) {
        // Block comment
        if(matches[0] == '/*') {
          l = string.indexOf('*/') + 2;
          t = 'cb';
        }
        // Single line comment
        else {
          l = string.indexOf("\n");
          t = 'c';
        }

        if(l === -1) {
          l = string.length;
        }

        return {
          v: string.substr(0, l),
          t: t
        };
      }

      // Quoted String
      c0 = string.charAt(0);
      if(c0 == '"' || c0 == "'") {
        return {
          v: SqlFormatter.getQuotedString(string),
          t: 'q'
        }
      }
      if(c0 == '`' || c0 == '[') {
        return {
          v: SqlFormatter.getQuotedString(string),
          t: 'qb'
        }
      }

      // User-defined variable / placeholders
      c1 = string.charAt(1);
      if((c0 === '@' || c0 === ':') && c1) {
        l = {
          t: 'v'
        };

        // Quoted variable name
        if(c1 === '"' || c1 === "'" || c1 === '`') {
          l.v = c0 + SqlFormatter.getQuotedString(string.substr(1));
        }
        // Non-quoted variable name
        else {
          matches = string.match(/^(.[a-zA-Z0-9._$]+)/);
          if(matches) {
            l.v = matches[1];
          }
        }

        if(l.v) return l;
      }

      // Number (decimal, binary, or hex)
      if(matches = string.match(SqlFormatter.regex_number)) {
        return {
          v: matches[1],
          t: 'n'
        };
      }

      // Boundary Character (punctuation and symbols)
      if(matches = string.match(SqlFormatter.regex_boundaries)) {
        return {
          v: matches[1],
          t: 'b'
        }
      }


      upper = string.toUpperCase();

      // Reserved words (cannot be preceded by a '.')
      if(!previous || previous.v !== '.') {
        // Top level reserved word
        if(matches = upper.match(SqlFormatter.regex_reserved_toplevel)) {
          return {
            v: matches[1],
            t: 'rt'
          };
        }
        // Newline reserved word
        if(matches = upper.match(SqlFormatter.regex_reserved_newline)) {
          return {
            v: matches[1],
            t: 'rn'
          };
        }
        // Other reserved word
        if(matches = upper.match(SqlFormatter.regex_reserved)) {
          return {
            v: matches[1],
            t: 'r'
          };
        }
      }

      // Function
      if(matches = upper.match(SqlFormatter.regex_function)) {
        return {
          v: matches[1],
          t: 'f'
        };
      }

      // Non reserved word (everything else)
      matches = string.match(SqlFormatter.regex_word);
      return {
        v: matches[1],
        t: 'w'
      };
    },
    getQuotedString: function(string) {
      // This checks for the following patterns:
      // 1. backtick quoted string using `` to escape
      // 2. square bracket quoted string (SQL Server) using ]] to escape
      // 3. double quoted string using "" or \" to escape
      // 4. single quoted string using '' or \' to escape
      if(matches = string.match(/^(((`[^`]*($|`))+)|((\[[^\]]*($|\]))(\][^\]]*($|\]))*)|(("[^"\\\\]*(?:\\\\.[^"\\\\]*)*("|$))+)|((\'[^\'\\\\]*(?:\\\\.[^\'\\\\]*)*(\'|$))+))/)) {
        return matches[1];
      }
    },
    tokenize: function(string) {
      var tokens = [],
        orig_l = string.length,
        old_l = string.length + 1,
        token = null,
        key;

      // Keep processing the string until it is empty
      while(string.length) {
        // If the string stopped shrinking, there was a problem
        if(old_l <= string.length) {
          tokens.push({
            v: string,
            t: 'e'
          });
          return tokens;
        }
        old_l = string.length;

        // Determine if we can use caching
        if(string.length >= SqlFormatter.options.max_cachekey_size) {
          key = string.substr(0, SqlFormatter.options.max_cachekey_size);
        }
        else {
          key = false;
        }

        // If token is already cached
        if(key && SqlFormatter.token_cache[key]) {
          token = SqlFormatter.token_cache[key];
          SqlFormatter.cache_hits++;
        }
        // Not cached
        else {
          token = SqlFormatter.getNextToken(string, token);
          SqlFormatter.cache_misses++;

          // Cache for next time
          if(key && token.v.length < SqlFormatter.options.max_cachekey_size) {
            SqlFormatter.token_cache[key] = token;
          }
        }
        tokens.push(token);

        // Advance the string
        string = string.substr(token.v.length);
      }

      return tokens;
    },

    format: function(string, highlight) {
      if(highlight !== false) highlight = true;

      var ret = '',
        i,
        l,
        j,
        t,
        v,
        indent_level = 0,
        indent = "",
        newline = false,
        increase_special_indent = false,
        increase_block_indent = false,
        indent_types = [],
        added_newline = false,
        inline_count = 0,
        inline_indented = false,
        inline_parentheses = false,
        clause_limit = false;

      // Tokenize SQL string
      var original_tokens = SqlFormatter.tokenize(string);

      // Remove existing whitespace
      var tokens = [];
      for(i = 0; i < original_tokens.length; i++) {
        if(original_tokens[i].t !== "ws") {
          original_tokens[i].i = i;
          tokens.push(original_tokens[i]);
        }
      }

      // Format token by token
      for(i = 0; i < tokens.length; i++) {
        t = tokens[i];

        // If highlighting too, get the highlighted value
        if(highlight) v = SqlFormatter.highlightToken(t);
        // Otherwise, just use plain text
        else v = t.v;

        // If we are increasing the special indent level now
        if(increase_special_indent) {
          indent_level++;
          increase_special_indent = false;
          indent_types.unshift('special');
        }
        // If we are inreasing the block indent level now
        if(increase_block_indent) {
          indent_level++;
          increase_block_indent = false;
          indent_types.unshift('block');
        }

        indent = "\t".repeat(indent_level);

        // If we need a new line before the token
        if(newline) {
          ret += "\n" + indent;
          newline = false;
          added_newline = true;
        }
        else {
          added_newline = false;
        }

        // Display comments directly where they appear in the source
        if(t.t === 'cb') {
          // Indent each line of a block comment
          if(!added_newline) {
            ret += "\n" + indent;
          }
          ret += v.replace(/\n/g, "\n" + indent);
          newline = true;
          continue;
        }
        else if(t.t === 'c') {
          ret += v;
          newline = true;
          continue;
        }

        // If we are in an inline parentheses block
        if(inline_parentheses) {
          // End of inline parentheses
          if(t.v === ")") {
            // Trim trailing whitespace on the line
            ret = ret.replace(/\s+$/, '');

            if(inline_indented) {
              indent_types.shift();
              indent_level--;
              ret += "\n" + "\t".repeat(indent_level);
            }

            inline_parentheses = false;

            ret += v + " ";
            continue;
          }

          // Limit number of characters per line
          if(t.v === ",") {
            if(inline_count >= SqlFormatter.options.max_line_length) {
              inline_count = 0;
              newline = true;
            }
          }

          inline_count += t.v.length;
        }

        // Opening parentheses increase the block indent level and start a new line
        if(t.v === '(') {
          // First check if this should be an inline parentheses block
          // Examples are "NOW()", "COUNT(*)", "int(10)", key(`somecolumn`), DECIMAL(7,2)
          l = 0;
          for(j = 1; j <= 250; j++) {
            // Reached end of string
            if(!tokens[i + j]) break;
            n = tokens[i + j];
            // Reached closing parentheses, able to inline it
            if(n.v === ')') {
              inline_parentheses = true;
              inline_count = 0;
              inline_indented = false;
              break;
            }
            // Reached an invalid token for inline parentheses
            if(n.v === ';' || n.v === '(') {
              break;
            }
            // Reached an invalid token type for inline parentheses
            if(n.t === "rt" || n.t === "rn" || n.t === "c" || n.t === "cb") {
              break;
            }

            l += n.v.length;
          }
          if(inline_parentheses && l > 30) {
            increase_block_indent = true;
            inline_indented = true;
            newline = true;
          }
          if(!inline_parentheses) {
            increase_block_indent = true;
            // Add a newline after the parentheses
            newline = true;
          }

          // Take out the preceding space unless there was whitespace there in the original query
          if(original_tokens[t.i - 1] && original_tokens[t.i - 1].t !== 'ws') {
            ret = ret.replace(/\s+$/, '');
          }
        }
        else if(t.v === ')') {
          // Remove whitespace before the closing parentheses
          ret = ret.replace(/\s+$/, '');
          indent_level--;
          // Reset indent level
          while(j = indent_types.shift()) {
            if(j === 'special') {
              indent_level--;
            }
            else {
              break;
            }
          }
          if(indent_level < 0) {
            // This is an invalid closing parentheses
            indent_level = 0;
            if(highlight) {
              // Mark as an error
              t.t = 'e';
              ret += "\n" + SqlFormatter.highlightToken(t);
              continue;
            }
          }
          // Add a newline before the closing parentheses (if not already added)
          if(!added_newline) {
            ret += "\n" + "\t".repeat(indent_level);
          }
        }
        // Top level reserved words start a new line and increase the special indent level
        else if(t.t === 'rt') {
          increase_special_indent = true;

          // If the last indent type was 'special', decrease the special indent for this round
          if(indent_types[0] === 'special') {
            indent_level--;
            indent_types.shift()
          }
          // Add a newline after the top level reserved word
          newline = true;
          // Add a newline before the top level reserved word (if not already added)
          if(!added_newline) {
            ret += "\n" + "\t".repeat(indent_level);
          }
          // If we already added a newline, redo the indentation since it may be different now
          else {
            ret = ret.replace(/\t+$/, '') + "\t".repeat(indent_level);
          }
          // If the token may have extra whitespace
          if(t.v.match(/\s/)) {
            v = v.replace(/\s+/g, ' ');
          }
          //if SQL 'LIMIT' clause, start variable to reset newline
          if(t.v === 'LIMIT' && !inline_parentheses) {
            clause_limit = true;
          }
        }
        // Only allow numbers and commas in limit clauses
        else if(clause_limit && t.v !== "," && t.t !== "n") {
          clause_limit = false;
        }
        // Commas start a new line (unless within inline parentheses or SQL 'LIMIT' clause)
        else if(t.v === ',' && !inline_parentheses) {
          //If the previous TOKEN_VALUE is 'LIMIT', resets new line
          if(clause_limit === true) {
            newline = false;
            clause_limit = false;
          }
          // All other cases of commas
          else {
            newline = true;
          }
        }
        // Newline reserved words start a new line
        else if(t.t === 'rn') {
          // Add a newline before the reserved word (if not already added)
          if(!added_newline) {
            ret += "\n" + "\t".repeat(indent_level);
          }
          // If the token may have extra whitespace
          if(t.v.match(/\s/)) {
            v = v.replace(/\s+/g, ' ');
          }
        }
        // Semicolons start a new line and clear indents
        else if(t.v === ';') {
          newline = true;
          indent_level = 0;
          increase_special_indent = false;
          increase_block_indent = false;
          indent_types = [];
          inline_indented = false;
          inline_parentheses = false;
          clause_limit = false;

          ret = ret.replace(/\s+$/, '');
          ret += v + "\n";
          continue;
        }
        // Multiple boundary characters in a row should not have spaces between them unless they do in the source (not including parentheses)
        else if(t.t === 'b') {
          if(tokens[i - 1] && tokens[i - 1].t === 'b') {
            if(original_tokens[t.i - 1] && original_tokens[t.i - 1].t !== "ws") {
              ret = ret.replace(/\s+$/, '');
            }
          }
        }



        // If the token shouldn't have a space before it
        if(t.v === '.' || t.v === ',' || t.v === ';') {
          ret = ret.replace(/\s+$/, '');
        }

        ret += v + ' ';

        // If the token shouldn't have a space after it
        if(t.v === '(' || t.v === '.') {
          ret = ret.replace(/\s+$/, '');
        }

        // If this is the "-" of a negative number, it shouldn't have a space after it
        if(t.v === '-' && tokens[i + 1] && tokens[i + 1].t === 'n' && tokens[i - 1]) {
          var prev = tokens[i - 1].t;
          if(prev !== 'q' && prev !== 'qb' && prev !== 'w' && prev !== 'n') {
            ret = ret.replace(/\s+$/, '');
          }
        }
      }

      // If there are unmatched parentheses
      if(highlight && SqlFormatter.options.mismatched_parentheses && indent_types.indexOf('block') !== -1) {
        ret += "\n" + SqlFormatter.highlightToken({
          t: 'e',
          v: SqlFormatter.options.mismatched_parentheses
        });
      }

      // Replace tab characters with the tab character option
      ret = ret.replace(/\t/g, SqlFormatter.options.tab).replace(/^\s+/, '').replace(/\s+$/, '');

      return ret;
    },

    highlight: function(string) {
      var tokens = SqlFormatter.tokenize(string);

      var ret = '';
      for(var i = 0; i < tokens.length; i++) {
        ret += SqlFormatter.highlightToken(tokens[i]);
      }

      return ret;
    },

    highlightToken: function(token) {
      var t = token.t;
      var v = token.v.replace(/</g, '&lt;');

      var attr = null;
      if(t === 'b') attr = SqlFormatter.options.attr_boundary;
      if(t === 'w') attr = SqlFormatter.options.attr_word;
      if(t === 'qb') attr = SqlFormatter.options.attr_backtick_quote;
      if(t === 'q') attr = SqlFormatter.options.attr_quote;
      if(t === 'r') attr = SqlFormatter.options.attr_reserved;
      if(t === 'rt') attr = SqlFormatter.options.attr_reserved;
      if(t === 'rn') attr = SqlFormatter.options.attr_reserved;
      if(t === 'n') attr = SqlFormatter.options.attr_number;
      if(t === 'v') attr = SqlFormatter.options.attr_variable;
      if(t === 'f') attr = SqlFormatter.options.attr_function;
      if(t === 'e') attr = SqlFormatter.options.attr_error;
      if(t === 'c' || t === 'cb') attr = SqlFormatter.options.attr_comment;

      if(attr) return '<span ' + attr + '>' + v + '</span>';
      else return v;
    }
  };

  SqlFormatter.init();

  self.SqlFormatter = SqlFormatter;
})(window);
