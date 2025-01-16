setwd("/home/agricolamz/work/materials/2022_HSE_m_instrumental_phonetics/materials/hw/hw1/answers")
library(tidyverse)
library(speakr)
praat_run("get-formants-args.praat", 
          "Hertz", 0.03, capture = TRUE) %>% 
  read_csv() ->
  abaza_formants
library(phonfieldwork)
abaza_duration <- textgrid_to_df("chain.TextGrid")
abaza_duration %>% 
  filter(tier == 3,
         content != "") %>% 
  mutate(duration = time_end - time_start) %>% 
  select(content, duration) ->
  abaza_duration

abaza_formants %>% 
  bind_cols(abaza_duration) %>% 
  ggplot(aes(F2, F1, label = vowel, color = vowel, size = duration))+
  geom_text()+
  scale_x_reverse()+
  scale_y_reverse()+
  coord_fixed()+
  labs(title = "Example of Abaza vowels")
