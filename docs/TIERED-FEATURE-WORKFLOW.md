# Tiered Feature Documentation Workflow

## Overview

The Hybrid Feature Documentation Workflow uses a **tiered approach** that adjusts documentation requirements based on feature size. This balances thorough documentation for significant changes with pragmatic flexibility for smaller updates.

---

## Three-Tier System

### Tier 1: Small Features (<200 lines changed)

**Examples:**
- Button color change
- Text copy update
- Minor UI adjustment
- Small bug fix in feature code

**Requirements:**
- ⚠️ Documentation **RECOMMENDED** but not enforced
- Minimum: 50 words (if documented)
- Missing sections show warnings but won't block merge
- Basic content in Overview and Goals sections

**Rationale:**
Small changes often don't warrant comprehensive documentation. However, brief context is still valuable for code reviews and future reference.

**Best Practice:**
Even for small features, create brief documentation:
```markdown
## Overview
Change submit button color from blue to green for better accessibility contrast.

## Goals
- **Project Goal:** WCAG 2.1 AA compliance
- Success: Passes contrast ratio test

## Implementation
- Modified: src/components/SubmitButton.css
- Changed: background-color #007bff → #28a745

## Testing
- Manual: Verified contrast ratio 4.6:1 (passes AA)
- Visual: Tested across all pages
```

---

### Tier 2: Medium Features (200-1000 lines changed)

**Examples:**
- New form component
- API endpoint addition
- Database migration
- Feature enhancement
- Integration with third-party service

**Requirements:**
- ✅ Documentation **REQUIRED**
- Minimum: 100 words
- All 4 sections must be present and substantive
- Each section should have meaningful content
- Blocks merge if documentation missing or incomplete

**Rationale:**
Medium features represent significant work that affects multiple parts of the codebase. Proper documentation ensures team alignment and eases future maintenance.

**Best Practice:**
Document thoroughly but concisely:
```markdown
## Overview
Add user profile form with avatar upload. Allows users to update their display name, bio, and profile picture. Improves user engagement by enabling personalization.

## Goals
- **Project Goal:** User engagement improvements (Q1 2025)
- **User Story:** As a user, I want to customize my profile
- Success:
  - [ ] Users can update all profile fields
  - [ ] Avatar uploads restricted to 2MB, image formats only
  - [ ] Changes save immediately with feedback

## Implementation
**Technical Approach:** React form with Formik validation, uploads to S3

**Key Files:**
- src/components/ProfileForm.js - Main form component
- src/api/profile.js - API endpoints for updates
- src/hooks/useProfileUpload.js - Avatar upload logic
- server/routes/profile.js - Backend routes

**Design Decisions:**
**Decision:** Use S3 for avatar storage
- **Why:** Scalable, CDN-ready, reduces server load
- **Alternatives:** Local storage (not scalable), database (expensive)

## Testing
**Unit Tests:** Form validation, avatar upload logic - Coverage: 92%
**Integration Tests:** Full profile update flow
**Edge Cases:**
- Oversized images - ✅ Rejected with error message
- Invalid file types - ✅ Filtered by input accept
- Concurrent updates - ✅ Last-write-wins with timestamp
```

---

### Tier 3: Large Features (>1000 lines changed)

**Examples:**
- New authentication system
- Payment integration
- Major architectural refactor
- Real-time chat feature
- Complete module rewrite

**Requirements:**
- ✅ **COMPREHENSIVE** documentation required
- Minimum: 200 words
- All 4 sections must be detailed and thorough
- Should include architecture diagrams, API specs (if applicable)
- May require design document approval before implementation
- Blocks merge if documentation insufficient

**Rationale:**
Large features are complex, touch many parts of the system, and have long-term impact. Thorough documentation is critical for team understanding, maintenance, and future development.

