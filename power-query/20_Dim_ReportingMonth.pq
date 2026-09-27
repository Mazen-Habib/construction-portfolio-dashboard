// Dim_ReportingMonth
// Distinct reporting months found in the folder, with a real date for sorting and
// the "data as of" card.   "Mar-25" -> 2025-03-01

let
    Months = Table.Distinct(Table.SelectColumns(fnMonthlyFiles(), {"Month"})),
    AsDate = Table.AddColumn(Months, "MonthDate",
               each Date.FromText("01-" & [Month], [Format = "dd-MMM-yy", Culture = "en-US"]), type date),
    Sorted = Table.Sort(AsDate, {{"MonthDate", Order.Ascending}})
in
    Sorted
