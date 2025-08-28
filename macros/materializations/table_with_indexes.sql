{% materialization table_with_indexes, adapter='oracle' %}
  
  {%- set identifier = model['alias'] -%}
  {%- set target_relation = api.Relation.create(
      identifier=identifier,
      schema=schema,
      database=database,
      type='table') -%}
      
  {{ run_hooks(pre_hooks) }}

  -- Standard table materialization logic
  {%- call statement('main') -%}
    {{ create_table_as(False, target_relation, sql) }}
  {%- endcall -%}
  
  -- Add indexes based on model config
  {%- set indexes = config.get('indexes', []) -%}
  {%- for index in indexes %}
    {%- set index_name = index.get('name') -%}
    {%- set columns = index.get('columns', []) -%}
    {%- set is_unique = index.get('unique', false) -%}
    
    {%- if columns and index_name -%}
      {%- set index_sql -%}
        {%- if is_unique -%}
          create unique index {{ index_name }} on {{ target_relation }} ({{ columns | join(', ') }})
        {%- else -%}
          create index {{ index_name }} on {{ target_relation }} ({{ columns | join(', ') }})
        {%- endif -%}
      {%- endset -%}
      
      {%- call statement(index_name) -%}
        {{ index_sql }}
      {%- endcall -%}
    {%- endif -%}
  {%- endfor %}

  {{ run_hooks(post_hooks) }}
  
  {{ return({'relations': [target_relation]}) }}
  
{% endmaterialization %}
