# curricle

## Solr

Start Solr with the following command, which will also generate a `/solr` directory with all of its config files:

`bundle exec rake sunspot:solr:start`

Replace the default text field in the Solr schema file with the template we've created:

* config/templates/text-field-schema.xml

Add/replace the synonyms.txt file in the Solr/configsets/sunspot/conf/ with the one provided in config/templates/

Then reindex the Solr models:

`rake sunspot:reindex`

When necessary, you can stop Solr with the following command:

`bundle exec rake sunspot:solr:stop`