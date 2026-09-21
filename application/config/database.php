<?php
defined('BASEPATH') OR exit('No direct script access allowed');

$active_group = 'default';
$query_builder = TRUE;

// Logic koneksi dinamis (ENV Vercel/Supabase/Cloud, Local, vs Live cPanel)
$env_host   = getenv('DB_HOST') ?: getenv('MYSQLHOST') ?: getenv('POSTGRES_HOST');
$env_user   = getenv('DB_USER') ?: getenv('MYSQLUSER') ?: getenv('POSTGRES_USER');
$env_pass   = getenv('DB_PASS') ?: getenv('MYSQLPASSWORD') ?: getenv('POSTGRES_PASSWORD');
$env_name   = getenv('DB_NAME') ?: getenv('MYSQLDATABASE') ?: getenv('POSTGRES_DATABASE') ?: 'postgres';
$env_driver = getenv('DB_DRIVER') ?: (strpos($env_host, 'supabase') !== false ? 'postgre' : 'mysqli');
$env_port   = getenv('DB_PORT') ?: getenv('MYSQLPORT') ?: getenv('POSTGRES_PORT') ?: ($env_driver === 'postgre' ? 5432 : 3306);

$is_localhost = (isset($_SERVER['SERVER_NAME']) && ($_SERVER['SERVER_NAME'] == 'localhost' || $_SERVER['REMOTE_ADDR'] == '127.0.0.1' || $_SERVER['REMOTE_ADDR'] == '::1'));

if (!empty($env_host)) {
	// ENV CONFIG (Vercel / Supabase / Cloud Database)
	$db['default'] = array(
		'dsn'	=> '',
		'hostname' => $env_host,
		'username' => $env_user,
		'password' => $env_pass,
		'database' => $env_name,
		'port'     => (int) $env_port,
		'dbdriver' => $env_driver,
		'dbprefix' => '',
		'pconnect' => FALSE,
		'db_debug' => (ENVIRONMENT !== 'production'),
		'cache_on' => FALSE,
		'cachedir' => '',
		'char_set' => 'utf8',
		'dbcollat' => 'utf8_general_ci',
		'swap_pre' => '',
		'encrypt' => FALSE,
		'compress' => FALSE,
		'stricton' => FALSE,
		'failover' => array(),
		'save_queries' => TRUE
	);
} elseif ($is_localhost) {
	// LOCALHOST
	$db['default'] = array(
		'dsn'	=> '',
		'hostname' => 'localhost',
		'username' => 'root',
		'password' => '',
		'database' => 'fkkmbt',
		'dbdriver' => 'mysqli',
		'dbprefix' => '',
		'pconnect' => FALSE,
		'db_debug' => (ENVIRONMENT !== 'production'),
		'cache_on' => FALSE,
		'cachedir' => '',
		'char_set' => 'utf8',
		'dbcollat' => 'utf8_general_ci',
		'swap_pre' => '',
		'encrypt' => FALSE,
		'compress' => FALSE,
		'stricton' => FALSE,
		'failover' => array(),
		'save_queries' => TRUE
	);
} else {
	// LIVE SERVER (cPanel)
	$db['default'] = array(
		'dsn'	=> '',
		'hostname' => 'localhost',
		'username' => 'ti2b8143_fkkmbt_admin',
		'password' => '@fkkmbtjayajaya',
		'database' => 'ti2b8143_fkkmbt',
		'dbdriver' => 'mysqli',
		'dbprefix' => '',
		'pconnect' => FALSE,
		'db_debug' => (ENVIRONMENT !== 'production'),
		'cache_on' => FALSE,
		'cachedir' => '',
		'char_set' => 'utf8',
		'dbcollat' => 'utf8_general_ci',
		'swap_pre' => '',
		'encrypt' => FALSE,
		'compress' => FALSE,
		'stricton' => FALSE,
		'failover' => array(),
		'save_queries' => TRUE
	);
}
