# Filter function to apply custom filtering
custom_filter <- function(data, value) {
  data[grepl(paste(value, collapse = "|"), data$Tags_lookup), ]
}


# Filter function to apply custom filtering
custom_filter <- sprintf(
  "function(data, value) {
     var selectedTags = value;
     if (selectedTags.length === 0) {
       return data;
     } else {
       return data.filter(function(row) {
         var tagsArray = row[3].split(',');
         for (var i = 0; i < selectedTags.length; i++) {
           if (tagsArray.indexOf(selectedTags[i]) !== -1) {
             return true;
           }
         }
         return false;
       });
     }
   }"
)


# DT datatable with custom filtering
inquiry %>% datatable(
  escape = FALSE,
  extensions = 'Buttons',
  options = list(
    dom = 'Bfrtip',
    buttons = c(I('colvis'), c('copy', 'csv', 'excel')),
    lengthMenu = c(10, 100),
    pageLength = 100,
    scrollX = TRUE,
    searchHighlight = TRUE,
    editable = TRUE,
    autoWidth = TRUE,
    initComplete = JS(
      "function(settings, json) {
         var tags = ", jsonlite::toJSON(tag_filter), ";
         var select = $('<select id=\"tag_filter\" multiple></select>')
           .appendTo($('#', settings.nTable).closest('.dataTables_wrapper').find('.dataTables_filter'))
           .on('change', function() {
             var selectedTags = $('option:selected', this).map(function(index, element) {
               return $(element).val();
             }).get();
             table.column(3).search(selectedTags.join(', '), true, false).draw();
           })
           .append(tags.map(function(tag) {
             return $('<option></option>').attr('value', tag).text(tag);
           }));
         var table = $(settings.nTable).DataTable();
       }"
    ),
    columnDefs = list(
      list(targets = 3, searchable = FALSE)
    )
  )
) %>%
  formatStyle(
    1,
    width = '50px !important'
  ) %>%
  saveWidget("inquiry.html", selfcontained = TRUE)

