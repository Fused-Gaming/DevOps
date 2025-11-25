# Email Handling System - DevOps Panel

## Overview

The Email Handling System is a comprehensive email management module integrated into the DevOps Panel. It provides email template management, delivery tracking, service configuration, and webhook integration for real-time delivery events.

## Features

### 1. Email Dashboard
- **Quick Access Widget** - Email statistics and quick actions on the main dashboard
- **Status Overview** - Real-time email activity tracking for the current day
- **Template Management** - Create, edit, and delete email templates
- **Service Configuration** - Configure email service providers and credentials
- **Webhook Integration** - Receive real-time delivery and bounce notifications

### 2. Email Components

#### EmailQuickAccess
**Location:** `components/email/email-quick-access.tsx`

Quick access widget for the main dashboard showing:
- Total email templates count
- Pending emails queue
- Failed emails (if any)
- Configuration status
- Links to manage system and settings

**Usage:**
```tsx
import EmailQuickAccess from "@/components/email/email-quick-access";

<EmailQuickAccess />
```

#### EmailStatus
**Location:** `components/email/email-status.tsx`

Real-time status card displaying:
- Emails sent today
- Pending emails
- Failed emails (if applicable)
- Success rate percentage
- Visual progress bar

**Usage:**
```tsx
import EmailStatus from "@/components/email/email-status";

<EmailStatus />
```

#### EmailTemplates
**Location:** `components/email/email-templates.tsx`

Template management interface with:
- List of all email templates
- Create new template button
- Edit template functionality
- Delete template with confirmation
- Template metadata display (name, subject, creation date)

**Usage:**
```tsx
import EmailTemplates from "@/components/email/email-templates";

<EmailTemplates />
```

### 3. API Routes

#### GET `/api/email/stats`
Fetch email system statistics
- Total templates count
- Pending emails count
- Failed emails count
- Service configuration status

**Response:**
```json
{
  "totalTemplates": 5,
  "pendingEmails": 3,
  "failedEmails": 0,
  "isConfigured": true
}
```

#### GET `/api/email/status`
Get today's email activity status
- Emails sent today
- Failed emails today
- Pending emails today
- Success rate percentage

**Response:**
```json
{
  "sentToday": 24,
  "failedToday": 0,
  "pendingToday": 3,
  "successRate": 100,
  "lastUpdated": "2024-01-15T10:30:00Z"
}
```

#### GET/POST/DELETE `/api/email/templates`
**GET:** Retrieve all email templates
**POST:** Create a new email template
**DELETE:** Remove an email template

**POST Request Body:**
```json
{
  "name": "Welcome Email",
  "subject": "Welcome to our platform",
  "description": "Sent to new users upon signup",
  "content": "<html>...</html>"
}
```

**DELETE Request Body:**
```json
{
  "id": "template_id"
}
```

#### POST `/api/email/send`
Send an email immediately

**Request Body:**
```json
{
  "to": "user@example.com",
  "subject": "Hello",
  "html": "<html>...</html>",
  "templateId": "optional_template_id",
  "variables": {
    "name": "John",
    "link": "https://example.com"
  }
}
```

**Response (202 Accepted):**
```json
{
  "success": true,
  "emailId": "email_1704269400000",
  "message": "Email queued for sending",
  "to": "user@example.com",
  "subject": "Hello",
  "sentAt": "2024-01-15T10:30:00Z"
}
```

#### POST `/api/email/webhook`
Receive delivery events from email service provider

**Webhook Event Body (example - varies by provider):**
```json
{
  "event": "delivered",
  "messageId": "email_123",
  "recipient": "user@example.com",
  "timestamp": "2024-01-15T10:35:00Z",
  "reason": "success"
}
```

## Environment Variables

### Required Variables (when using email service)
```env
# Email Service Provider
EMAIL_PROVIDER=sendgrid|mailgun|resend|smtp

# API Token for the service
EMAIL_SERVICE_TOKEN=your_api_key_here

# Sender Information
EMAIL_FROM=noreply@example.com
EMAIL_FROM_NAME=DevOps Team
```

### Optional Variables (for SMTP)
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_password
SMTP_TLS=true
```

### Webhook Configuration
```env
EMAIL_WEBHOOK_URL=https://your-domain.com/api/email/webhook
```

## Email Service Providers

### SendGrid
1. Get API key from https://app.sendgrid.com/settings/api_keys
2. Set `EMAIL_PROVIDER=sendgrid`
3. Set `EMAIL_SERVICE_TOKEN` to your API key
4. Configure webhook in SendGrid dashboard pointing to `/api/email/webhook`

### Mailgun
1. Get API key from https://app.mailgun.com/app/account/security/api_keys
2. Set `EMAIL_PROVIDER=mailgun`
3. Set `EMAIL_SERVICE_TOKEN` to your API key
4. Configure webhook in Mailgun dashboard

### Resend
1. Get API key from https://resend.com/api-keys
2. Set `EMAIL_PROVIDER=resend`
3. Set `EMAIL_SERVICE_TOKEN` to your API key
4. Configure webhook URL in Resend settings

### SMTP Server
1. Set `EMAIL_PROVIDER=smtp`
2. Configure SMTP_* environment variables
3. No API key needed
4. Webhooks not available with standard SMTP

## Getting Started

### 1. Access Email Management
- Go to the main DevOps Panel dashboard
- Click the "Email System" card or "Manage" button
- You'll be taken to `/email` page

### 2. Configure Email Service
1. Click the "Settings" tab
2. Select your email service provider
3. Enter your API token/credentials
4. Set the sender email and name
5. Click "Save Configuration"
6. Test the connection with "Test Connection" button

### 3. Create Email Templates
1. Click the "Templates" tab
2. Click "New Template" button
3. Enter template details:
   - Name: Identifier for the template
   - Subject: Email subject line
   - Content: HTML email body with optional variables like `{{name}}`, `{{link}}`, etc.
4. Save the template

### 4. Send Emails
**Option A: Using the API directly**
```bash
curl -X POST http://localhost:3000/api/email/send \
  -H "Content-Type: application/json" \
  -d '{
    "to": "user@example.com",
    "subject": "Test Email",
    "html": "<h1>Hello</h1>"
  }'
