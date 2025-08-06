library(PSoup)

# location of SBGN textfile
file <- "C:/Users/uqcmitsa/PSoup/data-raw/Shoot_Branching_Model (1).sbgn"

# generate network object
CBnetwork <- convertSBGNdiagram(file, "CBnetwork")

# location where model will be saved
folder <- "C:/Users/uqcmitsa/OneDrive - The University of Queensland/Desktop/PSoup Analysis/PSOUP_C/Landscape_test"

# generate model files
buildModel(CBnetwork, folder, forceOverwrite = TRUE)

# Load the genotype to save it for load the gene in the new network

load(paste0(folder, "/genotypeDef.RData"))
load(paste0(folder, "/nodestartDef.RData"))


# Load CSV file into a DataFrame
exogenousDef<- read.csv("C:/Users/uqcmitsa/OneDrive - The University of Queensland/Desktop/Paper/Dataset/Training/Training_genotype_F.csv")
genotypeDef <- read.csv("C:/Users/uqcmitsa/OneDrive - The University of Queensland/Desktop/Paper/Dataset/Training/Training_exogenous_F.csv")


# replace original genotypeDef.RData file with updated version
save(genotypeDef, file = paste0(folder, "/genotypeDef.RData"))
save(exogenousDef, file = paste0(folder, "/exogenousDef.RData"))

# run simulations for one combination
simulation <- simulateNetwork(folder, maxStep = 100)
head(simulation)
# run simulations for all combinations
allSim <- setupSims(folder, maxStep = 200, delay = 20, exogenousSupply = TRUE, combinatorial = FALSE, preventDrop = TRUE)

# run simulations for all combinations
allSim <- setupSims(folder, maxStep = 100, delay = 20, exogenousSupply = TRUE)

# run simulations for all combinations
allSim <- setupSims(folder, maxStep = 100, delay = 20)

# quickly plot to test things worked. can change the number to see different simulations
fastPlot(allSim$screen[[2]]$simulation, logTransform = T)

# collect the stable values for nodes of interest
Hormones <- finalStates(allSim$screen)
Gene <- genotypeDef
exogenous<- exogenousDef

# Exclude the first row from simDat in some occasions only
#simDat <- simDat[-1, , drop = FALSE]   # Remove the first row

#Save data for a new diagram
# Specify the file path
file_path_combined <- "C:/Users/uqcmitsa/Desktop/PSoup Analysis/Excell/Data from Psoup/Randomized_Edges.csv"

# Combine simDat and combinations into a single data frame
combined_data <- data.frame(Hormones = Hormones, Gene = Gene,exogenous=exogenous)

# Save the combined data to CSV
write.csv(combined_data, file = file_path_combined, row.names = FALSE)



