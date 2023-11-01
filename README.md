Dataset and code accompanying manuscript. 

The Dataset is provided here in JSON format, or can be made available on [Baserow](https://baserow.io/database/68981/) (at the moment).
The scripts demonstrate how to import and clean the data either from baserow, or json. 

The code imports and cleans data as above, and provides some preliminary analysis. 

The data itself is from the [Parliamentary Committee Inquiry into genAI in Education in Australia](https://www.aph.gov.au/Parliamentary_Business/Committees/House/Employment_Education_and_Training/AIineducation/Submissions), and used under a [cc-by-nc-nd license](https://www.aph.gov.au/Help/Disclaimer_Privacy_Copyright#c). 

Key documents are:

1. [report.rmd](report.rmd) which contains the main scripts for loading and processing the data
2. The `data` directory contains the raw data
3. The `output` directory contains some basic analysis including tabulated data and summaries, and some visualisations
4. The `R` directory contains
   1. [arc_data.R](R/arc_data.R) - some functions and quick scripts to get ARC grant data with a text filter
   2. [baserow_functions.R](R/[baserow_functions.R) - two simple functions to get (`get_data`) and process into tables (`table_data`) data from `baserow`
   3. [table_functions.R](R/table_functions.R) - some presets for output tables, `my_hux_theme` is used to create a common theme for huxtables
   4. [selector_table_attempt.R](R/selector_table_attempt.R) - a puzzle for the future...started drafting a code for filtering tables (doesn't work)
   5. [draft_functions.R](R/draft_functions.R) - a puzzle for the future...some functions to write back to baserow, and to use the tags as items (neither works)
   
You should cite

> Knight, S., Dickson-Deane, C., Heggart, K., Kitto, K., Çetindamar Kozanoğlu, D., Maher, D., Narayan, B., & Zarrabi, F. (2024). Generative AI in the Australian Education System: An Open Dataset of Stakeholder Recommendations and Emerging Analysis from a Public Inquiry. Australasian Journal of Educational Technology (AJET). Forthcoming.

