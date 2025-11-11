# Effective Claude Prompts for DevOps Operations

## Your Proven Pattern: Iterative Pipeline Checks

Your approach is excellent because it follows a **state-checking → action → verification → repeat** loop. Here's how to optimize and expand it:

---

## 🎯 Master DevOps Prompt Template

```markdown
# Pipeline Health Check & Recovery

## Execution Mode: Iterative with Progress Tracking

Check our CI/CD pipeline status and execute recovery procedures with terminal progress indicators.

### Phase 1: Status Assessment
1. Check last commit status: `git log -1 --pretty=format:"%H %s" && git status`
2. Fetch latest CI/CD results from GitHub Actions/GitLab CI/Jenkins
3. Parse build logs for failures
4. Generate initial status report

### Phase 2: Failure Recovery (if needed)
If any builds failed:
- Extract error messages from logs
- Identify root cause (dependency, syntax, test failure, deployment)
- Apply fix based on failure type
- Commit fix with conventional commit message
- Push and re-check status
- **LOOP**: Repeat Phase 1 until all builds pass

### Phase 3: Pre-Merge Validation (only if Phase 2 passed)
Run this checklist with terminal progress bar:

[█░░░░░░░░░] 1/9 Cleanup scripts (remove debug logs, temp files)
[██░░░░░░░░] 2/9 Update CHANGELOG.md with new changes
[███░░░░░░░] 3/9 Update PROJECT_STATUS.md with current sprint status
[████░░░░░░] 4/9 Update README.md (installation, usage, new features)
[█████░░░░░] 5/9 Review unfinished deliverables (check TODO, FIXME comments)
[██████░░░░] 6/9 Update VERSION file (semantic versioning)
[███████░░░] 7/9 Organize project root (move stray .md files to /docs)
[████████░░] 8/9 Wait for all GitHub Actions to complete
[█████████░] 9/9 Final verification - all green?

### Phase 4: Merge Readiness
If all checks pass:
- Verify branch is up-to-date with main/develop
- Check for merge conflicts
- Generate merge command or create PR
- Print final summary

### Phase 5: Post-Merge Cleanup
- Delete local feature branch
- Pull latest changes
- Verify deployment to staging/production

## Output Requirements
- Real-time progress updates
- Color-coded status (✓ green, ✗ red, ⚠ yellow)
- Error logs with file:line references
- Actionable recommendations for each failure
- Final status summary with metrics

## Error Handling
- Maximum 3 retry attempts per failed check
- Escalate to manual intervention if auto-fix fails
- Log all actions to `devops-log-$(date).txt`
```

---

## 📚 DevOps Prompt Library

### 1. **Pre-Commit Quality Gate**
```markdown
Run pre-commit quality checks before allowing commit:

1. **Linting**: Run ESLint/Pylint/RuboCop with auto-fix
2. **Type Checking**: Run TypeScript/MyPy strict mode
3. **Unit Tests**: Run fast tests only (< 30s)
4. **Format**: Run Prettier/Black auto-format
5. **Security**: Scan for secrets (git-secrets, trufflehog)
6. **Dependencies**: Check for vulnerabilities (npm audit, pip-audit)

If any check fails:
- Show specific failures with file paths
- Apply auto-fixes where possible
- Block commit if critical issues remain
- Suggest fixes for manual issues

Only proceed with commit if all checks pass.
```

### 2. **CI/CD Pipeline Debugger**
```markdown
Debug failed CI/CD pipeline with systematic approach:

## Step 1: Identify Failure Point
- Fetch latest pipeline run from GitHub Actions
- Parse YAML workflow file
- Identify which job/step failed
- Extract error messages and exit codes

## Step 2: Local Reproduction
- Recreate the exact environment (Docker image, Node version, etc.)
- Run the failed command locally
- Capture detailed error output

## Step 3: Root Cause Analysis
Check common failure categories:
- [ ] Dependency version mismatch
- [ ] Environment variable missing
- [ ] File permission issues
- [ ] Network/API timeout
- [ ] Flaky test
- [ ] Resource constraints (memory, disk)

## Step 4: Apply Fix
Based on root cause:
- Update package.json/requirements.txt versions
- Add missing env vars to .env.example
- Fix file permissions in CI config
- Add retry logic for network calls
- Mark flaky tests as @skip with ticket reference
- Increase resource limits in CI config

## Step 5: Verification
- Push fix to feature branch
- Monitor new pipeline run
- Compare before/after build times
- Document fix in troubleshooting guide

## Step 6: Prevention
- Add pre-commit hook to catch this earlier
- Update CI/CD workflow with better error messages
- Add this failure pattern to runbook
```

