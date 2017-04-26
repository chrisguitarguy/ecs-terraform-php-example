<?php

use Silex\Application;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

require __DIR__.'/../vendor/autoload.php';

$app = new Application([
    'debug' => (bool) getenv('APP_DEBUG'),
]);

$app->get('/', function (Request $r) {
    return new Response(sprintf(
        'Hello, %s!',
        $r->query->get('name') ?: 'World'
    ), 200, ['Content-Type' => 'text/plain']);
});

$app->run();
