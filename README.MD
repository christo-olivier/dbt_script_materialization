# Overview

DBT out of the box does not allow you to use complicated DML or DDL in a script to create your models. There are very good reasons for this and the team behind DBT articulates all of them in the documentation. Unfortunately there are scenarios where the limitations DBT tries to enforce on the type of SQL you should write makes solving particular challenges extremely difficult if not impossible.

This `script` materialization macro will allow you to create models in DBT by writing an SQL script containing any logic you choose. It allows you to use `ref` and `source` macros to have your model built as you would any other model. 

As the saying goes, with great power comes great responsability. You dont have any of the guardrails that DBT provides here. So you script needs to take care of doing the creation of tables if they dont exist as well as have custom logic for full refreshes.

# Handling full and incremental refreshes

Since this materialization is used instead of the normal `incremental` option you will not be able to rely on the `is_incremental` macro. The `is_incremental` macro only works when you specify your materialization as `incremental`. Instead you will need to use the `should_full_refresh` macro. For example:

```
{% if should_full_refresh() == True %}
    
    DO LOGIC ON FULL REFRESH

{% endif %}
```

# How to use this

Simply copy the `script.sql` file into your macros folder of your DBT project. Once that is completed you can specify `script` in the `materialized` property of a config block at the top of your model files or anywhere else that you normally would set the `materialized` property for your models such as your `dbt_project.yaml` file.