### 3. **Release Preparation Automation**
```markdown
Prepare for production release with zero-downtime checklist:

## Pre-Release Validation (30-45 min)

### Code Quality
[█░░░] Run full test suite (unit, integration, e2e)
[██░░] Check code coverage (minimum 80%)
[███░] Run security audit (Snyk, npm audit, OWASP)
[████] Verify no console.logs or debug statements

### Documentation
[█░░░] Update CHANGELOG.md with all changes since last release
[██░░] Update API documentation (OpenAPI/Swagger)
[███░] Update deployment runbook
[████] Create release notes for stakeholders

### Infrastructure
[█░░░] Verify staging environment matches production
[██░░] Run database migration dry-run
[███░] Check disk space and resource availability
[████] Verify backup systems are operational

### Dependencies
[█░░░] Update all patch-level dependencies
[██░░] Check for breaking changes in minor updates
[███░] Verify third-party API status pages
[████] Test payment gateway in sandbox

### Rollback Plan
[█░░░] Tag current production as rollback point
[██░░] Document rollback procedure
[███░] Verify rollback can complete in < 5 minutes
[████] Assign rollback decision maker

## Release Execution
If all checks pass:
1. Merge to main branch
2. Tag with semantic version: `v{major}.{minor}.{patch}`
3. Trigger production deployment
4. Monitor error rates and performance metrics
5. Send release notification to team/stakeholders

## Post-Release Monitoring (2 hours)
- Watch error tracking (Sentry, Rollbar)
- Monitor APM metrics (response times, throughput)
- Check logs for anomalies
- Verify key user flows in production
- Update status page if needed

## Rollback Trigger
Execute rollback if:
- Error rate increases > 5%
- Response time increases > 50%
- Critical feature is broken
- Payment processing fails

Rollback command: `./scripts/rollback.sh v{previous_version}`
```

### 4. **Environment Sync & Configuration Drift Detection**
```markdown
Detect and fix configuration drift between environments:

## Scan Target: Dev → Staging → Production

### Phase 1: Inventory Collection
For each environment, collect:
- Environment variables (.env files)
- Infrastructure config (Terraform state, CloudFormation)
- Feature flags (LaunchDarkly, etc.)
- Service versions (Docker images, npm packages)
- Database schema versions
- SSL certificates and expiration dates
- DNS records and load balancer configs

### Phase 2: Drift Detection
Compare environments and flag differences:
```
🔴 CRITICAL DRIFT - Production has different database schema version
   Production: v2.4.1
   Staging: v2.5.0
   Action: Hold production deployment until schemas match

🟡 WARNING - Staging missing API key
   Variable: THIRD_PARTY_API_KEY
   Exists in: Production, Dev
   Missing in: Staging
   Action: Add to Staging secrets

🟢 OK - All other configs match
```

### Phase 3: Sync Recommendations
Generate sync commands:
```bash
# Apply to Staging
export THIRD_PARTY_API_KEY="***"

# Apply to Production (after approval)
kubectl set image deployment/api api=myapp:v2.5.0
terraform apply -target=aws_db_instance.main
```

### Phase 4: Validation
- Run smoke tests in each environment
- Verify API endpoints return expected responses
- Check application logs for errors
- Confirm monitoring dashboards show healthy metrics

Report format:
```
Environment Sync Report
=======================
Dev ✓ Healthy
Staging ⚠ 2 warnings fixed
Production ✓ Synced successfully

Drift Score: 97% (3% drift resolved)
Last Sync: 2025-11-10 04:20 UTC
Next Scheduled Sync: 2025-11-11 04:20 UTC
```
```

