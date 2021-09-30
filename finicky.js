module.exports = {
  defaultBrowser: 'Safari',
  handlers: [
    {
      match: [
        'buildkite.com/*',
        'kanbanize.com/*', '*.kanbanize.com/*',
        'github.com/*',
        'heroku.com/*',

        'calendar.google.com/*',
        'docs.google.com/*',
        'mail.google.com/*',
        'meet.google.com/*'
      ],
      browser: 'Brave Browser'
    }
  ]
}
