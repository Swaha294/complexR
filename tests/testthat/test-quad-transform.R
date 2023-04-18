library(complexR)
library(testthat)

# testing for errors

test_that(
  "check for invalid input types", {
    expect_error(
      quad_transform(v = 0),
      regexp = "greater than 0"
    )
    expect_error(
      quad_transform(h = -5),
      regexp = "greater than 0"
    )
    expect_error(
      quad_transform(x0 = "a"),
      regexp = "should be numeric"
    )
    expect_error(
      quad_transform(x_new = 123),
      regexp = "of class expression"
    )
    expect_error(
      quad_transform(annotations = c("a", 2, 3)),
      regexp = "should be a list of complex numbers"
    )
  }
)

# checking that annotations lie on the given domain

test_that("testing that annotations lie on given domain", {
  expect_error(
    quad_transform(
      annotations = c(complex(real = 0.25, imaginary = 0.5), complex(real = 0.25, imaginary = 0.25))
    ),
    regexp = "not in given domain"
  )
})
