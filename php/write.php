<?php

require __DIR__ . '/vendor/autoload.php';
use Monolog\Logger;
use Monolog\Handler\StreamHandler;
use Monolog\Formatter\LogstashFormatter;

// create logger
$formatter = new LogstashFormatter('demoapp');
$handler = new StreamHandler(__DIR__ .'/log/demo.log', Logger::WARNING);
$handler->setFormatter($formatter);
$log = new Logger('name');
$log->pushHandler($handler);

// add records to the log
$log->warning('Foo', ['foo' => 'some value']);
$log->error('Bar', ['bar => some value']);