### 5. **Kubernetes Cluster Health Check**
```markdown
Perform comprehensive Kubernetes cluster health assessment:

## Health Check Sequence

### 1. Node Status
```bash
kubectl get nodes -o wide
# Check: All nodes Ready, sufficient disk/memory
```
Validate:
- [ ] All nodes in Ready state
- [ ] CPU usage < 80%
- [ ] Memory usage < 85%
- [ ] Disk usage < 75%

### 2. Pod Health
```bash
kubectl get pods --all-namespaces --field-selector=status.phase!=Running
# Check: No pods in CrashLoopBackOff, Error, or Pending
```
For each unhealthy pod:
- Describe pod: `kubectl describe pod {pod_name}`
- Check logs: `kubectl logs {pod_name} --previous`
- Identify issue: OOMKilled, ImagePullBackOff, etc.
- Apply fix or restart

### 3. Resource Quotas
```bash
kubectl describe quota --all-namespaces
# Check: No quotas exceeded
```

### 4. Network Policies
Test service-to-service connectivity:
```bash
kubectl run test-pod --image=curlimages/curl --rm -it -- curl http://service.namespace.svc.cluster.local
```

### 5. Persistent Volumes
```bash
kubectl get pv,pvc --all-namespaces
# Check: All PVCs bound, no pending volumes
```

### 6. Certificate Expiration
Check cert-manager certificates:
```bash
kubectl get certificate --all-namespaces
# Check: No certificates expiring in < 30 days
```

## Auto-Remediation Actions
If issues found:
- Scale up nodes if resource constrained
- Restart crashlooping pods (max 3 attempts)
- Evict pods from nodes with disk pressure
- Renew expiring certificates
- Clear old replica sets and completed jobs

## Report Format
```
Kubernetes Cluster Health Report
================================
Cluster: production-us-east-1
Nodes: 8/8 healthy ✓
Pods: 156 running, 2 issues found ⚠
  - api-worker-7d8f: CrashLoopBackOff (fixing...)
  - cache-redis-9b2c: OOMKilled (increasing memory limit)

Resource Usage:
  CPU: 62% (healthy ✓)
  Memory: 71% (healthy ✓)
  Disk: 54% (healthy ✓)

Certificates: 3 expiring in 45 days ⚠
  - *.api.example.com (expires: 2025-12-25)

Actions Taken:
  1. Restarted api-worker-7d8f
  2. Updated cache-redis memory limit: 2Gi → 4Gi
  3. Queued certificate renewal for December

Overall Status: HEALTHY with minor issues resolved
```
```

### 6. **Database Migration Safety Check**
```markdown
Execute database migration with zero-downtime strategy:

## Pre-Migration Validation

### 1. Backup Verification
- [ ] Full database backup completed
- [ ] Backup file integrity verified (checksum)
- [ ] Backup restore tested in separate environment
- [ ] Backup stored in 3 locations (local, S3, offsite)

### 2. Migration Review
Analyze migration file for risks:
```sql
-- Check for:
❌ DROP COLUMN (data loss risk)
❌ ALTER COLUMN type (potential data truncation)
❌ Locks on large tables (downtime risk)
✓ ADD COLUMN with DEFAULT (safe)
✓ CREATE INDEX CONCURRENTLY (PostgreSQL safe)
```

### 3. Performance Impact Assessment
- Estimate migration duration (dry-run on staging)
- Check table sizes: `SELECT pg_size_pretty(pg_total_relation_size('table_name'));`
- Identify long-running queries that could block
- Schedule during low-traffic window

### 4. Rollback Plan
Create reverse migration:
```sql
-- If migration adds column:
ALTER TABLE users DROP COLUMN new_field;

-- If migration changes data:
-- Restore from backup taken at: 2025-11-10 04:20 UTC
-- Command: psql mydb < backup_20251110_0420.sql
```

## Migration Execution

### Phase 1: Pre-Migration State
```bash
# Snapshot current state
pg_dump mydb > pre_migration_$(date +%Y%m%d_%H%M%S).sql

# Record table counts
SELECT table_name, 
       (SELECT COUNT(*) FROM table_name) as row_count
FROM information_schema.tables
WHERE table_schema = 'public';
```

### Phase 2: Run Migration
```bash
# Apply with transaction wrapper
BEGIN;
  \i migrations/0042_add_user_preferences.sql
  -- Verify changes
  SELECT COUNT(*) FROM users WHERE preferences IS NOT NULL;
COMMIT; -- or ROLLBACK if verification fails
```

### Phase 3: Post-Migration Validation
- [ ] Compare row counts (before vs after)
- [ ] Run application smoke tests
- [ ] Check for slow queries (new indexes working?)
- [ ] Monitor error logs for 15 minutes
- [ ] Verify data integrity constraints

### Phase 4: Application Deployment
- [ ] Deploy backward-compatible app version first
- [ ] Verify old code works with new schema
- [ ] Deploy new app version using new columns
- [ ] Monitor performance metrics

## Rollback Scenarios

### Scenario 1: Migration Failed
```bash
# Database rolled back automatically by transaction
# No action needed - investigate and retry
```

### Scenario 2: Migration Succeeded, App Broken
```bash
# Rollback application only
git revert HEAD
kubectl rollout undo deployment/api

