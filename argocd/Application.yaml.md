# ArgoCD Application.yaml Review Notes

## Critical Issues Found

### 1. HIGH Risk: prune + selfHeal Combination (Lines 19-20)
```yaml
prune: true
selfHeal: true  # ⚠️ DANGEROUS for production
```
**Risk:** Reconciliation storm → automatic deletion of production resources on drift.

**Recommendation:** Set `selfHeal: false` for production environments.


---

## Why `selfHeal: true` is High Risk in Production

### What `selfHeal: true` Does

Automatically syncs the cluster state to match Git **whenever any drift is detected** — no human approval, no visibility into what changed.

### Production Risks

| Risk | Impact |
|------|--------|
| **Automatic drift correction** | If someone makes an emergency hotfix directly on the cluster (e.g., scaling replicas, adjusting resources, fixing a config), ArgoCD **immediately overwrites it** |
| **Cascading deletions** | Combined with `prune: true`, any resource created outside Git (e.g., temporary debug pods, metrics sidecars) gets **deleted automatically** |
| **No rollback window** | Bad config pushed to Git → instantly deployed to all environments → no time to intercept |
| **Reconciliation storms** | During migrations or upgrades, temporary drift triggers → mass sync operations → potential resource deletion |

### When It's Acceptable

- ✅ **Dev/Test environments** — Rapid iteration, no production impact
- ✅ **Fully immutable clusters** — Zero manual changes allowed, strict GitOps discipline
- ✅ **After stabilization** — Post-migration, once config is proven stable

### Recommended Production Pattern

```yaml
syncPolicy:
  automated:
    prune: false      # Or require manual confirmation
    selfHeal: false   # ← Require explicit sync approval
```

### Recommended Workflow

1. Git change → ArgoCD shows "OutOfSync"
2. Team reviews diff in ArgoCD UI
3. Manual sync with dry-run
4. Verify health
5. Complete sync

**Bottom line:** `selfHeal: true` trades safety for automation. In production, you want humans in the loop for drift resolution.

---

## Summary

| Check | Status |
|-------|--------|
| apiVersion | ✓ `argoproj.io/v1alpha1` |
| metadata.labels | ✗ `label` (singular) |
| destination | ✓ Explicit namespace/server |
| syncPolicy.prune | ⚠️ `true` (risk) |
| syncPolicy.selfHeal | ⚠️ `true` (HIGH risk) |
| sync-wave | ✗ Missing |

**Action Required:** Fix the `label` → `labels` typo before syncing — ArgoCD will reject this manifest.
