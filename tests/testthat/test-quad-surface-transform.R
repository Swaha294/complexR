library(complexR)
library(testthat)

# testing for errors

test_that(
  "check for invalid input types", {
    expect_error(
      quad_surface_transform(v = 0),
      regexp = "greater than 0"
    )
    expect_error(
      quad_surface_transform(h = -5),
      regexp = "greater than 0"
    )
    expect_error(
      quad_surface_transform(x0 = "a"),
      regexp = "should be numeric"
    )
    expect_error(
      quad_surface_transform(x_new = 123),
      regexp = "of class expression"
    )
  }
)


