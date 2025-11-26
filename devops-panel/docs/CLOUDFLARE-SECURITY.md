# Cloudflare Security Configuration

This document outlines the Cloudflare security configuration for the DevOps Panel, including rate limiting, WAF rules, and DDoS protection.

## Table of Contents

- [Rate Limiting Rules](#rate-limiting-rules)
- [WAF Custom Rules](#waf-custom-rules)
- [Bot Management](#bot-management)
- [Security Headers](#security-headers)
- [Setup Instructions](#setup-instructions)

## Rate Limiting Rules

### Login Endpoint Protection

**Rule Name:** `rate-limit-login`

**Description:** Prevents brute force attacks on the login endpoint by limiting login attempts.

**Configuration:**

```text
Rule Expression:
  (http.request.uri.path eq "/api/auth/login") and
  (http.request.method eq "POST")

Rate Limiting:
  - Requests: 5 per 15 minutes
  - Action: Block
  - Duration: 30 minutes
  - Response Code: 429
  - Counting Method: IP Address + User Agent
```

**Custom Response:**
```json
{
  "error": "Too many login attempts from this IP address. Please try again in 30 minutes.",
  "code": "RATE_LIMIT_EXCEEDED",
  "retryAfter": 1800
}
```

### API Endpoints Protection

**Rule Name:** `rate-limit-api`

**Description:** General rate limiting for all API endpoints to prevent abuse.

**Configuration:**

```text
Rule Expression:
  (http.request.uri.path contains "/api/") and
  (http.request.method in {"POST" "PUT" "DELETE" "PATCH"})

Rate Limiting:
  - Requests: 60 per minute
  - Action: Challenge
  - Duration: 5 minutes
  - Counting Method: IP Address
```

## WAF Custom Rules

### 1. Block Known Attack Patterns

**Rule Name:** `block-sql-injection`

```text
Expression:
  (http.request.uri.query contains "' OR 1=1") or
  (http.request.uri.query contains "UNION SELECT") or
  (http.request.body contains "' OR '1'='1")

Action: Block
```

### 2. Require Strong Authentication Headers

**Rule Name:** `require-auth-headers`

```text
Expression:
  (http.request.uri.path contains "/api/") and
  (not http.request.uri.path eq "/api/auth/login") and
  (not http.request.headers["cookie"] contains "devops_panel_session")

Action: Block
Response: 401 Unauthorized
```

### 3. Block Suspicious User Agents

**Rule Name:** `block-bad-bots`

```text
Expression:
  (http.user_agent contains "sqlmap") or
  (http.user_agent contains "nikto") or
  (http.user_agent contains "masscan") or
  (http.user_agent eq "")

Action: Block
```

### 4. Geographic Restrictions (Optional)

**Rule Name:** `geo-restrictions`

```text
Expression:
  (ip.geoip.country in {"CN" "RU" "KP"}) and
  (http.request.uri.path eq "/api/auth/login")

Action: Challenge (Managed Challenge)
```

**Note:** Adjust country codes based on your legitimate traffic patterns.

## Bot Management

### Bot Fight Mode

Enable Cloudflare's Bot Fight Mode to automatically challenge and block known bad bots.

**Settings:**
- Enable Bot Fight Mode: Yes
- Challenge Score Threshold: 30
- Action: Managed Challenge

### JavaScript Detection

Require JavaScript for sensitive endpoints:

```text
Rule Expression:
  (http.request.uri.path eq "/api/auth/login")

Action: JavaScript Challenge
```

## Security Headers

Cloudflare should add these security headers to all responses:

```text
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
Permissions-Policy: geolocation=(), microphone=(), camera=()
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

**Note:** Most of these are already configured in `vercel.json`, but Cloudflare provides an additional layer.

## Setup Instructions

### Step 1: Access Cloudflare Dashboard

1. Log into Cloudflare
2. Select your domain (e.g., `vln.gg`)
3. Navigate to **Security** > **WAF**

### Step 2: Create Rate Limiting Rules

1. Go to **Security** > **WAF** > **Rate limiting rules**
2. Click **Create rule**
3. For each rate limiting rule above:
   - Enter the rule name
   - Set the expression
   - Configure rate limiting parameters
   - Set the action and duration
   - Save the rule

### Step 3: Create WAF Custom Rules

1. Go to **Security** > **WAF** > **Custom rules**
2. Click **Create rule**
3. For each WAF rule above:
   - Enter the rule name and description
   - Set the expression
   - Choose the action
   - Save the rule

### Step 4: Enable Bot Protection

1. Go to **Security** > **Bots**
2. Enable **Bot Fight Mode**
3. Configure challenge threshold to **30**
4. Save changes

### Step 5: Configure Security Headers

1. Go to **Rules** > **Transform Rules** > **Modify Response Header**
2. Click **Create rule**
3. Add each security header
4. Deploy changes

### Step 6: Test Configuration

```bash
# Test rate limiting (should block after 5 attempts)
for i in {1..6}; do
  curl -X POST https://dev.vln.gg/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"username":"test","password":"wrong"}' \
    -v
done

# Check for rate limit headers
curl -I https://dev.vln.gg/api/auth/login
```

## Monitoring and Alerts

### Cloudflare Analytics

Monitor these metrics:

- **Threats Mitigated:** Track blocked requests by rule
- **Rate Limiting Events:** Monitor triggered rate limits
- **Bot Score Distribution:** Identify bot traffic patterns
- **Geographic Traffic:** Identify unusual traffic sources

### Recommended Alerts

Create alerts for:

1. **High Rate Limit Triggers** (>100/hour)
2. **Blocked Attack Patterns** (>50/hour)
3. **Geographic Anomalies** (traffic from unexpected countries)
4. **Challenge Solve Rate** (<50% indicates potential attack)

## Defense in Depth Strategy

Our security implementation uses multiple layers:

```
┌─────────────────────────────────────────┐
│     Layer 1: Cloudflare WAF + Bots      │  ← Primary defense
├─────────────────────────────────────────┤
│     Layer 2: Cloudflare Rate Limiting   │  ← DDoS protection
├─────────────────────────────────────────┤
│     Layer 3: Server-Side Rate Limiter   │  ← Application-level (this repo)
├─────────────────────────────────────────┤
│     Layer 4: Progressive Delays         │  ← Exponential backoff
├─────────────────────────────────────────┤
│     Layer 5: Session Management         │  ← Iron Session validation
└─────────────────────────────────────────┘
```

## Server-Side Rate Limiting (Backup)

Our application also implements server-side rate limiting in `lib/auth/rate-limit.ts`:

**Features:**
- **5 attempts** per 15 minutes per IP+username combination
- **30 minute block** after max attempts exceeded
- **Progressive delays:** Exponential backoff (1s, 2s, 4s, 8s, 10s)
- **Automatic cleanup:** Old entries removed every 5 minutes

**Rate Limit Headers:**
```
X-RateLimit-Limit: 5
X-RateLimit-Remaining: 3
X-RateLimit-Reset: 2025-11-25T22:00:00.000Z
Retry-After: 1800
```

## Best Practices

1. **Monitor Logs:** Review Cloudflare firewall events daily
2. **Adjust Thresholds:** Fine-tune rate limits based on legitimate traffic
3. **Whitelist IPs:** Add trusted IPs (office, CI/CD) to bypass some rules
4. **Update Rules:** Regularly review and update WAF rules
5. **Test Changes:** Always test in staging before production
6. **Document Changes:** Keep this doc updated with any modifications

## Troubleshooting

### Users Getting Blocked Legitimately

1. Check Cloudflare Firewall Events
2. Identify the triggered rule
3. Create an exception rule for the specific case
4. Monitor for abuse

### Rate Limits Too Strict

1. Review analytics for false positives
2. Adjust the request threshold or time window
3. Consider using "Log" action first to test
4. Gradually move from Log → Challenge → Block

### False Positive Bot Detection

1. Review Bot Analytics
2. Check Bot Score for legitimate traffic
3. Adjust Bot Fight Mode threshold
4. Create bypass rules for specific user agents (if legitimate)

## Compliance Notes

This configuration helps meet:

- **OWASP Top 10:** Protects against injection, broken auth, etc.
- **PCI DSS:** Rate limiting and encryption requirements
- **SOC 2:** Security monitoring and incident response

## References

- [Cloudflare Rate Limiting](https://developers.cloudflare.com/waf/rate-limiting-rules/)
- [Cloudflare WAF](https://developers.cloudflare.com/waf/)
- [Bot Management](https://developers.cloudflare.com/bots/)
- [OWASP Brute Force](https://owasp.org/www-community/controls/Blocking_Brute_Force_Attacks)

---

**Last Updated:** 2025-11-25
**Maintained By:** VLN DevOps Team
**Review Schedule:** Quarterly
