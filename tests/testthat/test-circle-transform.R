library(complexR)
library(testthat)

# testing for errors

test_that("check for invalid inputs", {
  expect_error(
    circle_transform(r = -1),
    regexp = "greater than 0"
  )
  expect_error(
    circle_transform(x0 = "ab"),
    regexp = "should be numbers"
  )
  expect_error(
    circle_transform(theta_min = -pi),
    regexp = "should be between 0"
  )
  expect_error(
    circle_transform(theta_min = pi, theta_max = 0),
    regexp = "theta_min should be less than theta_max"
  )
  expect_error(
    circle_transform(x_new = "abc"),
    regexp = "should be objects of class 'expression'"
  )
  expect_error(
    circle_transform(annotations = c("a", 2, 3)),
    regexp = "should be a list of complex numbers"
  )
})

# checking that annotations lie on the domain

test_that("check annotations lying outside domain", {
  expect_error(
    circle_transform(annotations = complex(real = 1, imaginary = 1)),
    regexp = "lie on the given circle"
  )
})
