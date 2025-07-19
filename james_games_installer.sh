#!/bin/bash

# List of packages to install
packages=("cbonsai"
          "python3-psutil"
          "pipx"
          "curl"
          "libboost-program-options-dev"
          "libgit2-dev"
          "libjpeg-dev"
          "zlib1g-dev"
          "libfreetype6-dev"
          "libfribidi-dev"
          "libharfbuzz-dev"
          "build-essential"
          "cmake"
          "libmpv1"
          "libmpv-dev"
          "libncurses5-dev"
          "libncursesw5-dev"
          "vlc"
          "libasound2-dev"
          "libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio"
          "protobuf-compiler"
          "libdbus-1-dev"
)
# cbonsai: grow your own bonsai tree in the terminal (use `cbonsai -li`)
# pipx: Python package installer for user-level packages
# python3-psutil: Python system and process utilities
# curl: command-line tool for transferring data with URLs
# protobuf-compiler: Protocol Buffers compiler (for gstreamer, termusic)

pip_packages=()

# List of Python packages to install via pipx
pipx_packages=("glances"
                "yt-dlp[default]")

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if a Python package is installed via pipx
pipx_package_exists() {
  pipx list | grep -q "$1"
}

# Function to check if a Python package is installed via pip
pip_package_exists() {
  python3 -c "import $1" >/dev/null 2>&1
}


# ============================================
# PACKAGE INSTALLATION SECTION
# ============================================

echo "=== Installing system packages ==="
sudo apt-get update

for package in "${packages[@]}"; do
  if ! command_exists "$package"; then
    echo "Installing $package..."
    sudo apt-get install -y "$package"
  else
    echo "$package is already installed."
  fi
done

echo "System packages installation complete."





# ============================================
# FEDORA/RHEL SPECIFIC PACKAGES
# ============================================



# Better detection for Fedora/RHEL systems
if command_exists dnf && [ -f /etc/fedora-release ] || [ -f /etc/redhat-release ]; then
  echo "Detected Fedora/RHEL system, installing dnf packages..."
  for fedora_package in "${fedora_packages[@]}"; do
    echo "Installing $fedora_package..."
    if sudo dnf install -y "$fedora_package"; then
      echo "$fedora_package installed successfully."
    else
      echo "Failed to install $fedora_package, skipping..."
    fi
  done
elif command_exists dnf; then
  echo "dnf found but not on Fedora/RHEL system, skipping dnf packages..."
else
  echo "dnf not found, skipping Fedora/RHEL specific packages..."
fi

echo "Fedora/RHEL specific packages installation complete."

# ============================================
# PIP PACKAGE INSTALLATION SECTION
# ============================================

echo "=== Installing Python packages via pip ==="

if [ ${#pip_packages[@]} -gt 0 ]; then
  # Check if pip is installed
  if ! command_exists pip3; then
    echo "pip3 not found. Installing python3-pip..."
    sudo apt-get install -y python3-pip
  fi
  
  for pip_package in "${pip_packages[@]}"; do
    if ! pip_package_exists "$pip_package"; then
      echo "Installing $pip_package..."
      pip3 install --user "$pip_package"
    else
      echo "$pip_package is already installed."
    fi
  done
else
  echo "No Python packages to install."
fi

echo "Python packages installation complete."


# ============================================
# PIPX PACKAGE INSTALLATION SECTION
# ============================================

echo "=== Installing Python packages via pipx ==="

if [ ${#pipx_packages[@]} -gt 0 ]; then
  # Check if pipx is installed
  if ! command_exists pipx; then
    echo "pipx not found. Installing pipx..."
    sudo apt-get install -y pipx
  fi
  
  for pipx_package in "${pipx_packages[@]}"; do
    if ! pipx_package_exists "$pipx_package"; then
      echo "Installing $pipx_package..."
      pipx install "$pipx_package"
    else
      echo "$pipx_package is already installed."
    fi
  done
else
  echo "No Python packages to install."
fi

echo "Python packages installation complete."


# ============================================
# RUST INSTALLATION SECTION
# ============================================

echo "=== Installing Rust and Cargo packages ==="

# Install Rust if not already installed
if ! command_exists rustc; then
  echo "Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
else
  echo "Rust is already installed."
fi

# Install cargo packages
cargo_packages=("chess-tui"
                "tui-journal"
                "termusic"
                "termusic-server")

if [ ${#cargo_packages[@]} -gt 0 ]; then
  # Ensure cargo is available
  if ! command_exists cargo; then
    echo "Cargo not found. Please restart your terminal and run this script again."
    exit 1
  fi
  
  for cargo_package in "${cargo_packages[@]}"; do
    if ! cargo install --list | grep -q "^$cargo_package"; then
      echo "Installing $cargo_package..."
      cargo install "$cargo_package"
    else
      echo "$cargo_package is already installed."
    fi
  done
else
  echo "No Cargo packages to install."
fi

echo "Rust packages installation complete."

# ============================================
# GITHUB REPOSITORIES SECTION
# ============================================

echo "=== Cloning GitHub repositories ==="

# GitHub repositories to clone
github_repos=("")

# Create cloned-repos directory if it doesn't exist
CLONE_DIR="$HOME/src/cloned-repos"
if [ ! -d "$CLONE_DIR" ]; then
  echo "Creating $CLONE_DIR directory..."
  mkdir -p "$CLONE_DIR"
fi

if [ ${#github_repos[@]} -gt 0 ]; then
  cd "$CLONE_DIR"
  
  for repo in "${github_repos[@]}"; do
    # Extract repository name from URL
    repo_name=$(basename "$repo" .git)
    
    if [ ! -d "$repo_name" ]; then
      echo "Cloning $repo..."
      git clone "$repo"
    else
      echo "$repo_name already exists, skipping..."
    fi
  done
  
  cd - > /dev/null
else
  echo "No GitHub repositories to clone."
fi
```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````                                                                                                                             ``````````  
echo "GitHub repositories cloning complete."

echo "=== All installations and cloning complete ==="