```

**Option B: Using templates with variables**
```bash
curl -X POST http://localhost:3000/api/email/send \
  -H "Content-Type: application/json" \
  -d '{
    "to": "user@example.com",
    "templateId": "welcome_email",
    "variables": {
      "name": "John Doe",
      "activationLink": "https://app.example.com/activate?code=123"
    }
  }'
```

### 5. Monitor Email Activity
- Dashboard shows real-time statistics
- Check "Overview" tab for today's activity
- Failed emails are highlighted in red
- Success rate is displayed as a percentage

## Security Considerations

1. **Never commit `.env` files** - API keys should never be in version control
2. **Use strong API tokens** - Treat like passwords
3. **Webhook verification** - Validate webhook signatures from email providers
4. **Rate limiting** - Implement rate limiting for email sending endpoint
5. **Authentication** - All endpoints require session authentication
6. **HTTPS only** - Email webhooks should only accept HTTPS in production

## Troubleshooting

### "Email service not configured"
- Check that `EMAIL_SERVICE_TOKEN` is set in environment variables
- Verify the token is correct and hasn't expired
- Restart the application after setting environment variables

### Emails not sending
- Check email service status page
- Verify sender email is verified in service settings
- Check email logs in your service provider's dashboard
- Ensure rate limits haven't been exceeded

### Webhook not receiving events
- Verify webhook URL is publicly accessible
- Check that HTTPS is configured for production
- Verify webhook secret/signature validation
- Check email service provider webhook configuration

### Template variables not replacing
- Use double curly braces: `{{variable_name}}`
- Variable names must match exactly (case-sensitive)
- Ensure variables are passed in the request

## Development

### Adding a New Email Service Provider

1. Create a new module: `lib/email/providers/[provider-name].ts`
2. Implement the EmailProvider interface:
```typescript
interface EmailProvider {
  send(options: SendEmailOptions): Promise<SendResponse>;
  verifyWebhook(body: unknown, signature: string): boolean;
}
```

3. Update `/api/email/send` route to use the provider
4. Add environment variables for the new provider
5. Update `.env.example` documentation

### Local Development

```bash
# Install dependencies
pnpm install

# Set up environment variables
cp .env.example .env.local

# Edit .env.local with your settings
# EMAIL_PROVIDER=sendgrid
# EMAIL_SERVICE_TOKEN=your_token

# Run development server
pnpm dev

# Access at http://localhost:3000
```

## File Structure

```
devops-panel/
├── components/email/
│   ├── email-quick-access.tsx      # Dashboard widget
│   ├── email-status.tsx             # Status display component
│   └── email-templates.tsx          # Template management
├── app/
│   ├── email/
│   │   └── page.tsx                 # Email management page
│   └── api/email/
│       ├── stats/route.ts           # Statistics endpoint
│       ├── status/route.ts          # Status endpoint
│       ├── templates/route.ts       # Template management
│       ├── send/route.ts            # Send email endpoint
│       └── webhook/route.ts         # Webhook receiver
└── lib/email/                       # (Future) Email service logic
    ├── providers/                   # Email service implementations
    └── templates.ts                 # Template utilities
```

## API Response Status Codes

| Code | Meaning | Example |
|------|---------|---------|
| 200  | Success | Get request returned data |
| 201  | Created | Template created successfully |
| 202  | Accepted | Email queued for sending |
| 400  | Bad Request | Missing required fields |
| 401  | Unauthorized | User not logged in |
| 403  | Forbidden | User lacks permission |
| 500  | Server Error | Service error occurred |
| 503  | Service Unavailable | Email service not configured |

## Future Enhancements

- [ ] Email scheduling (send at specific time)
- [ ] Batch email sending
- [ ] Advanced template editor with preview
- [ ] Email campaign analytics
- [ ] A/B testing for templates
- [ ] Recipient list management
- [ ] Email bounce handling
- [ ] Unsubscribe list management
- [ ] DKIM/SPF configuration UI
- [ ] Integration with CRM systems

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review environment variables in `.env.example`
3. Check application logs for error messages
4. Consult your email service provider's documentation
5. Open an issue on GitHub: https://github.com/Fused-Gaming/DevOps/issues
