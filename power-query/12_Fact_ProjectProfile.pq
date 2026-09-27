// Fact_ProjectProfile
// The project fact sheet is stored as label/value pairs. Unpivot it and add a display
// order so the matrix visual always lists the fields in the same sequence.

let
    Order    = {"Location", "Technology", "Capacity", "Contract Value", "Contract Type",
                "Owner", "Main Contractor", "Equipment Supplier", "Operator"},
    Files    = fnMonthlyFiles(),
    Read     = Table.AddColumn(Files, "Data", each
                 let
                     Sheet = Excel.Workbook([Content], null, true){[Item = "Profile", Kind = "Sheet"]}[Data],
                     Pairs = Table.SelectRows(Table.SelectColumns(Sheet, {"Column1", "Column2"}),
                                              each [Column1] <> null)
                 in
                     Table.RenameColumns(Pairs, {{"Column1", "Attribute"}, {"Column2", "Value"}})),
    Expanded = Table.ExpandTableColumn(Table.RemoveColumns(Read, {"Content"}), "Data",
                 {"Attribute", "Value"}),
    Trimmed  = Table.TransformColumns(Expanded, {
                 {"Attribute", Text.Trim, type text},
                 {"Value", each Text.Trim(Text.From(_)), type text}}),
    Kept     = Table.SelectRows(Trimmed, each List.Contains(Order, [Attribute])),
    Indexed  = Table.AddColumn(Kept, "DisplayOrder",
                 each List.PositionOf(Order, [Attribute]) + 1, Int64.Type)
in
    Indexed
