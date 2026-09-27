// fnReadSection
// Reads one section (sheet) of a template workbook and promotes its header row.
// A single generic function instead of one copy-pasted "Transform File" helper per section.
//   content   : binary workbook
//   sheetName : template sheet to read
//   skipRows  : title rows above the header
//   columns   : columns to keep (drops legends and side-notes that live on the same sheet)

(content as binary, sheetName as text, skipRows as number, columns as list) as table =>
let
    Book     = Excel.Workbook(content, null, true),
    Sheet    = Book{[Item = sheetName, Kind = "Sheet"]}[Data],
    Body     = Table.Skip(Sheet, skipRows),
    Promoted = Table.PromoteHeaders(Body, [PromoteAllScalars = true]),
    Trimmed  = Table.TransformColumnNames(Promoted, Text.Trim),
    Kept     = Table.SelectColumns(Trimmed, columns, MissingField.UseNull),
    NoBlank  = Table.SelectRows(Kept, each List.NonNullCount(Record.FieldValues(_)) > 0)
in
    NoBlank
