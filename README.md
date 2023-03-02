# Structure

- `packages` - This is the directory for your dotfiles. This is supposed to be structered as the following:
- `packages/dir` - These directories usually relates to the kind of files it contains.
- `packages/dir/*.zsh` - These files are automatically loaded into your environment.
- `packages/dir/*.symlink` - These files are automatically symlinked to their corresponding section. The `.symlink.` is stripped.
- `packages/dir/*install.zsh` - These files are automatically executed during bootstrapping, unless barred from doing so. They can be executed seperately too. **Be sure to check if the installations are already present before proceeding**
- `packages/dir/*completion.zsh` - These files are loaded into zsh to get auto-completion.

