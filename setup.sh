#===============================================================================
# Initial setup for GEOS-Chem on CIMENT (https://gricad-doc.u-ga.fr/hpc/)
#
# Example:
#   ./setup.sh
#
# This script:
#
# * Creates micromamba environments
#   - gcclassic-gnu14 (GNU 14.1.0 compilers and libs for GCClassic)
#
# * Sets up a project code dir:
#   - Clone GCClassic v14.4.3 (https://github.com/geoschem/GCClassic)
#   - Clone bashdatacatalog (https://github.com/LiamBindle/bashdatacatalog)
#
# * Sets up a project data dir:
#   - Clone geos-chem-data (https://github.com/IGE-Microplastics/geos-chem-data)
#===============================================================================

#-------------------------------------------------------------------------------
# ↓ SET THESE VARIABLES TO CONFIGURE THE SETUP SCRIPT ↓
#-------------------------------------------------------------------------------

PROJECT='pr-geoschem'                          # Your project name
CODE_DIR="/home/PROJECTS/${PROJECT}"           # Shared code dir
DATA_DIR="/bettik/PROJECTS/${PROJECT}/COMMON"  # Shared data dir
SETUP_DIR="${CODE_DIR}/geos-chem-setup"        # Dir containing this script
GC_VERSION='14.4.3'                            # GEOS-Chem Classic version

#-------------------------------------------------------------------------------
# ↑ SET THESE VARIABLES TO CONFIGURE THE SETUP SCRIPT ↑
#-------------------------------------------------------------------------------

echo '============================================================'
echo 'Setting up GEOS-Chem'
echo '============================================================'
echo ''
echo "Project name:       $PROJECT"
echo "Setup dir:          $SETUP_DIR"
echo "Shared code dir:    $CODE_DIR"
echo "Shared data dir:    $DATA_DIR"
echo "GCClassic version:  $GC_VERSION"
echo ''

echo '------------------------------------------------------------'
echo 'Creating micromamba environments'
echo '------------------------------------------------------------'
echo ''

# Initialize micromamba
cd -P "$SETUP_DIR"
source init-mamba.sh

# GNU 14.1.0 compilers and libraries for GCClassic
if [ ! -e "${MAMBA_ROOT_PREFIX}/envs/gcclassic-gnu14" ]; then
  micromamba env create --yes --name gcclassic-gnu14 --file gcclassic-gnu14.lock
fi

echo '------------------------------------------------------------'
echo 'Cloning GEOS-Chem code'
echo '------------------------------------------------------------'
echo ''

# Activate gcclassic-gnu14 to ensure a modern git
micromamba activate gcclassic-gnu14

# GCClassic v14.4.3
if [ ! -e "${CODE_DIR}/GCClassic" ]; then
  echo "Cloning GCClassic in $CODE_DIR"
  cd -P "$CODE_DIR"
  git clone --recurse-submodules https://github.com/geoschem/GCClassic.git
  cd GCClassic

  echo "Checking out GCClassic v${GC_VERSION}"
  git checkout "tags/${GC_VERSION}"
  git branch "v${GC_VERSION}"
  git switch "v${GC_VERSION}"
  git submodule update --init --recursive
fi

# Deactive environment
micromamba deactivate

echo '------------------------------------------------------------'
echo 'Preparing data dir'
echo '------------------------------------------------------------'
echo ''

# Clone geos-chem-data
mkdir -p "$DATA_DIR"
if [ ! -e "${CODE_DIR}/geos-chem-data" ]; then
  cd -P "$DATA_DIR"
  echo "Cloning geos-chem-data in $DATA_DIR"
  git clone https://github.com/IGE-Microplastics/geos-chem-data
fi

echo '------------------------------------------------------------'
echo 'Installing bashdatacatalog'
echo '------------------------------------------------------------'
echo ''

# Install bashdatacatalog
if [ ! -e "${CODE_DIR}/bashdatacatalog" ]; then
  echo "Cloning bashdatacatalog in $CODE_DIR"
  cd -P "$CODE_DIR"
  git clone https://github.com/LiamBindle/bashdatacatalog.git

  # Link bashdatacatalog scripts to $HOME/.local/bin or $HOME/bin if exist
  scripts_dir="${CODE_DIR}/bashdatacatalog/bin"
  if [ -d "${HOME}/.local/bin" ]; then
    user_bin="${HOME}/.local/bin"
  elif [ -d "${HOME}/bin" ]; then
    user_bin="${HOME}/bin"
  fi
  if [ -n "$user_bin" ]; then
    echo "Linking bashdatacatalog scripts to $user_bin"
    ln -siv "${scripts_dir}"/bashdatacatalog* "$user_bin"
    scripts_dir="$user_bin"
  fi

  echo ''
  echo '------------------------------------------------------------'
  echo '!!! IMPORTANT !!!'
  echo ''
  echo "To use bashdatacatalog you must add ${scripts_dir} to your PATH"
  echo ''
  echo 'Example:'
  echo "  export PATH=${scripts_dir}:\$PATH"
  echo ''
  echo '!!! IMPORTANT !!!'
  echo '------------------------------------------------------------'
  echo ''

fi
