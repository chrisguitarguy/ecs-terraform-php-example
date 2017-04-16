<?php

use Silex\Application;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

require __DIR__.'/../vendor/autoload.php';

$app = new Application([
    'debug' => filter_var(getenv('APP_DEBUG'), FILTER_VALIDATE_BOOLEAN),
]);

$app->get('/', function (Request $r) {
    return new Response(sprintf(
        'Hello, %s!',
        $r->query->get('name') ?: 'World'
    ), 200, ['Content-Type' => 'text/plain']);
});

$app->run();
