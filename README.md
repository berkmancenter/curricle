# curricle

## Solr

**Setup**

Start Solr with the following command, which will also generate a `/solr` directory with all of its config files:

```
bundle exec rake sunspot:solr:start
```

Once the files are generated, stop Solr so we can modify the config files:

```
bundle exec rake sunspot:solr:stop
```

Replace the default text field in `solr/configsets/sunspot/conf/schema.xml` with the template we've created at `config/templates/text-field-schema.xml`.

  _Note: The opening tag of the default text field will have a `name="text"` property._

Replace the default synonyms.txt file with the one we've created:

```
cp config/templates/synonyms.txt solr/configsets/sunspot/conf/synonyms.txt
```

Then reindex the Solr models:

```
rake sunspot:reindex
```

**Operation**

To start Solr in the foreground, run:

```
bundle exec rake sunspot:solr:run
```

To start Solr in the background, run:

```
bundle exec rake sunspot:solr:start
```

When Solr is running in the background you can stop it by running:

```
bundle exec rake sunspot:solr:stop
```
