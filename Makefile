# Github variables
REPO_NAME = BST236-Chapter02_Github
GITHUB_USER = hsph-bst236
UPSTREAN_URL = https://github.com/hsph-bst236/BST236-Chapter02_Workflow.git
BRANCH = main

# Initialize a local Git repository and push to GitHub
init:
	git init
	git add .
	git commit -m "Initial commit"
	make init_repo

init_repo:
	gh repo create $(GITHUB_USER)/$(REPO_NAME) --private --source=. --remote=origin
	git push -u origin main

# Sync with Github
sync:
	git checkout main
	git pull origin main
	if [ "$(strip $(BRANCH))" != "main" ]; then \
		git checkout $(BRANCH); \
		git rebase main; \
	fi
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		$(VENV_PIP) install --upgrade -r requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry install; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(VENV_PIP) install --upgrade -r requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		uv pip sync requirements.txt; \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi
	@echo "Packages updated using $(VENV_METHOD)!"

# Push to GitHub
push:
	@echo "Freezing current packages to lockfile..."
	@if [ "$(strip $(VENV_METHOD))" = "venv" ]; then \
		$(VENV_PIP) freeze > requirements.txt; \
	elif [ "$(strip $(VENV_METHOD))" = "poetry" ]; then \
		poetry lock; \
	elif [ "$(strip $(VENV_METHOD))" = "conda" ]; then \
		$(CONDA_ACTIVATE) && \
		conda env export > environment.yml; \
	elif [ "$(strip $(VENV_METHOD))" = "uv" ]; then \
		uv pip freeze > requirements.txt; \
	else \
		echo "Unknown VENV_METHOD: '$(VENV_METHOD)'"; \
	fi
	echo "Lockfile created using $(VENV_METHOD)!"
	echo "Pushing to GitHub..."
	git add .
	git commit --amend --no-edit
	@if [ "$(strip $(BRANCH))" = "main" ]; then \
		git pull origin main --rebase; \
		git push origin main; \
	else \
		git push -f origin $(BRANCH); \
	fi

branch:
	git checkout -b $(BRANCH)

push_branch:
	git push origin $(BRANCH)

small_update:
	git add .
	git commit --amend --no-edit

change_name:
	git commit --amend -m "Update"

