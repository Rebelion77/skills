# API Testing — Full Checklist

## Enumeration

- OpenAPI, Swagger, Postman collections, and JavaScript files.
- API versions: v1, v2, beta, and undocumented versions.
- Methods: GET, POST, PUT, PATCH, DELETE, and OPTIONS for every endpoint.

## Authorization

- BOLA: change object IDs for read, write, and delete as a low-privilege test user.
- BFLA: call admin endpoints as a normal test user.
- BOPLA: add is_admin, role, price, user_id, and other extra fields.
- Excessive data: check list endpoints for fields the UI never shows.

## JWT

- Decode header and payload. Check alg, kid, jku, exp, and iss.
- Test none algorithm, algorithm confusion, and missing signature, only on a test token.
- Test expired tokens, tokens from another user, and tokens in URLs.
- Do not brute force a production secret at scale.

## GraphQL

- Introspection: query __schema and __type, if enabled.
- Field suggestions and error messages: record every field and type.
- Batching: test multiple queries in one request, and depth limits.
- Authorization: test every field and mutation as a low-privilege test user.

## WebSocket

- Authentication on connect, and authorization on subscribe.
- Injection in messages, and whether a user can subscribe to another user's channel.

## Rate limiting

- Send a small number of requests, note the limit, and stop.
- Do not flood the API, and do not test rate limiting on login with real accounts.
