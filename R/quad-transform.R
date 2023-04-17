#' Visualize transformations on squares and rectangles in the complex plane
#'
#' @param h A numeric vector. The breadth of the quadrilateral.
#' @param v A numeric vector. The length of the quadrilateral.
#' @param x0 A numeric vector. The center of the quadrilateral along the real
#' (\eqn{x-})axis.
#' @param y0 A numeric vector. The center of the quadrilateral along the imaginary
#' (\eqn{y-})axis.
#' @param x_new An object of class expression. The real part of the complex
#' number obtained from the transformation. The default value is set to
#' \eqn{expression(x^2 + y^2)}, corresponding to the transformation \eqn{z^2}.
#' @param y_new An object of class expression. The imaginary part of the complex
#' number obtained from the transformation. The default value is set to
#' \eqn{expression(2xy)}, corresponding to the transformation \eqn{z^2}.
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#' @import ggplot2

quad_transform <- function(h = 1, v = 1, x0 = 0, y0 = 0, x_new = expression(x^2 - y^2),
                           y_new = expression(2*x*y)) {

  if (!is.numeric(h) | !is.numeric(v) | !is.numeric(x0) | !is.numeric(y0)) {
    # checking inputs are numeric
    stop("Check input: h, v, x0, and y0 should be numeric", call. = FALSE)
  } else if (!is.expression(x_new) | !is.expression(y_new)) {
    # checking that x_new and y_new are expressions
    stop("Check input: x_new and y_new should be objects of class expression", call. = FALSE)
  } else {

    # creating square or rectangle
    my_quad = data.frame(
      x = stats::runif(5000, -h/2, h/2),
      y = rep(v/2, 5000)
    ) %>%
      rbind(
        data.frame(
          x = rep(h/2, 5000),
          y = stats::runif(5000, -v/2, v/2)
        )
      ) %>%
      rbind(
        data.frame(
          x = stats::runif(5000, -h/2, h/2),
          y = rep(-v/2, 5000)
        )
      ) %>%
      rbind(
        data.frame(
          x = rep(-h/2, 5000),
          y = stats::runif(5000, -v/2, v/2)
        )
      )

    # adjusting x and y for center
    my_quad = my_quad %>%
      dplyr::mutate(
        x = x + x0,
        y = y + y0
      )

    # creating visualization of domain
    domain = ggplot(
      data = my_quad,
      mapping = aes(x = x, y = y)
    ) +
      geom_point() +
      geom_vline(xintercept = x0, linetype = "dashed") +
      geom_hline(yintercept = y0, linetype = "dashed") +
      xlim(min(my_quad$x) - 0.5, max(my_quad$x) + 0.5) +
      ylim(min(my_quad$y) - 0.5, max(my_quad$y) + 0.5) +
      coord_fixed() +
      theme_bw() +
      labs(
        x = "Re z",
        y = "Im z",
        title = "Domain"
      )

    # applying transformation
    my_quad = my_quad %>%
      dplyr::mutate(
        x_new = eval(x_new, list(x = x, y = y)),
        y_new = eval(y_new, list(x = x, y = y))
      )

    # creating visualization of image
    image = ggplot(
      data = my_quad,
      mapping = aes(x = x_new, y = y_new)
    ) +
      geom_point() +
      geom_vline(xintercept = x0, linetype = "dashed") +
      geom_hline(yintercept = y0, linetype = "dashed") +
      xlim(min(my_quad$x_new) - 0.5, max(my_quad$x_new) + 0.5) +
      ylim(min(my_quad$y_new) - 0.5, max(my_quad$y_new) + 0.5) +
      coord_fixed() +
      theme_bw() +
      labs(
        x = "Re z",
        y = "Im z",
        title = "Image"
      )

    # returning the combined visualizations of domain and image
    ggpubr::ggarrange(domain, image, nrow = 1)

  }

}
