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
#' @param annotations A list of complex numbers. An optional list of complex numbers
#' you want to visualize.
#'
#' @export
#'
#' @importFrom magrittr "%>%"
#' @import ggplot2

quad_transform <- function(h = 1, v = 1, x0 = 0, y0 = 0, x_new = expression(x^2 - y^2),
                           y_new = expression(2*x*y), annotations = NULL) {

  if (!is.numeric(h) | !is.numeric(v) | !is.numeric(x0) | !is.numeric(y0)) {
    # checking inputs are numeric
    stop("Check input: h, v, x0, and y0 should be numeric", call. = FALSE)
  } else if (!is.expression(x_new) | !is.expression(y_new)) {
    # checking that x_new and y_new are expressions
    stop("Check input: x_new and y_new should be objects of class expression", call. = FALSE)
  } else if (h <= 0 | v <= 0) {
    # checking that h and v are positive numbers
    stop("Check input: h and v should be greater than 0", call. = FALSE)
  } else if (!is.complex(annotations)) {
    # checking that annotations is a list of complex numbers
    stop("Check input: annotations should be a list of complex numbers", call. = FALSE)
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

    # checking that annotations are on the given domain
    if (!is.null(annotations)) {

      all_real = c()
      all_imaginary = c()

      for (i in annotations) {

        re_anno = Re(i)
        im_anno = Im(i)

        if (re_anno != 0.5 | re_anno != -0.5) {
          if (im_anno != 0.5 & im_anno != -0.5) {
            stop(paste("Check input: z =", i, "not in given domain"))
          }
        } else if (im_anno != 0.5 | im_anno != -0.5) {
          if (re_anno != 0.5 & re_anno != -0.5) {
            paste("Check input: z =", i, "not in given domain")
          }
        } else if (x0 - h/2 <= re_anno & re_anno <= h/2 + x0) {
          stop(paste("Check input: z =", i, "not in given domain"))
        } else if (y0 - v/2 <= im_anno & im_anno <= v/2 + y0) {
          stop(paste("Check input: z =", i, "not in given domain"))
        }

        all_real = c(all_real, Re(i))
        all_imaginary = c(all_imaginary, Im(i))

      }

      my_points = data.frame(
        x = all_real,
        y = all_imaginary
      )

      my_points = my_points %>%
        dplyr::mutate(
          x_new = eval(x_new, list(x = x, y = y)),
          y_new = eval(y_new, list(x = x, y = y)),
          exp = paste0("(", x, ", ", y, ")"),
          exp_f = paste0("f(", x, ", ", y, ")")
        )

    }

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

    # adding annotations if given
    if (!is.null(annotations)) {

      domain = domain +
        geom_point(
          data = my_points,
          mapping = aes(x = x, y = y),
          size = 2.5,
          color = "orchid2"
        ) +
        ggrepel::geom_label_repel(
          data = my_points,
          mapping = aes(label = exp)
        )

    }

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

    # adding annotations if given
    if (!is.null(annotations)) {

      image = image +
        geom_point(
          data = my_points,
          mapping = aes(x = x_new, y = y_new),
          size = 2.5,
          color = "orchid2"
        ) +
        ggrepel::geom_label_repel(
          data = my_points,
          mapping = aes(label = exp_f)
        )

    }

    # returning the combined visualizations of domain and image
    ggpubr::ggarrange(domain, image, nrow = 1)

  }

}
