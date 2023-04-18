#' Visualize stereographic projections from \eqn{\mathbb{C}^*} to \eqn{\mathbb{C}}
#'
#' @param x A numeric vector. The x-coordinate of the point on the Riemann sphere.
#' @param y A numeric vector. The y-coordinate of the point on the Riemann sphere.
#' @param z A numeric vector. The z-coordinate of the point on the Riemann sphere.
#'
#' @return A visualization of the point in \eqn{\mathbb{C}^*} and its corresponding
#' projection in \eqn{\mathbb{C}}.
#'
#' @examples
#'
#' library(complexR)
#'
#' # Visualize the stereographic projection of the point (1/3, 2/3, 2/3) on the
#' # complex plane
#'
#' st_plane_plot(1/3, 2/3, 2/3)
#'
#' @export
#' @import ggplot2

st_plane_plot <- function(x, y, z) {

  c = sphere_to_plane(x, y, z)

  a = Re(c)
  b = Im(c)

  xy = ggplot() +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = 1)) +
    coord_fixed() +
    theme_bw() +
    labs(
      x = "x",
      y = "y",
      title = "X-Y view"
    ) +
    geom_point(aes(x = x, y = y)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed")

  yz = ggplot() +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = 1)) +
    coord_fixed() +
    theme_bw() +
    labs(
      x = "y",
      y = "z",
      title = "Y-Z view"
    ) +
    geom_point(aes(x = y, y = z)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed")

  zx = ggplot() +
    ggforce::geom_circle(aes(x0 = 0, y0 = 0, r = 1)) +
    coord_fixed() +
    theme_bw() +
    labs(
      x = "z",
      y = "x",
      title = "Z-X view"
    ) +
    geom_point(aes(x = z, y = x)) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    geom_vline(xintercept = 0, linetype = "dashed")

  sphere = ggpubr::ggarrange(xy, yz, zx, nrow = 1)

  point = ggplot() +
    geom_point(aes(x = a, y = b)) +
    xlim(a - 3, a + 3) +
    ylim(b - 3, b + 3) +
    labs(
      x = "Re z",
      y = "Im z",
      title = "Complex Plane"
    ) +
    theme_bw()

  ggpubr::ggarrange(sphere, point, nrow = 2)

}
