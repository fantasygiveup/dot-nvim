Neovim dotfiles

# Rationale

Keeping simple but at the same time powerful editing experience is what is
desired. And as David Thomas and Andrew Hunt say: 'Don’t spend more effort than
you save...'. So I stuck with a simple vim/neovim dotfiles configuration, which
gives me the following:

-   no mouse interaction
-   char, word, line and paragraph selection and movement
-   move by syntactic units, such as, matching delimiters, functions, mudules
-   code reindentation
-   comment and uncomment block with a single command
-   column, line number navigation
-   sorting
-   buffer and project-wide replacement by string or regexp pattern
-   multiple cursor (places) editing ([you-don-t-need-more-than-one-cursor-in-vim](https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db))
-   build, test and run a single unit or a whole project from the editor
-   switching between projects
-   interact with version control (blame, commit, logs, search)

Also, if a repetitive pattern is found during editing, then a command shortcut
is added. Mantra: 'Don’t spend more effort than you save' even if you fell in
love with your editor!

# References

-   [Lua guide](https://github.com/nanotee/nvim-lua-guide)
-   [Nvim API](https://neovim.io/doc/user/api.html)
-   [Whats new in nvim 0.7](https://gpanders.com/blog/whats-new-in-neovim-0-7)
-   [Other way to structure dot nvim](https://github.com/glepnir/nvim)
-   [Package manager](https://github.com/wbthomason/packer.nvim)

## License

MIT
