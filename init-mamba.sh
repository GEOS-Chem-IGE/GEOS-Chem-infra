# Source this script to initialize micromamba:
#   source init-mamba.sh

# Parse and eval the output of `micromamba shell init --dry-run`
MAMBA_EXE=$(command -v micromamba)
if [ -z "$MAMBA_EXE" ]; then
  echo 'Error: micromamba not found'
  exit 1
fi
__mamba_shell_init="$(
  $MAMBA_EXE shell init --dry-run \
    | sed -n '/# >>> mamba initialize >>>$/,/^# <<< mamba initialize <<<$/p'
)"
eval "$__mamba_shell_init"
unset __mamba_shell_init
