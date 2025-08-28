{% macro check_indexes(table_name) %}
    {% set query %}
        SELECT INDEX_NAME, TABLE_NAME FROM USER_INDEXES WHERE UPPER(TABLE_NAME) = UPPER({{ table_name }})
    {% endset %}
    {% set results = run_query(query) %}
    {{ results }}
{% endmacro %}
