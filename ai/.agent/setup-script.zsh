# Sets up OpenSkills and syncs
openskills update                     # All skills are committed and include a .openskills.json file that tells OpenSkills how to install
openskills sync -o ~/.agent/AGENTS.md # Actually does the installation and updates the AGENTS.md file with the new agents
