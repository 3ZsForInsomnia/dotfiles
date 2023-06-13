local M = {}

M.angular = {
  pattern =
  "/(.*)/(.*)/*.\\(component\\|spec\\|mock\\|interface\\|enum\\|directive\\|pipe\\|service\\|module\\|routing\\).ts$",
  target = {
    {
      target = "/%1/%2/%2.component.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.spec.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.mock.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.interface.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.enum.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.directive.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.pipe.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.service.ts",
      context = "angular"
    },
    {
      target = "/%1/%2.module.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.module.ts",
      context = "angular"
    },
    {
      target = "/%1.module.ts",
      context = "angular"
    },
    {
      target = "/%1/%2.module.ts",
      context = "angular"
    },
    {
      target = "/%1/%2/%2.routing.ts",
      context = "angular"
    },
    {
      target = "/%1.routing.ts",
      context = "angular"
    },
    {
      target = "/%1.routing.ts",
      context = "angular"
    }
  }
}

M.component = {
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

M.directive = {
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

M.service = {
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

M.pipe = {
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

M.routing = {
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

M.module = {
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

M.test = {
  pattern = "/(.*).\\(spec\\|mock\\).ts$",
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
      target = "/%1.module.ts",
      context = "module"
    },
    {
      target = "/%1.routing.ts",
      context = "routing"
    }
  }
}


return M
