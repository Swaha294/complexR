library(complexR)
library(testthat)

# testing for invalid input types

test_that(
  "check for invalid inputs types", {
    expect_error(
      plane_to_sphere("1", 2),
      regexp = "should be numeric"
    )
    expect_error(
      plane_to_sphere(1, "2"),
      regexp = "should be numeric"
    )
    expect_error(
      plane_to_sphere("1", "2"),
      regexp = "should be numeric"
    )
  }
)

# testing that function returns correct outputs

test_that(
  "check that function returns correct outputs", {
    expect_equal(
      round(plane_to_sphere(1, 2), 4),
      round(c(1/3, 2/3, 2/3), 4)
    )
    expect_equal(
      round(plane_to_sphere(1, 3), 4),
      round(c(2/11, 6/11, 9/11), 4)
    )
  }
)
