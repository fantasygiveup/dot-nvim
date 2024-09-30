local M = {}

M.config = function()
  require("gitlinker").setup({
    router = {
      browse = {
        ["^bitbucket%.dentsplysirona%.com"] = "https://bitbucket.dentsplysirona.com/"
          .. "projects/"
          .. "{_A.ORG}/repos/"
          .. "{_A.REPO}/browse/"
          .. "{_A.FILE}"
          .. "?at=refs/heads/{_A.CURRENT_BRANCH}"
          .. "#{_A.LSTART}"
          .. "{(_A.LEND > _A.LSTART and ('-' .. _A.LEND) or '')}",
      },
      default_branch = {
        ["^bitbucket%.dentsplysirona%.com"] = "https://bitbucket.dentsplysirona.com/"
          .. "projects/"
          .. "{_A.ORG}/repos/"
          .. "{_A.REPO}/browse/"
          .. "{_A.FILE}"
          .. "?at=refs/heads/{_A.DEFAULT_BRANCH}"
          .. "#{_A.LSTART}"
          .. "{(_A.LEND > _A.LSTART and ('-' .. _A.LEND) or '')}",
      },
      current_branch = {
        ["^bitbucket%.dentsplysirona%.com"] = "https://bitbucket.dentsplysirona.com/"
          .. "projects/"
          .. "{_A.ORG}/repos/"
          .. "{_A.REPO}/browse/"
          .. "{_A.FILE}"
          .. "?at=refs/heads/{_A.CURRENT_BRANCH}"
          .. "#{_A.LSTART}"
          .. "{(_A.LEND > _A.LSTART and ('-' .. _A.LEND) or '')}",
      },
    },
  })

  require("keymap").git_linker()
end

return M
