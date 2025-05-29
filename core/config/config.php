<?php
// Load environment variables from .env file if it exists
if (file_exists(__DIR__ . '/../../.env')) {
    $lines = file(__DIR__ . '/../../.env', FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        if (strpos(trim($line), '#') === 0) {
            continue;
        }
        
        list($name, $value) = explode('=', $line, 2);
        $name = trim($name);
        $value = trim($value);
        
        if (!array_key_exists($name, $_ENV)) {
            putenv(sprintf('%s=%s', $name, $value));
            $_ENV[$name] = $value;
        }
    }
}

// Configuration settings
return [
    'openrouter' => [
        'api_key' => getenv('OPENROUTER_API_KEY'),
        'model' => getenv('OPENROUTER_MODEL'),
        'api_url' => 'https://openrouter.ai/api/v1/chat/completions',
    ],
    'app' => [
        'debug' => true,
    ],
];