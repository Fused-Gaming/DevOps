# Feature Documentation Guide

## Why Feature Documentation Matters

Feature documentation serves as the single source of truth for:
- **Project alignment**: Ensuring features match project goals and requirements
- **Team coordination**: Keeping everyone informed about what's being built and why
- **Code review quality**: Providing context for reviewers to evaluate changes
- **Future maintenance**: Helping developers understand feature decisions months/years later
- **Compliance**: Meeting regulatory or organizational documentation requirements

---

## When to Document

### Required Documentation
Feature documentation is **REQUIRED** for:

✅ **All feature branches** (`feature/*` or `feat/*`)
✅ **Significant new functionality** (>500 lines of code)
✅ **User-facing features** (UI changes, API endpoints, new workflows)
✅ **Architectural changes** (new patterns, major refactors)
✅ **Third-party integrations** (new services, APIs, SDKs)

### Optional Documentation
Documentation is helpful but not mandatory for:

ℹ️ Bug fixes (`bugfix/*` branches)
ℹ️ Hot fixes (`hotfix/*` branches)
ℹ️ Minor refactors (internal code cleanup)
ℹ️ Documentation updates (`docs/*` branches)

---

## Documentation Workflow

### 1. Start with Planning (Before Coding)

When you create a feature branch, start your documentation:

```bash
# Create feature branch
git checkout -b feature/user-authentication

# Create documentation from template
cp docs/templates/FEATURE_TEMPLATE.md docs/features/user-authentication.md

# Fill in planning sections
vim docs/features/user-authentication.md
```

**What to document now:**
- Overview and goals
- Project alignment
- Technical approach (high-level)
- Success criteria

**Benefits:**
- Clarifies requirements before coding
- Ensures alignment with project goals
- Provides reference during development
- Makes code review easier

### 2. Update During Development

As you implement, keep documentation current:

```bash
# After implementing a component
vim docs/features/user-authentication.md
# Update: Implementation details, design decisions

# After writing tests
vim docs/features/user-authentication.md
# Update: Testing section, coverage numbers
```

**What to document:**
- Key files changed
- Design decisions and alternatives
- API changes
- Test coverage

### 3. Finalize Before PR

Before creating your pull request:

```bash
# Final documentation review
vim docs/features/user-authentication.md

# Complete checklist:
# - All sections filled in
# - Testing results documented
# - Security considerations reviewed
# - Deployment notes added
```

**What to verify:**
- All required sections complete
- Test coverage documented
- Security review completed
- Deployment plan outlined

### 4. Include in PR

```bash
# Add documentation to your commit
git add docs/features/user-authentication.md
git commit -m "docs: add feature documentation for user authentication"

# Push with your feature
git push origin feature/user-authentication
```

---

## Documentation Structure

### Minimum Required Sections

Your feature documentation **MUST** include:

#### 1. Overview
**Purpose:** Quick understanding of what and why

**Minimum content:**
- 2-3 sentence description
- Problem statement
- Value proposition

**Example:**
```markdown
## Overview

This feature implements user authentication using JWT tokens. It solves the
problem of users needing to log in on every request by maintaining session
state securely. This provides better UX and reduces server load.
```

#### 2. Goals
**Purpose:** Ensure alignment with project objectives

**Minimum content:**
- Reference to project goal/requirement
- Success criteria (3+ items)

**Example:**
```markdown
## Goals

### Project Alignment
- **Project Goal:** Implement secure user management (Q4 Roadmap)
- **User Story:** As a user, I want to stay logged in between sessions

### Success Criteria
- [ ] Users can login and receive JWT token
- [ ] Token refreshes automatically before expiry
- [ ] Logout invalidates token immediately
```

#### 3. Implementation
**Purpose:** Document technical approach and decisions

**Minimum content:**
- Technical approach summary
- Key files changed (5+ files)
- At least 1 design decision

**Example:**
```markdown
## Implementation

### Technical Approach
Using passport-jwt middleware with Redis for token blacklisting.

**Key Files Changed:**
- `src/auth/jwt.strategy.js` - JWT validation logic
- `src/auth/auth.controller.js` - Login/logout endpoints
- `src/middleware/auth.js` - Authentication middleware

### Design Decisions
**Decision:** Use Redis for token blacklist
- **Why:** Fast lookup for invalidated tokens
- **Alternatives:** Database storage (too slow), in-memory (not scalable)
```

#### 4. Testing
**Purpose:** Verify feature quality and coverage

**Minimum content:**
- Test strategy (unit + integration)
- Coverage percentage
- Edge cases tested (3+ cases)

**Example:**
```markdown
## Testing

### Test Strategy
**Unit Tests:** JWT generation, validation, expiry - Coverage: 95%
**Integration Tests:** Login flow, token refresh, logout

### Edge Cases Tested
- Expired token - ✅ Returns 401
- Invalid token format - ✅ Returns 401
- Concurrent logout - ✅ Properly synchronized
```

---

## Documentation Quality Standards

### Minimum Requirements (Enforced by Workflow)

✅ **File exists** in approved location
✅ **All 4 required sections** present
✅ **Minimum 100 words** of content
✅ **Updated in PR** (for feature changes)

### Quality Guidelines (Recommended)

📝 **Clarity**: Write for someone new to the project
📝 **Completeness**: Include enough detail to understand decisions
📝 **Conciseness**: Be thorough but not verbose
📝 **Currency**: Keep documentation updated with code changes

### Common Mistakes to Avoid

