// Fact_SafetyIndicators
// Monthly leading/lagging safety indicators from a REST API returning JSON.
// Endpoint comes from a parameter; credentials live in the Power BI credential store,
// never in the query text.

let
    Source   = Json.Document(Web.Contents(SafetyApiUrl)),
    AsTable  = Table.FromList(Source, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Fields   = {"MonthDate", "SiteId", "SiteStatus", "IndicatorGroup", "IndicatorType", "Count"},
    Expanded = Table.ExpandRecordColumn(AsTable, "Column1", Fields),
    Typed    = Table.TransformColumnTypes(Expanded, {
                 {"MonthDate", type date}, {"SiteId", Int64.Type}, {"SiteStatus", type text},
                 {"IndicatorGroup", type text}, {"IndicatorType", type text}, {"Count", Int64.Type}})
in
    Typed
