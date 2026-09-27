// fnMonthlyFiles
// Lists every template workbook under SourceFolder and tags it with its reporting month,
// read from the first sub-folder name:  <SourceFolder>\<Month>\<Region>\<Project>.xlsx
// Every fact query starts from this, so adding a month = dropping in a new folder.

() as table =>
let
    Source    = Folder.Files(SourceFolder),
    OnlyExcel = Table.SelectRows(Source, each [Extension] = ".xlsx"
                                        and [Attributes]?[Hidden]? <> true
                                        and not Text.StartsWith([Name], "~$")),
    RelPath   = Table.AddColumn(OnlyExcel, "RelPath",
                  each Text.AfterDelimiter([Folder Path], SourceFolder & "\"), type text),
    AddMonth  = Table.AddColumn(RelPath, "Month",
                  each Text.BeforeDelimiter([RelPath], "\"), type text),
    AddRegion = Table.AddColumn(AddMonth, "Region",
                  each Text.BetweenDelimiters([RelPath], "\", "\"), type text),
    Keep      = Table.SelectColumns(AddRegion, {"Content", "Name", "Month", "Region"}),
    Renamed   = Table.RenameColumns(Keep, {{"Name", "ProjectFile"}})
in
    Renamed
