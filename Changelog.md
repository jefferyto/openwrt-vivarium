# Changelog

## [0.1.5-dev][Unreleased] - Unreleased
* Switch to the openwrt/sdk Docker image
* Replace bind mounts for `sdk/staging_dir/hostpkg` and
  `sdk/staging_dir/target` with one bind mount for `sdk/staging_dir`
* Change bind mount destination paths for `packages` and `sdk/overrides`
* Use default feeds.conf from the SDK
* Always add `packages` as a custom feed
* Add `USE_GITHUB_FEEDS` run-time option
* Add script to set ownership of bind mounts
* Fix config options not set correctly

## [0.1.4] - 2022-05-30
* Update to v1.0.7 of the packages-cci Docker image (includes public
  keys for 22.03)

## [0.1.3] - 2022-05-11
* Update to v1.0.6 of the packages-cci Docker image (includes public
  keys for 21.02)

## [0.1.2] - 2019-12-02
* Update to v1.0.5 of the packages-cci Docker image (includes public
  keys for 19.07)

## [0.1.1] - 2019-07-18
* Added support for usign signatures

## 0.1.0 - 2019-06-05
* Initial release


[Unreleased]: https://github.com/jefferyto/openwrt-vivarium/compare/0.1.4...main
[0.1.4]: https://github.com/jefferyto/openwrt-vivarium/compare/0.1.3...0.1.4
[0.1.3]: https://github.com/jefferyto/openwrt-vivarium/compare/0.1.2...0.1.3
[0.1.2]: https://github.com/jefferyto/openwrt-vivarium/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/jefferyto/openwrt-vivarium/compare/0.1.0...0.1.1
