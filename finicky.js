module.exports = {
  defaultBrowser: 'Safari',
  handlers: [
    {
      match: [
        '15five.com/*', 'envato.15five.com/*',
        'buildkite.com/*',
        'kanbanize.com/*', '*.kanbanize.com/*',
        'github.com/*',
        'heroku.com/*',
        'trello.com/*',

        'calendar.google.com/*',
        'docs.google.com/*',
        'mail.google.com/*',
        'meet.google.com/*'
      ],
      browser: 'Brave Browser'
    }
  ]
}