❌ **Too brief**: "This adds authentication" (not enough detail)
❌ **Too late**: Writing docs after PR is created (makes review harder)
❌ **Missing context**: No explanation of why decisions were made
❌ **Stale docs**: Documentation doesn't match implementation

---

## Documentation Locations

### Primary Location (Recommended)
```
docs/features/{feature-name}.md
```

**Example:**
```
docs/features/user-authentication.md
docs/features/payment-processing.md
docs/features/email-notifications.md
```

**Pros:**
- Centralized documentation
- Easy to find and browse
- Works well for most features

### Alternative Locations

For complex features with multiple docs:
```
docs/features/{feature-name}/README.md
docs/features/{feature-name}/architecture.md
docs/features/{feature-name}/api-spec.md
```

For DevOps-specific features:
```
.devops/features/{feature-name}.md
```

---

## Integration with DevOps Workflow

### Automated Checks

The `feature-docs-check.yml` workflow automatically:

1. **Detects feature branches** (feature/* or feat/*)
2. **Checks for documentation** in approved locations
3. **Validates content** (required sections, word count)
4. **Verifies updates** (docs changed in PR)
5. **Comments on PR** if documentation missing
6. **Blocks merge** until documentation complete

### Manual Checks

Before creating PR, run:

```bash
# Use DevOps merge preparation
devops-merge

# The workflow will check:
# - Documentation exists
# - All sections complete
# - Tests documented
# - CHANGELOG updated
```

---

## Quick Start Examples

### Example 1: Simple Feature

```bash
# 1. Create branch
git checkout -b feature/dark-mode

# 2. Create minimal documentation
cat > docs/features/dark-mode.md << 'EOF'
# Feature: Dark Mode

## Overview
Adds dark mode toggle to user preferences. Improves accessibility and
reduces eye strain for users working at night.

## Goals
- **Project Goal:** Accessibility improvements (2025 Q1)
- Success criteria: Toggle in settings, persists across sessions,
  applies to all pages

## Implementation
- Modified: src/components/ThemeProvider.js, src/styles/themes.js
- Decision: Use CSS variables for easy theme switching
- Testing: Unit tests for theme logic, visual regression tests

## Testing
- Unit coverage: 90%
- Tested edge cases: System preference sync, invalid stored value,
  theme switching performance
EOF

# 3. Implement feature
# ... code ...

# 4. Commit together
git add docs/features/dark-mode.md src/
git commit -m "feat: add dark mode toggle"
```

### Example 2: Complex Feature

```bash
# 1. Create branch and directory
git checkout -b feature/real-time-chat
mkdir -p docs/features/real-time-chat

# 2. Create comprehensive documentation
cp docs/templates/FEATURE_TEMPLATE.md docs/features/real-time-chat/README.md
vim docs/features/real-time-chat/README.md

# 3. Add supplementary docs
touch docs/features/real-time-chat/websocket-protocol.md
touch docs/features/real-time-chat/scaling-strategy.md

# 4. Implement and keep docs updated
# ... code ...

# 5. Commit documentation updates as you go
git add docs/features/real-time-chat/
git commit -m "docs: update real-time chat implementation details"
```

---

## FAQ

### Q: Do I need to document every small change?
**A:** No. Focus on feature branches with significant new functionality. Bug fixes and minor changes don't require full feature documentation.

### Q: When should I create the documentation?
**A:** Start when you create the feature branch (planning sections), update during development, finalize before PR.

### Q: What if I don't know the implementation details yet?
**A:** Document what you know (overview, goals, approach). Update implementation details as you code.

### Q: Can I skip sections that don't apply?
**A:** The 4 core sections (Overview, Goals, Implementation, Testing) are required. Other sections are optional but recommended.

### Q: What if my feature is too simple for all this?
**A:** Use the minimum requirements. A simple feature can have brief sections, but all 4 must be present.

### Q: How do I handle documentation for experimental features?
**A:** Mark status as "Experimental" and document assumptions, expected outcomes, and evaluation criteria.

### Q: What if I'm documenting a refactor, not a new feature?
**A:** For major refactors, create documentation explaining why, what changed, migration guide, and testing approach.

### Q: How long should documentation be?
**A:** Minimum 100 words (enforced). Typical: 300-500 words for simple features, 800-1500 for complex features.

---

## Tools and Resources

### Templates
- **Feature Template:** `docs/templates/FEATURE_TEMPLATE.md`
- Copy and fill in for your feature

### Workflows
- **Feature Docs Check:** `.github/workflows/feature-docs-check.yml`
- Automatically validates documentation on PR

### Commands
```bash
# Check documentation before PR
devops-merge

# View documentation quality
wc -w docs/features/*.md

# Find missing documentation
find docs/features -type f -name "*.md" -size -1k
```

### Best Practices Reference
- **Writing:** Clear, concise, context-rich
- **Timing:** Start early, update often, finalize before PR
- **Review:** Treat docs like code - review and iterate

---

## Getting Help

### Documentation Issues
- Check this guide first
- Review examples in `docs/features/`
- Ask in #dev-docs channel

### Workflow Issues
- Workflow failing? Check required sections
- Can't find where to document? Use `docs/features/{name}.md`
- Need to bypass check temporarily? Get lead approval

### Questions
- **"What should I document?"** - See "Minimum Required Sections"
- **"How much detail?"** - Enough for someone new to understand your decisions
- **"When is it done?"** - When all required sections are complete and accurate

---

## Continuous Improvement

This guide and workflow will evolve based on team feedback. Suggestions welcome!

**Last Updated:** 2025-11-13
**Maintained by:** DevOps Team
**Feedback:** Create issue or PR to this document