**Best Practice:**
Create comprehensive documentation with additional detail:
```markdown
## Overview
Implement real-time chat using WebSockets. Enables users to communicate instantly within the application. Supports 1-on-1 and group conversations with message history, typing indicators, and presence status.

This solves the current limitation of asynchronous-only communication and provides competitive parity with similar platforms. Expected to increase daily active users by 25% based on user research.

## Goals
### Project Alignment
- **Project Goal:** Feature parity with competitors (2025 roadmap item #3)
- **User Story:** As a user, I want real-time chat to collaborate with team members
- **Business Objective:** Increase user engagement and reduce churn

### Success Criteria
- [ ] Messages delivered within 500ms
- [ ] Supports 100+ concurrent connections per server
- [ ] 99.9% message delivery reliability
- [ ] Works across all supported browsers
- [ ] Graceful degradation if WebSocket unavailable

## Implementation
### Technical Approach
Using Socket.IO for WebSocket communication with Redis pub/sub for horizontal scaling. Messages stored in PostgreSQL with full-text search. Client uses React hooks for real-time updates.

**Architecture:**
```
[Client] ←WebSocket→ [Socket.IO Server] ←Redis Pub/Sub→ [Other Servers]
                              ↓
                        [PostgreSQL]
                        (Message Storage)
```

**Key Components:**
- `client/src/chat/` - React chat UI components
- `client/src/hooks/useChat.js` - Chat state management
- `server/chat/socket-handler.js` - WebSocket event handlers
- `server/chat/message-service.js` - Message persistence
- `server/chat/presence-tracker.js` - Online/offline status

**Key Files Changed:** (15+ files, see detailed list in PR)

### Design Decisions

**Decision 1:** Socket.IO vs native WebSockets
- **Chosen:** Socket.IO
- **Why:** Automatic reconnection, fallback to polling, room management
- **Alternatives:** Native WebSockets (more code), SignalR (C# focused)
- **Tradeoffs:** Larger bundle size, vendor lock-in

**Decision 2:** Redis for pub/sub
- **Chosen:** Redis pub/sub
- **Why:** Fast, already in stack, proven for this use case
- **Alternatives:** RabbitMQ (overkill), Direct server-to-server (not scalable)
- **Tradeoffs:** Additional infrastructure dependency

**Decision 3:** PostgreSQL message storage
- **Chosen:** PostgreSQL with JSONB
- **Why:** Strong consistency, ACID guarantees, full-text search
- **Alternatives:** MongoDB (eventual consistency issues), Cassandra (overkill)
- **Tradeoffs:** Write throughput limit (acceptable for our scale)

### API Changes
**New WebSocket Events:**
```javascript
// Client → Server
socket.emit('message:send', { roomId, content, attachments })
socket.emit('typing:start', { roomId })
socket.emit('typing:stop', { roomId })

