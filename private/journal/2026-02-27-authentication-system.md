# Dev Journal — Authentication System

**Date:** 2026-02-27
**Project:** Seaway
**Topic:** Authentication Architecture

---

## Context

Today I implemented the first complete version of the authentication system for Seaway.

The main goal was to design a system that is **stateless, secure, and compatible with a modern SPA frontend**.

---

# Architecture

The authentication system is based on:

* JWT access tokens
* refresh tokens
* stateless backend authentication

The system uses two tokens:

| Token         | Purpose                    |
| ------------- | -------------------------- |
| Access token  | short-lived authentication |
| Refresh token | renew access tokens        |

---

# Token Strategy

The access token has a short lifetime (15 minutes) and contains:

* user id
* role
* actor type
* issuer
* expiration

The refresh token allows generating new access tokens without requiring the user to log in again.

This design improves both **security and user experience**.

---

# Cookie Strategy

Tokens are stored in **HTTP-only secure cookies**.

Properties used:

* `httpOnly`
* `secure`
* `SameSite=Lax`

This prevents access from JavaScript and protects against common XSS token theft attacks.

---

# Backend Integration

The authentication flow is integrated into Spring Security using a custom filter:

```
JwtAuthFilter
```

The filter:

1. extracts the token from cookies
2. validates the JWT
3. injects the authentication into the security context

This allows the API to remain **fully stateless**.

---

# Outcome

The platform now has a functional authentication system with:

* login
* register
* token refresh
* logout
* authenticated endpoints

This was a major milestone for enabling secured API endpoints.
