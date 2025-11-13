# Feature Documentation Validation

You are validating feature documentation before a PR is created. Be thorough but constructive.

## Step 1: Identify Current Branch

```bash
CURRENT_BRANCH=$(git branch --show-current)
echo "Current branch: $CURRENT_BRANCH"
```

Check if this is a feature branch:
- If branch starts with `feature/` or `feat/` → Continue validation
- If not → Inform user this validation is only for feature branches

Extract feature name from branch (everything after `feature/` or `feat/`)

## Step 2: Locate Documentation

Look for documentation in these locations (in order of preference):

```bash
FEATURE_NAME="${CURRENT_BRANCH#feature/}"
FEATURE_NAME="${FEATURE_NAME#feat/}"

# Check these paths
docs/features/${FEATURE_NAME}.md
docs/features/${FEATURE_NAME}/README.md
.devops/features/${FEATURE_NAME}.md
FEATURES/${FEATURE_NAME}.md
```

**If found:**
- ✅ Note the location
- Proceed to content validation

**If NOT found:**
- ❌ Documentation missing!
- Provide clear instructions:
  ```
  📝 Feature documentation not found!

  Expected location: docs/features/${FEATURE_NAME}.md

  To create it:
  1. Run: cp docs/templates/FEATURE_TEMPLATE.md docs/features/${FEATURE_NAME}.md
  2. Fill in the required sections
  3. Commit: git add docs/features/${FEATURE_NAME}.md

  Or use: devops-feature-start (if starting fresh)
  ```
- STOP validation here

## Step 3: Validate Required Sections

Check that these sections exist and are filled in:

### Section 1: Overview
**Required markers:** `## Overview`

**Validation:**
- [ ] Section exists
- [ ] Contains "What problem does this solve?" or problem statement
- [ ] Contains "What value does it provide?" or value proposition
- [ ] Minimum 2 sentences (not counting headers)

**If missing/incomplete:**
```
❌ Overview section incomplete

Required content:
- Clear description of what the feature does
- Problem statement (what problem it solves)
- Value proposition (what benefit it provides)

Example:
## Overview

This feature implements dark mode toggle in user preferences. It solves
the problem of eye strain for users working at night. This provides better
accessibility and improved user experience.
```

### Section 2: Goals
**Required markers:** `## Goals`

**Validation:**
- [ ] Section exists
- [ ] Contains project alignment (references a project goal/requirement)
- [ ] Contains success criteria (at least 3 items)
- [ ] Success criteria are specific and measurable

**If missing/incomplete:**
```
❌ Goals section incomplete

Required content:
- Project alignment (which goal/requirement does this address?)
- Success criteria (3+ specific, measurable items)

Example:
## Goals

### Project Alignment
- **Project Goal:** Accessibility improvements (2025 Q1 Roadmap)
- **User Story:** As a user, I want dark mode for nighttime use

### Success Criteria
- [ ] Users can toggle dark mode from settings
- [ ] Theme preference persists across sessions
- [ ] All pages support both light and dark themes
```

### Section 3: Implementation
**Required markers:** `## Implementation`

**Validation:**
- [ ] Section exists
- [ ] Contains technical approach description
- [ ] Lists key files changed (at least 3 files OR explains why fewer)
- [ ] Documents at least 1 design decision with reasoning

**If missing/incomplete:**
```
❌ Implementation section incomplete

Required content:
- Technical approach (how you built it)
- Key files changed (3-5 main files with purpose)
- Design decisions (at least 1 decision + why + alternatives)

Example:
## Implementation

### Technical Approach
Using CSS variables for theme switching, controlled by React Context.

**Key Files Changed:**
- src/components/ThemeProvider.js - Theme state management
- src/styles/themes.js - Color definitions
- src/components/Settings.js - Toggle UI

### Design Decisions
**Decision:** Use CSS variables instead of className switching
- **Why:** Instant updates without component re-renders
- **Alternatives:** Sass themes (requires page reload), styled-components themes (performance overhead)
```

### Section 4: Testing
**Required markers:** `## Testing`

**Validation:**
- [ ] Section exists
- [ ] Contains test strategy (unit/integration/manual)
- [ ] Includes coverage percentage OR explains testing approach
- [ ] Lists edge cases tested (at least 3)

**If missing/incomplete:**
```
❌ Testing section incomplete

Required content:
- Test strategy (unit, integration, manual testing)
- Coverage percentage OR testing approach
- Edge cases tested (3+ cases with results)

Example:
## Testing

### Test Strategy
**Unit Tests:** Theme switching logic - Coverage: 90%
**Integration Tests:** Settings page interaction with theme
**Manual Tests:** Visual verification across all pages

### Edge Cases Tested
- System preference sync - ✅ Works correctly
- Invalid stored theme value - ✅ Falls back to light mode
- Theme switching during page transitions - ✅ No flicker
```

## Step 4: Validate Content Quality

### Word Count Check
```bash
WORD_COUNT=$(wc -w < docs/features/${FEATURE_NAME}.md)
```

**Validation:**
- Minimum: 100 words (excluding code blocks)
- Recommended: 300-500 words for simple features
- Complex features: 800+ words