// Server → Client
socket.on('message:new', { id, roomId, userId, content, timestamp })
socket.on('message:delivered', { messageId, userId, timestamp })
socket.on('typing:update', { roomId, userIds })
socket.on('presence:update', { userId, status, lastSeen })
```

**New REST Endpoints:**
```
GET  /api/chat/rooms - List user's chat rooms
POST /api/chat/rooms - Create new room
GET  /api/chat/rooms/:id/messages - Get message history
POST /api/chat/rooms/:id/messages - Send message (fallback if WebSocket unavailable)
GET  /api/chat/search - Full-text search across messages
```

## Testing
### Test Strategy
**Unit Tests:**
- WebSocket event handlers - Coverage: 95%
- Message service - Coverage: 98%
- Presence tracker - Coverage: 90%

**Integration Tests:**
- Full message flow (send → store → deliver)
- Multi-server message delivery via Redis
- Reconnection and message queue

**Load Tests:**
- 500 concurrent connections per server - ✅ Passed
- 10,000 messages/second - ✅ Passed with 250ms p99
- Sustained load for 1 hour - ✅ No memory leaks

**Manual Testing:**
- Cross-browser testing (Chrome, Firefox, Safari, Edge)
- Mobile responsiveness
- Network interruption scenarios

### Test Coverage
- **Overall:** 94%
- **New Code:** 96%
- **Critical Paths:** 100%

### Edge Cases Tested
- Connection dropped during message send - ✅ Queued and resent
- Message sent while offline - ✅ Stored and sent on reconnect
- Concurrent messages from same user - ✅ Proper ordering maintained
- Large message (>10KB) - ✅ Rejected with error
- Invalid room access - ✅ Permission check enforced
- Server restart - ✅ Clients reconnect automatically
- Redis failure - ✅ Graceful degradation (single-server only)
- Database unavailable - ✅ Messages queued in memory (max 1000)

## Security Considerations
- [x] Authentication required for all WebSocket connections
- [x] Room access control enforced on server
- [x] Input sanitization for all messages (XSS prevention)
- [x] Rate limiting: 10 messages/second per user
- [x] Message size limit: 10KB
- [x] No sensitive data in WebSocket URLs
- [x] HTTPS/WSS in production

## Performance Impact
**Expected Performance:**
- Message delivery: <500ms p95
- Typing indicator: <100ms
- Presence update: <200ms
- History load: <1s for 100 messages

**Resource Usage:**
- Memory: +50MB per 1000 connections
- CPU: +10% at 500 concurrent connections
- Database: +5GB/month for 1M messages

**Optimization Applied:**
- Message batching for delivery
- Presence updates debounced (200ms)
- Message history pagination (50 messages/page)
- Indexed database queries

## Deployment Notes
### Prerequisites
- [ ] Redis 6.0+ configured
- [ ] PostgreSQL full-text search extensions enabled
- [ ] WebSocket load balancer configured (sticky sessions)
- [ ] Environment variables set (see .env.example)

### Migration Steps
1. Run database migration: `npm run migrate:chat`
2. Deploy backend servers (rolling update, 1 at a time)
3. Deploy frontend (feature flag: `chat_enabled`)
4. Monitor error rates for 15 minutes
5. Enable for 10% of users (feature flag)
6. Gradually roll out to 100% over 48 hours

### Rollback Plan
1. Disable feature flag: `chat_enabled=false`
2. Revert frontend deployment
3. Revert backend deployment
4. Database rollback: `npm run migrate:rollback`

### Monitoring
- WebSocket connection count (alert if >80% capacity)
- Message delivery latency (alert if p95 >1s)
- Error rate (alert if >0.1%)
- Redis pub/sub lag (alert if >100ms)

## Future Considerations
### Potential Improvements
- End-to-end encryption
- Voice/video calling
- Message reactions and threading
- File sharing via chat
- Message translation

### Known Limitations
- Max 100 users per group chat
- No offline message storage on client
- Search limited to last 90 days
- No message editing after 5 minutes

### Related Features
- Notifications (issue #456) - Will trigger on new messages
- User status (issue #478) - Integrated with presence tracker
- Admin moderation tools (issue #523) - Needed for chat content review

## References
### Related Issues/PRs
- Design Document: #445
- API Spec: #447
- Load Testing Results: #451

### External Documentation
- Socket.IO docs: https://socket.io/docs/v4
- Redis pub/sub: https://redis.io/topics/pubsub

### Discussion
- Architecture review: [Link to discussion]
- Security review: [Link to security review]
```

---

## How Tiers Are Determined

### Automatic Calculation

The GitHub Actions workflow automatically calculates feature size:

```bash
LINES_ADDED=$(git diff --shortstat base...HEAD | grep -oP '\d+(?= insertion)')
LINES_DELETED=$(git diff --shortstat base...HEAD | grep -oP '\d+(?= deletion)')
LINES_CHANGED=$((LINES_ADDED + LINES_DELETED))

if [ $LINES_CHANGED -lt 200 ]; then
  TIER=1  # Small
elif [ $LINES_CHANGED -lt 1000 ]; then
  TIER=2  # Medium
else
  TIER=3  # Large
fi
```

### What Counts Toward Line Count

**Included:**
- All source code changes
- Configuration file changes
- Schema/migration files
- Test files

**Excluded:**
- Documentation files (*.md)
- Package lock files (package-lock.json, yarn.lock)
- Generated files
- Binary files

### Edge Cases

**What if my feature is 195 lines but very complex?**
- Use your judgment - create Tier 2 documentation anyway
- Quality over quantity
- The workflow won't block you, but good docs help

**What if my feature is 1200 lines but mostly boilerplate?**
- Still create Tier 3 documentation
- Document why it's boilerplate
- Explain what it does at a high level

**What if I have multiple small changes in one PR?**
- Lines are cumulative
- Multiple small changes together may trigger Tier 2/3
- Consider splitting into separate PRs if logically distinct

---

## Workflow Behavior by Tier

