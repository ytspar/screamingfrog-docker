# Forked from ScreamingFrog Docker (Enchanced)

Found here: https://github.com/carlwoodhouse/screamingfrog-docker

Giving it a version bump to 11.3 and 4gb RAM by default.

## Very important

The license file is licence.txt (in UK English, licence is the noun and license the verb form... go figure).

There should be no newline at the end.

If you're stuck on "license invalid" errors, `scp` the file from a GUI version of Screaming Frog on your local machine (on my Mac, the config files are located at `~/.ScreamingFrogSEOSpider`).

**So**

From your local Screaming Frog directory,

`scp licence.txt user@remoteboxip:~/reotescreamingfrogdir/licence.txt`

You may also want to compare the sha1 checksums of both with `openssl sha1 licence.txt`

# ScreamingFrog Docker (Enhanced)

Forked from https://github.com/iihnordic/screamingfrog-docker - thanks for the original

Enhanced features
* [Memory Allocation (ENV Variable)](#Memory-allocation)
* [SF Version Declaration (Build Arg)](#Setting-the-version)
* [Azure Container Instance Support](#Azure-container-instance-support)


# ScreamingFrog Docker (Original)
Provides headless screaming frogs.

Helped by [`databulle`](https://www.databulle.com/blog/seo/screaming-frog-headless.html) - thank you!

Contains a Docker installation Ubuntu ScreamingFrog v10 intended to be used for its [Command Line Interface](https://www.screamingfrog.co.uk/seo-spider/user-guide/general/#command-line).


## Installation

1. Clone repo
2. Add a licence.txt file with your username on the first line, and key on the second.

3. Run:

`docker build -t screamingfrog .`

Or submit to Google Build Triggers, which will host it for you privately at a URL like
`gcr.io/your-project/screamingfrog-docker:a2ffbd174483aaa27473ef6e0eee404f19058b1a` - for use in Kubernetes and such like.

## Usage

Once the image is built it can be reached via `docker run screamingfrog`.  By default it will show `--help`

```
> docker run screamingfrog

usage: ScreamingFrogSEOSpider [crawl-file|options]

Positional arguments:
    crawl-file
                         Specify a crawl to load. This argument will be ignored if there
                         are any other options specified

Options:
    --crawl <url>
                         Start crawling the supplied URL

    --crawl-list <list file>
                         Start crawling the specified URLs in list mode

    --config <config>
                         Supply a config file for the spider to use

    --use-majestic
                         Use Majestic API during crawl

    --use-mozscape
                         Use Mozscape API during crawl

    --use-ahrefs
                         Use Ahrefs API during crawl

    --use-google-analytics <google account> <account> <property> <view> <segment>
                         Use Google Analytics API during crawl

    --use-google-search-console <google account> <website>
                         Use Google Search Console API during crawl

    --headless
                         Run in silent mode without a user interface

    --output-folder <output>
                         Where to store saved files. Default: current working directory

    --export-format <csv|xls|xlsx>
                         Supply a format to be used for all exports

    --overwrite
                         Overwrite files in output directory

    --timestamped-output
                         Create a timestamped folder in the output directory, and store
                         all output there

    --save-crawl
                         Save the completed crawl

    --export-tabs <tab:filter,...>
                         Supply a comma separated list of tabs to export. You need to
                         specify the tab name and the filter name separated by a colon

    --bulk-export <[submenu:]export,...>
                         Supply a comma separated list of bulk exports to perform. The
                         export names are the same as in the Bulk Export menu in the UI.
                         To access exports in a submenu, use <submenu-name:export-name>

    --save-report <[submenu:]report,...>
                         Supply a comma separated list of reports to save. The report
                         names are the same as in the Report menu in the UI. To access
                         reports in a submenu, use <submenu-name:report-name>

    --create-sitemap
                         Creates a sitemap from the completed crawl

    --create-images-sitemap
                         Creates an images sitemap from the completed crawl

 -h, --help
                         Print this message and exit
```

## Crawling

Crawl a website via the example below.  You need to add a local volume if you want to save the results to your laptop.  A folder of `/home/crawls/` is available in the Docker image you can save crawl results to.

The example below starts a headless crawl of `http://iihnordic.com` and saves the crawl and a bulk export of "All Outlinks" to a local folder, that is linked to the `/home/crawls` folder within the container.

```
> docker run -v /foo/bar/screamingfrog-docker/crawls:/home/crawls screamingfrog --crawl http://iihnordic.com --headless --save-crawl --output-folder /home/crawls --timestamped-output --bulk-export 'All Outlinks'
```

## Memory allocation

By default screamingfrog sets a memory allocation of 2gb, this can be limiting if using in memory crawling for large sites (over 100k)+. To increase the memory allocation run with an envirnmoent variable of SF_MEMORY set to a value (12g, 1024M, etc) - recommended is 2g less then the memory in the container.

## Setting the version

By default this image uses version 10.3 of screaming frog, you can override this when building the container by setting SF_Version arg to the required version

## Azure Container Instance support

To deploy this image as an azure container instance so you can spin up on demand docker images to crawl you can just use the supplied arm template, in order to override the params for your crawl, set the commands param to be something like this ..

```
sh, /docker-entrypoint.sh --headless, --crawl, https://google.come, --config, /home/crawls/mycrawlconfig.seospiderconfig, --save-crawl, --output-folder, /home/crawls, --timestamped-output, --export-tabs, Internal:All, --export-format, csv, --save-report, Crawl Overview, Orphan Pages, --bulk-export, Response Codes:Client Error (4xx) Inlinks
```

By default the template asks for some Azure storage credentials, this is where the crawl results should be saved ...
Ps. If you use Azure devops you can do neat stuff like schedule arm deployments using the template to do scheduled on demand crawling! And only pay for the time used to crawl.