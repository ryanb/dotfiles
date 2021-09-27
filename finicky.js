module.exports = {
  defaultBrowser: "Safari",
  handlers: [
    {
      match: [
        "mail.google.com", "mail.google.com/*",
        "docs.google.com", "docs.google.com/*",
        "calendar.google.com", "calendar.google.com/*",
        "meet.google.com", "meet.google.com/*",
        "github.com", "github.com/*"
      ],
      browser: "Brave Browser"
    }
  ]
};
