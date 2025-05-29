<?php
require_once __DIR__ . '/../config/config.php';
require_once __DIR__ . '/../src/Router.php';
require_once __DIR__ . '/../src/ApiController.php';

// Set headers for CORS and JSON response
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

// Handle preflight OPTIONS request
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Initialize router
$router = new Router();

// Define routes
$router->addRoute('GET', '/api/health', 'ApiController@healthCheck');
$router->addRoute('POST', '/api/chat', 'ApiController@generateChatResponse');

// Handle the request
$router->handleRequest();