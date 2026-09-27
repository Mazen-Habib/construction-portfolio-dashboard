// Parameters: set once in Power BI Desktop (Transform data > Manage Parameters)
//   SourceFolder : root of the monthly template folder, e.g. C:\data\sample-data
//   SafetyApiUrl : endpoint of the safety-reporting API (not included in this repo)

SourceFolder = "C:\data\sample-data"
    meta [IsParameterQuery = true, Type = "Text", IsParameterQueryRequired = true]