**If below minimum:**
```
⚠️ Documentation word count: ${WORD_COUNT} words (minimum: 100)

Your documentation is too brief. Please add more detail to:
- Explain your technical approach more thoroughly
- Document why you made specific design decisions
- Describe edge cases and how you handled them
```

### Project Alignment Check
Search for keywords indicating project alignment:
- "project goal", "roadmap", "requirement", "objective", "user story", "guideline"

**If none found:**
```
⚠️ Warning: Documentation doesn't clearly reference project goals

Please add context about how this feature aligns with:
- Project roadmap items
- Specific requirements
- User stories
- Business objectives

This ensures the feature doesn't deviate from planned direction.
```

### Design Decisions Check
Search for decision documentation:
- "Decision:", "Alternative:", "Why:", "Considered:"

**If none found:**
```
⚠️ Warning: No design decisions documented

Document at least one key decision you made:
- What options did you consider?
- Which did you choose and why?
- What were the tradeoffs?

This helps future developers understand your reasoning.
```

## Step 5: Check Documentation Freshness

```bash
# Check if documentation was updated in current branch
git fetch origin main 2>/dev/null || git fetch origin master 2>/dev/null

if git diff --name-only origin/main...HEAD | grep -q "docs/features/${FEATURE_NAME}.md"; then
  echo "✅ Documentation was updated in this branch"
else
  echo "⚠️ Documentation exists but wasn't updated in this branch"
fi
```

**If not updated:**
```
⚠️ Documentation exists but wasn't modified in this branch

If you made changes to the feature, please update the documentation:
1. Update Implementation section with new details
2. Update Testing section with new test results
3. Commit the documentation changes
```

## Step 6: Generate Validation Report

Create a comprehensive report:

```
╔═══════════════════════════════════════════════════════════╗
║  FEATURE DOCUMENTATION VALIDATION REPORT                  ║
╚═══════════════════════════════════════════════════════════╝

Feature: {feature-name}
Branch: {current-branch}
Documentation: {path-to-docs}

REQUIRED SECTIONS
├─ Overview          [✅/❌]
├─ Goals             [✅/❌]
├─ Implementation    [✅/❌]
└─ Testing           [✅/❌]

QUALITY CHECKS
├─ Word count        [✅/❌] ({word-count} words, min: 100)
├─ Project alignment [✅/⚠️]
├─ Design decisions  [✅/⚠️]
└─ Updated in branch [✅/⚠️]

OVERALL STATUS: [✅ READY FOR PR / ⚠️ NEEDS IMPROVEMENT / ❌ BLOCKED]

{Detailed findings here}

NEXT STEPS:
{List of actions needed, if any}
```

## Step 7: Provide Actionable Feedback

### If ALL checks pass (✅):
```
🎉 Excellent! Your feature documentation is complete and ready.

✅ All required sections present and filled in
✅ Content quality meets standards
✅ Documentation updated in this branch

You're ready to create a PR! The GitHub Actions workflow will
automatically validate your documentation when you push.

Recommended next steps:
1. Run 'devops-merge' for full pre-merge checklist
2. Ensure all tests pass
3. Update CHANGELOG.md
4. Create your pull request
```

### If some checks need improvement (⚠️):
```
✅ Good progress! Your documentation is mostly complete.

Required sections: ✅ Complete
Content quality: ⚠️ Could be improved

Recommendations:
{List specific improvements}

Your documentation will likely pass the automated check, but
improving these areas will make code review easier and help
future developers.
```

### If critical checks fail (❌):
```
❌ Documentation needs work before PR

Issues found:
{List missing/incomplete sections}

Action required:
{Specific steps to fix each issue}

Once fixed:
1. Commit documentation changes
2. Run 'devops-feature-validate' again
3. All checks must pass before creating PR

Need help? See docs/FEATURE-DOCUMENTATION-GUIDE.md
```

## Step 8: Estimate Time to Fix

Based on issues found, estimate time needed:

- Missing section: ~5 minutes each
- Incomplete section: ~2-3 minutes each
- Quality improvements: ~5-10 minutes
- Total: X minutes

Tell the user:
```
⏱️ Estimated time to address issues: {X} minutes

This small investment now will save hours during code review and
future maintenance. Good documentation is a gift to your future self!
```

## Additional Validations (Optional but Recommended)

### Check for Common Issues:

**Placeholder text still present:**
```bash
if grep -q "TODO" docs/features/${FEATURE_NAME}.md; then
  echo "⚠️ Found TODO markers - please replace with actual content"
fi
```

**Example/template text not customized:**
```bash
if grep -q "Example:" docs/features/${FEATURE_NAME}.md; then
  echo "⚠️ Contains 'Example:' - ensure you've customized template text"
fi
```

**Links are broken:**
```bash
# Check for markdown links
if grep -o '\[.*\](.*)' docs/features/${FEATURE_NAME}.md | grep -q 'TODO\|XXX\|LINK'; then
  echo "⚠️ Found placeholder links - please add actual URLs"
fi
```

## Remember

**Be constructive:** Documentation is a skill that improves with practice. Praise what's done well, guide improvement for what's not.

**Context matters:** A small feature can have brief documentation, but all 4 sections are still required.

**Enforce standards, enable success:** The goal is quality documentation that helps the team, not bureaucracy for its own sake.
