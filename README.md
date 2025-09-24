# GitHub Codespaces Template

This repository serves as a template for quickly getting started with R, RStudio and Quarto in GitHub Codespaces. It provides a base configuration that you can use to create your own development environment in the cloud.

This template is inspired by David Smith's [RStudio Codespaces Template](https://github.com/revodavid/devcontainers-rstudio). Link to his presentation videos: [YouTube](https://www.youtube.com/watch?v=2uXLikk30Ew) | [RStudio](https://www.rstudio.com/conference/2022/talks/zero-setup-r-workshops-github/)

## What is GitHub Codespaces?

GitHub Codespaces is a cloud-based development environment that lets you code from anywhere using a web browser or VS Code. It provides:
- A fully configured development environment in seconds
- Cloud-hosted development environments
- Access to your workspace from any device
- Customizable container configurations
- Seamless GitHub integration

## Getting Started

1. Click the "Use this template" button at the top of this repository
2. Choose a name for your new repository
3. Select whether you want the repository to be public or private
4. Click "Create repository from template"
5. Once created, click the "Code" button and select "Open with Codespaces"
6. Click "New codespace" to launch your development environment

## Customization

You can customize your Codespace by:
- Modifying the `.devcontainer` folder
- Adding development dependencies
- Configuring VS Code settings
- Installing additional extensions

### Persisting Changes

To make your customizations available in future Codespaces:

1. Keybindings: Update `.devcontainer/keybindings.json`
2. VS Code settings: Modify the settings in `.devcontainer/devcontainer.json`
3. R packages: Add them to the Dockerfile
4. VS Code extensions: Add them to the extensions list in `devcontainer.json`

Remember to commit and push your changes to the repository to make them available in future Codespaces.

## Installed Components

### Core Environment
- R 4.4 with tidyverse
- RStudio Server
- Quarto CLI
- JupyterLab with IRkernel
- Python support

### R Packages
- tidyverse (core tidyverse packages)
- here
- tidymodels
- markdown
- gtsummary
- ggsurvfit
- survival
- gt
- quarto
- rmarkdown
- languageserver
- WeightIt
- MatchIt
- MatchThem
- cobalt
- smdi
- encore.analytics

### VS Code Extensions
- Jupyter
- Jupyter Renderers
- Python
- Pylance
- CodeTour
- GitHub Copilot
- Quarto

### Exposed Ports
- RStudio: 8787
- JupyterLab: 8888

