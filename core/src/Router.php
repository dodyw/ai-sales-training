<?php
class Router {
    private $routes = [];
    
    /**
     * Add a route to the router
     * 
     * @param string $method HTTP method (GET, POST, etc.)
     * @param string $path URL path
     * @param string $handler Controller and method (e.g., 'ApiController@method')
     */
    public function addRoute($method, $path, $handler) {
        $this->routes[] = [
            'method' => $method,
            'path' => $path,
            'handler' => $handler
        ];
    }
    
    /**
     * Handle the incoming request
     */
    public function handleRequest() {
        $method = $_SERVER['REQUEST_METHOD'];
        $path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
        
        foreach ($this->routes as $route) {
            if ($route['method'] === $method && $this->matchPath($route['path'], $path)) {
                $this->executeHandler($route['handler']);
                return;
            }
        }
        
        // No route found
        $this->sendResponse(['error' => 'Not Found'], 404);
    }
    
    /**
     * Match the route path with the request path
     * 
     * @param string $routePath Route path pattern
     * @param string $requestPath Actual request path
     * @return bool Whether the paths match
     */
    private function matchPath($routePath, $requestPath) {
        // Simple exact matching for now
        return $routePath === $requestPath;
    }
    
    /**
     * Execute the handler for the matched route
     * 
     * @param string $handler Controller and method (e.g., 'ApiController@method')
     */
    private function executeHandler($handler) {
        list($controller, $method) = explode('@', $handler);
        
        if (class_exists($controller)) {
            $instance = new $controller();
            if (method_exists($instance, $method)) {
                $instance->$method();
                return;
            }
        }
        
        // Handler not found
        $this->sendResponse(['error' => 'Internal Server Error'], 500);
    }
    
    /**
     * Send a JSON response
     * 
     * @param mixed $data Response data
     * @param int $statusCode HTTP status code
     */
    public function sendResponse($data, $statusCode = 200) {
        http_response_code($statusCode);
        echo json_encode($data);
        exit;
    }
}