library(complexR)
library(testthat)

# checking for invalid inputs

test_that(
  "check for invalid inputs", {
    expect_error(
      cart_to_polar(real = "1", imaginary = 2),
      regexp = "should be numbers"
    )
    expect_error(
      cart_to_polar(real = 1, imaginary = "2"),
      regexp = "should be numbers"
    )
    expect_error(
      cart_to_polar(real = "1", imaginary = "2"),
      regexp = "should be numbers"
    )
  }
)

# checking that function returns correct values

test_that(
  "check that function returns correct values", {
    expect_equal(
      round(cart_to_polar(real = 1, imaginary = 0), 4),
      round(c(r = 1, theta = 0), 4)
    )
    expect_equal(
      round(cart_to_polar(real = 0, imaginary = 1), 4),
      round(c(r = 1, theta = pi/2), 4)
    )
    expect_equal(
      round(cart_to_polar(real = -1, imaginary = 0), 4),
      round(c(r = 1, theta = pi), 4)
    )
    expect_equal(
      round(cart_to_polar(real = 0, imaginary = -1), 4),
      round(c(r = 1, theta = -pi/2), 4)
    )
    expect_equal(
      round(cart_to_polar(real = 1, imaginary = sqrt(3)), 4),
      round(c(r = 2, theta = pi/3), 4)
    )
  }
)
