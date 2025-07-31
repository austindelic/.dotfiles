# For Debian/Ubuntu

## Install brew requirements
```bash
sudo apt-get install build-essential procps curl file git
```
# Homebrew

## Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install dotter

```bash
brew install dotter
```

# dotter

## Clone Repo and cd into it

```bash
cd ~
git clone https://github.com/austindelic/.dotfiles.git
cd .dotfiles
```

## Run dotter

```bash
dotter deploy -v
```

## Run Brew Bundle (start new terminal session if not in fish)
```bash
bb
```
