{% macro concat_customer_name(first_name, last_name) %}
    CONCAT({{ first_name }}, ' ', {{ last_name }})
{% endmacro %}
