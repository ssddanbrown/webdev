# Webdev

Ruby script for setting up new LAMP projects

## What Webdev Does

This script will add a line to your hosts file and create a new apache configuration so you can create development projects quickly and have neater urls such as `www.{project_name}.dev` instead of `localhost/{project_name}`.

## Requirements

This script only requires ruby to work. I have only tested functionality with ruby 2.1 so issues could arise with other versions.

Since the script changes system files you will most likely also require root access for full functionality.

## Configuration

Configuration variables can be found in the config.rb file. The hosts and apache configuration files are set for the default locations on Ubuntu. 

You will most likely have to change the projectsFolder variable you keep your sites. This is not where you want apache to point to.

Here are the defaults:

``` ruby
$projectsFolder = '/home/dan/www'	# The location of your project folders
$hosts = '/etc/hosts'				# Location of the systems host file
$apacheConfigDir = '/etc/apache2/sites-available' # Apache sites location
$exportFolder = '/usr/local/bin' 	# Where the 'export' command can create a link from to allow the script to be ran from any location
```
## Apache Templates

Within the `templates` folder you can find apache configurations. To fit in with current apache requirements these should end in '.conf'. Templates for laravel, wordpress and static sites are supplied as default. You can easily make your own for other applications. Just create a new template file with a sensible name and use the following syntax as substitutions:

```
{{name}}  # The name given with the create command
{{webroot}}  # The projectsFolder variable you configured
```

Look at the supplied templates as an example of using these variables.

## Usage

* `$ webdev create {name}` Creates apache configrations and hosts entries so that `www.{name}.dev` and `{name}.dev` point to the `{name}` folder in your configured projects folder.
*  `$ webdev create {name} {template}` Does the same as the above command but will use the specified template file. *Do not type the '.conf' extensionfor this command.*
*  `$ webdev remove {name}` Removes apache and hosts entry for `{name}`.
*  `$ webdev hosts-add {name}` Adds entries to your hosts file for `{name}.dev` and `www.{name}.dev`.
*  `$ webdev hosts-remove {name}` Removes entries for your project that are specified within the hosts file. 
*  `$ wedev export` Exports `webdev` to the `$exportFolder` so the command can be used from anywhere.
*  `$ webdev help` Shown help page with available commands.

## Notes

I have developed this script on Ubuntu 14.04 so many of the configurations may be out for your operating system and some functions may not even work. Please let me know if you have any issues or create a pull request with fixes. 