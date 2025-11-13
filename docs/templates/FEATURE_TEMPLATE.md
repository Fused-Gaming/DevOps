# Feature: [Feature Name]

**Branch:** `feature/your-feature-name`
**Author:** [Your Name]
**Date:** [YYYY-MM-DD]
**Status:** [Planning | In Progress | Review | Completed]

---

## Overview

Provide a clear, concise description of what this feature does and why it exists.

**What problem does this solve?**
- [Problem statement]

**What value does it provide?**
- [Value proposition]

---

## Goals

### Project Alignment
How does this feature align with project goals and requirements?

- **Project Goal:** [Reference specific project objective]
- **Roadmap Item:** [Reference roadmap if applicable]
- **User Story:** [Reference user story/requirement]

### Success Criteria
What defines success for this feature?

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

---

## Implementation

### Technical Approach
Describe the technical implementation approach.

**Architecture:**
- [Component/Module 1]: Purpose and responsibility
- [Component/Module 2]: Purpose and responsibility

**Key Files Changed:**
- `path/to/file1.js` - [Purpose of changes]
- `path/to/file2.js` - [Purpose of changes]

**Dependencies Added:**
- `package-name@version` - [Why it's needed]

### Design Decisions
Document important design decisions and alternatives considered.

**Decision 1:** [What was decided]
- **Why:** [Reasoning]
- **Alternatives considered:** [What else was evaluated]

**Decision 2:** [What was decided]
- **Why:** [Reasoning]
- **Alternatives considered:** [What else was evaluated]

### API Changes
If applicable, document any API changes.

```javascript
// New endpoint example
POST /api/feature-endpoint
{
  "param1": "value",
  "param2": 123
}

// Response
{
  "status": "success",
  "data": { ... }
}
```

---

## Testing

### Test Strategy
Describe how this feature was tested.

**Unit Tests:**
- [ ] [Test category 1] - Coverage: XX%
- [ ] [Test category 2] - Coverage: XX%

**Integration Tests:**
- [ ] [Test scenario 1]
- [ ] [Test scenario 2]

**Manual Testing:**
- [ ] [Manual test case 1]
- [ ] [Manual test case 2]

### Test Coverage
- **Overall Coverage:** XX%
- **New Code Coverage:** XX%

### Edge Cases Tested
- [Edge case 1] - ✅ Handled
- [Edge case 2] - ✅ Handled
- [Known Limitation] - ⚠️ Documented

---

## Security Considerations

### Security Review
- [ ] No sensitive data exposed
- [ ] Input validation implemented
- [ ] Authentication/authorization checked
- [ ] SQL injection prevention verified
- [ ] XSS prevention verified
- [ ] CSRF protection applied (if applicable)

### Secrets/Credentials
- [ ] No hardcoded secrets
- [ ] All secrets use environment variables
- [ ] .env.example updated (if needed)

---

## Performance Impact

**Expected Performance:**
- Response time: [X ms]
- Database queries: [X queries]
- Memory usage: [Negligible | Low | Medium | High]

**Optimization Notes:**
- [Any performance optimizations applied]

---

## Documentation Updates

### Files Updated
- [ ] README.md - [What was added/changed]
- [ ] CHANGELOG.md - [Version and changes documented]
- [ ] API documentation - [If applicable]
- [ ] User guide - [If applicable]

### Team Communication
- [ ] Team notified in [channel/meeting]
- [ ] Demo prepared/completed
- [ ] Knowledge transfer completed

---

## Deployment Notes

### Prerequisites
- [ ] Environment variables configured
- [ ] Database migrations ready (if needed)
- [ ] Third-party services configured

### Deployment Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Rollback Plan
If issues occur after deployment:
1. [Rollback step 1]
2. [Rollback step 2]

---

## Future Considerations

### Potential Improvements
- [Improvement 1]
- [Improvement 2]

### Known Limitations
- [Limitation 1]
- [Limitation 2]

### Related Features
- [Related feature or future work item]

---

## References

### Related Issues/PRs
- Issue #XXX: [Link to issue]
- PR #XXX: [Link to related PR]

### External Documentation
- [Link to relevant external docs]
- [Link to design document]

### Discussion
- [Link to discussion thread/decision log]

---

## Sign-off

**Developer:** [Name] - [Date]
**Reviewed by:** [Name] - [Date]
**Approved by:** [Name] - [Date]

---

## Notes

Add any additional notes, warnings, or context here.
