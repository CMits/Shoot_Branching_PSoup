library(PSoup)
library(fst)

# location of SBGN textfile
file <- "/g/data/vw43/cm9768/HPsim/Benchmark_Model.sbgn"

# generate network object
CBnetwork <- convertSBGNdiagram(file, "CBnetwork")

# location where model will be saved
folder <- "/g/data/vw43/cm9768/HPsim/Bmodel"

# generate model files
buildModel(CBnetwork, folder, forceOverwrite = TRUE)

# Load the RData file and capture the name(s) of the loaded objects
loaded_obj_names <- load("/g/data/vw43/cm9768/HPsim/16384/param_values_all_Incr_1_part2.RData")

# Assign the first loaded object to genotypeDef
genotypeDef <- get(loaded_obj_names[1])


# Modify genotypeDef as needed (example: subset to the first 10 rows)
#genotypeDef <- genotypeDef[1:10, ]


# replace original genotypeDef.RData file with updated version
save(genotypeDef, file = paste0(folder, "/genotypeDef.RData"))


# run simulations for all combinations
allSim <- setupSims(folder, maxStep = 200, delay = 20, exogenousSupply = FALSE, combinatorial = FALSE, preventDrop = TRUE,nCores = 30, reduceSize = TRUE)

# collect the stable values for nodes of interest 
Hormones <- finalStates(allSim$screen)


# Combine simDat and combinations into a single data frame
combined_data <- data.frame(Hormones = Hormones)


# Specify the file path for the fst file
file_path_combined <- "/g/data/vw43/cm9768/HPsim/16384/Results_Sobol_second_run.fst"

# Save the combined data to an fst file
write_fst(combined_data, file_path_combined)