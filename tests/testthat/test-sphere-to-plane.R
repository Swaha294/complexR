library(complexR)
library(testthat)

# testing for invalid input types

test_that(
  "check for invalid input types", {
    expect_error(
      sphere_to_plane("1", 0, 0),
      regexp = "should be numeric"
    )
    expect_error(
      sphere_to_plane(1, 1, 0),
      regexp = "not on the unit sphere"
    )
  }
)

# testing that the function returns the correct outputs

test_that(
  "check that function returns correct outputs", {
    expect_equal(
      sphere_to_plane(0, 0, 1),
      Inf
    )
    expect_equal(
      sphere_to_plane(1, 0, 0),
      complex(real = 1, imaginary = 0)
    )
    expect_equal(
      sphere_to_plane(0, 0, -1),
      complex(real = 0, imaginary = 0)
    )
    expect_equal(
      sphere_to_plane(1/3, 2/3, 2/3),
      complex(real = 1, imaginary = 2)
    )
  }
)
