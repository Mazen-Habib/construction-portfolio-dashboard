// Fact_ProgressSCurve
// Monthly and cumulative progress for four curves: baseline early, baseline late, actual, forecast.

let
    Cols     = {"Date", "EarlyMonthly", "EarlyCum", "LateMonthly", "LateCum",
                "ActualMonthly", "ActualCum", "ForecastMonthly", "ForecastCum"},
    Files    = fnMonthlyFiles(),
    Read     = Table.AddColumn(Files, "Data", each fnReadSection([Content], "SCurve", 1, Cols)),
    Expanded = Table.ExpandTableColumn(Table.RemoveColumns(Read, {"Content"}), "Data", Cols),
    Dated    = Table.SelectRows(Expanded, each [Date] <> null),
    Typed    = Table.TransformColumnTypes(Dated,
                 {{"Date", type date}} & List.Transform(List.Skip(Cols), each {_, type number})),
    // actuals stop at the data date: blank the trailing zeros so the line ends cleanly
    CleanActual = Table.ReplaceValue(Typed, 0, null, Replacer.ReplaceValue, {"ActualCum"})
in
    CleanActual
