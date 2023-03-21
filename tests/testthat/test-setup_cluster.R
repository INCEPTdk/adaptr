test_that("setup_cluster works", {
  expect_null(.adaptr_cluster_env$cl)
  expect_null(.adaptr_cluster_env$cores)
  expect_null(setup_cluster()) # No default cluster

  # Setup and check cluster
  cl <- setup_cluster(2)
  expect_equal(class(cl), c("SOCKcluster", "cluster"))
  expect_equal(length(cl), 2)

  # Check that existing cluster is returned, if any
  expect_identical(setup_cluster(), cl)

  # Check that 1 removes cluster but stores value
  expect_null(setup_cluster(1))
  expect_null(.adaptr_cluster_env$cl)
  expect_identical(.adaptr_cluster_env$cores, 1)

  # Check that NULL removes cluster and value
  expect_null(setup_cluster(NULL))
  expect_null(.adaptr_cluster_env$cl)
  expect_null(.adaptr_cluster_env$cores)
})

test_that("setup_cluster errors on invalid values", {
  expect_error(setup_cluster(0.33))
})
