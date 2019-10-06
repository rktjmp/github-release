# meeDamian/github-release

[![branches_gh_action_svg]][branches_gh_action_url]
[![gh_last_release_svg]][gh_last_release_url]
[![tippin_svg]][tippin_url]

[branches_gh_action_svg]: https://github.com/meeDamian/github-release/workflows/Create%20shortened%20tags/badge.svg
[branches_gh_action_url]: https://github.com/meeDamian/github-release/blob/master/.github/workflows/on-tag.yml

[gh_last_release_svg]: https://img.shields.io/github/v/release/meeDamian/github-release?sort=semver
[gh_last_release_url]: https://github.com/meeDamian/github-release/releases/latest

[tippin_svg]: https://img.shields.io/badge/donate-lightning-FDD023?logo=bitcoin&style=flat
[tippin_url]: https://tippin.me/@meeDamian

Github Action to create and update Github Releases, as well as upload assets to them.

# Usage

See [action.yml](action.yml)

### Minimal

```yaml
steps:
- uses: actions/checkout@v1

- uses: meeDamian/github-release@1.0
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
```

`token` is the only **always required** parameter to be passed to this action.  Everything else can use sane defaults in some circumstances.  See [arguments] to learn more.

[arguments]: #Arguments

### Arguments

#### Action Inputs

| name             | required   | description 
|:----------------:|:----------:|-------------
| `token`          | **always** | Github Access token.  Can be accessed by using `${{ secrets.GITHUB_TOKEN }}` in the workflow file.
| `tag`            | sometimes  | If triggered by git tag push, tag is picked up automatically.  Otherwise `tag:` has to be set. For tags constructed dynamically, see [Environment Variables] section.
| `commitish`      | no         | Commit hash this release should point to.  Unnecessary, if `tag` is a git tag.  Otherwise, current `master` is used. [more]
| `name`           | no         | Place to name the release, the more creative, the better. Defaults to the name of the tag used. [more]
| `body`           | no         | Place to put a longer description of the release, ex changelog, or info about contributors.  Defaults to the commit message of the reference commit. [more]
| `draft`          | no         | Set to `true` to create a release, but not publish it. `false` by default. [more]
| `prerelease`    | no         | Marks this release as a pre-release. `false` by default. [more]
| `files`          | no         | A **space-separated** list of files to be uploaded. When left empty, no files are uploaded. [More on files below]
| `gzip`          | no         | Set whether to `gzip` uploaded assets, or not.  Available options are: `true`, `false`, and `folders` which uploads files unchanged, but compresses directories/folders.  Defaults to `true`.  Note: it errors if set to `false`, and `files:` argument contains path to a directory.
| `allow_override` | no        | Allow override of release, if one with the same tag already exists.  Defaults to `false`


[Environment Variables]: #Environment-Variables
[more]: https://developer.github.com/v3/repos/releases/#create-a-release
[More on files below]: #Files-syntax

#### Environment Variables

Github Actions inputs don't understand variables.  To go around it, some of the inputs provided by this action  fall back to reading from environment variables.

* `RELEASE_TAG` - Useful for dynamically created tag names

> **Note:** to [make an environment variable] visible to steps afterwards, use:
>   ```sh
>   echo ::set-env name=RELEASE_TAG::"v1.0.0"
>   ```

[make an environment variable]: https://help.github.com/en/articles/development-tools-for-github-actions#set-an-environment-variable-set-env

#### Files syntax

In it's simplest form it takes a single file/folder to be compressed & uploaded:

```yaml
with:
  …
  files: release/
```

Each uploaded element can also be named by prefixing the path to it with: `<name>:`, example:

```yaml
with:
  …
  files: release-v1.0.0:release/
```

As of Aug 2019, Github Actions doesn't support list arguments to actions, so to pass multiple files, pass them as a space-separated string.  To do that in an easier to read way, [YAML multiline syntax] can be used, example:

```yaml
with:
  …
  files: >
    release-v1.0.0-linux:release/linux/
    release-v1.0.0-mac:release/darwin/
    release-v1.0.0-windows:release/not-supported-notice
    checksums.txt      
```
[YAML multiline syntax]: https://yaml-multiline.info/ 

### Advanced example

```yaml
steps:
- uses: actions/checkout@master

- uses: meeDamian/github-release@0.1
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
    tag: v1.3.6
    name: My Creative Name
    body: >
      This release actually changes the fabric of the reality, so be careful 
      while applying, as error in database migration, can irrecoverably wipe 
      some laws of physics.  
    gzip: folders
    files: >
      Dockerfile
      action.yml
     .github/
      license:LICENSE
      work-flows:.github/
```


### Versioning

As of Aug 2019, Github Actions doesn't natively understand shortened tags in `uses:` directive.

To go around that and not do what `git-tag-manual` calls _"[The insane thing]"_, I'm creating permanent git tags for each release in a semver format prefixed with `v`, **as well as** maintain branches with shortened tags.  You can see the exact process [here].

Ex. `1.4` branch always points to the newest `v1.4.x` tag, etc.

In practice:

```yaml
# For exact version
steps:
  uses: meeDamian/github-release@v1.0.1
```
Or
```yaml
# For newest minor version 1.0
steps:
  uses: meeDamian/github-release@1.0
```

Note: It's likely branches will be deprecated once Github Actions fixes its limitation.

[The insane thing]: https://git-scm.com/docs/git-tag#_on_re_tagging
[here]: .github/workflows/on-tag.yml

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE)
