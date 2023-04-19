library(hexSticker)
library(magick)
library(dplyr)
library(showtext)

font_add_google("Montserrat", db_cache = FALSE, bold.wt = 1100)

img <- image_read("R/sticker/hex-complexR.jpg")

res <- img %>%
  image_convert("png") %>%
  image_resize("1200 x 200")


complexR_sticker <- sticker(
  subplot = res,
  s_x = 1,
  s_y = 0.85,
  s_height = 1.3,
  s_width = 1.3,
  package = "complexR",
  p_x = 1,
  p_y = 1.55,
  p_size = 12,
  p_color = "#4C0C65",
  h_fill = "#FFFFFF",
  h_color = "#4C0C65",
  h_size = 1.5,
  p_family = "Montserrat"
)


save_sticker(here::here("R/sticker", "hex_complexR.png"), complexR_sticker)
