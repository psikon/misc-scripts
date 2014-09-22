#' little script to read in a peak file with 5 motifs 
#' and plot these different motifs by their distance from 
#' peak summit 
library(reshape2)
library(ggplot2)
library(scales)

setwd("../")
# load motif data (adjust path)
all.fimo <- read.table("data/ChipSeq.motifs.txt")
# add names to data.frame
names(all.fimo) <- c("motif", "peak", "start", "end", "strand", "score", "p-val", "q-val", "seq")

# extract used columns
data <- all.fimo[, c(1:4)]
# peak length/2 for x axis in plot
peak_length <- 250

# extract the motifs and calculate the mean 
m1 <- data[which(data$motif == 1), ]
m1 <- m1[!duplicated(m1$peak), ]
for(i in 1:nrow(m1)){
  m1[i, 'mean'] <- mean(c(m1[i, 'start'], m1[i, 'end'])) - peak_length
}

m2 <- data[which(data$motif == 2), ]
m2 <- m2[!duplicated(m2$peak), ]
for(i in 1:nrow(m2)){
  m2[i, 'mean'] <- mean(c(m2[i, 'start'], m2[i, 'end'])) - peak_length
}
m3 <- data[which(data$motif == 3),]
m3 <- m3[!duplicated(m3$peak),]
for(i in 1:nrow(m3)){
  m3[i, 'mean'] <- mean(c(m3[i, 'start'], m3[i, 'end'])) - peak_length
}
m4 <- data[which(data$motif == 4),]
m4 <- m4[!duplicated(m4$peak),]
for(i in 1:nrow(m4)){
  m4[i, 'mean'] <- mean(c(m4[i, 'start'], m4[i,'end'])) - peak_length
}
m5 <- data[which(data$motif == 5),]
m5 <- m5[!duplicated(m5$peak),]
for(i in 1:nrow(m5)){
  m5[i, 'mean'] <- mean(c(m5[i, 'start'], m5[i, 'end'])) - peak_length
}

# create a data.frame with all motifs
x <- rbind(m1, m2)
x <- rbind(x, m3)
x <- rbind(x, m4)
x <- rbind(x, m5)

# adjust var for coloring the plot
x$motif <- as.factor(x$motif)

# create the plot
ggplot(x, aes(x = mean, group = motif, color = motif)) + 
  # adjust the curves
  stat_density(position = "identity", geom = "line", size = 1) + 
  # change the theme
  theme_bw() + 
  # adjust x axis
  scale_x_continuous(name = "Distance from peak summit", breaks = pretty_breaks(n = 10), 
                     label = comma ) +
  # adjust y axis
  scale_y_continuous(name = "Density",breaks = pretty_breaks(n = 5), label = comma) + 
  # give plot a title
  ggtitle("Peak length distribution") 

# save to file (possible: pdf, tiff, jpeg, svg)
ggsave("peak.distribution.pdf")
