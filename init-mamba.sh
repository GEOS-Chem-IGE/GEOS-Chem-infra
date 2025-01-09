# Source this script to initialize micromamba:
#   source init-mamba.sh

# Use pr-geoschem micromamba binary and environments
MAMBA_ROOT_PREFIX="/home/PROJECTS/pr-geoschem/micromamba"
MAMBA_EXE="${MAMBA_ROOT_PREFIX}/micromamba"

# Confirm micromamba is installed
fail() {
    echo "Error: $1" >&2
    return 1
}
if [ ! -d "$MAMBA_ROOT_PREFIX" ]; then
  fail "micromamba directory does not exist: $MAMBA_ROOT_PREFIX"
fi
if [ ! -e "$MAMBA_EXE" ]; then
  fail "micromamba binary not found: $MAMBA_EXE"
fi

# Generate and run micromamba shell init commands
__mamba_shell_init="$(
  $MAMBA_EXE shell init $MAMBA_ROOT_PREFIX --dry-run \
    | sed -n '/# >>> mamba initialize >>>$/,/^# <<< mamba initialize <<<$/p'
)"
eval "$__mamba_shell_init"
unset __mamba_shell_init
