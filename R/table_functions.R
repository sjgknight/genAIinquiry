
#thing for DT
headerCallback <- c(
  "function(thead, data, start, end, display){",
  "  var $ths = $(thead).find('th');",
  "  $ths.css({'vertical-align': 'bottom', 'white-space': 'nowrap'});",
  "  var betterCells = [];",
  "  $ths.each(function(){",
  "    var cell = $(this);",
  "    var newDiv = $('<div>', {height: 'auto', width: cell.height()});",
  "    var newInnerDiv = $('<div>', {text: cell.text()});",
  "    newDiv.css({margin: 'auto'});",
  "    newInnerDiv.css({",
  "      transform: 'rotate(180deg)',",
  "      'writing-mode': 'tb-rl',",
  "      'white-space': 'normal',",
  "      'word-wrap': 'break-word'",
  "    });",
  "    newDiv.append(newInnerDiv);",
  "    betterCells.push(newDiv);",
  "  });",
  "  $ths.each(function(i){",
  "    $(this).html(betterCells[i]);",
  "  });",
  "}"
)

pacman::p_load(huxtable)
# theme for hux
my_hux_theme <- function(ht) {
  font(ht) <- "Arial"
  font_size(ht) <- 11

  #bold header
  bold(ht[1,1]) <- TRUE

  #no outer borders
  top_border(ht[1,]) <- 0
  bottom_border(ht[nrow(ht),]) <- 0
  left_border(ht[,1]) <- 0
  right_border(ht[,ncol(ht)]) <- 0
  #or more simply
  #set_outer_borders()


  #spacing
  set_all_padding(ht, 0.1)

  #return modified
  return(ht)

}
