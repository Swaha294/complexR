library(complexR)
library(testthat)

# testing for invalid inputs

test_that(
  "checking for invalid inputs", {
    expect_error(
      polar_to_cart(1, "pi"),
      regexp = "should be numbers"
    )
    expect_error(
      polar_to_cart("1", pi),
      regexp = "should be numbers"
    )
    expect_error(
      polar_to_cart(1, -pi),
      regexp = "should be between"
    )
    expect_error(
      polar_to_cart(-1, pi),
      regexp = "should be greater than"
    )
  }
)

# checking that function returns to correct outputs

test_that(
  "checking that function returns the correct outpus", {
    expect_equal(
      polar_to_cart(1, 0),
      c(x = 1, y = 0)
    )
    expect_equal(
      polar_to_cart(1, pi/2),
      c(x = 0, y = 1)
    )
    expect_equal(
      polar_to_cart(1, pi),
      c(x = -1, y = 0)
    )
    expect_equal(
      polar_to_cart(1, 3*pi/2),
      c(x = 0, y = -1)
    )
    expect_equal(
      polar_to_cart(1, 2*pi),
      c(x = 1, y = 0)
    )
    expect_equal(
      round(polar_to_cart(2, pi/3), 4),
      round(c(x = 1, y = sqrt(3)), 4)
    )
    expect_equal(
      round(polar_to_cart(2, 2*pi/3), 4),
      round(c(x = -1, y = sqrt(3)), 4)
    )
    expect_equal(
      round(polar_to_cart(2, 4*pi/3), 4),
      round(c(x = -1, y = -sqrt(3)), 4)
    )
    expect_equal(
      round(polar_to_cart(2, 5*pi/3), 4),
      round(c(x = 1, y = -sqrt(3)), 4)
    )
  }
)
