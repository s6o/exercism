%{
  statement: :select,
  columns: ["col1"],
  from: %{
    statement: :select,
    columns: ["col2", "col3"],
    from: % {
      statement: :select,
      columns: ["col4", "col5", "col6"],
      from: "some_table"
    }
  }
}
