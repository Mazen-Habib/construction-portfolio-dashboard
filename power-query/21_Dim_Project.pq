// Dim_Project
// One row per project file: the hub every fact table relates to.
// File naming convention: "<ProjectCode> <Project Name>.xlsx"

let
    Distinct = Table.Distinct(Table.SelectColumns(fnMonthlyFiles(), {"ProjectFile", "Region"})),
    AddCode  = Table.AddColumn(Distinct, "ProjectCode",
                 each Text.BeforeDelimiter([ProjectFile], " "), type text),
    AddName  = Table.AddColumn(AddCode, "ProjectName",
                 each Text.BeforeDelimiter(Text.AfterDelimiter([ProjectFile], " "), ".xlsx"), type text)
in
    AddName
