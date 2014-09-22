#' little script for reading in a ChipSeq peak file and
#' plot the these motifs as a lineplot showing the occurences 
#' of a peak regarding to the number of peaks in the file 
#'
library(plyr)
library(ggplot2)
library(scales)
library(data.table)

#' function that extract all motifs from given data and calculate 
#' in given resolutions the number of motifs
#' return a data.frame for ggplot 2
generate.input <- function(data, resolution, trim = TRUE) {
  # extract all motifs
  motifs <- unique(data$motif)
  # build a list of data.frame containing the calculated data for every motif
  res <- lapply(motifs, function(x) {
    # starting position of peak
    start <- 0
    # determine the exit - for better plotting incomplete 
    # intervals at the end can be thrown away
    if (trim) {
      exit <- round_any(max(data$peak), resolution.steps)
    } else {
      exit <- max(data$peak)
    }
    # extract actual motif  
    actual.motif <- data[which(data$motif == x), ]
    # use only unique actual motifs
    actual.motif <- actual.motif[!duplicated(actual.motif$peak), ]
    # initialize an empty data.frame 
    data2 <- data.frame(motif=integer(),
                        peak=integer(),
                        count=numeric())  
    # index of data.frame
    i <- 1
    # calculate the rows for every interval 
    while(!(start >= exit)) {
      # determine end of interval
      end <- start + resolution
      # get all peaks in the interval
      y <- actual.motif[between(actual.motif$peak, start, end),]
      # create a row for the interval
      data2[i, ] <- data.frame(motif = unique(y$motif),
                               peak = end,
                               count = nrow(y)/resolution)
      # increase the index
      i <- i+1
      # get new starting point
      start <- start + resolution
    }
    # remove rows containing NA and return it 
    na.omit(data2)
  })
  # return the complete calculated data.frame
  return(do.call("rbind",res))
}

#################
# main function # 
#################

# resolution intervals for plotting, e.g 1-100, 101-200, ...
resolution.steps = 150
# read input file - adjust path for other file 
fimo.file <- read.table("data/ChipSeq.motifs.txt")
# adjust the names of columns for easier access
names(fimo.file) <- c("motif", "peak", "start", "end", "strand", 
                      "score", "p-val", "q-val", "seq")

# generate input data for plotting
data <- generate.input(data = fimo.file[,1:2], 
                       resolution = resolution.steps,
                       trim = TRUE)

# adjust the motifs for colouring
data$motif <- as.factor(data$motif)

# draw the plot
ggplot(data, aes(x = peak, y = count, group = motif, colour = motif)) + 
  # adjust the line and theme
  geom_line(size = 1) + theme_bw() + 
  # adjust the x axis name and the number of ticks
  scale_x_continuous(name = "Peaks", breaks = pretty_breaks(n = 10)) +
  # adjust the y axis name and the number of ticks
  scale_y_continuous(name = "% of peaks with motif" , 
                     breaks = pretty_breaks(n = 10)) + 
  # give the plot a title
  ggtitle("Number of Peaks per motif")

# save the plot to a file
ggsave("motif.resolution.pdf")
