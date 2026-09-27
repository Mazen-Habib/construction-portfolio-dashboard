// Fact_Budget
// One wide row per project/month, unpivoted to (Measure, Value) so a single column chart
// can show budget, forecast, overrun and contingency side by side.

let
    Cols     = {"Budget", "Forecast", "Overrun",
                "ContingencyBase", "ContingencyUsed", "ContingencyForecast", "PotentialSavings"},
    Files    = fnMonthlyFiles(),
    Read     = Table.AddColumn(Files, "Data", each fnReadSection([Content], "Cost", 2, Cols)),
    Expanded = Table.ExpandTableColumn(Table.RemoveColumns(Read, {"Content"}), "Data", Cols),
    Dashes   = Table.ReplaceValue(Expanded, "-", null, Replacer.ReplaceValue, Cols),   // "-" = n/a
    Typed    = Table.TransformColumnTypes(Dashes, List.Transform(Cols, each {_, type number})),
    Long     = Table.UnpivotOtherColumns(Typed, {"ProjectFile", "Month", "Region"}, "Measure", "Value"),
    NoErrors = Table.ReplaceErrorValues(Long, {{"Value", 0}})
in
    NoErrors
