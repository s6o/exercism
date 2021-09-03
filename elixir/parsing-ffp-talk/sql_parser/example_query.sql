select col1 from (
  select col2, col3 from (
    select col4, col5, col6 from some_table
  )
)