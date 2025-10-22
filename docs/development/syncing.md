# Keeping Bradleyco in Sync with Origin

This guide explains how to keep your local `bradleyco` repository synchronized with the upstream `origin` remote, which points to the Medusa starter default repository (`https://github.com/medusajs/medusa-starter-default.git`). This is important for incorporating upstream updates, bug fixes, and new features while maintaining your customizations.

## Prerequisites

- Ensure you have Git installed and configured.
- Your local repository should have the remotes set up as follows (verify with `git remote -v`):
  - `bradleyco`: Your personal repository (`git@github.com:calumbradley/bradleyco.git`)
  - `origin`: The upstream Medusa repository (`https://github.com/medusajs/medusa-starter-default.git`)

## Syncing Process

### 1. Fetch Upstream Changes

First, fetch the latest changes from the `origin` remote without merging them:

```bash
git fetch origin
```

This downloads the latest commits from the upstream repository but doesn't modify your local branches.

### 2. Check for Updates

View the differences between your current branch (e.g., `master`) and the upstream `master`:

```bash
git log --oneline master..origin/master
```

If there are no new commits, you're already up to date. Otherwise, proceed to merge or rebase.

### 3. Merge or Rebase Upstream Changes

You have two main options: merge or rebase. Choose based on your workflow preference.

#### Option A: Merge (Preserves History)

Merge the upstream changes into your local `master` branch:

```bash
git checkout master
git merge origin/master
```

This creates a merge commit, preserving the full history.

#### Option B: Rebase (Cleaner History)

Rebase your local changes on top of the upstream changes:

```bash
git checkout master
git rebase origin/master
```

This rewrites your commit history to appear as if your changes were made on top of the latest upstream code. Use this if you prefer a linear history.

**Note:** If you have uncommitted changes, stash them first with `git stash` before rebasing.

### 4. Resolve Conflicts (If Any)

If conflicts occur during merge or rebase:

1. Git will pause and show conflicting files.
2. Edit the conflicted files to resolve the issues.
3. Stage the resolved files: `git add <file>`
4. Continue the process:
   - For merge: `git commit`
   - For rebase: `git rebase --continue`

### 5. Push Changes to Your Repository

After successfully syncing, push the updated `master` branch to your `bradleyco` remote:

```bash
git push bradleyco master
```

### 6. Handle Feature Branches

If you have feature branches based on an older version of `master`:

1. Update your `master` branch as described above.
2. For each feature branch:
   ```bash
   git checkout <feature-branch>
   git rebase master  # or git merge master
   ```
3. Resolve any conflicts and push the updated branches.

## Best Practices

- **Regular Syncing:** Sync with `origin` regularly to avoid large conflicts and stay current with upstream developments.
- **Test After Syncing:** After merging upstream changes, run your tests and ensure your customizations still work.
- **Backup Before Major Changes:** Consider creating a backup branch before rebasing if you're unsure.
- **Communicate Changes:** If you're collaborating, inform team members about upstream syncs that might affect shared branches.
- **Avoid Force Pushing:** Only force push (`git push --force`) if absolutely necessary and you've communicated with collaborators.

## Troubleshooting

- **Permission Issues:** Ensure you have push access to your `bradleyco` repository.
- **Divergent Branches:** If your local `master` has diverged significantly from `origin/master`, consider rebasing or creating a new branch.
- **Lost Commits:** If rebasing goes wrong, use `git reflog` to recover lost commits.

For more information on Git workflows, refer to the [Git documentation](https://git-scm.com/doc).
