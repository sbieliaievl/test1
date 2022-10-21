module.exports = {
  extends: ['@commitlint/config-conventional'],

  /*
  More details:
      * https://commitlint.js.org/#/reference-rules
      * https://github.com/conventional-changelog/commitlint/blob/master/%40commitlint/config-conventional/index.js
  */
  rules: {
    'body-leading-blank': [1, 'always'],
    'body-max-line-length': [2, 'always', 100],
    'footer-leading-blank': [1, 'always'],
    'footer-max-line-length': [2, 'always', 100],
    'header-max-length': [2, 'always', 100],

    // Allow more cases here to suit with Talend scoping based on JIRA-ITEM
    'scope-case': [
      2,
      'always',
      ['lower-case', 'upper-case', 'kebab-case']
    ],
    'subject-case': [
      2,
      'never',
      ['start-case', 'pascal-case', 'upper-case']
    ],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'type-case': [2, 'always', 'lower-case'],
    'type-empty': [2, 'never'],
    'type-enum': [
      2,
      'always',
      [
        'build',
        'chore',
        'ci',
        'docs',
        'feat',
        'fix',
        'perf',
        'refactor',
        'revert',
        'style',
        'test'
      ]
    ]
  }
}
