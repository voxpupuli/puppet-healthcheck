# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v2.1.0](https://github.com/voxpupuli/puppet-healthcheck/tree/v2.1.0) (2024-04-30)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Add Debian 12 support [\#88](https://github.com/voxpupuli/puppet-healthcheck/pull/88) ([bastelfreak](https://github.com/bastelfreak))
- Add Puppet 8 support [\#79](https://github.com/voxpupuli/puppet-healthcheck/pull/79) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- metadata.json: fix typo in summary [\#81](https://github.com/voxpupuli/puppet-healthcheck/pull/81) ([kenyon](https://github.com/kenyon))

## [v2.0.0](https://github.com/voxpupuli/puppet-healthcheck/tree/v2.0.0) (2023-05-02)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v1.0.1...v2.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#74](https://github.com/voxpupuli/puppet-healthcheck/pull/74) ([bastelfreak](https://github.com/bastelfreak))
- Drop Eol EL6/Ubuntu 14.04 support [\#71](https://github.com/voxpupuli/puppet-healthcheck/pull/71) ([bastelfreak](https://github.com/bastelfreak))
- Fix \#61 - Migrate to new runtime client, take II [\#66](https://github.com/voxpupuli/puppet-healthcheck/pull/66) ([kbucheli](https://github.com/kbucheli))
- Fix \#61 - Migrate to new runtime client [\#62](https://github.com/voxpupuli/puppet-healthcheck/pull/62) ([duritong](https://github.com/duritong))

**Implemented enhancements:**

- Add EL8/9, Ubuntu 20/22 and Debian 10/11 support [\#72](https://github.com/voxpupuli/puppet-healthcheck/pull/72) ([bastelfreak](https://github.com/bastelfreak))
- Add tcp\_conn\_validator acceptance tests [\#70](https://github.com/voxpupuli/puppet-healthcheck/pull/70) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Puppet 7 gives deprecation warning [\#61](https://github.com/voxpupuli/puppet-healthcheck/issues/61)

**Merged pull requests:**

- Document json accept header in README.md [\#75](https://github.com/voxpupuli/puppet-healthcheck/pull/75) ([bastelfreak](https://github.com/bastelfreak))
- Add http\_conn\_validator acceptance tests [\#73](https://github.com/voxpupuli/puppet-healthcheck/pull/73) ([bastelfreak](https://github.com/bastelfreak))
- Add REFERENCE.md [\#68](https://github.com/voxpupuli/puppet-healthcheck/pull/68) ([bastelfreak](https://github.com/bastelfreak))
- puppet-lint: Enable docs and types check [\#67](https://github.com/voxpupuli/puppet-healthcheck/pull/67) ([bastelfreak](https://github.com/bastelfreak))

## [v1.0.1](https://github.com/voxpupuli/puppet-healthcheck/tree/v1.0.1) (2020-04-05)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v1.0.0...v1.0.1)

**Fixed bugs:**

- replace configtimeout with http\_connect\_timeout \(\#54\) [\#55](https://github.com/voxpupuli/puppet-healthcheck/pull/55) ([b4ldr](https://github.com/b4ldr))

**Closed issues:**

- Accessing 'configtimeout' as a setting is deprecated [\#54](https://github.com/voxpupuli/puppet-healthcheck/issues/54)

**Merged pull requests:**

- README Formatting fix [\#49](https://github.com/voxpupuli/puppet-healthcheck/pull/49) ([deanwilson](https://github.com/deanwilson))

## [v1.0.0](https://github.com/voxpupuli/puppet-healthcheck/tree/v1.0.0) (2019-03-16)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v0.4.1...v1.0.0)

**Breaking changes:**

- modulesync 2.6.0 & drop Puppet 4 [\#47](https://github.com/voxpupuli/puppet-healthcheck/pull/47) ([bastelfreak](https://github.com/bastelfreak))

**Merged pull requests:**

- modulesync 2.2.0 and allow puppet 6.x [\#44](https://github.com/voxpupuli/puppet-healthcheck/pull/44) ([bastelfreak](https://github.com/bastelfreak))

## [v0.4.1](https://github.com/voxpupuli/puppet-healthcheck/tree/v0.4.1) (2018-09-07)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v0.4.0...v0.4.1)

**Merged pull requests:**

- Remove docker nodesets [\#38](https://github.com/voxpupuli/puppet-healthcheck/pull/38) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#37](https://github.com/voxpupuli/puppet-healthcheck/pull/37) ([bastelfreak](https://github.com/bastelfreak))
- drop EOL OSs; fix puppet version range [\#35](https://github.com/voxpupuli/puppet-healthcheck/pull/35) ([bastelfreak](https://github.com/bastelfreak))

## [v0.4.0](https://github.com/voxpupuli/puppet-healthcheck/tree/v0.4.0) (2017-11-17)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v0.3.0...v0.4.0)

**Merged pull requests:**

- bump puppet version dependency to \>= 4.7.1 \< 6.0.0 [\#31](https://github.com/voxpupuli/puppet-healthcheck/pull/31) ([bastelfreak](https://github.com/bastelfreak))

## [v0.3.0](https://github.com/voxpupuli/puppet-healthcheck/tree/v0.3.0) (2017-06-15)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v0.2.0...v0.3.0)

**Merged pull requests:**

- Document the verify peer parameter [\#26](https://github.com/voxpupuli/puppet-healthcheck/pull/26) ([duritong](https://github.com/duritong))
- fix example [\#25](https://github.com/voxpupuli/puppet-healthcheck/pull/25) ([duritong](https://github.com/duritong))
- Add LICENSE file [\#24](https://github.com/voxpupuli/puppet-healthcheck/pull/24) ([alexjfisher](https://github.com/alexjfisher))

## [v0.2.0](https://github.com/voxpupuli/puppet-healthcheck/tree/v0.2.0) (2017-01-12)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/v0.1.0...v0.2.0)

**Merged pull requests:**

- Bump minimum version\_requirement for Puppet [\#16](https://github.com/voxpupuli/puppet-healthcheck/pull/16) ([juniorsysadmin](https://github.com/juniorsysadmin))

## [v0.1.0](https://github.com/voxpupuli/puppet-healthcheck/tree/v0.1.0) (2016-08-31)

[Full Changelog](https://github.com/voxpupuli/puppet-healthcheck/compare/00ccbf0030226f18b2bf3493f9006c338dc78389...v0.1.0)

**Merged pull requests:**

- Added verify\_peer property to provider. [\#9](https://github.com/voxpupuli/puppet-healthcheck/pull/9) ([soylentgrn](https://github.com/soylentgrn))
- Modulesync 0.12.5 & Release 0.1.0 [\#8](https://github.com/voxpupuli/puppet-healthcheck/pull/8) ([bastelfreak](https://github.com/bastelfreak))
- Add parameter for expected HTTP code [\#6](https://github.com/voxpupuli/puppet-healthcheck/pull/6) ([claytono](https://github.com/claytono))
- Remove UTF-8 characters from strings [\#5](https://github.com/voxpupuli/puppet-healthcheck/pull/5) ([claytono](https://github.com/claytono))
- Remove UTF-8 characters from strings [\#4](https://github.com/voxpupuli/puppet-healthcheck/pull/4) ([claytono](https://github.com/claytono))
- http\_conn\_validator: Initial commit [\#2](https://github.com/voxpupuli/puppet-healthcheck/pull/2) ([Spredzy](https://github.com/Spredzy))
- tcp\_conn\_validator: Initial commit [\#1](https://github.com/voxpupuli/puppet-healthcheck/pull/1) ([Spredzy](https://github.com/Spredzy))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
