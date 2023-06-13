local M = {}

M.styles = {
  {
    pattern = "/(.*)\\(*.css\\|*.scss\\)$",
    target = {
      {
        target = "/%1.\\(theme.css\\|theme.scss\\)",
        context = "style"
      },
      {
        target = "/%1.\\(component.css\\|component.scss\\)",
        context = "style"
      },
      {
        target = "/%1.\\(*.css\\|*.scss\\)",
        context = "style"
      }
    }
  }
}

return M
