{% materialization script, default %}
  {%- set identifier = model['alias'] -%}
  {%- set target_relation = api.Relation.create(identifier=identifier, schema=schema, database=database, type='table') -%}

  -- drop the temp relations if they exist already in the database
  {{ run_hooks(pre_hooks, inside_transaction=False) }}
 
  -- `BEGIN` happens here:
  {{ run_hooks(pre_hooks, inside_transaction=True) }}

  -- build model
  {% call statement('main') -%}
    {{ sql }}
  {%- endcall %}

  {{ run_hooks(post_hooks, inside_transaction=True) }}

  -- `COMMIT` happens here
  {{ adapter.commit() }}

  -- persist the docs after the script has completed to ensure that the required object has been created
  {% do persist_docs(target_relation, model) %}

  {{ run_hooks(post_hooks, inside_transaction=False) }}

  {{ return({'relations': [target_relation]}) }}
{% endmaterialization %}