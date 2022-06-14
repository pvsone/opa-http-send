# opa-http-send

Simple test of OPA's `http.send` built-in function with caching.

## Run OPA as a server
```sh
opa run --server rules.rego
```

## Query OPA with metrics

**Query 1 Request**

When the cache is empty, the call will take the full 5 seconds.  Append `metrics=true` to have OPA return the performance metrics.
```sh
curl 'localhost:8181/v1/data/rules/response/status_code?metrics=true' | jq .
```

**Query 1 Response**
```less
{
  "metrics": {
    "counter_server_query_cache_hit": 0,
    "timer_rego_builtin_http_send_ns": 5160468004,
    "timer_rego_input_parse_ns": 1054,
    "timer_rego_query_compile_ns": 101537,
    "timer_rego_query_eval_ns": 5160627448,
    "timer_rego_query_parse_ns": 72875,
    "timer_server_handler_ns": 5160948386
  },
  "result": 200
}
```
The `timer_rego_builtin_http_send_ns` metric shows the call took over 5 seconds (5160468004 nanoseconds) to complete.

**Query 2 Request**

Repeat query 1, the response will be retrieved from cache.
```sh
curl 'localhost:8181/v1/data/rules/response/status_code?metrics=true' | jq .
```

**Query 2 Response**
```less
{
  "metrics": {
    "counter_rego_builtin_http_send_interquery_cache_hits": 1,
    "counter_server_query_cache_hit": 1,
    "timer_rego_builtin_http_send_ns": 202776,
    "timer_rego_input_parse_ns": 563,
    "timer_rego_query_eval_ns": 286116,
    "timer_server_handler_ns": 318597
  },
  "result": 200
}
```

The `timer_rego_builtin_http_send_ns` metric shows the call took 200 microseconds (202776 nanoseconds) and the response was retrieved from cache.  Additionally `counter_rego_builtin_http_send_interquery_cache_hits` returns a value of 1 - indicating that this request was a hit against the internal `http.send` cache.
