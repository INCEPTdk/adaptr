read_testdata <- function(filename) {
  readRDS(system.file("testdata", paste0(filename, ".RData"), package = "adaptr"))
}
