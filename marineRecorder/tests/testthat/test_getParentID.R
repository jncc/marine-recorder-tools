library(marineRecorder)
context("get Parent Aphia IDs")

testthat::test_that("returns an integer", {
                      expect_true(typeof(getParentID(2)) == "integer", TRUE )
})
