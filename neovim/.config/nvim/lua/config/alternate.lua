local emberOthers = {
  {
    target = "/iverson/app/controllers/%1.js", context = 'controller',
  },
  {
    target = "/iverson/app/controllers/**/%1.js", context = 'controller',
  },
  {
    target = "/iverson/app/models/%1.js", context = 'model',
  },
  {
    target = "/iverson/app/models/**/%1.js", context = 'model',
  },
  {
    target = "/iverson/app/components/%1.js", context = 'component',
  },
  {
    target = "/iverson/app/components/**/%1.js", context = 'component',
  },
  {
    target = "/iverson/app/templates/components/%1.hbs", context = 'hbs',
  },
  {
    target = "/iverson/app/templates/components/**/%1.hbs", context = 'hbs',
  },
  {
    target = "/iverson/app/styles/%1.scss", context = 'css',
  },
  {
    target = "/iverson/app/styles/**/%1.scss", context = 'css',
  },
  {
    target = "/iverson/app/**/%1.js", context = "anyjs"
  },
  {
    target = "/iverson/app/**/%1.scss", context = "anycss"
  },
  {
    target = "/iverson/app/**/%1.hbs", context = "anyhbs"
  },
  -- looser check for files that contain but are not exact matches of the expected
  {
    target = "/iverson/app/controllers/*%1*.js", context = 'controller',
  },
  {
    target = "/iverson/app/controllers/**/*%1*.js", context = 'controller',
  },
  {
    target = "/iverson/app/models/*%1*.js", context = 'model',
  },
  {
    target = "/iverson/app/models/**/*%1*.js", context = 'model',
  },
  {
    target = "/iverson/app/components/*%1*.js", context = 'component',
  },
  {
    target = "/iverson/app/components/**/*%1*.js", context = 'component',
  },
  {
    target = "/iverson/app/components/templates/*%1*.hbs", context = 'hbs',
  },
  {
    target = "/iverson/app/components/templates/**/*%1*.hbs", context = 'hbs',
  },
  {
    target = "/iverson/app/styles/*%1*.scss", context = 'css',
  },
  {
    target = "/iverson/app/styles/**/*%1*.scss", context = 'css',
  },
  {
    target = "/iverson/app/**/*%1*.js", context = "anyjs"
  },
  {
    target = "/iverson/app/**/*%1*.scss", context = "anycss"
  },
  {
    target = "/iverson/app/**/*%1*.hbs", context = "anyhbs"
  },
}

require("other-nvim").setup({
  mappings = {
    "angular",
    {
      pattern = "/iverson/app/controllers/(.*).js",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/models/(.*).js",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/components/(.*).js",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/templates/components/(.*).hbs",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/styles/(.*).scss",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/controllers/**/(.*).js",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/models/**/(.*).js",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/components/**/(.*).js",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/templates/components/**/(.*).hbs",
      target = emberOthers,
    },
    {
      pattern = "/iverson/app/styles/**/(.*).scss",
      target = emberOthers,
    },
  },
  transformers = {
    lowercase = function(inputString)
      return inputString:lower()
    end
  },
  style = {
    border = "solid",
    seperator = "|",
    width = 0.7,
    minHeight = 2
  },
})