# Database schema remains (backward compatible)
```

### Scenario 3: Data Corruption Detected
```bash
# Full rollback required
# 1. Take current state snapshot (for forensics)
pg_dump mydb > corrupted_state_$(date +%Y%m%d_%H%M%S).sql

# 2. Restore from pre-migration backup
psql mydb < pre_migration_20251110_0420.sql

# 3. Rollback application
git revert HEAD && git push
kubectl rollout undo deployment/api

# 4. Post-mortem: Analyze corrupted_state file
```

## Success Criteria
✓ Migration completed in < 30 seconds
✓ Zero data loss
✓ All tests passing
✓ Error rate unchanged
✓ Response times within 10% of baseline
✓ No rollback needed for 24 hours
```

---

## 🎨 Advanced Pattern: State Machine DevOps

```markdown
# Intelligent DevOps State Machine

Execute DevOps workflows with state tracking and automatic recovery.

## State Definition
```javascript
const pipelineStates = {
  INIT: 'initializing',
  CHECK: 'checking_status',
  BUILD: 'building',
  TEST: 'testing',
  DEPLOY: 'deploying',
  VERIFY: 'verifying',
  ROLLBACK: 'rolling_back',
  SUCCESS: 'completed',
  FAILED: 'failed'
};
```

## Execution Flow

### Current State: {DYNAMIC}
Load from: `.devops-state.json`

### State Transitions
```
INIT → CHECK → BUILD → TEST → DEPLOY → VERIFY → SUCCESS
  ↓      ↓       ↓       ↓        ↓        ↓
  └──────┴───────┴───────┴────────┴────────→ ROLLBACK → FAILED
```

### State: CHECK
Actions:
1. `git status` - verify clean working directory
2. `git fetch origin` - check for upstream changes
3. Check CI/CD platform API for last build status
4. Parse build logs for errors

Transitions:
- If checks pass → BUILD
- If checks fail → Fix issues, stay in CHECK
- If critical failure → FAILED

### State: BUILD
Actions:
1. `npm run build` or equivalent
2. Monitor build output for warnings
3. Verify build artifacts created
4. Check bundle size (< 500KB for frontend)

Transitions:
- If build succeeds → TEST
- If build fails → ROLLBACK or stay in BUILD (auto-retry 3x)

### State: TEST
Actions:
1. `npm test -- --coverage`
2. Run integration tests
3. Run e2e tests (Playwright/Cypress)
4. Generate coverage report (minimum 80%)

Transitions:
- If all tests pass → DEPLOY
- If tests fail → Fix and return to BUILD
- If > 3 failures → ROLLBACK

### State: DEPLOY
Actions:
1. Tag release: `git tag v1.2.3`
2. Push to deployment branch
3. Trigger deployment pipeline
4. Monitor deployment progress

Transitions:
- If deploy succeeds → VERIFY
- If deploy fails → ROLLBACK

### State: VERIFY
Actions:
1. Run smoke tests against deployed environment
2. Check health endpoints
3. Monitor error rates for 10 minutes
4. Verify key metrics (response time, throughput)

Transitions:
- If verification passes → SUCCESS
- If verification fails → ROLLBACK

### State: ROLLBACK
Actions:
1. Revert to previous stable version
2. `git revert HEAD` or redeploy previous tag
3. Restore database if migrations were applied
4. Notify team of rollback

Transitions:
- Always → FAILED (requires manual intervention)

### State: SUCCESS
Actions:
1. Update CHANGELOG.md
2. Send success notification
3. Archive build artifacts
4. Clean up temporary files
5. Update `.devops-state.json` with SUCCESS

### State: FAILED
Actions:
1. Generate detailed failure report
2. Attach logs and stack traces
3. Create GitHub issue with failure details
4. Notify on-call engineer
5. Update `.devops-state.json` with FAILED

## State Persistence
Save after each state change:
```json
{
  "currentState": "VERIFY",
  "previousState": "DEPLOY",
  "timestamp": "2025-11-10T04:20:00Z",
  "attemptCount": 1,
  "metadata": {
    "commitHash": "abc123",
    "branch": "feature/new-checkout",
    "triggeredBy": "j.",
    "buildNumber": "456"
  },
  "history": [
    "INIT → CHECK → BUILD → TEST → DEPLOY → VERIFY"
  ]
}
```

## Recovery from Interruption
If Claude process is interrupted:
1. Load `.devops-state.json`
2. Resume from `currentState`
3. Replay last action with idempotency checks
4. Continue state machine execution

## Output Format
```
╔════════════════════════════════════════╗
║  DevOps State Machine - Status Report  ║
╚════════════════════════════════════════╝

