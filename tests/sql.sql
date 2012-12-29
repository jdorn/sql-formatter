SELECT customer_id, customer_name, COUNT(order_id) as total
FROM customers INNER JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customer_id, customer_name
HAVING COUNT(order_id) > 5
ORDER BY COUNT(order_id) DESC;

UPDATE customers
        SET totalorders = ordersummary.total
        FROM (SELECT customer_id, count(order_id) As total 
FROM orders GROUP BY customer_id) As ordersummary
        WHERE customers.customer_id = ordersummary.customer_id

SELECT * FROM sometable
UNION ALL
SELECT * FROM someothertable;

SET NAMES 'utf8';

CREATE TABLE `PREFIX_access` (
  `id_profile` int(10) unsigned NOT NULL,
  `id_tab` int(10) unsigned NOT NULL,
  `view` int(11) NOT NULL,
  `add` int(11) NOT NULL,
  `edit` int(11) NOT NULL,
  `delete` int(11) NOT NULL,
  PRIMARY KEY (`id_profile`,`id_tab`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_accessory` (
  `id_product_1` int(10) unsigned NOT NULL,
  `id_product_2` int(10) unsigned NOT NULL,
  KEY `accessory_product` (`id_product_1`,`id_product_2`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_address` (
  `id_address` int(10) unsigned NOT NULL auto_increment,
  `id_country` int(10) unsigned NOT NULL,
  `id_state` int(10) unsigned default NULL,
  `id_customer` int(10) unsigned NOT NULL default '0',
  `id_manufacturer` int(10) unsigned NOT NULL default '0',
  `id_supplier` int(10) unsigned NOT NULL default '0',
  `id_warehouse` int(10) unsigned NOT NULL default '0',
  `alias` varchar(32) NOT NULL,
  `company` varchar(64) default NULL,
  `lastname` varchar(32) NOT NULL,
  `firstname` varchar(32) NOT NULL,
  `address1` varchar(128) NOT NULL,
  `address2` varchar(128) default NULL,
  `postcode` varchar(12) default NULL,
  `city` varchar(64) NOT NULL,
  `other` text,
  `phone` varchar(16) default NULL,
  `phone_mobile` varchar(16) default NULL,
  `vat_number` varchar(32) default NULL,
  `dni` varchar(16) DEFAULT NULL,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  `active` tinyint(1) unsigned NOT NULL default '1',
  `deleted` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_address`),
  KEY `address_customer` (`id_customer`),
  KEY `id_country` (`id_country`),
  KEY `id_state` (`id_state`),
  KEY `id_manufacturer` (`id_manufacturer`),
  KEY `id_supplier` (`id_supplier`),
  KEY `id_warehouse` (`id_warehouse`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_alias` (
  `id_alias` int(10) unsigned NOT NULL auto_increment,
  `alias` varchar(255) NOT NULL,
  `search` varchar(255) NOT NULL,
  `active` tinyint(1) NOT NULL default '1',
  PRIMARY KEY (`id_alias`),
  UNIQUE KEY `alias` (`alias`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attachment` (
  `id_attachment` int(10) unsigned NOT NULL auto_increment,
  `file` varchar(40) NOT NULL,
  `file_name` varchar(128) NOT NULL,
  `mime` varchar(128) NOT NULL,
  PRIMARY KEY (`id_attachment`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attachment_lang` (
  `id_attachment` int(10) unsigned NOT NULL auto_increment,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(32) default NULL,
  `description` TEXT,
  PRIMARY KEY (`id_attachment`, `id_lang`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_product_attachment` (
  `id_product` int(10) unsigned NOT NULL,
  `id_attachment` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_product`,`id_attachment`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attribute` (
  `id_attribute` int(10) unsigned NOT NULL auto_increment,
  `id_attribute_group` int(10) unsigned NOT NULL,
  `color` varchar(32) default NULL,
  `position` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_attribute`),
  KEY `attribute_group` (`id_attribute_group`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attribute_group` (
  `id_attribute_group` int(10) unsigned NOT NULL auto_increment,
  `is_color_group` tinyint(1) NOT NULL default '0',
  `group_type` ENUM('select', 'radio', 'color') NOT NULL DEFAULT  'select',
  `position` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_attribute_group`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attribute_group_lang` (
  `id_attribute_group` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `public_name` varchar(64) NOT NULL,
  PRIMARY KEY (`id_attribute_group`,`id_lang`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attribute_impact` (
  `id_attribute_impact` int(10) unsigned NOT NULL auto_increment,
  `id_product` int(11) unsigned NOT NULL,
  `id_attribute` int(11) unsigned NOT NULL,
  `weight` DECIMAL(20,6) NOT NULL,
  `price` decimal(17,2) NOT NULL,
  PRIMARY KEY (`id_attribute_impact`),
  UNIQUE KEY `id_product` (`id_product`,`id_attribute`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attribute_lang` (
  `id_attribute` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  PRIMARY KEY (`id_attribute`,`id_lang`),
  KEY `id_lang` (`id_lang`,`name`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_carrier` (
  `id_carrier` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_reference` int(10) unsigned NOT NULL,
  `id_tax_rules_group` int(10) unsigned DEFAULT '0',
  `name` varchar(64) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `shipping_handling` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `range_behavior` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_module` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `is_free` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `shipping_external` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `need_range` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `external_module_name` varchar(64) DEFAULT NULL,
  `shipping_method` int(2) NOT NULL DEFAULT '0',
  `position` int(10) unsigned NOT NULL default '0',
  `max_width` int(10) DEFAULT 0,
  `max_height` int(10)  DEFAULT 0,
  `max_depth` int(10)  DEFAULT 0,
  `max_weight` int(10)  DEFAULT 0,
  `grade` int(10)  DEFAULT 0,
  PRIMARY KEY (`id_carrier`),
  KEY `deleted` (`deleted`,`active`),
  KEY `id_tax_rules_group` (`id_tax_rules_group`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_carrier_lang` (
  `id_carrier` int(10) unsigned NOT NULL,
  `id_shop` int(11) unsigned NOT NULL DEFAULT '1',
  `id_lang` int(10) unsigned NOT NULL,
  `delay` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`id_lang`,`id_shop`, `id_carrier`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_carrier_zone` (
  `id_carrier` int(10) unsigned NOT NULL,
  `id_zone` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_carrier`,`id_zone`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart` (
  `id_cart` int(10) unsigned NOT NULL auto_increment,
  `id_shop_group` INT(11) UNSIGNED NOT NULL DEFAULT '1',
  `id_shop` INT(11) UNSIGNED NOT NULL DEFAULT '1',
  `id_carrier` int(10) unsigned NOT NULL,
  `delivery_option` varchar(100),
  `id_lang` int(10) unsigned NOT NULL,
  `id_address_delivery` int(10) unsigned NOT NULL,
  `id_address_invoice` int(10) unsigned NOT NULL,
  `id_currency` int(10) unsigned NOT NULL,
  `id_customer` int(10) unsigned NOT NULL,
  `id_guest` int(10) unsigned NOT NULL,
  `secure_key` varchar(32) NOT NULL default '-1',
  `recyclable` tinyint(1) unsigned NOT NULL default '1',
  `gift` tinyint(1) unsigned NOT NULL default '0',
  `gift_message` text,
  `allow_seperated_package` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_cart`),
  KEY `cart_customer` (`id_customer`),
  KEY `id_address_delivery` (`id_address_delivery`),
  KEY `id_address_invoice` (`id_address_invoice`),
  KEY `id_carrier` (`id_carrier`),
  KEY `id_lang` (`id_lang`),
  KEY `id_currency` (`id_currency`),
  KEY `id_guest` (`id_guest`),
  KEY `id_shop_group` (`id_shop_group`),
  KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule` (
	`id_cart_rule` int(10) unsigned NOT NULL auto_increment,
	`id_customer` int unsigned NOT NULL default 0,
	`date_from` datetime NOT NULL,
	`date_to` datetime NOT NULL,
	`description` text,
	`quantity` int(10) unsigned NOT NULL default 0,
	`quantity_per_user` int(10) unsigned NOT NULL default 0,
	`priority` int(10) unsigned NOT NULL default 1,
	`partial_use` tinyint(1) unsigned NOT NULL default 0,
	`code` varchar(254) NOT NULL,
	`minimum_amount` decimal(17,2) NOT NULL default 0,
	`minimum_amount_tax` tinyint(1) NOT NULL default 0,
	`minimum_amount_currency` int unsigned NOT NULL default 0,
	`minimum_amount_shipping` tinyint(1) NOT NULL default 0,
	`country_restriction` tinyint(1) unsigned NOT NULL default 0,
	`carrier_restriction` tinyint(1) unsigned NOT NULL default 0,
	`group_restriction` tinyint(1) unsigned NOT NULL default 0,
	`cart_rule_restriction` tinyint(1) unsigned NOT NULL default 0,
	`product_restriction` tinyint(1) unsigned NOT NULL default 0,
	`shop_restriction` tinyint(1) unsigned NOT NULL default 0,
	`free_shipping` tinyint(1) NOT NULL default 0,
	`reduction_percent` decimal(5,2) NOT NULL default 0,
	`reduction_amount` decimal(17,2) NOT NULL default 0,
	`reduction_tax` tinyint(1) unsigned NOT NULL default 0,
	`reduction_currency` int(10) unsigned NOT NULL default 0,
	`reduction_product` int(10) NOT NULL default 0,
	`gift_product` int(10) unsigned NOT NULL default 0,
	`gift_product_attribute` int(10) unsigned NOT NULL default 0,
	`active` tinyint(1) unsigned NOT NULL default 0,
	`date_add` datetime NOT NULL,
	`date_upd` datetime NOT NULL,
	PRIMARY KEY (`id_cart_rule`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_lang` (
	`id_cart_rule` int(10) unsigned NOT NULL,
	`id_lang` int(10) unsigned NOT NULL,
	`name` varchar(254) NOT NULL,
	PRIMARY KEY (`id_cart_rule`, `id_lang`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_country` (
	`id_cart_rule` int(10) unsigned NOT NULL,
	`id_country` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id_cart_rule`, `id_country`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_group` (
	`id_cart_rule` int(10) unsigned NOT NULL,
	`id_group` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id_cart_rule`, `id_group`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_carrier` (
	`id_cart_rule` int(10) unsigned NOT NULL,
	`id_carrier` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id_cart_rule`, `id_carrier`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_combination` (
	`id_cart_rule_1` int(10) unsigned NOT NULL,
	`id_cart_rule_2` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id_cart_rule_1`, `id_cart_rule_2`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_product_rule_group` (
	`id_product_rule_group` int(10) unsigned NOT NULL auto_increment,
	`id_cart_rule` int(10) unsigned NOT NULL,
	`quantity` int(10) unsigned NOT NULL default 1,
	PRIMARY KEY (`id_product_rule_group`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_product_rule` (
	`id_product_rule` int(10) unsigned NOT NULL auto_increment,
	`id_product_rule_group` int(10) unsigned NOT NULL,
	`type` ENUM('products', 'categories', 'attributes', 'manufacturers', 'suppliers') NOT NULL,
	PRIMARY KEY (`id_product_rule`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_product_rule_value` (
	`id_product_rule` int(10) unsigned NOT NULL,
	`id_item` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id_product_rule`, `id_item`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_cart_rule` (
  `id_cart` int(10) unsigned NOT NULL,
  `id_cart_rule` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_cart`,`id_cart_rule`),
  KEY (`id_cart_rule`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_rule_shop` (
	`id_cart_rule` int(10) unsigned NOT NULL,
	`id_shop` int(10) unsigned NOT NULL,
	PRIMARY KEY (`id_cart_rule`, `id_shop`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cart_product` (
  `id_cart` int(10) unsigned NOT NULL,
  `id_product` int(10) unsigned NOT NULL,
  `id_address_delivery` int(10) UNSIGNED DEFAULT 0,
  `id_shop` int(10) unsigned NOT NULL DEFAULT '1',
  `id_product_attribute` int(10) unsigned default NULL,
  `quantity` int(10) unsigned NOT NULL default '0',
  `date_add` datetime NOT NULL,
  KEY `cart_product_index` (`id_cart`,`id_product`),
  KEY `id_product_attribute` (`id_product_attribute`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_category` (
  `id_category` int(10) unsigned NOT NULL auto_increment,
  `id_parent` int(10) unsigned NOT NULL,
  `id_shop_default` int(10) unsigned NOT NULL default 1,
  `level_depth` tinyint(3) unsigned NOT NULL default '0',
  `nleft` int(10) unsigned NOT NULL default '0',
  `nright` int(10) unsigned NOT NULL default '0',
  `active` tinyint(1) unsigned NOT NULL default '0',
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  `position` int(10) unsigned NOT NULL default '0',
  `is_root_category` tinyint(1) NOT NULL default '0',
  PRIMARY KEY (`id_category`),
  KEY `category_parent` (`id_parent`),
  KEY `nleftright` (`nleft`, `nright`),
  KEY `nleftrightactive` (`nleft`, `nright`, `active`),
  KEY `level_depth` (`level_depth`),
  KEY `nright` (`nright`),
  KEY `nleft` (`nleft`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_category_group` (
  `id_category` int(10) unsigned NOT NULL,
  `id_group` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_category`,`id_group`),
  KEY `id_category` (`id_category`),
  KEY `id_group` (`id_group`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_tax_lang` (
  `id_tax` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  PRIMARY KEY (`id_tax`,`id_lang`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_timezone` (
	id_timezone int(10) unsigned NOT NULL auto_increment,
	name VARCHAR(32) NOT NULL,
	PRIMARY KEY (`id_timezone`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_web_browser` (
  `id_web_browser` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(64) default NULL,
  PRIMARY KEY (`id_web_browser`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_zone` (
  `id_zone` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(64) NOT NULL,
  `active` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_zone`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_carrier_group` (
  `id_carrier` int(10) unsigned NOT NULL,
  `id_group` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id_carrier`,`id_group`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_store` (
  `id_store` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_country` int(10) unsigned NOT NULL,
  `id_state` int(10) unsigned DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `address1` varchar(128) NOT NULL,
  `address2` varchar(128) DEFAULT NULL,
  `city` varchar(64) NOT NULL,
  `postcode` varchar(12) NOT NULL,
  `latitude` decimal(11,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `hours` varchar(254) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `fax` varchar(16) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `note` text,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_store`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_webservice_account` (
  `id_webservice_account` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(32) NOT NULL,
  `description` text NULL,
  `class_name` VARCHAR( 50 ) NOT NULL DEFAULT 'WebserviceRequest',
  `is_module` TINYINT( 2 ) NOT NULL DEFAULT '0',
  `module_name` VARCHAR( 50 ) NULL DEFAULT NULL,
  `active` tinyint(2) NOT NULL,
  PRIMARY KEY (`id_webservice_account`),
  KEY `key` (`key`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_webservice_permission` (
  `id_webservice_permission` int(11) NOT NULL AUTO_INCREMENT,
  `resource` varchar(50) NOT NULL,
  `method` enum('GET','POST','PUT','DELETE','HEAD') NOT NULL,
  `id_webservice_account` int(11) NOT NULL,
  PRIMARY KEY (`id_webservice_permission`),
  UNIQUE KEY `resource_2` (`resource`,`method`,`id_webservice_account`),
  KEY `resource` (`resource`),
  KEY `method` (`method`),
  KEY `id_webservice_account` (`id_webservice_account`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_required_field` (
  `id_required_field` int(11) NOT NULL AUTO_INCREMENT,
  `object_name` varchar(32) NOT NULL,
  `field_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id_required_field`),
  KEY `object_name` (`object_name`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_memcached_servers` (
`id_memcached_server` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`ip` VARCHAR( 254 ) NOT NULL ,
`port` INT(11) UNSIGNED NOT NULL ,
`weight` INT(11) UNSIGNED NOT NULL
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_product_country_tax` (
  `id_product` int(11) NOT NULL,
  `id_country` int(11) NOT NULL,
  `id_tax` int(11) NOT NULL,
  PRIMARY KEY (`id_product`,`id_country`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_tax_rule` (
  `id_tax_rule` int(11) NOT NULL AUTO_INCREMENT,
  `id_tax_rules_group` int(11) NOT NULL,
  `id_country` int(11) NOT NULL,
  `id_state` int(11) NOT NULL,
  `zipcode_from` VARCHAR(12) NOT NULL,
  `zipcode_to` VARCHAR(12) NOT NULL,
  `id_tax` int(11) NOT NULL,
  `behavior` int(11) NOT NULL,
  `description` VARCHAR( 100 ) NOT NULL,
  PRIMARY KEY (`id_tax_rule`),
  KEY `id_tax_rules_group` (`id_tax_rules_group`),
  KEY `id_tax` (`id_tax`),
  KEY `category_getproducts` ( `id_tax_rules_group` , `id_country` , `id_state` , `zipcode_from` )
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_tax_rules_group` (
`id_tax_rules_group` INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`name` VARCHAR( 50 ) NOT NULL ,
`active` INT NOT NULL
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_help_access` (
  `id_help_access` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(45) NOT NULL,
  `version` varchar(8) NOT NULL,
  PRIMARY KEY (`id_help_access`),
  UNIQUE KEY `label` (`label`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_specific_price_priority` (
	`id_specific_price_priority` INT NOT NULL AUTO_INCREMENT ,
	`id_product` INT NOT NULL ,
	`priority` VARCHAR( 80 ) NOT NULL ,
	PRIMARY KEY ( `id_specific_price_priority` , `id_product` ),
	UNIQUE KEY `id_product` (`id_product`)
)  ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_log` (
	`id_log` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`severity` tinyint(1) NOT NULL,
	`error_code` int(11) DEFAULT NULL,
	`message` text NOT NULL,
	`object_type` varchar(32) DEFAULT NULL,
	`object_id` int(10) unsigned DEFAULT NULL,
	`date_add` datetime NOT NULL,
	`date_upd` datetime NOT NULL,
	PRIMARY KEY (`id_log`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_import_match` (
  `id_import_match` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `match` text NOT NULL,
  `skip` int(2) NOT NULL,
  PRIMARY KEY (`id_import_match`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_shop_group` (
  `id_shop_group` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 NOT NULL,
  `share_customer` TINYINT(1) NOT NULL,
  `share_order` TINYINT(1) NOT NULL,
  `share_stock` TINYINT(1) NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_shop_group`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_shop` (
  `id_shop` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_shop_group` int(11) unsigned NOT NULL,
  `name` varchar(64) CHARACTER SET utf8 NOT NULL,
  `id_category` INT(11) UNSIGNED NOT NULL DEFAULT '1',
  `id_theme` INT(1) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_shop`),
  KEY `id_shop_group` (`id_shop_group`),
  KEY `id_category` (`id_category`),
  KEY `id_theme` (`id_theme`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_shop_url` (
  `id_shop_url` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_shop` int(11) unsigned NOT NULL,
  `domain` varchar(150) NOT NULL,
  `domain_ssl` varchar(150) NOT NULL,
  `physical_uri` varchar(64) NOT NULL,
  `virtual_uri` varchar(64) NOT NULL,
  `main` TINYINT(1) NOT NULL,
  `active` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id_shop_url`),
  KEY `id_shop` (`id_shop`),
  UNIQUE KEY `full_shop_url` (`domain`, `physical_uri`, `virtual_uri`),
  UNIQUE KEY `full_shop_url_ssl` (`domain_ssl`, `physical_uri`, `virtual_uri`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_theme` (
  `id_theme` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `directory` varchar(64) NOT NULL,
  PRIMARY KEY (`id_theme`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_theme_specific` (
  `id_theme` int(11) unsigned NOT NULL,
	`id_shop` INT(11) UNSIGNED NOT NULL,
  `entity` int(11) unsigned NOT NULL,
  `id_object` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id_theme`,`id_shop`, `entity`,`id_object`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_country_shop` (
`id_country` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_country`, `id_shop`),
  KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_carrier_shop` (
`id_carrier` INT( 11 ) UNSIGNED NOT NULL ,
`id_shop` INT( 11 ) UNSIGNED NOT NULL ,
PRIMARY KEY (`id_carrier`, `id_shop`),
  KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_address_format` (
  `id_country` int(10) unsigned NOT NULL,
  `format` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id_country`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cms_shop` (
`id_cms` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL ,
  PRIMARY KEY (`id_cms`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_lang_shop` (
`id_lang` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_lang`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_currency_shop` (
`id_currency` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_currency`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_contact_shop` (
	`id_contact` INT(11) UNSIGNED NOT NULL,
	`id_shop` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`id_contact`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_image_shop` (
	`id_image` INT( 11 ) UNSIGNED NOT NULL,
	`id_shop` INT( 11 ) UNSIGNED NOT NULL,
	`cover` tinyint(1) NOT NULL,
	KEY (`id_image`, `id_shop`, `cover`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attribute_shop` (
`id_attribute` INT(11) UNSIGNED NOT NULL,
`id_shop` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (`id_attribute`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_feature_shop` (
`id_feature` INT(11) UNSIGNED NOT NULL,
`id_shop` INT(11) UNSIGNED NOT NULL ,
	PRIMARY KEY (`id_feature`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_group_shop` (
`id_group` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
	PRIMARY KEY (`id_group`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_attribute_group_shop` (
`id_attribute_group` INT( 11 ) UNSIGNED NOT NULL ,
`id_shop` INT( 11 ) UNSIGNED NOT NULL ,
	PRIMARY KEY (`id_attribute_group`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_tax_rules_group_shop` (
	`id_tax_rules_group` INT( 11 ) UNSIGNED NOT NULL,
	`id_shop` INT( 11 ) UNSIGNED NOT NULL,
	PRIMARY KEY (`id_tax_rules_group`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_zone_shop` (
`id_zone` INT( 11 ) UNSIGNED NOT NULL ,
`id_shop` INT( 11 ) UNSIGNED NOT NULL ,
	PRIMARY KEY (`id_zone`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_manufacturer_shop` (
`id_manufacturer` INT( 11 ) UNSIGNED NOT NULL ,
`id_shop` INT( 11 ) UNSIGNED NOT NULL ,
	PRIMARY KEY (`id_manufacturer`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_supplier_shop` (
`id_supplier` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
PRIMARY KEY (`id_supplier`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_store_shop` (
`id_store` INT( 11 ) UNSIGNED NOT NULL ,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
PRIMARY KEY (`id_store`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_module_shop` (
`id_module` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
PRIMARY KEY (`id_module` , `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_webservice_account_shop` (
`id_webservice_account` INT( 11 ) UNSIGNED NOT NULL,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
PRIMARY KEY (`id_webservice_account` , `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_scene_shop` (
`id_scene` INT( 11 ) UNSIGNED NOT NULL ,
`id_shop` INT( 11 ) UNSIGNED NOT NULL,
PRIMARY KEY (`id_scene`, `id_shop`),
	KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_stock_mvt` (
  `id_stock_mvt` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_stock` INT(11) UNSIGNED NOT NULL,
  `id_order` INT(11) UNSIGNED DEFAULT NULL,
  `id_supply_order` INT(11) UNSIGNED DEFAULT NULL,
  `id_stock_mvt_reason` INT(11) UNSIGNED NOT NULL,
  `id_employee` INT(11) UNSIGNED NOT NULL,
  `employee_lastname` varchar(32) DEFAULT '',
  `employee_firstname` varchar(32) DEFAULT '',
  `physical_quantity` INT(11) UNSIGNED NOT NULL,
  `date_add` DATETIME NOT NULL,
  `sign` tinyint(1) NOT NULL DEFAULT 1,
  `price_te` DECIMAL(20,6) DEFAULT '0.000000',
  `last_wa` DECIMAL(20,6) DEFAULT '0.000000',
  `current_wa` DECIMAL(20,6) DEFAULT '0.000000',
  `referer` bigint UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id_stock_mvt`),
  KEY `id_stock` (`id_stock`),
  KEY `id_stock_mvt_reason` (`id_stock_mvt_reason`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_stock_mvt_reason` (
  `id_stock_mvt_reason` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `sign` tinyint(1) NOT NULL DEFAULT 1,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  `deleted` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_stock_mvt_reason`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_stock_mvt_reason_lang` (
  `id_stock_mvt_reason` INT(11) UNSIGNED NOT NULL,
  `id_lang` INT(11) UNSIGNED NOT NULL,
  `name` VARCHAR(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id_stock_mvt_reason`,`id_lang`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_stock` (
`id_stock` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`id_warehouse` INT(11) UNSIGNED NOT NULL,
`id_product` INT(11) UNSIGNED NOT NULL,
`id_product_attribute` INT(11) UNSIGNED NOT NULL,
`reference`  VARCHAR(32) NOT NULL,
`ean13`  VARCHAR(13) DEFAULT NULL,
`upc`  VARCHAR(12) DEFAULT NULL,
`physical_quantity` INT(11) UNSIGNED NOT NULL,
`usable_quantity` INT(11) UNSIGNED NOT NULL,
`price_te` DECIMAL(20,6) DEFAULT '0.000000',
  PRIMARY KEY (`id_stock`),
  KEY `id_warehouse` (`id_warehouse`),
  KEY `id_product` (`id_product`),
  KEY `id_product_attribute` (`id_product_attribute`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_warehouse` (
`id_warehouse` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`id_currency` INT(11) UNSIGNED NOT NULL,
`id_address` INT(11) UNSIGNED NOT NULL,
`id_employee` INT(11) UNSIGNED NOT NULL,
`reference` VARCHAR(32) DEFAULT NULL,
`name` VARCHAR(45) NOT NULL,
`management_type` ENUM('WA', 'FIFO', 'LIFO') NOT NULL DEFAULT 'WA',
`deleted` tinyint(1) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_warehouse`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_warehouse_product_location` (
  `id_warehouse_product_location` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_product` int(11) unsigned NOT NULL,
  `id_product_attribute` int(11) unsigned NOT NULL,
  `id_warehouse` int(11) unsigned NOT NULL,
  `location` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id_warehouse_product_location`),
  UNIQUE KEY `id_product` (`id_product`,`id_product_attribute`,`id_warehouse`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_warehouse_shop` (
`id_shop` INT(11) UNSIGNED NOT NULL,
`id_warehouse` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_warehouse`, `id_shop`),
  KEY `id_warehouse` (`id_warehouse`),
  KEY `id_shop` (`id_shop`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_warehouse_carrier` (
`id_carrier` INT(11) UNSIGNED NOT NULL,
`id_warehouse` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`id_warehouse`, `id_carrier`),
  KEY `id_warehouse` (`id_warehouse`),
  KEY `id_carrier` (`id_carrier`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_stock_available` (
`id_stock_available` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`id_product` INT(11) UNSIGNED NOT NULL,
`id_product_attribute` INT(11) UNSIGNED NOT NULL,
`id_shop` INT(11) UNSIGNED NOT NULL,
`id_shop_group` INT(11) UNSIGNED NOT NULL,
`quantity` INT(10) NOT NULL DEFAULT '0',
`depends_on_stock` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
`out_of_stock` TINYINT(1) UNSIGNED NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_stock_available`),
  KEY `id_shop` (`id_shop`),
  KEY `id_shop_group` (`id_shop_group`),
  KEY `id_product` (`id_product`),
  KEY `id_product_attribute` (`id_product_attribute`),
  UNIQUE `product_sqlstock` ( `id_product` , `id_product_attribute` , `id_shop` )
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_supply_order` (
`id_supply_order` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`id_supplier` INT(11) UNSIGNED NOT NULL,
`supplier_name` VARCHAR(64) NOT NULL,
`id_lang` INT(11) UNSIGNED NOT NULL,
`id_warehouse` INT(11) UNSIGNED NOT NULL,
`id_supply_order_state` INT(11) UNSIGNED NOT NULL,
`id_currency` INT(11) UNSIGNED NOT NULL,
`id_ref_currency` INT(11) UNSIGNED NOT NULL,
`reference` VARCHAR(64) NOT NULL,
`date_add` DATETIME NOT NULL,
`date_upd` DATETIME NOT NULL,
`date_delivery_expected` DATETIME DEFAULT NULL,
`total_te` DECIMAL(20,6) DEFAULT '0.000000',
`total_with_discount_te` DECIMAL(20,6) DEFAULT '0.000000',
`total_tax` DECIMAL(20,6) DEFAULT '0.000000',
`total_ti` DECIMAL(20,6) DEFAULT '0.000000',
`discount_rate` DECIMAL(20,6) DEFAULT '0.000000',
`discount_value_te` DECIMAL(20,6) DEFAULT '0.000000',
`is_template` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id_supply_order`),
  KEY `id_supplier` (`id_supplier`),
  KEY `id_warehouse` (`id_warehouse`),
  KEY `reference` (`reference`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_supply_order_detail` (
`id_supply_order_detail` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`id_supply_order` INT(11) UNSIGNED NOT NULL,
`id_currency` INT(11) UNSIGNED NOT NULL,
`id_product` INT(11) UNSIGNED NOT NULL,
`id_product_attribute` INT(11) UNSIGNED NOT NULL,
`reference`  VARCHAR(32) NOT NULL,
`supplier_reference`  VARCHAR(32) NOT NULL,
`name`  varchar(128) NOT NULL,
`ean13`  VARCHAR(13) DEFAULT NULL,
`upc`  VARCHAR(12) DEFAULT NULL,
`exchange_rate` DECIMAL(20,6) DEFAULT '0.000000',
`unit_price_te` DECIMAL(20,6) DEFAULT '0.000000',
`quantity_expected` INT(11) UNSIGNED NOT NULL,
`quantity_received` INT(11) UNSIGNED NOT NULL,
`price_te` DECIMAL(20,6) DEFAULT '0.000000',
`discount_rate` DECIMAL(20,6) DEFAULT '0.000000',
`discount_value_te` DECIMAL(20,6) DEFAULT '0.000000',
`price_with_discount_te` DECIMAL(20,6) DEFAULT '0.000000',
`tax_rate` DECIMAL(20,6) DEFAULT '0.000000',
`tax_value` DECIMAL(20,6) DEFAULT '0.000000',
`price_ti` DECIMAL(20,6) DEFAULT '0.000000',
`tax_value_with_order_discount` DECIMAL(20,6) DEFAULT '0.000000',
`price_with_order_discount_te` DECIMAL(20,6) DEFAULT '0.000000',
  PRIMARY KEY (`id_supply_order_detail`),
  KEY `id_supply_order` (`id_supply_order`),
  KEY `id_product` (`id_product`),
  KEY `id_product_attribute` (`id_product_attribute`),
  KEY `id_product_product_attribute` (`id_product`, `id_product_attribute`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_supply_order_history` (
`id_supply_order_history` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`id_supply_order` INT(11) UNSIGNED NOT NULL,
`id_employee` INT(11) UNSIGNED NOT NULL,
`employee_lastname` varchar(32) DEFAULT '',
`employee_firstname` varchar(32) DEFAULT '',
`id_state` INT(11) UNSIGNED NOT NULL,
`date_add` DATETIME NOT NULL,
  PRIMARY KEY (`id_supply_order_history`),
  KEY `id_supply_order` (`id_supply_order`),
  KEY `id_employee` (`id_employee`),
  KEY `id_state` (`id_state`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_supply_order_state` (
`id_supply_order_state` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`delivery_note` tinyint(1) NOT NULL DEFAULT 0,
`editable` tinyint(1) NOT NULL DEFAULT 0,
`receipt_state` tinyint(1) NOT NULL DEFAULT 0,
`pending_receipt` tinyint(1) NOT NULL DEFAULT 0,
`enclosed` tinyint(1) NOT NULL DEFAULT 0,
`color` VARCHAR(32) DEFAULT NULL,
  PRIMARY KEY (`id_supply_order_state`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_supply_order_state_lang` (
`id_supply_order_state` INT(11) UNSIGNED NOT NULL,
`id_lang` INT(11) UNSIGNED NOT NULL,
`name` VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY (`id_supply_order_state`, `id_lang`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_supply_order_receipt_history` (
`id_supply_order_receipt_history` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`id_supply_order_detail` INT(11) UNSIGNED NOT NULL,
`id_employee` INT(11) UNSIGNED NOT NULL,
`employee_lastname` varchar(32) DEFAULT '',
`employee_firstname` varchar(32) DEFAULT '',
`id_supply_order_state` INT(11) UNSIGNED NOT NULL,
`quantity` INT(11) UNSIGNED NOT NULL,
`date_add` DATETIME NOT NULL,
  PRIMARY KEY (`id_supply_order_receipt_history`),
  KEY `id_supply_order_detail` (`id_supply_order_detail`),
  KEY `id_supply_order_state` (`id_supply_order_state`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_product_supplier` (
  `id_product_supplier` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_product` int(11) UNSIGNED NOT NULL,
  `id_product_attribute` int(11) UNSIGNED NOT NULL DEFAULT '0',
  `id_supplier` int(11) UNSIGNED NOT NULL,
  `product_supplier_reference` varchar(32) DEFAULT NULL,
  `product_supplier_price_te` decimal(20,6) NOT NULL DEFAULT '0.000000',
  `id_currency` int(11) unsigned NOT NULL,
  PRIMARY KEY (`id_product_supplier`),
  UNIQUE KEY `id_product` (`id_product`,`id_product_attribute`,`id_supplier`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_order_carrier` (
  `id_order_carrier` int(11) NOT NULL AUTO_INCREMENT,
  `id_order` int(11) unsigned NOT NULL,
  `id_carrier` int(11) unsigned NOT NULL,
  `id_order_invoice` int(11) unsigned DEFAULT NULL,
  `weight` DECIMAL(20,6) DEFAULT NULL,
  `shipping_cost_tax_excl` decimal(20,6) DEFAULT NULL,
  `shipping_cost_tax_incl` decimal(20,6) DEFAULT NULL,
  `tracking_number` varchar(64) DEFAULT NULL,
  `date_add` datetime NOT NULL,
  PRIMARY KEY (`id_order_carrier`),
  KEY `id_order` (`id_order`),
  KEY `id_carrier` (`id_carrier`),
  KEY `id_order_invoice` (`id_order_invoice`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_specific_price_rule` (
	`id_specific_price_rule` int(10) unsigned NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`id_shop` int(11) unsigned NOT NULL DEFAULT '1',
	`id_currency` int(10) unsigned NOT NULL,
	`id_country` int(10) unsigned NOT NULL,
	`id_group` int(10) unsigned NOT NULL,
	`from_quantity` mediumint(8) unsigned NOT NULL,
	`price` DECIMAL(20,6),
	`reduction` decimal(20,6) NOT NULL,
	`reduction_type` enum('amount','percentage') NOT NULL,
	`from` datetime NOT NULL,
	`to` datetime NOT NULL,
	PRIMARY KEY (`id_specific_price_rule`),
	KEY `id_product` (`id_shop`,`id_currency`,`id_country`,`id_group`,`from_quantity`,`from`,`to`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_specific_price_rule_condition_group` (
	`id_specific_price_rule_condition_group` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`id_specific_price_rule` INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY ( `id_specific_price_rule_condition_group`, `id_specific_price_rule` )
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_specific_price_rule_condition` (
	`id_specific_price_rule_condition` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	`id_specific_price_rule_condition_group` INT(11) UNSIGNED NOT NULL,
	`type` VARCHAR(255) NOT NULL,
	`value` VARCHAR(255) NOT NULL,
PRIMARY KEY (`id_specific_price_rule_condition`),
INDEX (`id_specific_price_rule_condition_group`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_risk` (
  `id_risk` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `percent` tinyint(3) NOT NULL,
  `color` varchar(32) NULL,
  PRIMARY KEY (`id_risk`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE IF NOT EXISTS `PREFIX_risk_lang` (
  `id_risk` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(20) NOT NULL,
  PRIMARY KEY (`id_risk`,`id_lang`),
  KEY `id_risk` (`id_risk`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_category_shop` (
  `id_category` int(11) NOT NULL,
  `id_shop` int(11) NOT NULL,
  `position` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_category`, `id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_module_preference` (
  `id_module_preference` int(11) NOT NULL auto_increment,
  `id_employee` int(11) NOT NULL,
  `module` varchar(255) NOT NULL,
  `interest` tinyint(1) default NULL,
  `favorite` tinyint(1) default NULL,
  PRIMARY KEY (`id_module_preference`),
  UNIQUE KEY `employee_module` (`id_employee`, `module`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_carrier_tax_rules_group_shop` (
	`id_carrier` int( 11 ) unsigned NOT NULL,
	`id_tax_rules_group` int(11) unsigned NOT NULL,
	`id_shop` int(11) unsigned NOT NULL,
	PRIMARY KEY (`id_carrier`, `id_tax_rules_group`, `id_shop`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_order_invoice_payment` (
	`id_order_invoice` int(11) unsigned NOT NULL,
	`id_order_payment` int(11) unsigned NOT NULL,
	`id_order` int(11) unsigned NOT NULL,
	PRIMARY KEY (`id_order_invoice`,`id_order_payment`),
	KEY `order_payment` (`id_order_payment`),
	KEY `id_order` (`id_order`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

SET NAMES 'utf8'

UPDATE `PREFIX_configuration` SET value = '1' WHERE name = 'PS_CONDITIONS'

UPDATE `PREFIX_configuration` SET value = '10' WHERE name = 'PS_PRODUCTS_PER_PAGE'

UPDATE `PREFIX_configuration` SET value = '0' WHERE name = 'PS_PRODUCTS_ORDER_WAY'

UPDATE `PREFIX_configuration` SET value = '4' WHERE name = 'PS_PRODUCTS_ORDER_BY'

UPDATE `PREFIX_configuration` SET value = '1' WHERE name = 'PS_DISPLAY_QTIES'

UPDATE `PREFIX_configuration` SET value = '20' WHERE name = 'PS_NB_DAYS_NEW_PRODUCT'

UPDATE `PREFIX_configuration` SET value = '1' WHERE name = 'PS_BLOCK_CART_AJAX'

UPDATE `PREFIX_configuration` SET value = '8388608' WHERE name = 'PS_PRODUCT_PICTURE_MAX_SIZE'

UPDATE `PREFIX_configuration` SET value = '64' WHERE name = 'PS_PRODUCT_PICTURE_WIDTH'

UPDATE `PREFIX_configuration` SET value = '64' WHERE name = 'PS_PRODUCT_PICTURE_HEIGHT'

UPDATE `PREFIX_configuration` SET value = '3' WHERE name = 'PS_SEARCH_MINWORDLEN'

UPDATE `PREFIX_configuration` SET value = '6' WHERE name = 'PS_SEARCH_WEIGHT_PNAME'

UPDATE `PREFIX_hook_module` SET position = 1
WHERE
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayPayment') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'cheque')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayPaymentReturn') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'cheque')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayHome') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'homeslider')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionAuthentication') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'statsdata')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionShopDataDuplication') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'homeslider')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayTop') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'blocklanguages')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionCustomerAccountAdd') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'statsdata')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayCustomerAccount') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'favoriteproducts')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayAdminStatsModules') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'statsvisits')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayAdminStatsGraphEngine') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'graphvisifire')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayAdminStatsGridEngine') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'gridhtml')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayLeftColumnProduct') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'blocksharefb')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionSearch') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'statssearch')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionCategoryAdd') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'blockcategories')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionCategoryUpdate') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'blockcategories')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionCategoryDelete') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'blockcategories')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'actionAdminMetaSave') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'blockcategories')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayMyAccountBlock') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'favoriteproducts')
	OR
	id_hook = (SELECT id_hook FROM `PREFIX_hook` WHERE name = 'displayFooter') AND id_module = (SELECT id_module FROM `PREFIX_module` WHERE name = 'blockreinsurance')

ALTER TABLE `PREFIX_employee` ADD `bo_color` varchar(32) default NULL AFTER `stats_date_to`

ALTER TABLE `PREFIX_employee` ADD `bo_theme` varchar(32) default NULL AFTER `bo_color`

ALTER TABLE `PREFIX_employee` ADD `bo_uimode` ENUM('hover','click') default 'click' AFTER `bo_theme`

ALTER TABLE `PREFIX_employee` ADD `id_lang` int(10) unsigned NOT NULL default 0 AFTER `id_profile`

ALTER TABLE `PREFIX_cms` ADD `id_cms_category` int(10) unsigned NOT NULL default '0' AFTER `id_cms`

ALTER TABLE `PREFIX_cms` ADD `position` int(10) unsigned NOT NULL default '0' AFTER `id_cms_category`

CREATE TABLE `PREFIX_cms_category` (
  `id_cms_category` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_parent` int(10) unsigned NOT NULL,
  `level_depth` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  `position` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY (`id_cms_category`),
  KEY `category_parent` (`id_parent`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_cms_category_lang` (
  `id_cms_category` int(10) unsigned NOT NULL,
  `id_lang` int(10) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `description` text,
  `link_rewrite` varchar(128) NOT NULL,
  `meta_title` varchar(128) DEFAULT NULL,
  `meta_keywords` varchar(255) DEFAULT NULL,
  `meta_description` varchar(255) DEFAULT NULL,
  UNIQUE KEY `category_lang_index` (`id_cms_category`,`id_lang`),
  KEY `category_name` (`name`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

INSERT INTO `PREFIX_cms_category_lang` VALUES(1, 1, 'Home', '', 'home', NULL, NULL, NULL)

INSERT INTO `PREFIX_cms_category_lang` VALUES(1, 2, 'Accueil', '', 'home', NULL, NULL, NULL)

INSERT INTO `PREFIX_cms_category_lang` VALUES(1, 3, 'Inicio', '', 'home', NULL, NULL, NULL)

INSERT INTO `PREFIX_cms_category` VALUES(1, 0, 0, 1, NOW(), NOW(),0)

UPDATE `PREFIX_cms_category` SET `position` = 0

UPDATE `PREFIX_cms` SET `position` = 0

UPDATE `PREFIX_cms` SET `id_cms_category` = 0

ALTER TABLE `PREFIX_category` ADD `position` int(10) unsigned NOT NULL default '0' AFTER `date_upd`

UPDATE `PREFIX_employee` SET `id_lang` = (SELECT `value` FROM `PREFIX_configuration` WHERE `name` = "PS_LANG_DEFAULT")

ALTER TABLE `PREFIX_customer` ADD `note` text AFTER `secure_key`

ALTER TABLE `PREFIX_contact` ADD `customer_service` tinyint(1) NOT NULL DEFAULT 0 AFTER `email`

CREATE TABLE `PREFIX_customer_thread` (
  `id_customer_thread` int(11) unsigned NOT NULL auto_increment,
  `id_lang` int(10) unsigned NOT NULL,
  `id_contact` int(10) unsigned NOT NULL,
  `id_customer` int(10) unsigned default NULL,
  `id_order` int(10) unsigned default NULL,
  `id_product` int(10) unsigned default NULL,
  `status` enum('open','closed','pending1','pending2') NOT NULL default 'open',
  `email` varchar(128) NOT NULL,
  `token` varchar(12) default NULL,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_customer_thread`),
  KEY `id_customer_thread` (`id_customer_thread`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_customer_message` (
  `id_customer_message` int(10) unsigned NOT NULL auto_increment,
  `id_customer_thread` int(11) default NULL,
  `id_employee` int(10) unsigned default NULL,
  `message` text NOT NULL,
  `file_name` varchar(18) DEFAULT NULL,
  `ip_address` int(11) default NULL,
  `user_agent` varchar(128) default NULL,
  `date_add` datetime NOT NULL,
  PRIMARY KEY  (`id_customer_message`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_payment_cc` (
	`id_payment_cc` INT NOT NULL auto_increment,
	`id_order` INT UNSIGNED NULL,
	`id_currency` INT UNSIGNED NOT NULL,
	`amount` DECIMAL(10,2) NOT NULL,
	`transaction_id` VARCHAR(254) NULL,
	`card_number` VARCHAR(254) NULL,
	`card_brand` VARCHAR(254) NULL,
	`card_expiration` CHAR(7) NULL,
	`card_holder` VARCHAR(254) NULL,
	`date_add` DATETIME NOT NULL,
	PRIMARY KEY (`id_payment_cc`),
	KEY `id_order` (`id_order`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_specific_price` (
	`id_specific_price` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`id_product` INT UNSIGNED NOT NULL,
	`id_shop` TINYINT UNSIGNED NOT NULL,
	`id_currency` INT UNSIGNED NOT NULL,
	`id_country` INT UNSIGNED NOT NULL,
	`id_group` INT UNSIGNED NOT NULL,
	`priority` SMALLINT UNSIGNED NOT NULL,
	`price` DECIMAL(20, 6) NOT NULL,
	`from_quantity` SMALLINT UNSIGNED NOT NULL,
	`reduction` DECIMAL(20, 6) NOT NULL,
	`reduction_type` ENUM('amount', 'percentage') NOT NULL,
	`from` DATETIME NOT NULL,
	`to` DATETIME NOT NULL,
	PRIMARY KEY(`id_specific_price`),
	KEY (`id_product`, `id_shop`, `id_currency`, `id_country`, `id_group`, `from_quantity`, `from`, `to`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

INSERT INTO `PREFIX_specific_price` (`id_product`, `id_shop`, `id_currency`, `id_country`, `id_group`, `priority`, `price`, `from_quantity`, `reduction`, `reduction_type`, `from`, `to`)
	(	SELECT dq.`id_product`, 1, 1, 0, 1, 0, 0.00, dq.`quantity`, IF(dq.`id_discount_type` = 2, dq.`value`, dq.`value` / 100), IF (dq.`id_discount_type` = 2, 'amount', 'percentage'), '0000-00-00 00:00:00', '0000-00-00 00:00:00'
		FROM `PREFIX_discount_quantity` dq
		INNER JOIN `PREFIX_product` p ON (p.`id_product` = dq.`id_product`)
	)

DROP TABLE `PREFIX_discount_quantity`

INSERT INTO `PREFIX_specific_price` (`id_product`, `id_shop`, `id_currency`, `id_country`, `id_group`, `priority`, `price`, `from_quantity`, `reduction`, `reduction_type`, `from`, `to`) (
	SELECT
		p.`id_product`,
		1,
		0,
		0,
		0,
		0,
		0.00,
		1,
		IF(p.`reduction_price` > 0, p.`reduction_price`, p.`reduction_percent` / 100),
		IF(p.`reduction_price` > 0, 'amount', 'percentage'),
		IF (p.`reduction_from` = p.`reduction_to`, '0000-00-00 00:00:00', p.`reduction_from`),
		IF (p.`reduction_from` = p.`reduction_to`, '0000-00-00 00:00:00', p.`reduction_to`)
	FROM `PREFIX_product` p
	WHERE p.`reduction_price` OR p.`reduction_percent`
)

ALTER TABLE `PREFIX_product`
	DROP `reduction_price`,
	DROP `reduction_percent`,
	DROP `reduction_from`,
	DROP `reduction_to`

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES
('PS_SPECIFIC_PRICE_PRIORITIES', 'id_shop;id_currency;id_country;id_group', NOW(), NOW()),
('PS_TAX_DISPLAY', 0, NOW(), NOW()),
('PS_SMARTY_FORCE_COMPILE', 1, NOW(), NOW()),
('PS_DISTANCE_UNIT', 'km', NOW(), NOW()),
('PS_STORES_DISPLAY_CMS', 0, NOW(), NOW()),
('PS_STORES_DISPLAY_FOOTER', 0, NOW(), NOW()),
('PS_STORES_SIMPLIFIED', 0, NOW(), NOW()),
('PS_STATSDATA_CUSTOMER_PAGESVIEWS', 1, NOW(), NOW()),
('PS_STATSDATA_PAGESVIEWS', 1, NOW(), NOW()),
('PS_STATSDATA_PLUGINS', 1, NOW(), NOW())

CREATE TABLE `PREFIX_group_reduction` (
	`id_group_reduction` MEDIUMINT UNSIGNED NOT NULL AUTO_INCREMENT,
	`id_group` INT(10) UNSIGNED NOT NULL,
	`id_category` INT(10) UNSIGNED NOT NULL,
	`reduction` DECIMAL(4, 3) NOT NULL,
	PRIMARY KEY(`id_group_reduction`),
	UNIQUE KEY(`id_group`, `id_category`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_product_group_reduction_cache` (
	`id_product` INT UNSIGNED NOT NULL,
	`id_group` INT UNSIGNED NOT NULL,
	`reduction` DECIMAL(4, 3) NOT NULL,
	PRIMARY KEY(`id_product`, `id_group`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

ALTER TABLE `PREFIX_currency` ADD `iso_code_num` varchar(3) NOT NULL default '0' AFTER `iso_code`

UPDATE `PREFIX_currency` SET iso_code_num = '978' WHERE iso_code = 'EUR' LIMIT 1

UPDATE `PREFIX_currency` SET iso_code_num = '840' WHERE iso_code = 'USD' LIMIT 1

UPDATE `PREFIX_currency` SET iso_code_num = '826' WHERE iso_code = 'GBP' LIMIT 1

ALTER TABLE `PREFIX_country` ADD `call_prefix` int(10) NOT NULL default '0' AFTER `iso_code`

UPDATE `PREFIX_country` SET `call_prefix` = 49 WHERE `iso_code` = 'DE' LIMIT 1

UPDATE `PREFIX_country` SET `call_prefix` = 43 WHERE `iso_code` = 'AT' LIMIT 1

UPDATE `PREFIX_country` SET `call_prefix` = 32 WHERE `iso_code` = 'BE' LIMIT 1

UPDATE `PREFIX_country` SET `call_prefix` = 1 WHERE `iso_code` = 'CA' LIMIT 1

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES ('PS_CONDITIONS_CMS_ID', IFNULL((SELECT `id_cms` FROM `PREFIX_cms` WHERE `id_cms` = 3), 0), NOW(), NOW())

CREATE TEMPORARY TABLE `PREFIX_configuration_tmp` (
	`value` text
)

INSERT INTO `PREFIX_configuration_tmp` (SELECT value FROM (SELECT `value` FROM `PREFIX_configuration` WHERE `name` = 'PREFIX_CONDITIONS_CMS_ID') AS tmp)

UPDATE `PREFIX_configuration` SET `value` = IF((SELECT value FROM PREFIX_configuration_tmp), 1, 0) WHERE `name` = 'PREFIX_CONDITIONS'

DROP TABLE PREFIX_configuration_tmp

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES ('PS_CIPHER_ALGORITHM', 0, NOW(), NOW())

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES ('PS_ORDER_PROCESS_TYPE', 0, NOW(), NOW())

ALTER TABLE `PREFIX_product` ADD `minimal_quantity` INT NOT NULL DEFAULT '1' AFTER `quantity`

ALTER TABLE `PREFIX_product` ADD `cache_default_attribute` int(10) unsigned default NULL AFTER `indexed`

ALTER TABLE `PREFIX_product` ADD `cache_has_attachments` TINYINT(1) NOT NULL default '0' AFTER `indexed`

ALTER TABLE `PREFIX_product` ADD `cache_is_pack` TINYINT(1) NOT NULL default '0' AFTER `indexed`

ALTER TABLE `PREFIX_product` ADD `available_for_order` TINYINT(1) NOT NULL DEFAULT '1' AFTER  `active`

ALTER TABLE `PREFIX_product` ADD `show_price` TINYINT(1) NOT NULL DEFAULT '1' AFTER `available_for_order`

ALTER TABLE `PREFIX_product` ADD `online_only` TINYINT(1) NOT NULL DEFAULT '0' AFTER `on_sale`

ALTER TABLE `PREFIX_product` ADD `condition` ENUM('new', 'used', 'refurbished') NOT NULL DEFAULT 'new' AFTER `available_for_order`

ALTER TABLE `PREFIX_product` ADD `upc` VARCHAR( 12 ) NULL AFTER `ean13`

ALTER TABLE `PREFIX_product_attribute` ADD `upc` VARCHAR( 12 ) NULL AFTER `ean13`

SET @defaultOOS = (SELECT value FROM `PREFIX_configuration` WHERE name = 'PS_ORDER_OUT_OF_STOCK')

UPDATE `PREFIX_product` p SET `cache_default_attribute` =  0 WHERE `id_product` NOT IN (SELECT `id_product` FROM `PREFIX_product_attribute`)

UPDATE `PREFIX_product` p SET `cache_default_attribute` = (SELECT `id_product_attribute` FROM `PREFIX_product_attribute` WHERE `id_product` = p.`id_product` AND default_on = 1 AND quantity > 0 LIMIT 1) WHERE `cache_default_attribute` IS NULL

UPDATE `PREFIX_product` p SET `cache_default_attribute` = (SELECT `id_product_attribute` FROM `PREFIX_product_attribute` WHERE `id_product` = p.`id_product` AND default_on = 1 LIMIT 1) WHERE `cache_default_attribute` IS NULL AND `out_of_stock` = 1 OR `out_of_stock` = IF(@defaultOOS = 1, 2, 1)

UPDATE `PREFIX_product` p SET `cache_default_attribute` = (SELECT `id_product_attribute` FROM `PREFIX_product_attribute` WHERE `id_product` = p.`id_product` AND quantity > 0 LIMIT 1) WHERE `cache_default_attribute` IS NULL

UPDATE `PREFIX_product` p SET `cache_default_attribute` = (SELECT `id_product_attribute` FROM `PREFIX_product_attribute` WHERE `id_product` = p.`id_product` AND default_on = 1 LIMIT 1) WHERE `cache_default_attribute` IS NULL

UPDATE `PREFIX_product` p SET
cache_is_pack = (SELECT IF(COUNT(*) > 0, 1, 0) FROM `PREFIX_pack` pp WHERE pp.`id_product_pack` = p.`id_product`),
cache_has_attachments = (SELECT IF(COUNT(*) > 0, 1, 0) FROM `PREFIX_product_attachment` pa WHERE pa.`id_product` = p.`id_product`)

INSERT INTO `PREFIX_hook` (`name`, `title`, `description`, `position`) VALUES ('deleteProductAttribute', 'Product Attribute Deletion', NULL, 0)

INSERT INTO `PREFIX_hook` (`name` ,`title` ,`description` ,`position`) VALUES ('beforeCarrier', 'Before carrier list', 'This hook is display before the carrier list on Front office', 1)

INSERT INTO `PREFIX_hook` (`name`, `title`, `description`, `position`) VALUES ('orderDetailDisplayed', 'Order detail displayed', 'Displayed on order detail on front office', 1)

INSERT INTO `PREFIX_hook_module` (`id_module`, `id_hook`, `position`) VALUES
((SELECT IFNULL((SELECT `id_module` FROM `PREFIX_module` WHERE `name` = 'mailalerts'), 0)),
(SELECT `id_hook` FROM `PREFIX_hook` WHERE `name` = 'deleteProductAttribute'), 1)

DELETE FROM `PREFIX_hook_module` WHERE `id_module` = 0

ALTER TABLE `PREFIX_country` ADD `need_zip_code` TINYINT(1) NOT NULL DEFAULT '1'

ALTER TABLE `PREFIX_country` ADD `zip_code_format` VARCHAR(12) NOT NULL DEFAULT ''

ALTER TABLE `PREFIX_product` ADD `unit_price` DECIMAL(20,6) NOT NULL DEFAULT '0.000000' AFTER `wholesale_price`

ALTER TABLE `PREFIX_product` ADD `unity` VARCHAR(10) NOT NULL DEFAULT '0.000000' AFTER `unit_price`

ALTER TABLE `PREFIX_product_attribute` ADD `unit_price_impact` DECIMAL(17,2) NOT NULL DEFAULT '0.00' AFTER `weight`

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES ('PS_VOLUME_UNIT', 'cl', NOW(), NOW())

ALTER TABLE `PREFIX_carrier` ADD `shipping_external` TINYINT( 1 ) UNSIGNED NOT NULL

ALTER TABLE `PREFIX_carrier` ADD `external_module_name` varchar(64) DEFAULT NULL

ALTER TABLE `PREFIX_carrier` ADD `need_range` TINYINT( 1 ) UNSIGNED NOT NULL

INSERT INTO `PREFIX_hook` (`name`, `title`, `description`, `position`) VALUES ('processCarrier', 'Carrier Process', NULL, 0)

INSERT INTO `PREFIX_hook` (`name`, `title`, `description`, `position`) VALUES ('orderDetail', 'Order Detail', 'To set the follow-up in smarty when order detail is called', 0)

INSERT INTO `PREFIX_hook` (`name`, `title`, `description`, `position`) VALUES ('paymentCCAdded', 'Payment CC added', 'Payment CC added', '0')

INSERT INTO `PREFIX_hook` (`name`, `title`, `description`, `position`) VALUES ('extraProductComparison', 'Extra Product Comparison', 'Extra Product Comparison', '0')

ALTER TABLE `PREFIX_address` ADD `vat_number` varchar(32) NULL DEFAULT NULL AFTER `phone_mobile`

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES ('PS_TAX_ADDRESS_TYPE', 'id_address_delivery', NOW(), NOW())

ALTER TABLE `PREFIX_product` ADD `additional_shipping_cost` DECIMAL(20,2) NOT NULL DEFAULT '0.000000' AFTER `unit_price`

ALTER TABLE `PREFIX_currency` ADD `active` TINYINT(1) NOT NULL DEFAULT '1'

ALTER TABLE `PREFIX_tax` ADD `active` TINYINT(1) NOT NULL DEFAULT '1'

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES ('PS_ATTRIBUTE_CATEGORY_DISPLAY', 1, NOW(), NOW())

ALTER TABLE `PREFIX_discount` ADD `cart_display` TINYINT( 4 ) NOT NULL AFTER `active` , ADD `date_add` DATETIME NOT NULL AFTER `cart_display` , ADD `date_upd` DATETIME NOT NULL AFTER `date_add`

ALTER TABLE `PREFIX_carrier` ADD `shipping_method` INT( 2 ) NOT NULL DEFAULT '0'

CREATE TABLE `PREFIX_stock_mvt` (
  `id_stock_mvt` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `id_product` int(11) unsigned DEFAULT NULL,
  `id_product_attribute` int(11) unsigned DEFAULT NULL,
  `id_order` int(11) unsigned DEFAULT NULL,
  `id_stock_mvt_reason` int(11) unsigned NOT NULL,
  `id_employee` int(11) unsigned NOT NULL,
  `quantity` int(11) NOT NULL,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_stock_mvt`),
  KEY `id_order` (`id_order`),
  KEY `id_product` (`id_product`),
  KEY `id_product_attribute` (`id_product_attribute`),
  KEY `id_stock_mvt_reason` (`id_stock_mvt_reason`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_stock_mvt_reason` (
  `id_stock_mvt_reason` int(11) NOT NULL AUTO_INCREMENT,
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_stock_mvt_reason`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

ALTER TABLE `PREFIX_product` CHANGE `quantity` `quantity` INT( 10 ) NOT NULL DEFAULT '0'

ALTER TABLE `PREFIX_product_attribute` CHANGE `quantity` `quantity` INT( 10 ) NOT NULL DEFAULT '0'

CREATE TABLE `PREFIX_stock_mvt_reason_lang` (
  `id_stock_mvt_reason` int(11) NOT NULL,
  `id_lang` int(11) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id_stock_mvt_reason`,`id_lang`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

INSERT INTO `PREFIX_stock_mvt_reason` (`id_stock_mvt_reason`, `date_add`, `date_upd`) VALUES
(1, NOW(), NOW()), (2, NOW(), NOW()), (3, NOW(), NOW())

INSERT INTO `PREFIX_stock_mvt_reason_lang` (`id_stock_mvt_reason`, `id_lang`, `name`) VALUES
(1, 1, 'Order'),
(1, 2, 'Commande'),
(2, 1, 'Missing Stock Movement'),
(2, 2, 'Mouvement de stock manquant'),
(3, 1, 'Restocking'),
(3, 2, 'RÃ©assort')

INSERT INTO `PREFIX_configuration` (`name`, `value`, `date_add`, `date_upd`) VALUES ('PS_COMPARATOR_MAX_ITEM', 0, NOW(), NOW())

ALTER TABLE `PREFIX_meta_lang` ADD `url_rewrite` VARCHAR( 255 ) NOT NULL , ADD INDEX ( `url_rewrite` )

INSERT INTO `PREFIX_meta` (`page`) VALUES ('address')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'address'), 'Address', 'address'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'address'), 'Adresse', 'adresse'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'address'), 'DirecciÃ³n', 'direccion')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('addresses')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'addresses'), 'Addresses', 'addresses'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'addresses'), 'Adresses', 'adresses'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'addresses'), 'Direcciones', 'direcciones')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('authentication')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'authentication'), 'Authentication', 'authentication'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'authentication'), 'Authentification', 'authentification'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'authentication'), 'AutenticaciÃ³n', 'autenticacion')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('cart')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'cart'), 'Cart', 'cart'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'cart'), 'Panier', 'panier'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'cart'), 'Carro de la compra', 'carro-de-la-compra')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('discount')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'discount'), 'Discount', 'discount'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'discount'), 'Bons de rÃ©duction', 'bons-de-reduction'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'discount'), 'Descuento', 'descuento')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('history')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'history'), 'Order history', 'order-history'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'history'), 'Historique des commandes', 'historique-des-commandes'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'history'), 'Historial de pedidos', 'historial-de-pedidos')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('identity')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'identity'), 'Identity', 'identity'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'identity'), 'IdentitÃ©', 'identite'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'identity'), 'Identidad', 'identidad')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('my-account')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'my-account'), 'My account', 'my-account'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'my-account'), 'Mon compte', 'mon-compte'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'my-account'), 'Mi Cuenta', 'mi-cuenta')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('order-follow')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order-follow'), 'Order follow', 'order-follow'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order-follow'), 'DÃ©tails de la commande', 'details-de-la-commande'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order-follow'), 'DevoluciÃ³n de productos', 'devolucion-de-productos')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('order-slip')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order-slip'), 'Order slip', 'order-slip'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order-slip'), 'Avoirs', 'avoirs'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order-slip'), 'Vales', 'vales')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('order')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order'), 'Order', 'order'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order'), 'Commande', 'commande'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'order'), 'Carrito', 'carrito')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('search')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'search' LIMIT 1), 'Search', 'search'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'search' LIMIT 1), 'Recherche', 'recherche'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'search' LIMIT 1), 'Buscar', 'buscar')

INSERT INTO `PREFIX_meta` (`page`) VALUES ('stores')

INSERT INTO `PREFIX_meta_lang` (`id_lang`, `id_meta`, `title`, `url_rewrite`) VALUES
(1, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'stores'), 'Stores', 'stores'),
(2, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'stores'), 'Magagins', 'magasins'),
(3, (SELECT `id_meta` FROM `PREFIX_meta` WHERE `page` = 'stores'), 'Tiendas', 'tiendas')

ALTER TABLE `PREFIX_manufacturer` ADD `active` tinyint(1) NOT NULL default 0

ALTER TABLE `PREFIX_supplier` ADD `active` tinyint(1) NOT NULL default 0

UPDATE `PREFIX_manufacturer` SET `active` = 1

UPDATE `PREFIX_supplier` SET `active` = 1

ALTER TABLE `PREFIX_cms` ADD `active` tinyint(1) unsigned NOT NULL default 0

UPDATE `PREFIX_cms` SET `active` = 1

ALTER TABLE `PREFIX_cart` ADD `secure_key` varchar(32) NOT NULL default '-1' AFTER `id_guest`

ALTER TABLE `PREFIX_order_detail` ADD `product_upc` varchar(12) default NULL AFTER `product_ean13`

ALTER TABLE `PREFIX_discount` ADD `id_group` int(10) unsigned NOT NULL default 0

CREATE TABLE `PREFIX_store` (
  `id_store` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `id_country` int(10) unsigned NOT NULL,
  `id_state` int(10) unsigned DEFAULT NULL,
  `name` varchar(128) NOT NULL,
  `address1` varchar(128) NOT NULL,
  `address2` varchar(128) DEFAULT NULL,
  `city` varchar(64) NOT NULL,
  `postcode` varchar(12) NOT NULL,
  `latitude` float(10,6) DEFAULT NULL,
  `longitude` float(10,6) DEFAULT NULL,
  `hours` varchar(254) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `fax` varchar(16) DEFAULT NULL,
  `email` varchar(128) DEFAULT NULL,
  `note` text,
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `date_add` datetime NOT NULL,
  `date_upd` datetime NOT NULL,
  PRIMARY KEY (`id_store`)
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

INSERT INTO `PREFIX_hook` (`name`, `title`, `description`, `position`) VALUES
('categoryAddition', '', 'Temporary hook. Must NEVER be used. Will soon be replaced by a generic CRUD hook system.', 0),
('categoryUpdate', '', 'Temporary hook. Must NEVER be used. Will soon be replaced by a generic CRUD hook system.', 0),
('categoryDeletion', '', 'Temporary hook. Must NEVER be used. Will soon be replaced by a generic CRUD hook system.', 0)

DELETE FROM `PREFIX_hook_module` WHERE `id_module` = 0

CREATE TABLE `PREFIX_required_field` (
  `id_required_field` int(11) NOT NULL AUTO_INCREMENT,
  `object_name` varchar(32) NOT NULL,
  `field_name` varchar(32) NOT NULL,
  PRIMARY KEY (`id_required_field`),
  KEY `object_name` (`object_name`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_memcached_servers` (
`id_memcached_server` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY ,
`ip` VARCHAR( 254 ) NOT NULL ,
`port` INT(11) UNSIGNED NOT NULL ,
`weight` INT(11) UNSIGNED NOT NULL
) ENGINE=ENGINE_TYPE DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_webservice_account` (
  `id_webservice_account` int(11) NOT NULL AUTO_INCREMENT,
  `key` varchar(32) NOT NULL,
  `active` tinyint(2) NOT NULL,
  PRIMARY KEY (`id_webservice_account`),
  KEY `key` (`key`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

CREATE TABLE `PREFIX_webservice_permission` (
  `id_webservice_permission` int(11) NOT NULL AUTO_INCREMENT,
  `resource` varchar(50) NOT NULL,
  `method` enum('GET','POST','PUT','DELETE') NOT NULL,
  `id_webservice_account` int(11) NOT NULL,
  PRIMARY KEY (`id_webservice_permission`),
  UNIQUE KEY `resource_2` (`resource`,`method`,`id_webservice_account`),
  KEY `resource` (`resource`),
  KEY `method` (`method`),
  KEY `id_webservice_account` (`id_webservice_account`)
) ENGINE=ENGINE_TYPE  DEFAULT CHARSET=utf8

DROP TABLE IF EXISTS `admin_assert`

CREATE TABLE `admin_assert` (
  `assert_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Assert ID',
  `assert_type` varchar(20) NOT NULL COMMENT 'Assert Type',
  `assert_data` text COMMENT 'Assert Data',
  PRIMARY KEY (`assert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Admin Assert Table'

LOCK TABLES `admin_assert` WRITE

UNLOCK TABLES

DROP TABLE IF EXISTS `admin_role`

CREATE TABLE `admin_role` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Role ID',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Parent Role ID',
  `tree_level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Role Tree Level',
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Role Sort Order',
  `role_type` varchar(1) NOT NULL DEFAULT '0' COMMENT 'Role Type',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'User ID',
  `role_name` varchar(50) NOT NULL COMMENT 'Role Name',
  PRIMARY KEY (`role_id`),
  KEY `IDX_ADMIN_ROLE_PARENT_ID_SORT_ORDER` (`parent_id`,`sort_order`),
  KEY `IDX_ADMIN_ROLE_TREE_LEVEL` (`tree_level`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='Admin Role Table'

LOCK TABLES `admin_role` WRITE

insert  into `admin_role`(`role_id`,`parent_id`,`tree_level`,`sort_order`,`role_type`,`user_id`,`role_name`) values (1,0,1,1,'G',0,'Administrators'),(4,1,2,0,'U',1,'Store')

DROP TABLE IF EXISTS `admin_rule`

CREATE TABLE `admin_rule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Rule ID',
  `role_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Role ID',
  `resource_id` varchar(255) NOT NULL COMMENT 'Resource ID',
  `privileges` varchar(20) DEFAULT NULL COMMENT 'Privileges',
  `assert_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Assert ID',
  `role_type` varchar(1) DEFAULT NULL COMMENT 'Role Type',
  `permission` varchar(10) DEFAULT NULL COMMENT 'Permission',
  PRIMARY KEY (`rule_id`),
  KEY `IDX_ADMIN_RULE_RESOURCE_ID_ROLE_ID` (`resource_id`,`role_id`),
  KEY `IDX_ADMIN_RULE_ROLE_ID_RESOURCE_ID` (`role_id`,`resource_id`),
  CONSTRAINT `FK_ADMIN_RULE_ROLE_ID_ADMIN_ROLE_ROLE_ID` FOREIGN KEY (`role_id`) REFERENCES `admin_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Admin Rule Table'

LOCK TABLES `admin_rule` WRITE

insert  into `admin_rule`(`rule_id`,`role_id`,`resource_id`,`privileges`,`assert_id`,`role_type`,`permission`) values (1,1,'all','',0,'G','allow')

UNLOCK TABLES

DROP TABLE IF EXISTS `admin_user`

CREATE TABLE `admin_user` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'User ID',
  `firstname` varchar(32) DEFAULT NULL COMMENT 'User First Name',
  `lastname` varchar(32) DEFAULT NULL COMMENT 'User Last Name',
  `email` varchar(128) DEFAULT NULL COMMENT 'User Email',
  `username` varchar(40) DEFAULT NULL COMMENT 'User Login',
  `password` varchar(100) DEFAULT NULL COMMENT 'User Password',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'User Created Time',
  `modified` timestamp NULL DEFAULT NULL COMMENT 'User Modified Time',
  `logdate` timestamp NULL DEFAULT NULL COMMENT 'User Last Login Time',
  `lognum` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'User Login Number',
  `reload_acl_flag` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Reload ACL',
  `is_active` smallint(6) NOT NULL DEFAULT '1' COMMENT 'User Is Active',
  `extra` text COMMENT 'User Extra Data',
  `rp_token` text COMMENT 'Reset Password Link Token',
  `rp_token_created_at` timestamp NULL DEFAULT NULL COMMENT 'Reset Password Link Token Creation Date',
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `UNQ_ADMIN_USER_USERNAME` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Admin User Table'

LOCK TABLES `admin_user` WRITE

insert  into `admin_user`(`user_id`,`firstname`,`lastname`,`email`,`username`,`password`,`created`,`modified`,`logdate`,`lognum`,`reload_acl_flag`,`is_active`,`extra`,`rp_token`,`rp_token_created_at`) values (1,'Store','Owner','owner@example.com','admin','e53f3a2b9372babb593ed61c119c5ee1:El','2011-10-24 16:25:38','2011-10-24 13:25:06','2011-10-24 13:25:38',3,0,1,'N;',NULL,NULL)

UNLOCK TABLES

DROP TABLE IF EXISTS `adminnotification_inbox`

CREATE TABLE `adminnotification_inbox` (
  `notification_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Notification id',
  `severity` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Problem type',
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Create date',
  `title` varchar(255) NOT NULL COMMENT 'Title',
  `description` text COMMENT 'Description',
  `url` varchar(255) DEFAULT NULL COMMENT 'Url',
  `is_read` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Flag if notification read',
  `is_remove` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Flag if notification might be removed',
  PRIMARY KEY (`notification_id`),
  KEY `IDX_ADMINNOTIFICATION_INBOX_SEVERITY` (`severity`),
  KEY `IDX_ADMINNOTIFICATION_INBOX_IS_READ` (`is_read`),
  KEY `IDX_ADMINNOTIFICATION_INBOX_IS_REMOVE` (`is_remove`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8 COMMENT='Adminnotification Inbox'

LOCK TABLES `adminnotification_inbox` WRITE

insert  into `adminnotification_inbox`(`notification_id`,`severity`,`date_added`,`title`,`description`,`url`,`is_read`,`is_remove`) values (1,4,'2008-07-25 05:24:40','Magento 1.1 Production Version Now Available','We are thrilled to announce the availability of the production release of Magento 1.1. Read more about the release in the Magento Blog.','http://www.magentocommerce.com/blog/comments/magento-11-is-here-1/',0,0),(2,4,'2008-08-02 05:30:16','Updated iPhone Theme is now available','Updated iPhone theme for Magento 1.1 is now available on Magento Connect and for upgrade through your Magento Connect Manager.','http://www.magentocommerce.com/blog/comments/updated-iphone-theme-for-magento-11-is-now-available/',0,0),(3,3,'2008-08-02 05:40:27','Magento version 1.1.2 is now available','Magento version 1.1.2 is now available for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-version-112-is-now-available/',0,0),(4,3,'2008-08-13 21:51:46','Magento version 1.1.3 is now available','Magento version 1.1.3 is now available','http://www.magentocommerce.com/blog/comments/magento-version-113-is-now-available/',0,0),(5,1,'2008-09-03 01:10:31','Magento Version 1.1.4 Security Update Now Available','Magento 1.1.4 Security Update Now Available. If you are using Magento version 1.1.x, we highly recommend upgrading to this version as soon as possible.','http://www.magentocommerce.com/blog/comments/magento-version-114-security-update/',0,0),(6,3,'2008-09-16 02:09:54','Magento version 1.1.5 Now Available','Magento version 1.1.5 Now Available.\n\nThis release includes many bug fixes, a new category manager and a new skin for the default Magento theme.','http://www.magentocommerce.com/blog/comments/magento-version-115-now-available/',0,0),(7,3,'2008-09-18 00:18:35','Magento version 1.1.6 Now Available','Magento version 1.1.6 Now Available.\n\nThis version includes bug fixes for Magento 1.1.x that are listed in the release notes section.','http://www.magentocommerce.com/blog/comments/magento-version-116-now-available/',0,0),(8,4,'2008-11-08 04:46:42','Reminder: Change Magento`s default phone numbers and callouts before site launch','Before launching your Magento store, please remember to change Magento`s default phone numbers that appear in email templates, callouts, templates, etc.','',0,0),(9,3,'2008-11-20 06:31:12','Magento version 1.1.7 Now Available','Magento version 1.1.7 Now Available.\n\nThis version includes over 350 issue resolutions for Magento 1.1.x that are listed in the release notes section, and new functionality that includes:\n\n-Google Website Optimizer integration\n-Google Base integration\n-Scheduled DB logs cleaning option','http://www.magentocommerce.com/blog/comments/magento-version-117-now-available/',0,0),(10,3,'2008-11-27 02:24:50','Magento Version 1.1.8 Now Available','Magento version 1.1.8 now available.\n\nThis version includes some issue resolutions for Magento 1.1.x that are listed in the release notes section.','http://www.magentocommerce.com/blog/comments/magento-version-118-now-available/',0,0),(11,3,'2008-12-30 12:45:59','Magento version 1.2.0 is now available for download and upgrade','We are extremely happy to announce the availability of Magento version 1.2.0 for download and upgrade.\n\nThis version includes numerous issue resolutions for Magento version 1.1.x and some highly requested new features such as:\n\n    * Support for Downloadable/Digital Products. \n    * Added Layered Navigation to site search result page.\n    * Improved site search to utilize MySQL fulltext search\n    * Added support for fixed-taxes on product level.\n    * Upgraded Zend Framework to the latest stable version 1.7.2','http://www.magentocommerce.com/blog/comments/magento-version-120-is-now-available/',0,0),(12,2,'2008-12-31 02:59:22','Magento version 1.2.0.1 now available','Magento version 1.2.0.1 now available.This version includes some issue resolutions for Magento 1.2.x that are listed in the release notes section.','http://www.magentocommerce.com/blog/comments/magento-version-1201-available/',0,0),(13,2,'2009-01-13 01:41:49','Magento version 1.2.0.2 now available','Magento version 1.2.0.2 is now available for download and upgrade. This version includes an issue resolutions for Magento version 1.2.0.x as listed in the release notes.','http://www.magentocommerce.com/blog/comments/magento-version-1202-now-available/',0,0),(14,3,'2009-01-24 05:25:56','Magento version 1.2.0.3 now available','Magento version 1.2.0.3 is now available for download and upgrade. This version includes issue resolutions for Magento version 1.2.0.x as listed in the release notes.','http://www.magentocommerce.com/blog/comments/magento-version-1203-now-available/',0,0),(15,3,'2009-02-03 02:57:00','Magento version 1.2.1 is now available for download and upgrade','We are happy to announce the availability of Magento version 1.2.1 for download and upgrade.\n\nThis version includes some issue resolutions for Magento version 1.2.x. A full list of items included in this release can be found on the release notes page.','http://www.magentocommerce.com/blog/comments/magento-version-121-now-available/',0,0),(16,3,'2009-02-24 05:45:47','Magento version 1.2.1.1 now available','Magento version 1.2.1.1 now available.This version includes some issue resolutions for Magento 1.2.x that are listed in the release notes section.','http://www.magentocommerce.com/blog/comments/magento-version-1211-now-available/',0,0),(17,3,'2009-02-27 06:39:24','CSRF Attack Prevention','We have just posted a blog entry about a hypothetical CSRF attack on a Magento admin panel. Please read the post to find out if your Magento installation is at risk at http://www.magentocommerce.com/blog/comments/csrf-vulnerabilities-in-web-application-and-how-to-avoid-them-in-magento/','http://www.magentocommerce.com/blog/comments/csrf-vulnerabilities-in-web-application-and-how-to-avoid-them-in-magento/',0,0),(18,2,'2009-03-04 04:03:58','Magento version 1.2.1.2 now available','Magento version 1.2.1.2 is now available for download and upgrade.\nThis version includes some updates to improve admin security as described in the release notes page.','http://www.magentocommerce.com/blog/comments/magento-version-1212-now-available/',0,0),(19,3,'2009-03-31 06:22:40','Magento version 1.3.0 now available','Magento version 1.3.0 is now available for download and upgrade. This version includes numerous issue resolutions for Magento version 1.2.x and new features as described on the release notes page.','http://www.magentocommerce.com/blog/comments/magento-version-130-is-now-available/',0,0),(20,3,'2009-04-18 08:06:02','Magento version 1.3.1 now available','Magento version 1.3.1 is now available for download and upgrade. This version includes some issue resolutions for Magento version 1.3.x and new features such as Checkout By Amazon and Amazon Flexible Payment. To see a full list of updates please check the release notes page.','http://www.magentocommerce.com/blog/comments/magento-version-131-now-available/',0,0),(21,3,'2009-05-20 02:31:21','Magento version 1.3.1.1 now available','Magento version 1.3.1.1 is now available for download and upgrade. This version includes some issue resolutions for Magento version 1.3.x and a security update for Magento installations that run on multiple domains or sub-domains. If you are running Magento with multiple domains or sub-domains we highly recommend upgrading to this version.','http://www.magentocommerce.com/blog/comments/magento-version-1311-now-available/',0,0),(22,3,'2009-05-30 02:54:06','Magento version 1.3.2 now available','This version includes some improvements and issue resolutions for version 1.3.x that are listed on the release notes page. also included is a Beta version of the Compile module.','http://www.magentocommerce.com/blog/comments/magento-version-132-now-available/',0,0),(23,3,'2009-06-01 23:32:52','Magento version 1.3.2.1 now available','Magento version 1.3.2.1 now available for download and upgrade.\n\nThis release solves an issue for users running Magento with PHP 5.2.0, and changes to index.php to support the new Compiler Module.','http://www.magentocommerce.com/blog/comments/magento-version-1321-now-available/',0,0),(24,3,'2009-07-02 05:21:44','Magento version 1.3.2.2 now available','Magento version 1.3.2.2 is now available for download and upgrade.\n\nThis release includes issue resolution for Magento version 1.3.x. To see a full list of changes please visit the release notes page http://www.magentocommerce.com/download/release_notes.','http://www.magentocommerce.com/blog/comments/magento-version-1322-now-available/',0,0),(25,3,'2009-07-23 10:48:54','Magento version 1.3.2.3 now available','Magento version 1.3.2.3 is now available for download and upgrade.\n\nThis release includes issue resolution for Magento version 1.3.x. We recommend to upgrade to this version if PayPal payment modules are in use. To see a full list of changes please visit the release notes page http://www.magentocommerce.com/download/release_notes.','http://www.magentocommerce.com/blog/comments/magento-version-1323-now-available/',0,0),(26,4,'2009-08-28 22:26:28','PayPal is updating Payflow Pro and Website Payments Pro (Payflow Edition) UK.','If you are using Payflow Pro and/or Website Payments Pro (Payflow Edition) UK.  payment methods, you will need to update the URLâ€˜s in your Magento Administrator Panel in order to process transactions after September 1, 2009. Full details are available here: http://www.magentocommerce.com/wiki/paypal_payflow_changes','http://www.magentocommerce.com/wiki/paypal_payflow_changes',0,0),(27,2,'2009-09-24 00:16:49','Magento Version 1.3.2.4 Security Update','Magento Version 1.3.2.4 is now available. This version includes a security updates for Magento 1.3.x that solves possible XSS vulnerability issue on customer registration page and is available through SVN, Download Page and through the Magento Connect Manager.','http://www.magentocommerce.com/blog/comments/magento-version-1324-security-update/',0,0),(28,4,'2009-09-25 18:57:54','Magento Preview Version 1.4.0.0-alpha2 is now available','We are happy to announce the availability of Magento Preview Version 1.4.0.0-alpha2 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-1400-alpha2-now-available/',0,0),(29,4,'2009-10-07 04:55:40','Magento Preview Version 1.4.0.0-alpha3 is now available','We are happy to announce the availability of Magento Preview Version 1.4.0.0-alpha3 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-1400-alpha3-now-available/',0,0),(30,4,'2009-12-09 04:30:36','Magento Preview Version 1.4.0.0-beta1 is now available','We are happy to announce the availability of Magento Preview Version 1.4.0.0-beta1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-1400-beta1-now-available/',0,0),(31,4,'2009-12-31 14:22:12','Magento Preview Version 1.4.0.0-rc1 is now available','We are happy to announce the availability of Magento Preview Version 1.4.0.0-rc1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-1400-rc1-now-available/',0,0),(32,4,'2010-02-13 08:39:53','Magento CE Version 1.4.0.0 Stable is now available','We are excited to announce the availability of Magento CE Version 1.4.0.0 Stable for upgrade and download.','http://bit.ly/c53rpK',0,0),(33,3,'2010-02-20 07:39:36','Magento CE Version 1.4.0.1 Stable is now available','Magento CE 1.4.0.1 Stable is now available for upgrade and download.','http://www.magentocommerce.com/blog/comments/magento-ce-version-1401-stable-now-available/',0,0),(34,4,'2010-04-24 00:09:03','Magento Version CE 1.3.3.0 Stable - Now Available With Support for 3-D Secure','Based on community requests, we are excited to announce the release of Magento CE 1.3.3.0-Stable with support for 3-D Secure. This release is intended for Magento merchants using version 1.3.x, who want to add support for 3-D Secure.','http://www.magentocommerce.com/blog/comments/magento-version-ce-1330-stable-now-available-with-support-for-3-d-secure/',0,0),(35,4,'2010-05-31 21:20:21','Announcing the Launch of Magento Mobile','The Magento team is pleased to announce the launch of Magento mobile, a new product that will allow Magento merchants to easily create branded, native mobile storefront applications that are deeply integrated with Magentoâ€™s market-leading eCommerce platform. The product includes a new administrative manager, a native iPhone app that is fully customizable, and a service where Magento manages the submission and maintenance process for the iTunes App Store.\n\nLearn more by visiting the Magento mobile product page and sign-up to be the first to launch a native mobile commerce app, fully integrated with Magento.','http://www.magentocommerce.com/product/mobile',0,0),(36,4,'2010-06-11 00:08:08','Magento CE Version 1.4.1.0 Stable is now available','We are excited to announce the availability of Magento CE Version 1.4.1.0 Stable for upgrade and download. Some of the highlights of this release include: Enhanced PayPal integration (more info to follow), Change of Database structure of the Sales module to no longer use EAV, and much more.','http://www.magentocommerce.com/blog/comments/magento-ce-version-1410-stable-now-available/',0,0),(37,4,'2010-07-27 01:37:34','Magento CE Version 1.4.1.1 Stable is now available','We are excited to announce the availability of Magento CE Version 1.4.1.1 Stable for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-ce-version-1411-stable-now-available/',0,0),(38,4,'2010-07-28 09:12:12','Magento CE Version 1.4.2.0-beta1 Preview Release Now Available','This release gives a preview of the new Magento Connect Manager.','http://www.magentocommerce.com/blog/comments/magento-preview-version-1420-beta1-now-available/',0,0),(39,4,'2010-07-29 00:15:01','Magento CE Version 1.4.1.1 Patch Available','As some users experienced issues with upgrading to CE 1.4.1.1 through PEAR channels we provided a patch for it that is available on our blog http://www.magentocommerce.com/blog/comments/magento-ce-version-1411-stable-patch/','http://www.magentocommerce.com/blog/comments/magento-ce-version-1411-stable-patch/',0,0),(40,4,'2010-10-12 04:13:25','Magento Mobile is now live!','Magento Mobile is now live! Signup today to have your own native iPhone mobile-shopping app in iTunes for the holiday season! Learn more at http://www.magentomobile.com/','http://www.magentomobile.com/',0,0),(41,4,'2010-11-09 02:52:06','Magento CE Version 1.4.2.0-RC1 Preview Release Now Available','We are happy to announce the availability of Magento Preview Version 1.4.2.0-RC1 for download.','http://www.magentocommerce.com/blog/comments/magento-preview-version-1420-rc1-now-available/',0,0),(42,4,'2010-12-03 01:33:00','Magento CE Version 1.4.2.0-RC2 Preview Release Now Available','We are happy to announce the availability of Magento Preview Version 1.4.2.0-RC2 for download.','http://www.magentocommerce.com/blog/comments/magento-preview-version-1420-rc2-now-available/',0,0),(43,4,'2010-12-09 03:29:55','Magento CE Version 1.4.2.0 Stable is now available','We are excited to announce the availability of Magento CE Version 1.4.2.0 Stable for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-ce-version-1420-stable-now-available/',0,0),(44,4,'2010-12-18 04:23:55','Magento Preview Version CE 1.5.0.0-alpha1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.5.0.0-alpha1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1500-alpha1-now-available/',0,0),(45,4,'2010-12-30 04:51:08','Magento Preview Version CE 1.5.0.0-alpha2 is now available','We are happy to announce the availability of Magento Preview Version CE 1.5.0.0-alpha2 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1500-alpha2-now-available/',0,0),(46,4,'2011-01-14 05:35:36','Magento Preview Version CE 1.5.0.0-beta1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.5.0.0-beta1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1500-beta1-now-available/',0,0),(47,4,'2011-01-22 02:19:09','Magento Preview Version CE 1.5.0.0-beta2 is now available','We are happy to announce the availability of Magento Preview Version CE 1.5.0.0-beta2 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1500-beta2-now-available/',0,0),(48,4,'2011-01-25 03:10:33','Join us for Magento\'s Imagine eCommerce Conference!','Magento\'s Imagine eCommerce Conference is a must-attend event for anyone who uses the Magento platform or is part of the Magento ecosystem. The conference will bring together over 500 retailers, merchants, developers, partners, eCommerce experts, technologists and marketing pros for a fun and intensive conversation about the future of eCommerce.\n\nThe conference is in Los Angeles and kicks off early Monday evening February 7th through Wednesday, February 9th, 2011.\n\nRegister at http://www.magento.com/imagine. First 20 registrants use discount code IMAGINE3X76 for $300 off. *This discount is sponsored by PayPal and is only valid for new registrations.\n\nHope to see you there!\n\nMagento Team','http://www.magento.com/imagine',0,0),(49,4,'2011-01-28 02:27:57','Magento Preview Version CE 1.5.0.0-rc1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.5.0.0-rc1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1500-rc1-now-available/',0,0),(50,4,'2011-02-04 02:56:33','Magento Preview Version CE 1.5.0.0-rc2 is now available','We are happy to announce the availability of Magento Preview Version CE 1.5.0.0-rc2 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1500-rc2-now-available/',0,0),(51,4,'2011-02-09 00:43:23','Magento CE Version 1.5.0.0 Stable is now available','We are excited to announce the availability of Magento CE Version 1.5.0.0 Stable for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-community-professional-and-enterprise-editions-releases-now-availab/',0,0),(52,4,'2011-02-10 04:42:57','Magento CE 1.5.0.1 stable Now Available','We are excited to announce the availability of Magento CE Version 1.5.0.1 Stable for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-ce-1501-stable-now-available/',0,0),(53,4,'2011-03-19 00:15:45','Magento CE 1.5.1.0-beta1 Now Available','We are happy to announce the availability of Magento Preview Version CE 1.5.1.0-beta1 for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1510-beta1-now-available/',0,0),(54,4,'2011-03-31 22:43:02','Magento CE 1.5.1.0-rc1 Now Available','We are happy to announce the availability of Magento Preview Version CE 1.5.1.0-rc1 for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1510-rc1-now-available/',0,0),(55,4,'2011-04-26 23:21:07','Magento CE 1.5.1.0-stable Now Available','We are excited to announce the availability of Magento CE Version 1.5.1.0 Stable for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-ce-version-1510-stable-now-available/',0,0),(56,4,'2011-05-26 23:33:23','Magento Preview Version CE 1.6.0.0-alpha1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.6.0.0-alpha1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1600-alpha1-now-available/',0,0),(57,4,'2011-06-15 22:12:08','Magento Preview Version CE 1.6.0.0-beta1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.6.0.0-beta1for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1600-beta1-now-available/',0,0),(58,4,'2011-06-30 23:03:58','Magento Preview Version CE 1.6.0.0-rc1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.6.0.0-rc1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1600-rc1-now-available/',0,0),(59,4,'2011-07-11 23:07:39','Magento Preview Version CE 1.6.0.0-rc2 is now available','We are happy to announce the availability of Magento Preview Version CE 1.6.0.0-rc2 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1600-rc2-now-available/',0,0),(60,4,'2011-08-19 21:58:31','Magento CE 1.6.0.0-stable Now Available','We are excited to announce the availability of Magento CE Version 1.6.0.0 Stable for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-ce-version-1600-stable-now-available/',0,0),(61,4,'2011-09-17 05:31:26','Magento Preview Version CE 1.6.1.0-beta1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.6.1.0-beta1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1610-beta1-now-available/',0,0),(62,4,'2011-09-29 19:44:10','Magento Preview Version CE 1.6.1.0-rc1 is now available','We are happy to announce the availability of Magento Preview Version CE 1.6.1.0-rc1 for download.\nAs this is a preview version it is NOT recommended in any way to be used in a production environment.','http://www.magentocommerce.com/blog/comments/magento-preview-version-ce-1610-rc1-now-available/',0,0),(63,4,'2011-10-19 21:50:05','Magento CE 1.6.1.0-stable Now Available','We are excited to announce the availability of Magento CE Version 1.6.1.0 Stable for download and upgrade.','http://www.magentocommerce.com/blog/comments/magento-ce-version-1610-stable-now-available/',0,0)

UNLOCK TABLES

DROP TABLE IF EXISTS `api_assert`

CREATE TABLE `api_assert` (
  `assert_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Assert id',
  `assert_type` varchar(20) DEFAULT NULL COMMENT 'Assert type',
  `assert_data` text COMMENT 'Assert additional data',
  PRIMARY KEY (`assert_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Asserts'

LOCK TABLES `api_assert` WRITE

UNLOCK TABLES

DROP TABLE IF EXISTS `api_role`

CREATE TABLE `api_role` (
  `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Role id',
  `parent_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Parent role id',
  `tree_level` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Role level in tree',
  `sort_order` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Sort order to display on admin area',
  `role_type` varchar(1) NOT NULL DEFAULT '0' COMMENT 'Role type',
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'User id',
  `role_name` varchar(50) DEFAULT NULL COMMENT 'Role name',
  PRIMARY KEY (`role_id`),
  KEY `IDX_API_ROLE_PARENT_ID_SORT_ORDER` (`parent_id`,`sort_order`),
  KEY `IDX_API_ROLE_TREE_LEVEL` (`tree_level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Roles'

LOCK TABLES `api_role` WRITE;

UNLOCK TABLES;

DROP TABLE IF EXISTS `api_rule`;

CREATE TABLE `api_rule` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Api rule Id',
  `role_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Api role Id',
  `resource_id` varchar(255) DEFAULT NULL COMMENT 'Module code',
  `api_privileges` varchar(20) DEFAULT NULL COMMENT 'Privileges',
  `assert_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Assert id',
  `role_type` varchar(1) DEFAULT NULL COMMENT 'Role type',
  `api_permission` varchar(10) DEFAULT NULL COMMENT 'Permission',
  PRIMARY KEY (`rule_id`),
  KEY `IDX_API_RULE_RESOURCE_ID_ROLE_ID` (`resource_id`,`role_id`),
  KEY `IDX_API_RULE_ROLE_ID_RESOURCE_ID` (`role_id`,`resource_id`),
  CONSTRAINT `FK_API_RULE_ROLE_ID_API_ROLE_ROLE_ID` FOREIGN KEY (`role_id`) REFERENCES `api_role` (`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api ACL Rules'

DROP TABLE IF EXISTS `api_session`

CREATE TABLE `api_session` (
  `user_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'User id',
  `logdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Login date',
  `sessid` varchar(40) DEFAULT NULL COMMENT 'Sessioin id',
  KEY `IDX_API_SESSION_USER_ID` (`user_id`),
  KEY `IDX_API_SESSION_SESSID` (`sessid`),
  CONSTRAINT `FK_API_SESSION_USER_ID_API_USER_USER_ID` FOREIGN KEY (`user_id`) REFERENCES `api_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Api Sessions'
