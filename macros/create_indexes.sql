{% macro create_indexes_from_meta() %}
  {# Updated to handle newer dbt versions where the graph structure may have changed #}
  {% set models_with_indexes = [] %}
  {% if graph.nodes is defined %}
    {% set models_with_indexes = graph.nodes.values() | selectattr('resource_type', 'equalto', 'model') | selectattr('meta.indexes', 'defined') %}
  {% elif graph.model is defined %}
    {% set models_with_indexes = graph.model.values() | selectattr('meta.indexes', 'defined') %}
  {% endif %}
  
  {% for model in models_with_indexes %}
    {% if model.config.materialized != 'view' %}
      {% for index in model.meta.indexes %}
        {% set index_name = index.name %}
        {% set columns = index.columns | join(", ") %}
        {% set type = index.type | default('normal') %}
        
        {% set index_sql %}
          {% if type == 'unique' %}
            create unique index {{ index_name }} on {{ model.schema }}.{{ model.name }} ({{ columns }})
          {% else %}
            create index {{ index_name }} on {{ model.schema }}.{{ model.name }} ({{ columns }})
          {% endif %}
        {% endset %}
        
        {% do run_query(index_sql) %}
      {% endfor %}
    {% endif %}
  {% endfor %}
{% endmacro %}