Current State: VERIFY
Progress: [████████░] 8/9 steps

State History:
✓ INIT      (00:00:02)
✓ CHECK     (00:00:15)
✓ BUILD     (00:02:34)
✓ TEST      (00:05:12)
✓ DEPLOY    (00:03:45)
⟳ VERIFY    (00:00:30) - In Progress

Next Actions:
- Monitoring error rates (8/10 min complete)
- Checking response times
- Validating user flows

Estimated completion: 2 minutes
```
```

---

## 🔧 Prompt Engineering Best Practices for DevOps

### 1. **Always Include State Checking**
```markdown
Before taking any action:
1. Check current state
2. Verify preconditions
3. Document assumptions
```

### 2. **Make It Idempotent**
```markdown
Each step should be safely repeatable:
- Check if already done before executing
- Use `if not exists` patterns
- Don't fail on already-completed steps
```

### 3. **Include Progress Indicators**
```markdown
Show real-time progress:
[█████░░░░░] 50% - Running tests (234/500)

Not just:
Running tests...
```

### 4. **Define Success Criteria**
```markdown
Explicit exit conditions:
✓ All tests pass (347/347)
✓ Coverage > 80% (actual: 87%)
✓ Build size < 500KB (actual: 423KB)
✓ No security vulnerabilities (0 found)

Result: PASS - Proceed to next stage
```

### 5. **Build Escape Hatches**
```markdown
Maximum retry attempts: 3
Timeout per step: 5 minutes
Escalation: After 2 failures, require manual approval
Emergency abort: Type 'ABORT' to stop immediately
```

### 6. **Log Everything**
```markdown
Create audit trail:
- Timestamp each action
- Save command outputs
- Capture error messages
- Record state changes
- Store in: `logs/devops-{timestamp}.log`
```

---

## 🚀 Quick Reference: Common DevOps Prompts

### Quick Status Check
```markdown
Give me a 30-second DevOps health check:
1. Last commit status
2. CI/CD pipeline status  
3. Production health metrics
4. Any critical alerts

Format: Traffic light (🟢/🟡/🔴) with one-line summary each.
```

### Emergency Rollback
```markdown
EMERGENCY: Rollback production immediately

1. Identify current production version
2. Identify last known good version
3. Execute rollback
4. Verify rollback succeeded
5. Notify team

Time budget: 5 minutes maximum
```

### Dependency Update
```markdown
Update all dependencies safely:

1. Check for available updates
2. Categorize: patch, minor, major
3. Update patches automatically
4. Test minors in separate branch
5. Create tickets for majors
6. Run full test suite
7. Create PR if all tests pass
```

---

## 💡 Pro Tips

1. **Use Checkpoints**: Save state after each major step so you can resume if interrupted

2. **Parallel Where Possible**: Run independent checks concurrently
   ```markdown
   Run in parallel:
   - Linting & formatting
   - Unit tests
   - Security scans
   
   Wait for all to complete before proceeding
   ```

3. **Fail Fast**: Check cheapest/fastest validations first
   ```markdown
   Order of checks (fast → slow):
   1. Syntax validation (1s)
   2. Linting (5s)
   3. Unit tests (30s)
   4. Integration tests (2m)
   5. E2E tests (10m)
   ```

4. **Provide Context**: Help Claude understand the bigger picture
   ```markdown
   Project: E-commerce checkout flow
   Stack: Next.js 14, PostgreSQL, Redis
   Deployment: Vercel
   Critical path: Payment processing
   
   Now run pre-deployment checks...
   ```

5. **Version Your Prompts**: Keep prompt templates in version control
   ```bash
   .claude/
     ├── prompts/
     │   ├── deploy-checklist-v1.2.md
     │   ├── rollback-procedure-v2.0.md
     │   └── health-check-v1.5.md
   ```

---

## 📊 Metrics to Track

Add to your prompts:
```markdown
After completion, report:
- Total execution time
- Number of retries needed
- Commands executed (count)
- Data transferred (bytes)
- Cost estimate (API calls, compute time)
- Success rate (this run vs historical)
```

---

## Final Recommendation

Your iterative check pattern is solid. Enhance it with:
1. **State persistence** (so you can resume)
2. **Parallel execution** (where safe)
3. **Better progress indicators** (real-time updates)
4. **Automatic error classification** (transient vs permanent)
5. **Contextual help** (suggest fixes based on error type)

This creates a robust, resumable DevOps automation system that Claude can execute reliably.
