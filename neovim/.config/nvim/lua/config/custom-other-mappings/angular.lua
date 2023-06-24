local M = {}

local ng = {
  template = {
    target = "/%1/%2/%2.component.html",
    context = "template",
  },
  style = {
    target = "/%1/%2/%2.component.scss",
    context = "style",
  },
  theme = {
    target = "/%1/%2/%2.theme.scss",
    context = "style",
  },
  test = {
    target = "/%1/%2/%2.component.spec.ts",
    context = "test",
  },
  component = {
    target = "/%1/%2/%2.component.ts",
    context = "component",
  },
  module = {
    target = "/%1/%2/%2.module.ts",
    context = "module",
  },
  routing = {
    target = "/%1/%2/%2.routing.ts",
    context = "routing",
  },
  any = {
    target = "/%1/%2/%2.*.ts",
    context = "angular"
  }
}

M.module = {
  {
    pattern = "/(.*)/(.*)/.*.module.ts$",
    target = {
      ng.routing,
      ng.theme
    }
  }
}

M.routing = {
  {
    pattern = "/(.*)/(.*)/.*.routing.ts$",
    target = {
      ng.module
    }
  }
}

M.other = {
  {
    pattern = "/(.*)/(.*)/\\(*.service\\|*.pipe\\|*.directive\\).ts$",
    target = {
      ng.test
    }
  }
}

M.component = {
  {
    pattern = "/(.*)/(.*)/.*.component.ts$",
    target = {
      ng.template,
      ng.style,
      ng.theme,
      ng.test
    },
  },
}

M.template = {
  {
    pattern = "/(.*)/(.*)/.*.html$",
    target = {
      ng.component,
      ng.style,
      ng.theme,
      ng.test
    },
  },
}

M.style = {
  pattern = "/(.*)/(.*)/.*.scss$",
  target = {
    ng.template,
    ng.component,
    ng.test,
  },
}

M.test = {
  pattern = "/(.*)/(.*)/.*.spec.ts$",
  target = {
    ng.template,
    ng.style,
    ng.theme,
    ng.component,
    ng.any
  },
}

M.angular = {
  {
    pattern = "/(.*)/(.*)/.*.ts$",
    target = {
      ng.component,
      ng.module,
      ng.routing,
      ng.any,
      ng.style,
      ng.theme,
      ng.test
    },
  },
}

return M
