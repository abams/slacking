# Slacking

Slacking is a small Ruby CLI to post to slack chat room with different various profiles (impersonating other users, i.e. Tim Lincecum)

## Dependencies

- Ruby 1.9 or better

## Installation

Install with RubyGems.

```
$ gem install slacking
```

## Usage

### Post messages to Slack

```
$ slacking
```

This will create a session that will allow you to use and reuse multiple profiles to post messages to slack.  You will need your slack api token.

### Profiles

Profiles are stored in `~/.slacking_profiles`

Config (slack api token) is stored in `~/.slacking_config`

You can change these locations by running Slacking using Environment Variables

`PROFILES_DIR, CONFIG_DIR, HOME`

### Editing Profiles

Profiles can be edited by using either a `--image` or `--channel` tag when specifying the username

## License

Slacking is MIT licensed (see LICENSE.txt)

## Contributing

1. Fork it ( http://github.com/<my-github-username>/slacking/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
