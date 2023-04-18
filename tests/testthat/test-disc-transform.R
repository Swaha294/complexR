library(complexR)
library(testthat)

# testing for errors

test_that("check for invalid inputs", {
  expect_error(
    disc_transform(r_inner = -1),
    regexp = "greater than 0"
  )
  expect_error(
    disc_transform(r_outer = 0),
    regexp = "greater than 0"
  )
  expect_error(
    disc_transform(x0 = "ab"),
    regexp = "should be numbers"
  )
  expect_error(
    disc_transform(theta_min = -pi),
    regexp = "should be between 0"
  )
  expect_error(
    disc_transform(theta_min = pi, theta_max = 0),
    regexp = "theta_min should be less than theta_max"
  )
  expect_error(
    disc_transform(x_new = "abc"),
    regexp = "should be objects of class 'expression'"
  )
})
