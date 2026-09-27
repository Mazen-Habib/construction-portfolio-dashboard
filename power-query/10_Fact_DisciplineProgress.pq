// Fact_DisciplineProgress
// Weight / early plan / late plan / actual % per discipline, per project, per month.

let
    Cols     = {"Discipline", "Weight", "EarlyPlan", "LatePlan", "Actual"},
    Files    = fnMonthlyFiles(),
    Read     = Table.AddColumn(Files, "Data", each fnReadSection([Content], "Progress", 1, Cols)),
    Expanded = Table.ExpandTableColumn(Table.RemoveColumns(Read, {"Content"}), "Data", Cols),
    Typed    = Table.TransformColumnTypes(Expanded,
                 List.Transform(List.Skip(Cols), each {_, type number})),
    NoErrors = Table.ReplaceErrorValues(Typed,
                 List.Transform(List.Skip(Cols), each {_, null}))
in
    NoErrors
