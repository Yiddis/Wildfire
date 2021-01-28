# To install the stable version of this R package from CRAN:
install.packages("TDAmapper", dependencies=TRUE)

# To install the latest version of this R package directly from github:
install.packages("devtools")
library(devtools)
devtools::install_github("paultpearson/TDAmapper")
library(TDAmapper)

require(fastcluster) 
library(igraph)
getwd()
#setwd("C:\Users\isaac\OneDrive\Documents\R\Intro")

XVAL <- (1:10)
YVAL <- (1:10)
manualData <- data.frame( x=XVAL, y=YVAL )


readfile <- read.csv("WildFires.csv")
#readfile <- read.csv("California_Fire_Perimeters.csv")

myData <- readfile
#myData <- manualData



#m1 <- mapper1D(distance_matrix = dist(myData),
#               filter_values = myData[,2],
#               num_intervals = 10,
#               percent_overlap = 90,
#               num_bins_when_clustering = 10)

#plot(myData[,3], myData[,4])

#g1 <- graph.adjacency(m1$adjacency, mode="undirected")
#plot(g1, layout = layout.auto(g1) )


library(devtools)
devtools::install_github("christophergandrud/networkD3")
library(networkD3)
library(rgl)

X <- data.frame(x = myData[,3], y = myData[,4], z = myData[,2])
loc_data <- data.frame(x = myData[,3], y = myData[,4])
f <- X

m5 <- mapper(dist(X), f, c(10,10,10), c(75,75,75), 5)
g5 <- graph.adjacency(m5$adjacency, mode="undirected")
plot(g5, layout = layout.auto(g5) )
tkplot(g5)

# create data frames for vertices and edges with the right variable names 
MapperNodes <- mapperVertices(m5, 1:dim(f)[1] )
MapperLinks <- mapperEdges(m5)

# interactive plot
forceNetwork(Nodes = MapperNodes, Links = MapperLinks, 
             Source = "Linksource", Target = "Linktarget",
             Value = "Linkvalue", NodeID = "Nodename",
             Group = "Nodegroup", opacity = 0.8, 
             linkDistance = 10, charge = -400) 


#plot3d(X$x, X$y, X$z)

install.packages("rlang", dependencies = TRUE)

library(rlang)

library(ggplot2)

library(dplyr)

library(maps)

library(mapproj)

library(ggrepel)

library(viridis)

library(plotly)


#UK <- map_data("world") %>% filter(region=="usa")
USA <- map_data("usa") 
states <- map_data("state")

wildFireData <- data.frame(long = myData[,3], lat = myData[,4], size = myData[,2], name = myData[,1])


#wildFireData %>%
#  arrange(size) %>% 
#  mutate( name=factor(name, unique(name))) %>% 
#ggplot() +
#  geom_polygon(data = USA, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
#  geom_point( data=wildFireData, aes(x=long, y=lat, size=size, color=size)) +
#  scale_size_continuous(range=c(1,12)) +
#  scale_color_viridis(trans="log") +
#  theme_void() + coord_map()  + theme(legend.position="none")



# Rorder data + Add a new column with tooltip text
wildFireData <- wildFireData %>%
  arrange(size) %>%
  mutate( name=factor(name, unique(name))) %>%
  mutate( mytext=paste(
    "Fire: ", name, "\n", 
    "Size: ", size, sep="")
  )


# Make the map (static)
p <- wildFireData %>%
  ggplot() +
  geom_polygon(data = USA, aes(x=long, y = lat, group = group), fill="grey", alpha=0.3) +
  geom_polygon(data = states, aes(x=long, y = lat), fill = NA, color = "white") +
  geom_point(aes(x=long, y=lat, size=size, color=size, text=mytext, alpha=size) ) +
  scale_size_continuous(range=c(1,15)) +
  scale_color_viridis(option="inferno", trans="log" ) +
  scale_alpha_continuous(trans="log") +
  theme_void() +
 #ylim(50,59) +
  coord_map() +
  theme(legend.position = "none")
  

p <- ggplotly(p, tooltip="text")
p

library(htmlwidgets)

saveWidget(p, file=paste0( getwd(), "bubblemapWILDFIRE.html"))
