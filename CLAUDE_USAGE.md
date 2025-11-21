# Claude Code Usage Tracking

This file automatically tracks Claude Code usage for this repository.

## Usage Summary

| Date | Feature/Fix | Tokens Used | Estimated Cost | Session ID |
|------|-------------|-------------|----------------|------------|
| 2025-11-20 | feat: add multi-subdomain deployment with configuration wizard | 14520 | $0.0940 | 3666e3a |
| 2025-11-19 | feat: add one-liner auto-deploy and webhook automation | 8520 | $0.0550 | fa4f76a |
| 2025-11-19 | feat: add SSH deployment script for preview.vln.gg server | 11700 | $0.0760 | 8e3bf80 |
| 2025-11-19 | feat: add Next.js DevOps control panel with VLN styling | 78500 | $0.5080 | ecc4671 |
| 2025-11-19 | feat: add automated milestone tracking system | 18600 | $0.1200 | b74885e |
| 2025-11-18 | feat: add fully automated GitHub to Vercel deployment | 12240 | $0.0790 | a75f65f |
| 2025-11-18 | feat: add Vercel deployment with web UI and Telegram login | 15900 | $0.1030 | f3b628b |
| 2025-11-18 | feat: add CNAME generation and automatic update checker | 4208 | $0.0260 | 4091de0e |
| 2025-11-18 | feat: add automated Claude usage tracking workflow | 7736 | $0.0500 | 312682ad |
| 2025-11-18 | chore: update SEO and marketing files | 6452 | $0.0420 | 8756b37e |
| 2025-11-16 | Add MVP plan documentation for DevOps re | 36440 | $0.2390 | 42e0c3f7 |
| *Initial setup* | Usage tracking initialized | 0 | $0.00 | - |

## Total Accumulated Usage

- **Total Tokens**: 214816
- **Total Estimated Cost**: $1.39
- **Sessions**: 12

---

## Pricing Reference

Claude Sonnet 4.5 Pricing (as of 2025):
- Input tokens: $3.00 per million tokens
- Output tokens: $15.00 per million tokens

## Notes

This file is automatically updated by the Claude Usage Tracking workflow. Each commit will:
- Record the date and time
- Capture the commit message (feature/fix description)
- Track token usage from the Claude Code session
- Calculate estimated costs based on current pricing
- Accumulate totals over time

### Update Mechanism

The tracking is performed by:
1. **GitHub Actions Workflow** (`.github/workflows/claude-usage-tracking.yml`) - Triggers on every push
2. **Tracking Script** (`scripts/track-claude-usage.sh`) - Calculates usage based on code changes

### Token Estimation Method

- ~12 tokens per line of code changed (average)
- +500 token baseline for context
- 70% input tokens, 30% output tokens
- Based on git diff statistics

### Recent Updates (2025-11-20)

**Fixed Issues:**
- ✅ Corrected file formatting and corrupted entries
- ✅ Updated totals to accurately reflect all sessions
- ✅ Added missing entries from recent feature branches
- ✅ Reconstructed history from git logs

**Known Limitations:**
- Estimates are approximations based on code changes
- Does not include exploratory conversations
- Tracking only activates on push to main branch (by default)

---

*Last Updated: 2025-11-20*
*Tracking Script Version: 1.0.0*
*Documentation Updated: 2025-11-20*
