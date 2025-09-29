#===============================================================================
# Initial setup for GEOS-Chem on CIMENT (https://gricad-doc.u-ga.fr/hpc/)
#
# Example:
#   ./setup.sh
#
# This script:
#
# * Installs micromamba and creates environments
#   - gcclassic-gnu14 (GNU 14.1.0 compilers and libs for GCClassic)
#
# * Sets up a project code dir:
#   - Clone GCClassic v14.4.3 (https://github.com/geoschem/GCClassic)
#   - Clone bashdatacatalog (https://github.com/LiamBindle/bashdatacatalog)
#
# * Sets up a project data dir:
#   - Clone geos-chem-data (https://github.com/IGE-Microplastics/geos-chem-data)
#
# Author: Ian Hough
# Date: 2025-01-09
#===============================================================================

#-------------------------------------------------------------------------------
# ↓ SET THESE VARIABLES TO CONFIGURE THE SETUP SCRIPT ↓
#-------------------------------------------------------------------------------

PROJECT='pr-geoschem'                          # Your project name
CODE_DIR="/home/PROJECTS/${PROJECT}"           # Shared code dir
DATA_DIR="/bettik/PROJECTS/${PROJECT}/COMMON"  # Shared data dir
MAMBA_DIR="${CODE_DIR}/micromamba"             # Micromamba envs dir
SETUP_DIR="${CODE_DIR}/geos-chem-setup"        # Dir containing this script
GC_VERSION='14.5.0'                            # GEOS-Chem Classic version

#-------------------------------------------------------------------------------
# ↑ SET THESE VARIABLES TO CONFIGURE THE SETUP SCRIPT ↑
#-------------------------------------------------------------------------------

echo '============================================================'
echo 'Setting up GEOS-Chem'
echo '============================================================'
echo ''
echo "Project name:       $PROJECT"
echo "Shared code dir:    $CODE_DIR"
echo "Shared data dir:    $DATA_DIR"
echo "Micromamba dir:     $MAMBA_DIR"
echo "Setup dir:          $SETUP_DIR"
echo "GCClassic version:  $GC_VERSION"
echo ''

echo '------------------------------------------------------------'
echo 'Installing micromamba'
echo '------------------------------------------------------------'
echo ''

read -n1 -s -r -p $'Press any key to continue...' key
echo ''

# Install micromamba
MAMBA_EXE="${MAMBA_DIR}/micromamba"
if [ ! -e "$MAMBA_EXE" ]; then
  mkdir -p "$MAMBA_DIR"
  cd -P "$MAMBA_DIR"
  echo 'Enter the following at the prompts:'
  echo "  Micromamba binary folder: $MAMBA_DIR"
  echo "  Init shell ($SHELL): n"
  echo '  Configure conda-forge: n'
  echo ''
  read -n1 -s -r -p $'Press any key to continue...' key
  echo ''
  "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
  echo ''
fi

echo '------------------------------------------------------------'
echo 'Updating micromamba init script'
echo '------------------------------------------------------------'
echo ''

read -n1 -s -r -p $'Press any key to continue...' key
echo ''

# Update the micromamba root prefix in init-mamba.sh
MAMBA_INIT_SCRIPT="${SETUP_DIR}/init-mamba.sh"
cd -P "$SETUP_DIR"
sed -i -E "s|^MAMBA_ROOT_PREFIX=.+|MAMBA_ROOT_PREFIX=\"${MAMBA_DIR}\"|" $MAMBA_INIT_SCRIPT

echo '------------------------------------------------------------'
echo 'Building micromamba environment'
echo '------------------------------------------------------------'
echo ''

read -n1 -s -r -p $'Press any key to continue...' key
echo ''

# Create environment for GCClassic with GNU 14.1.0 compilers
GC_ENV=gcclassic-gnu14
if [ ! -d "${MAMBA_DIR}/envs/${GC_ENV}" ]; then
  cd -P "$SETUP_DIR"
  source "$MAMBA_INIT_SCRIPT"
  micromamba env create --yes --name $GC_ENV --file "${GC_ENV}.lock"
fi

echo '------------------------------------------------------------'
echo 'Cloning GEOS-Chem Classic source code'
echo '------------------------------------------------------------'
echo ''

read -n1 -s -r -p $'Press any key to continue...' key
echo ''

# Clone the GCClassic source cocde
GC_DIR="${CODE_DIR}/GCClassic-${GC_VERSION}"
if [ ! -d "$GC_DIR" ]; then

  # Activate gcclassic-gnu14 to ensure a modern git
  cd -P "$SETUP_DIR"
  source "$MAMBA_INIT_SCRIPT"
  micromamba activate "$GC_ENV"

  echo "Cloning GCClassic in $CODE_DIR"
  cd -P "$CODE_DIR"
  git clone https://github.com/geoschem/GCClassic.git "$GC_DIR"
  cd "$GC_DIR"

  echo "Checking out GCClassic v${GC_VERSION} including submodules"
  git checkout "tags/${GC_VERSION}"
  git switch -c "v${GC_VERSION}"
  git submodule update --init --recursive

  # Deactive environment
  micromamba deactivate
  echo ''

fi

echo '------------------------------------------------------------'
echo 'Preparing data dir'
echo '------------------------------------------------------------'
echo ''

read -n1 -s -r -p $'Press any key to continue...' key
echo ''

# Clone geos-chem-data repository
if [ ! -d "${CODE_DIR}/geos-chem-data" ]; then
  mkdir -p "$DATA_DIR"
  cd -P "$DATA_DIR"
  echo "Cloning geos-chem-data in $DATA_DIR"
  git clone git@github.com:IGE-Microplastics/geos-chem-data
  echo ''
fi

echo '------------------------------------------------------------'
echo 'Installing bashdatacatalog'
echo '------------------------------------------------------------'
echo ''

read -n1 -s -r -p $'Press any key to continue...' key
echo ''

# Install bashdatacatalog
BASHDATACATALOG_DIR="${CODE_DIR}/bashdatacatalog"
if [ ! -d "$BASHDATACATALOG_DIR" ]; then
  echo "Cloning bashdatacatalog in $CODE_DIR"
  cd -P "$CODE_DIR"
  git clone https://github.com/LiamBindle/bashdatacatalog.git

  BASHDATACATALOG_BIN="${BASHDATACATALOG_BIN}/bin"
  echo ''
  echo '------------------------------------------------------------'
  echo '!!! IMPORTANT !!!'
  echo ''
  echo "To use the bashdatacatalog scripts, you must add them to your PATH"
  echo ''
  echo 'Example:'
  echo "  export PATH=${BASHDATACATALOG_BIN}:\$PATH"
  echo ''
  echo 'Alternatively, you could link the scripts to a directory that is'
  echo 'already in your PATH such as ~/.local/bin or ~/bin'
  echo ''
  echo 'Example:'
  echo "  ln -siv ${BASHDATACATALOG_BIN}/* ~/.local/bin"
  echo ''
  echo '!!! IMPORTANT !!!'
  echo '------------------------------------------------------------'
fi
