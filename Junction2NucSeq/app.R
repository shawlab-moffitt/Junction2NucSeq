library(shiny)
library(httr2)

parse_region <- function(region) {
  m <- regexec("^(chr)?([^:]+):(\\d+)-(\\d+)$", region)
  x <- regmatches(region, m)[[1]]
  
  if (length(x) == 0) return(NULL)
  
  chr <- x[3]
  start <- as.numeric(x[4])
  end <- as.numeric(x[5])
  
  if (is.na(start) || is.na(end) || start > end) return(NULL)
  
  list(chr = chr, start = start, end = end)
}

get_ensembl_seq <- function(chr, start, end, strand = "+") {
  chr_clean <- sub("^chr", "", chr)
  strand_num <- ifelse(strand == "+", 1, -1)
  
  start <- as.numeric(start)
  end <- as.numeric(end)
  
  region <- sprintf("%s:%d..%d:%d", chr_clean, start, end, strand_num)
  
  req <- request(
    paste0("https://rest.ensembl.org/sequence/region/human/", region)
  ) |>
    req_headers("Content-Type" = "text/plain")
  
  resp <- req_perform(req)
  resp_body_string(resp)
}

get_junction_flanks <- function(chr, donor_end, acceptor_start,
                                strand = "+", flank = 10) {
  donor_end <- as.numeric(donor_end)
  acceptor_start <- as.numeric(acceptor_start)
  flank <- as.numeric(flank)
  
  seq_5p <- get_ensembl_seq(
    chr,
    donor_end - flank + 1,
    donor_end,
    strand
  )
  
  seq_3p <- get_ensembl_seq(
    chr,
    acceptor_start,
    acceptor_start + flank - 1,
    strand
  )
  
  list(
    five_prime_flank = seq_5p,
    three_prime_flank = seq_3p
  )
}

ui <- fluidPage(
  titlePanel("hg38/GRCh38 junction flank sequence fetch"),
  sidebarLayout(
    sidebarPanel(
      textInput("region", 'Junction region: "chr:start-end"', value = "chrX:54471487-54474527"),
      numericInput("flank", "Flank size", value = 10, min = 1),
      selectInput("strand", "Strand", choices = c("+", "-"), selected = "+"),
      actionButton("run", "Fetch sequence")
    ),
    mainPanel(
      verbatimTextOutput("status"),
      tags$hr(),
      verbatimTextOutput("sequence")
    )
  )
)

server <- function(input, output, session) {
  seq_res <- eventReactive(input$run, {
    reg <- parse_region(input$region)
    
    validate(
      need(!is.null(reg), 'Could not parse region. Use format like "chr1:100-200".')
    )
    
    seq <- tryCatch(
      get_junction_flanks(
        chr = reg$chr,
        donor_end = reg$start,
        acceptor_start = reg$end,
        strand = input$strand,
        flank = input$flank
      ),
      error = function(e) {
        list(error = conditionMessage(e))
      }
    )
    
    list(reg = reg, seq = seq)
  })
  
  output$status <- renderText({
    x <- seq_res()
    if (is.null(x)) return("Enter a junction and click Fetch sequence.")
    
    reg <- x$reg
    sprintf("Requested junction: chr%s:%d-%d", reg$chr, reg$start, reg$end)
  })
  
  output$sequence <- renderText({
    x <- seq_res()
    if (is.null(x)) return("")
    
    if (!is.null(x$seq$error)) {
      return(paste("ERROR:", x$seq$error))
    }
    
    paste0(
      "5' flank:\n", x$seq$five_prime_flank,
      "\n\n3' flank:\n", x$seq$three_prime_flank,
      "\n\n", paste0(x$seq$five_prime_flank, x$seq$three_prime_flank)
    )
  })
}

shinyApp(ui, server)
