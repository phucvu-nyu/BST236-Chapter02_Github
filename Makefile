# Github variables
REPO_NAME = Your_Repo_Name
GITHUB_USER = Your_Github_Username
UPSTREAM_URL = Your_Upstream_URL
BRANCH = main
BRANCH_LOCAL = my_feature

# Initialize a local Git repository and push to GitHub
init:
	git init
	git add .
	git commit -m "Initial commit"
	make init_repo

init_repo:
	gh repo create $(GITHUB_USER)/$(REPO_NAME) --private --source=. --remote=origin
	git push -u origin main

# Add upstream
add_upstream:
	git remote add upstream $(UPSTREAM_URL)

# Add a new branch
add_branch:
	git checkout -b $(BRANCH_LOCAL)

push_branch:
	git push -f origin $(BRANCH_LOCAL)

# Sync with Github
sync:
	git checkout main
	git pull upstream main
	git checkout $(BRANCH_LOCAL)
	git	rebase main

