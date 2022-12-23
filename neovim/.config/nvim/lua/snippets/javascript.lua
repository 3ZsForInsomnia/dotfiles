return {
  s('de', { t('debugger') }),
  s(
    {
      trig = 'clv',
      name = 'console.log("$1", $1);',
    },
    {
      t('console.log("'),
      i(1),
      t('", '),
      extras.rep(1),
      t(');')
    }
  ),
}
