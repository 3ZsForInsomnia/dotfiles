local M = {}

local ngrx = {
  actions = {
    target = "/%1/%2/%3.actions.ts",
    context = "actions",
  },
  selectors = {
    target = "/%1/%2/%3.selectors.ts",
    context = "selectors",
  },
  reducer = {
    target = "/%1/%2/%3.reducer.ts",
    context = "reducer",
  },
  effects = {
    target = "/%1/%2/%3.effects.ts",
    context = "effects",
  },
  test = {
    target = "/%1/%2/%3.spec.ts",
    context = "test",
  },
  state = {
    target = "/%1/%2/%3.state.ts",
    context = "state",
  },
}

M.actions = {
  {
    pattern = "/(.*)/(.*)/(.*).actions.ts$",
    target = {
      ngrx.selectors,
      ngrx.reducer,
      ngrx.effects,
      ngrx.test,
      ngrx.state
    },
  },
}

M.selectors = {
  {
    pattern = "/(.*)/(.*)/(.*).selectors.ts$",
    target = {
      ngrx.actions,
      ngrx.reducer,
      ngrx.effects,
      ngrx.test,
      ngrx.state
    },
  },
}

M.reducer = {
  {
    pattern = "/(.*)/(.*)/(.*).reducer.ts$",
    target = {
      ngrx.actions,
      ngrx.selectors,
      ngrx.effects,
      ngrx.test,
      ngrx.state
    },
  },
}

M.effects = {
  {
    pattern = "/(.*)/(.*)/(.*).effects.ts$",
    target = {
      ngrx.actions,
      ngrx.selectors,
      ngrx.reducer,
      ngrx.test,
      ngrx.state
    },
  },
}

M.test = {
  {
    pattern = "/(.*)/(.*)/(.*).spec.ts$",
    target = {
      ngrx.actions,
      ngrx.selectors,
      ngrx.effects,
      ngrx.reducer,
      ngrx.state
    },
  },
}

M.state = {
  {
    pattern = "/(.*)/(.*)/(.*).state.ts$",
    target = {
      ngrx.actions,
      ngrx.selectors,
      ngrx.effects,
      ngrx.reducer,
      ngrx.test
    },
  },
}

M.ngrx = {
  {
    pattern = "/(.*)/(.*)/(.*).ts$",
    target = {
      ngrx.actions,
      ngrx.selections,
      ngrx.effects,
      ngrx.reducer,
      ngrx.test,
      ngrx.state,
    },
  }
}

return M
