package rules

response := http.send({
  "url": "http://httpbin.org/delay/5",
  "method": "GET",
  "timeout": "10s",
  "force_cache": true,
  "force_cache_duration_seconds": 3600
})
