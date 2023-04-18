library(complexR)
library(testthat)

# testing for errors

test_that("testing for invalid inputs", {
  expect_error(
    line_transform(c = "b"),
    regexp = "should be numbers"
  )
  expect_error(
    line_transform(x_intercept = "c"),
    regexp = "should be numbers"
  )
  expect_error(
    line_transform(annotations = c(1, 2, 3)),
    regexp = "should be a list of complex numbers"
  )
})

# testing that annotations lie on the given domain
test_that("testing that annotations lie on the given domain", {
  expect_error(
    line_transform(m = 0, annotations = complex(real = 2, imaginary = 2)),
    regexp = "on the given line"
  )
})
