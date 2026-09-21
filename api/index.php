<?php
// Bridge script untuk Vercel Serverless PHP Execution
error_reporting(E_ALL & ~E_DEPRECATED & ~E_STRICT & ~E_NOTICE);
ini_set('display_errors', 0);

chdir(__DIR__ . '/..');

$_SERVER['SCRIPT_NAME'] = '/index.php';
$_SERVER['SCRIPT_FILENAME'] = __DIR__ . '/../index.php';

require __DIR__ . '/../index.php';
