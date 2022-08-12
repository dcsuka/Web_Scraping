library(rvest)
library(xml2)
library(tidyverse)

price_xpath <- ".//parent::a/parent::h2/parent::div/following-sibling::div//a/span[not(@class='a-price a-text-price')]/span[@class='a-offscreen']"
description_xpath <- "//div/h2/a/span"

get_amazon_info <- function(item) {
  source_html <- read_html(str_c("https://www.amazon.com/s?k=", str_replace_all(item, " ", "+")))

  root_nodes <- source_html %>%
    html_elements(xpath = description_xpath)
  
  prices <- xml_find_all(root_nodes, xpath = price_xpath, flatten = FALSE)
  prices <- lapply(prices, function(x) html_text(x)[1])
  prices[lengths(prices) == 0] <- NA

  tibble(product = html_text(root_nodes),
         price = unlist(prices, use.names = FALSE)) %>%
    mutate(price = parse_number(str_remove(price, "\\$")))
}

get_amazon_info("NVIDIA Tesla")

# # A tibble: 19 × 2
#    product                                                                                                                                               price
#    <chr>                                                                                                                                                 <dbl>
#  1 Amulet Hotkey NVIDIA Tesla Tesla P6 Graphic Card - 16 GB GDDR5 - 256 bit Bus Width (Renewed)                                                         626.  
#  2 HHCJ6 Dell NVIDIA Tesla K80 24GB GDDR5 PCI-E 3.0 Server GPU Accelerator (Renewed)                                                                    140.  
#  3 nVidia Tesla K80                                                                                                                                     350.  
#  4 NVIDIA Tesla M40 24GB Module                                                                                                                         397.  
#  5 NVIDIA Tesla P100 GPU computing processor - Tesla P100 - 16 GB - Centernex update                                                                    990.  
#  6 nVidia Tesla K10 8GB GDDR5 PCI-E x16 Computing Accelerator Processing Unit With Dual GK104 Kepler GPUs                                               175.  
#  7 PNY NVIDIA Tesla T4 Datacenter Card 16GB GDDR6 PCI Express 3.0 x16, Single Slot, Passive Cooling                                                    1648   
#  8 NVIDIA Video Card 900-22080-0000-000 Tesla K80 24GB DDR5 PCI-Express Passive Cooling Brown Box NCNR.                                                 335.  
#  9 Nvidia TESLA M40 GPU 12GB GDDR5 Accelerator Processing Card 900-2G600-0000-000                                                                       279   
# 10 NVIDIA 900-2G414-0000-000 Tesla P4 8GB GDDR5 Inferencing Accelerator Passive Cooling                                                                 299   
# 11 Nvidia Tesla v100 16GB                                                                                                                              3604   
# 12 Suyitai Graphics Card Power Cable（10 cm ） Replacement for NVIDIA Tesla K80 M60 M40 P100 P40 030-0571-000                                             9.99
# 13 NVIDIA Tesla V100 Volta GPU Accelerator 32GB Graphics Card                                                                                          9969   
# 14 NVIDIA M1060 nVidia Tesla M1060 Passive Cooling 4GB PCI-E x16 GPU Computing G IBM 43V5909 Nvidia Tesla M1060 4Gb PCI-Express x16 Video Graphic Card  100.  
# 15 HP J0G95A NVIDIA Tesla K80 - GPU computing processor - 2 GPUs - Tesla K80 - 24 GB GDDR5 - PCI Express 3.0 x16 - fanless                              360.  
# 16 Nvidia Tesla M2090 Gpu Card                                                                                                                          200.  
# 17 NVIDIA Quadro RTX4000 GPU                                                                                                                           1089.  
# 18 NVIDIA Tesla M10 GPU Computing Processor Graphic Cards Q0J62A                                                                                       1898   
# 19 659489-001 HP Nvidia Tesla M2075 6GB GDDR5 Graphic Processing Unit                                                                                   180.  

get_amazon_info("dog food")

# # A tibble: 73 × 2
#    product                                                                                                            price
#    <chr>                                                                                                              <dbl>
#  1 Amazon Brand - Wag Wholesome Grains Dry Dog Food (Chicken/Salmon/Beef/Lamb and Brown Rice)                          17.0
#  2 Purina Pro Plan High Protein Dog Food With Probiotics for Dogs, Shredded Blend Chicken & Rice Formula - 35 lb. Bag  64.0
#  3 Nulo FS Dog LID GF Salmon 24LB                                                                                      86.0
#  4 Purina Pro Plan High Protein Dog Food with Probiotics for Dogs, Shredded Blend Turkey & Rice Formula - 17 lb. Bag   45.7
#  5 IAMS PROACTIVE HEALTH Adult Minichunks Small Kibble High Protein Dry Dog Food with Real Chicken, 30 lb. Bag         36.0
#  6 Blue Buffalo Life Protection Formula Natural Adult Dry Dog Food, Chicken and Brown Rice 30-lb                       61.0
#  7 Purina ONE Natural Dry Dog Food, SmartBlend Lamb & Rice Formula - 31.1 lb. Bag                                      43.3
#  8 Merrick Lil Plates Small Breed Dry Dog Food with Real Meat                                                          68.0
#  9 Merrick Dry Dog Food with added Vitamins & Minerals for All Breeds, 25-Pound, Chicken                               70.0
# 10 Purina ONE Dog Digestive Support, Natural Dry Dog Food, Plus Digestive Health Formula - 31.1 lb. Bag                44.4
# # … with 63 more rows

get_amazon_info("best selling books")

# # A tibble: 60 × 2
#    product                                    price
#    <chr>                                      <dbl>
#  1 Things We Never Got Over                   13.9 
#  2 Rum Soldier                                13.0 
#  3 The Reunion                                 0   
#  4 The Tree of Knowledge: A Thriller          23.0 
#  5 The Seven Husbands of Evelyn Hugo: A Novel  9.42
#  6 The 6:20 Man: A Thriller                   15.0 
#  7 I'm Glad My Mom Died                       19.1 
#  8 The Maze (John Corey Book 8)               15.0 
#  9 The Last Thing He Told Me: A Novel         13.1 
# 10 Wish You Were Here: A Novel                12.0 
# # … with 50 more rows







