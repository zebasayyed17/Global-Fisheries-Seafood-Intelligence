# Global Fisheries Intelligence: Power BI build (about 25 min)
1. Power BI Desktop > View > Themes > Browse for themes > `theme_ocean.json`. Set canvas 16:9, page background #F3F6FA.
2. Transform data > New Parameter `DataPath` (Text) = full path of `data\` folder. Add queries from `1_power_query.m`. Close & Apply.
3. Model view: create `Dim_Year` and `_Measures` as in `2_measures.dax`; draw the listed relationships. Hide key columns. Format: Share/Growth measures as %, Mt with 1 decimal.
4. Dim_Entity: Entity sort fine; add a slicer filter `EntityType = Country` on rankings (visual-level filter).

## Page 1 "Overview"
- Top row: Slicers (Entity dropdown single-select, default World; Year slider). Title card = [Selected Title].
- 5 Cards: [Total Production Mt], [Aquaculture Share %], [Capture t] (format Millions), [Consumption kg pc], [Sustainable Stock %]. Add [Production Growth 5Y %] as card subtitle/KPI visual.
- Stacked area: Axis Dim_Year[Year], Values [Capture t], [Aquaculture t] (colors orange/green).
- Bar (top 10): Dim_Entity[Entity] by [Total Production Mt], filter Top N 10, EntityType=Country, year slicer applied. Conditional color for selected.
- Line: Year vs [Consumption kg pc].
## Page 2 "Sustainability & Structure"
- Stacked area Fact_FishType: Year, [Fish Type Mt], Legend FishType (Entity=World).
- Stacked area Fact_Sector: Year, Value Tonnes/1e6, Legend Sector.
- 100% stacked bar Fact_Stocks by Region: Sustainable_Pct, Overexploited_Pct (latest year via visual filter Year = max, exclude World).
- Line: Fact_Stocks[Year] vs [Sustainable Stock %] (World).
## Page 3 "Country Explorer"
- Map (filled): Dim_Entity[Entity] with Country filter, bubble size [Total Production Mt], color [Aquaculture Share %]. Table: Entity, [Total Production Mt], [Aquaculture Share %], [Production Growth 5Y %], [Producer Rank]. Add Decomposition tree (Capture/Aquaculture).
Add bookmarks + page navigator, sync slicers, tooltips pages for KPIs. Publish and set scheduled refresh if sources move online.
