# Global Fisheries Intelligence — Premium Power BI Project

## Open the dashboard
1. Extract the entire ZIP to a normal local folder (do not open the ZIP in place).
2. Open `Global_Fisheries_Intelligence.pbip` in Power BI Desktop.
3. The report opens with six pages: Executive Overview, Aquaculture Leaders, Stock Sustainability, Production by Fish Type, Fishery Sectors, and Seafood Consumption.
4. Use the dropdown slicers and select bars/lines to cross-filter visuals within the same source table.
5. Save changes from Power BI Desktop. To create a PBIX for sharing, use **File → Save As → Power BI Desktop file (.pbix)** after the project opens successfully.

## Model preservation
The original `.SemanticModel` folder and its `.pbi/cache.abf` data cache are preserved from the user-supplied PBIP export. The nine source views, table columns, partitions and MySQL connection definitions were not modified. The report is rebuilt in PBIR (the report-definition layer) only.

## Data connection
The original semantic model uses Import partitions with a MySQL source at `localhost:3306`, database `global_fisheries_db`. Existing imported data is retained in the project cache. Refreshing the model requires the same MySQL database and compatible connector to be available on the machine.

## Page coverage and cautions
- Executive Overview: global capture and aquaculture annual trend; share cards are averages of annual share values.
- Aquaculture Leaders: country output snapshot (2018), contribution-share view, and production versus per-capita seafood supply comparison.
- Stock Sustainability: source view compares 2015 and 2017 stock measures.
- Production by Fish Type: source coverage 1961–2013. It defaults to `World` so country, regional and world aggregate rows are not added together.
- Fishery Sectors: global sector history 1950–2010; volume and share views remain separate.
- Seafood Consumption: per-capita supply series 1961–2017. Country ranking uses average annual supply across available years unless narrowed by the Year slicer.

The source tables do not have relationships in the original model. This package intentionally does not add speculative relationships between views with different grain/coverage. Slicers filter visuals backed by the same view, and chart selections cross-highlight compatible visuals on their page.

## Verification
All PBIR JSON files were parsed and structurally checked for required report/page/visual keys. The original semantic-model files were left unchanged. This environment does not include Power BI Desktop, so final in-application rendering must be verified by opening the `.pbip` file in Desktop.

READABILITY REVISION (2026-11-15)
- Updated all six report pages with a brighter, high-contrast ocean palette.
- Increased report title, subtitle, chart axis, legend, card, and note typography.
- Set chart axes, data labels, and card callouts to no automatic K/M display scaling.
- Added dynamic numeric format measures for production and catch volumes: thousands retain full grouped values (e.g. 2,000), while values at or above one million display with an m suffix (e.g. 2.5m).
- Enabled value labels on clustered bar charts; kept line, area, and scatter plots uncluttered.
