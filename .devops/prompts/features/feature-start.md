# Feature Start Workflow

You are helping a developer start a new feature branch with proper documentation from the beginning.

## Step 1: Gather Information

Ask the developer:
1. **Feature name** (will be used in branch name)
2. **Brief description** (1-2 sentences)
3. **Which project goal/requirement** does this address?

## Step 2: Create Feature Branch

```bash
git checkout -b feature/{feature-name}
```

Example: `git checkout -b feature/dark-mode-toggle`

## Step 3: Create Documentation Scaffold

```bash
# Ensure directories exist
mkdir -p docs/features

# Copy template
cp docs/templates/FEATURE_TEMPLATE.md docs/features/{feature-name}.md
```

## Step 4: Pre-fill Documentation

Open the documentation file and help the developer fill in the initial sections:

### Fill in NOW (before coding):

**Header Section:**
- Feature name
- Branch name
- Author name
- Current date
- Status: "Planning"

**Overview Section:**
Guide them to answer:
- What problem does this solve? (2-3 sentences)
- What value does it provide? (2-3 sentences)

**Goals Section:**
Help them document:
- **Project Alignment:** Which specific project goal/requirement does this address?
- **Success Criteria:** What defines success? (at least 3 specific, measurable criteria)

Example success criteria:
- [ ] Users can toggle dark mode from settings
- [ ] Theme preference persists across sessions
- [ ] All pages support both themes

### Mark for LATER (during development):

**Implementation Section:**
- Leave placeholder: "To be completed during development"
- Remind: "Update this as you build"

**Testing Section:**
- Leave placeholder: "To be completed with tests"
- Remind: "Document test strategy and coverage"

## Step 5: Initial Commit

```bash
git add docs/features/{feature-name}.md
git commit -m "docs: initialize feature documentation for {feature-name}"
git push -u origin feature/{feature-name}
```

## Step 6: Provide Next Steps

Tell the developer:

✅ **You're all set!** Your feature branch and documentation are ready.

**As you develop:**
1. Update the Implementation section with:
   - Technical approach
   - Key files you're changing
   - Important design decisions

2. Update the Testing section with:
   - Test strategy (unit, integration, manual)
   - Coverage percentages
   - Edge cases you've tested

3. Update the Status field:
   - "Planning" → "In Progress" → "Review" → "Completed"

**Before creating a PR:**
- Run `devops-feature-validate` to check documentation completeness
- Ensure all 4 required sections are filled in
- Update CHANGELOG.md with your changes

**Helpful commands:**
- `devops-feature-validate` - Check if documentation is complete
- `devops-merge` - Full pre-merge checklist (includes docs check)

## Step 7: Create Quick Reference Card

Display this summary:

```
╔════════════════════════════════════════════════════════╗
║  FEATURE: {feature-name}                               ║
║  BRANCH: feature/{feature-name}                        ║
╚════════════════════════════════════════════════════════╝

📝 DOCUMENTATION: docs/features/{feature-name}.md
✅ Initial sections completed: Overview, Goals
⏳ Complete during dev: Implementation, Testing

NEXT STEPS:
1. Start coding your feature
2. Update docs/features/{feature-name}.md as you go
3. Run 'devops-feature-validate' before creating PR
4. All checks must pass before merge

REQUIRED BEFORE MERGE:
- [ ] All 4 sections complete (Overview, Goals, Implementation, Testing)
- [ ] Minimum 100 words of content
- [ ] References project goals/requirements
- [ ] Test coverage documented
- [ ] CHANGELOG.md updated
```

## Additional Guidance

**If they ask about section length:**
- Overview: 2-5 sentences minimum
- Goals: At least project alignment + 3 success criteria
- Implementation: Key approach + 3-5 key files + 1-2 design decisions
- Testing: Strategy + coverage % + 3+ edge cases

**If they ask "What if I don't know the implementation yet?"**
- That's perfect! Just fill in Overview and Goals now
- These help you clarify requirements before coding
- Update Implementation and Testing as you develop

**If they say "This seems like a lot of work":**
- Initial setup: 5 minutes
- Updates during dev: 2-3 minutes per major change
- Benefit: 40% faster code reviews, easier maintenance
- The workflow enforces this automatically to ensure quality

**If they're working on a small feature (<200 lines):**
- Still create documentation (helps with context)
- Can be brief, but all 4 sections required
- Quality over quantity - clear and concise is fine

Remember: You're setting them up for success. Good documentation now saves hours of confusion later!
