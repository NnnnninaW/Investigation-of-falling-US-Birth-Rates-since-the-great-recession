#### load the libraies we need ####
library(tidyverse)
library(dplyr)
library(here)
library(ggplot2)
library(haven)

# Import the dta
birth_pop <- read_dta(here::here("inputs/data/nchs_births_pop_1990_2019.dta"))
# Import the dta
age_race_pop <- read_dta(here::here("inputs/data/age_race_comp_seer.dta"))
# Mege two dta together
merged_data <- merge(birth_pop, age_race_pop, by = c("stname", "year"))

# Define new column
merged_data$pop2044 <- with(merged_data, `pop2024.y` + `pop2534.y` + `pop3544.y`)
# use a group by to get the sum
merged_data_grouped_by <- group_by(merged_data, year) %>% summarise(fb_sum = sum(numbirth_firstbirth), sb_sum = sum(numbirth_secondbirth), tb_sum = sum(numbirth_thirdbirth), fbp_sum = sum(numbirth_fourthbirth), pop_sum = sum(pop1544))

#define new columns based on existing columns
merged_data_grouped_by$brith_rate_fb <- with(merged_data_grouped_by, fb_sum / `pop_sum` * 1000)
merged_data_grouped_by$brith_rate_sb <- with(merged_data_grouped_by, sb_sum / `pop_sum` * 1000)
merged_data_grouped_by$brith_rate_tb <- with(merged_data_grouped_by, tb_sum / `pop_sum` * 1000)
merged_data_grouped_by$brith_rate_fbp <- with(merged_data_grouped_by, fbp_sum / `pop_sum` * 1000)

# merge the plot and add legends
ggplot(merged_data_grouped_by, aes(x=year)) + 
 geom_line(aes(y = brith_rate_fb, color = "First Birth")) + 
  geom_line(aes(y = brith_rate_sb, color="Second Birth")) +
  geom_line(aes(y = brith_rate_tb, color="Third Birth")) +
  geom_line(aes(y = brith_rate_fbp, color="Fourth Birth")) +
  scale_color_manual(name = "Parity (ages 15-44)", 
                     values = c("First Birth" = "steelblue", 
                                "Second Birth" = "orange", 
                                "Third Birth" = "gray", 
                                "Fourth Birth" = "yellow")) + 
  xlab("Year") + ylab("Birth Rate (births per 1000 women)") + ggtitle("Parity (ages 15-44)")






















