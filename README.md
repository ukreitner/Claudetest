# GitHub Repo Creator for Claude Code

This repository contains a script that lets you create new GitHub repositories directly from your conversations with Claude Code on mobile or desktop.

## Quick Start

### First-Time Setup

1. **Install GitHub CLI** (if not already installed):
   ```bash
   # On macOS
   brew install gh

   # On Linux
   sudo apt install gh
   # or
   sudo dnf install gh
   ```

2. **Authenticate with GitHub**:
   ```bash
   gh auth login
   ```
   Follow the prompts to authenticate with your GitHub account.

3. **You're ready!** Now you can ask Claude Code to create repos for you.

## Usage

### Method 1: Ask Claude Code (Easiest!)

Just tell Claude Code:
- "Create a new repo called my-project"
- "Make a new GitHub repo named awesome-app with description 'My awesome application' as public"
- "Create a private repo called secret-project"

Claude will run the script for you with the right parameters.

### Method 2: Run Manually

```bash
./create-github-repo.sh <repo-name> [description] [visibility]
```

**Parameters:**
- `repo-name` (required): Name of the repository
- `description` (optional): Repository description (default: "Created via Claude Code")
- `visibility` (optional): `public` or `private` (default: private)

**Examples:**
```bash
# Create a private repo with default description
./create-github-repo.sh my-new-project

# Create a public repo with custom description
./create-github-repo.sh awesome-app "My awesome application" public

# Create a private repo with custom description
./create-github-repo.sh secret-project "Top secret stuff" private
```

## What Happens When You Create a Repo?

1. ✓ Repository is created on GitHub
2. ✓ Repository is cloned to a local folder
3. ✓ You get the repository URL
4. ✓ Ready to start coding immediately!

## Example Workflow

```bash
# In your conversation with Claude Code on mobile:
You: "Create a new repo called my-portfolio"

# Claude will run:
# ./create-github-repo.sh my-portfolio "Created via Claude Code" private

# Result:
# ✓ Repository created: https://github.com/yourusername/my-portfolio
# ✓ Cloned to: ./my-portfolio
# Ready to code!
```

## Troubleshooting

### "gh: command not found"
Install the GitHub CLI using the First-Time Setup instructions above.

### "Error: Not authenticated with GitHub CLI"
Run `gh auth login` and follow the authentication prompts.

### "Permission denied"
Make sure the script is executable:
```bash
chmod +x create-github-repo.sh
```

## Features

- 🚀 Create repos in seconds from mobile or desktop
- 🔒 Choose public or private visibility
- 📝 Add custom descriptions
- 🔄 Automatically clones repo locally
- ✅ Simple one-command operation

## Requirements

- GitHub CLI (`gh`) installed
- GitHub account with authentication
- Bash shell

---

**Pro Tip**: When using Claude Code on mobile, you can simply describe what you want and Claude will handle running the script with the right parameters!
