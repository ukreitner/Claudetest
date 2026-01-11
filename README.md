# GitHub Repo Creator for Claude Code

Create new GitHub repositories directly from your conversations with Claude Code on mobile or desktop - **no CLI tools required!**

## Quick Start (API Version - Works Everywhere!)

### One-Time Setup (Takes 2 minutes)

1. **Run the setup script:**
   ```bash
   ./setup-github-token.sh
   ```

2. **Follow the prompts to:**
   - Create a GitHub Personal Access Token at https://github.com/settings/tokens/new
   - Give it 'repo' scope (full control of repositories)
   - Paste the token when prompted

3. **You're ready!** Now you can ask Claude Code to create repos for you.

### That's it! No installation needed, works on any system with curl.

## Usage

### Method 1: Ask Claude Code (Easiest!)

Just tell Claude Code:
- "Create a new repo called my-project"
- "Make a new GitHub repo named awesome-app with description 'My awesome application' as public"
- "Create a private repo called secret-project"

Claude will run the script for you with the right parameters.

### Method 2: Run Manually

```bash
./create-repo-api.sh <repo-name> [description] [visibility]
```

**Parameters:**
- `repo-name` (required): Name of the repository
- `description` (optional): Repository description (default: "Created via Claude Code")
- `visibility` (optional): `public` or `private` (default: private)

**Examples:**
```bash
# Create a private repo with default description
./create-repo-api.sh my-new-project

# Create a public repo with custom description
./create-repo-api.sh awesome-app "My awesome application" public

# Create a private repo with custom description
./create-repo-api.sh secret-project "Top secret stuff" private
```

## What Happens When You Create a Repo?

1. ✓ Repository is created on GitHub via API
2. ✓ Repository is initialized with README
3. ✓ You get the repository URL
4. ✓ Option to clone it locally
5. ✓ Ready to start coding immediately!

## Example Workflow

```bash
# In your conversation with Claude Code on mobile:
You: "Create a new repo called my-portfolio"

# Claude will run:
# ./create-repo-api.sh my-portfolio "Created via Claude Code" private

# Result:
# ✓ Repository created: https://github.com/yourusername/my-portfolio
# ✓ Ready to clone and code!
```

## Files in This Repo

- **`create-repo-api.sh`** - Main script (uses GitHub API directly)
- **`setup-github-token.sh`** - Easy token setup wizard
- **`create-github-repo.sh`** - Alternative version using GitHub CLI (optional)

## Troubleshooting

### "GitHub Personal Access Token not configured"
Run `./setup-github-token.sh` to set up your token.

### "Token validation failed"
Your token may have expired or been revoked. Run `./setup-github-token.sh` again to create a new one.

### "Permission denied"
Make sure the scripts are executable:
```bash
chmod +x *.sh
```

### "curl: command not found"
Install curl (it's usually pre-installed):
```bash
# Linux
sudo apt install curl

# macOS - already included
```

## Security Notes

- Your GitHub token is stored in `~/.github-repo-creator.conf` with secure permissions (600)
- Never share your token or commit it to a repository
- The token only has 'repo' scope - just enough to create repositories
- You can revoke the token anytime at https://github.com/settings/tokens

## Features

- 🚀 Create repos in seconds from mobile or desktop
- 🔒 Choose public or private visibility
- 📝 Add custom descriptions
- 🌐 Works everywhere - no special tools required
- ✅ Simple one-command operation
- 🔐 Secure token storage

## Requirements

- curl (pre-installed on most systems)
- GitHub account
- GitHub Personal Access Token (created during setup)
- Bash shell

## Alternative: GitHub CLI Version

If you prefer using GitHub CLI and have it installed, you can use `create-github-repo.sh` instead:

1. Install gh CLI: `brew install gh` (macOS) or `sudo apt install gh` (Linux)
2. Authenticate: `gh auth login`
3. Use: `./create-github-repo.sh <repo-name>`

The API version (`create-repo-api.sh`) is recommended as it works everywhere without additional installations.

---

**Pro Tip**: When using Claude Code on mobile, you can simply describe what you want and Claude will handle running the script with the right parameters!
