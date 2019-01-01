# amber-auth

Amber authentication is a plugin to Amber that provides a generator.

## Installation

1. Add the dev dependency to your `shard.yml` in your amber project:
```yaml
dev-dependencies:
  amber
    github: amberframework/amber

  amber-auth:
    github: drujensen/amber-auth
```

2. Run `shards build amber`

## Usage

Run the generator using `amber` that was just built:
```bash
bin/amber g auth user
```

## Contributing

1. Fork it (<https://github.com/drujensen/amber-auth/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Dru Jensen](https://github.com/drujensen) - creator and maintainer
