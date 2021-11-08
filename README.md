A simple URL shortner built using the following tools:

Perl
[Mojolicious](https://mojolicious.org/)
SQLite
[Tailwind CSS](https://tailwindcss.com/)
[clipboard.js](https://clipboardjs.com/)

## Installing:

```bash
  cpanm --installdeps .
```

## Running tests:
```bash
  prove -l t/
```

## Running web server:

#### Dev server:
```bash
morbo script/url_shortner
```

#### Prod server:
```bash
hypnotoad script/url_shortner
```

Things to improve:

- [ ] Add collision detection, its unlikely but possible
- [ ] Add better logging debug/warning/error
- [ ] Add additional testing
- [ ] Implement the database connection in a cleaner way
