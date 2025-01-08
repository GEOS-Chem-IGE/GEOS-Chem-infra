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
#===============================================================================

#-------------------------------------------------------------------------------
# ↓ SET THESE VARIABLES TO CONFIGURE THE SETUP SCRIPT ↓
#-------------------------------------------------------------------------------

PROJECT='pr-geoschem'                          # Your project name
CODE_DIR="/home/PROJECTS/${PROJECT}"           # Shared code dir
DATA_DIR="/bettik/PROJECTS/${PROJECT}/COMMON"  # Shared data dir
MAMBA_DIR="${CODE_DIR}/micromamba"             # Micromamba envs dir
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

if [ ! -e "$MAMBA_DIR"/micromamba ]; then
  mkdir -p $MAMBA_DIR
  cd -P $MAMBA_DIR
  echo 'Enter the following at the prompts:'
  echo "  Micromamba binary folder: $MAMBA_DIR"
  echo "  Init shell ($SHELL): n"
  echo '  Configure conda-forge: n'
  echo ''
  read -n1 -s -r -p $'Press any key to continue...' key
  echo ''
  "${SHELL}" <(curl -L micro.mamba.pm/install.sh)
fi

echo '------------------------------------------------------------'
echo 'Creating micromamba environments'
echo '------------------------------------------------------------'
echo ''

# Create environment for GCClassic with GNU 14.1.0 compilers
if [ ! -e "${MAMBA_DIR}/envs/gcclassic-gnu14" ]; then
  cd -P "$SETUP_DIR"
  source init-mamba.sh
  micromamba env create --yes --name gcclassic-gnu14 --file gcclassic-gnu14.lock
fi

echo '------------------------------------------------------------'
echo 'Cloning GEOS-Chem code'
echo '------------------------------------------------------------'
echo ''

if [ ! -d "${CODE_DIR}/GCClassic-${GC_VERSION}" ]; then

  # Activate gcclassic-gnu14 to ensure a modern git
  cd -P "$SETUP_DIR"
  source init-mamba.sh
  micromamba activate gcclassic-gnu14

  echo "Cloning GCClassic in $CODE_DIR"
  cd -P "$CODE_DIR"
  git clone --recurse-submodules https://github.com/geoschem/GCClassic.git
  cd GCClassic

  echo "Checking out GCClassic v${GC_VERSION}"
  git checkout "tags/${GC_VERSION}"
  git branch "v${GC_VERSION}"
  git switch "v${GC_VERSION}"
  git submodule update --init --recursive

  # Deactive environment
  micromamba deactivate
fi

echo '------------------------------------------------------------'
echo 'Preparing data dir'
echo '------------------------------------------------------------'
echo ''

# Clone geos-chem-data
mkdir -p "$DATA_DIR"
if [ ! -d "${CODE_DIR}/geos-chem-data" ]; then
  cd -P "$DATA_DIR"
  echo "Cloning geos-chem-data in $DATA_DIR"
  git clone https://github.com/IGE-Microplastics/geos-chem-data
fi

echo '------------------------------------------------------------'
echo 'Installing bashdatacatalog'
echo '------------------------------------------------------------'
echo ''

# Install bashdatacatalog
if [ ! -d "${CODE_DIR}/bashdatacatalog" ]; then
  echo "Cloning bashdatacatalog in $CODE_DIR"
  cd -P "$CODE_DIR"
  git clone https://github.com/LiamBindle/bashdatacatalog.git

  bashdatacatalog_bin="$CODE_DIR/bashdatacatalog/bin"

  echo ''
  echo '------------------------------------------------------------'
  echo '!!! IMPORTANT !!!'
  echo ''
  echo "To use the bashdatacatalog scripts, you must add them to your PATH"
  echo ''
  echo 'Example:'
  echo "  export PATH=${bashdatacatalog_bin}:\$PATH"
  echo ''
  echo 'Alternatively, you could link the scripts to a directory that is'
  echo 'already in your PATH such as ~/.local/bin or ~/bin'
  echo ''
  echo 'Example:'
  echo "  ln -siv ${bashdatacatalog_bin}/* ~/.local/bin"
  echo ''
  echo '!!! IMPORTANT !!!'
  echo '------------------------------------------------------------'
  echo ''
fi
