{% macro age_group(date_of_birth) %}
    CASE
        WHEN DATEDIFF(YEAR, {{ date_of_birth }}, CURRENT_DATE) < 18 THEN 'below 18'
        WHEN DATEDIFF(YEAR, {{ date_of_birth }}, CURRENT_DATE) BETWEEN 18 AND 30 THEN '18-30'
        WHEN DATEDIFF(YEAR, {{ date_of_birth }}, CURRENT_DATE) BETWEEN 31 AND 45 THEN '31-45'
        WHEN DATEDIFF(YEAR, {{ date_of_birth }}, CURRENT_DATE) BETWEEN 46 AND 60 THEN '46-60'
        ELSE 'above 60'
    END
{% endmacro %}
