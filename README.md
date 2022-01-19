Neovim dotfiles

## Rationale

Keeping simple but at the same time powerful editing experience is what is
desired. And as David Thomas and Andrew Hunt say: 'Don’t spend more effort than
you save...'. So I stuck with a simple vim/neovim dotfiles configuration, which
gives me the following:

- no mouse interaction
- char, word, line and paragraph selection and movement
- move by syntactic units, such as, matching delimiters, functions, mudules
- code reindentation
- comment and uncomment block with a single command
- column, line number navigation
- sorting
- buffer and project-wide replacement by string or regexp pattern
- multiple cursor editing
- build, test and run a single unit or a whole project from the editor
- switching between projects
- interact with version control (blame, commit, logs, search)

Also, if a repetitive pattern is found during editing, then a command mapping to
shortcut is added. And always try to remember: 'Don’t spend more effort than you
save'!

## References

- [Lua guide](https://github.com/nanotee/nvim-lua-guide)
- [Other way to structure dot nvim](https://github.com/glepnir/nvim)
- [Package manager](https://github.com/wbthomason/packer.nvim)
- [Packages installation path](file://${HOME}/.local/share/nvim/site/pack/packer/start)

## License

MIT
