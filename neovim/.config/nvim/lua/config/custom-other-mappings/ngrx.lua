local M = {}

M.ngrx = {
  pattern = "/(.*)/(.*)/*.\\(reducer\\|effects\\|actions\\|mock\\|spec|\\interface\\|enum\\|state\\|selectors\\).ts$",
  target = {
    {
      target = "/%1/%2/%2.reducer.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2/%2.spec.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2/%2.mock.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2/%2.interface.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2/%2.enum.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2/%2.actions.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2/%2.effects.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2/%2.state.ts",
      context = "ngrx"
    },
    {
      target = "/%1/%2.selectors.ts",
      context = "ngrx"
    },
  }
}

M.actions = {
  pattern = "/(.*)/(.*)/*.component.ts$",
  target = {
    {
      target = "/%1/*/*.directive.ts",
      context = "directive"
    },
    {
      target = "/%1/*/*.pipe.ts",
      context = "pipe"
    },
    {
      target = "/%1/*/*.service.ts",
      context = "service"
    },
    {
      target = "/%1/%2/%2.spec.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.mock.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.spec.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.mock.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.interface.ts",
      context = "type"
    },
    {
      target = "/%1/%2/%2.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.interface.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.enum.ts",
      context = "type"
    },
    {
      target = "/%1.module.ts",
      context = "module"
    },
    {
      target = "/%2.module.ts",
      context = "module"
    },
    {
      target = "/%1.routing.ts",
      context = "routing"
    }
  }
}

M.effects = {
  pattern = "/(.*)/(.*)/*.directive.ts$",
  target = {
    {
      target = "/%1/%2/%2.component.ts",
      context = "component"
    },
    {
      target = "/%1/*/*.pipe.ts",
      context = "pipe"
    },
    {
      target = "/%1/*/*.service.ts",
      context = "service"
    },
    {
      target = "/%1/%2/%2.spec.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.mock.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.spec.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.mock.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.interface.ts",
      context = "type"
    },
    {
      target = "/%1/%2/%2.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.interface.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.enum.ts",
      context = "type"
    },
    {
      target = "/%1.module.ts",
      context = "module"
    },
    {
      target = "/%2.module.ts",
      context = "module"
    },
    {
      target = "/%1.routing.ts",
      context = "routing"
    }
  }
}

M.selectors = {
  pattern = "/(.*)/(.*)/*.service.ts$",
  target = {
    {
      target = "/%1/*/*.component.ts",
      context = "component"
    },
    {
      target = "/%1/*/*.directive.ts",
      context = "directive"
    },
    {
      target = "/%1/%2/%2.spec.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.mock.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.spec.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.mock.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.interface.ts",
      context = "type"
    },
    {
      target = "/%1/%2/%2.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.interface.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.pipe.ts",
      context = "pipe"
    },
    {
      target = "/%1.module.ts",
      context = "module"
    },
    {
      target = "/%2.module.ts",
      context = "module"
    },
    {
      target = "/%1.routing.ts",
      context = "routing"
    }
  }
}

M.state = {
  pattern = "/(.*)/(.*)/*.pipe.ts$",
  target = {
    {
      target = "/%1/*/*.component.ts",
      context = "component"
    },
    {
      target = "/%1/*/*.directive.ts",
      context = "directive"
    },
    {
      target = "/%1/%2/%2.spec.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.mock.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.spec.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.mock.ts",
      context = "test"
    },
    {
      target = "/%1/%2/%2.interface.ts",
      context = "type"
    },
    {
      target = "/%1/%2/%2.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.interface.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.service.ts",
      context = "service"
    },
    {
      target = "/%1.module.ts",
      context = "module"
    },
    {
      target = "/%2.module.ts",
      context = "module"
    },
    {
      target = "/%1.routing.ts",
      context = "routing"
    }
  }
}

M.reducer = {
  pattern = "/(.*).routing.ts$",
  target = {
    {
      target = "/%1/*/*.component.ts",
      context = "component"
    },
    {
      target = "/%1/*/*.directive.ts",
      context = "directive"
    },
    {
      target = "/%1/*/*.spec.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.mock.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.interface.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.pipe.ts",
      context = "pipe"
    },
    {
      target = "/%1/*/*.service.ts",
      context = "service"
    },
    {
      target = "/%1.module.ts",
      context = "module"
    }
  }
}

M.test = {
  pattern = "/(.*).module.ts$",
  target = {
    {
      target = "/%1/*/*.component.ts",
      context = "component"
    },
    {
      target = "/%1/*/*.directive.ts",
      context = "directive"
    },
    {
      target = "/%1/*/*.spec.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.mock.ts",
      context = "test"
    },
    {
      target = "/%1/*/*.interface.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*/*.pipe.ts",
      context = "pipe"
    },
    {
      target = "/%1/*/*.service.ts",
      context = "service"
    },
    {
      target = "/%1/*.component.ts",
      context = "component"
    },
    {
      target = "/%1/*.directive.ts",
      context = "directive"
    },
    {
      target = "/%1/*.spec.ts",
      context = "test"
    },
    {
      target = "/%1/*.mock.ts",
      context = "test"
    },
    {
      target = "/%1/*.interface.ts",
      context = "type"
    },
    {
      target = "/%1/*.enum.ts",
      context = "type"
    },
    {
      target = "/%1/*.pipe.ts",
      context = "pipe"
    },
    {
      target = "/%1/*.service.ts",
      context = "service"
    },
    {
      target = "/%1.routing.ts",
      context = "routing"
    }
  }
}

return M