| Aspect | Tier 1 | Tier 2 | Tier 3 |
|--------|--------|--------|--------|
| **Lines Changed** | <200 | 200-1000 | >1000 |
| **Enforcement** | Warnings only | Blocks merge | Blocks merge |
| **Minimum Words** | 50 (recommended) | 100 (required) | 200 (required) |
| **Section Requirements** | All 4 recommended | All 4 required | All 4 required (detailed) |
| **Documentation Depth** | Brief context | Substantive | Comprehensive |
| **Merge Blocked If Missing** | No | Yes | Yes |
| **Review Requirement** | 1 approver | 1 approver | 2 approvers (recommended) |
| **Design Doc Required** | No | No | Recommended |

---

## Best Practices by Tier

### Tier 1 Best Practices
✅ **Do:**
- Create brief documentation anyway (helps reviewers)
- Fill in Overview and Goals at minimum
- Document why the change was made

❌ **Don't:**
- Skip documentation entirely (loses context)
- Write placeholder text
- Assume everyone knows the context

### Tier 2 Best Practices
✅ **Do:**
- Document before you start coding (clarifies requirements)
- Update docs as implementation evolves
- Include specific design decisions
- List key files with their purpose
- Document edge cases and how they're handled

❌ **Don't:**
- Write documentation as afterthought
- Copy-paste without customizing
- Skip the "why" behind decisions
- Leave sections with placeholder text

### Tier 3 Best Practices
✅ **Do:**
- Create design document before implementation
- Get design review approval
- Include architecture diagrams
- Document all major design decisions
- List all edge cases and their handling
- Include deployment and rollback plans
- Add monitoring and alerting strategy
- Document future improvements and known limitations

❌ **Don't:**
- Start coding without documentation
- Assume implementation details are self-explanatory
- Skip security considerations
- Forget deployment notes
- Ignore performance implications

---

## Examples of Each Tier

### Tier 1 Example: Change Button Color
- **Lines Changed:** 3
- **Documentation:** 75 words
- **Enforcement:** Warning only

### Tier 2 Example: Add Profile Form
- **Lines Changed:** 487
- **Documentation:** 342 words
- **Enforcement:** Required, blocks merge if missing

### Tier 3 Example: Real-time Chat
- **Lines Changed:** 2,847
- **Documentation:** 1,245 words
- **Enforcement:** Required, comprehensive

---

## Adjusting Tier Thresholds

The tier thresholds can be customized by editing `.github/workflows/feature-docs-check.yml`:

```yaml
# Current thresholds
if [ $LINES_CHANGED -lt 200 ]; then    # Tier 1
  tier=1
elif [ $LINES_CHANGED -lt 1000 ]; then  # Tier 2
  tier=2
else                                    # Tier 3
  tier=3
fi

# Example: More strict thresholds
if [ $LINES_CHANGED -lt 100 ]; then    # Tier 1: <100 lines
  tier=1
elif [ $LINES_CHANGED -lt 500 ]; then  # Tier 2: 100-500 lines
  tier=2
else                                   # Tier 3: >500 lines
  tier=3
fi
```

**Recommended Thresholds:**
- **Startup/Small Team:** 300 / 1500 (more lenient)
- **Medium Team:** 200 / 1000 (balanced - default)
- **Large Team/Enterprise:** 100 / 500 (more strict)

---

## FAQ

### Q: Can I override the tier for my feature?
**A:** The tier is automatically calculated. If you believe your feature needs more/less documentation than required, discuss with your team lead.

### Q: What if my feature touches generated code?
**A:** Generated code should be excluded from the line count. File an issue if the workflow incorrectly counts generated files.

### Q: Do test files count toward the line count?
**A:** Yes, test files count. If you're adding substantial tests, your tier may increase, which is appropriate since complex features need good documentation.

### Q: Can I split my large feature into multiple PRs to avoid Tier 3?
**A:** Splitting for logical reasons is fine. Splitting purely to avoid documentation is discouraged - large features deserve comprehensive documentation.

### Q: What if I'm refactoring without changing behavior?
**A:** Refactors still need documentation explaining:
- Why the refactor was needed
- What changed at a high level
- Any behavior differences (even subtle ones)
- Migration guide (if applicable)

---

**Last Updated:** 2025-11-13
**Version:** 1.0
**Maintained by:** DevOps Team
