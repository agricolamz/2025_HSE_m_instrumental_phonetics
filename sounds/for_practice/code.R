# lookup for selecting words -----------------------------------------------
library(tidyverse)
df <- read_csv("https://raw.githubusercontent.com/agricolamz/english_freq_ipa_dataset/master/english_ipa_freq_pos.csv")

df %>% 
  mutate(us = str_remove_all(us, "[ˈˌ/]"),
         uk = str_remove_all(uk, "[ˈˌ/]"),) %>% 
  filter(us == uk) %>% 
  mutate(vowelless = str_replace_all(us, "[əuɝeɛʊoɔɜæɑaiɪʌɐ]", "V")) %>% 
  group_by(vowelless) %>% 
  mutate(n = n()) %>% 
  arrange(-n) %>% 
  filter(n > 1) %>% 
  View()


df %>% 
  mutate(us = str_remove_all(us, "[ˈˌ/]"),
         uk = str_remove_all(uk, "[ˈˌ/]"),) %>% 
  filter(us == uk) %>% 
  distinct() %>% 
  mutate(son = str_replace_all(us, "[mnrljw]", "C")) %>% 
  group_by(son) %>% 
  mutate(n = n()) %>% 
  arrange(-n) %>% 
  filter(n > 1,
         str_detect(son, "C")) %>% 
  View()

# merge vowel files and create pictures ------------------------------------
setwd("/home/agricolamz/work/materials/2022_HSE_m_instrumental_phonetics/materials/sounds/for_practice/vowels")
library(tidyverse)
library(phonfieldwork)
tibble(files = list.files(pattern = ".mp3")) %>% 
  mutate(group = as.double(str_extract(files, "\\d{3}"))) %>% 
  group_by(group) %>% 
  mutate(files = files[sample(row_number())],
         stumuli = str_extract(files, "(?<=(\\d{3}_)).*(?=\\.)"),
         id = 1:n(),
         max = max(id),
         new_name = str_c(id, files)) %>% 
  arrange(max) ->
  result

dir.create("merged")

groups <- unique(result$group)

map(seq_along(groups), function(i){
  result %>% 
    filter(group == groups[i]) ->
    df
  name = str_c(str_c(c(i, df$stumuli), collapse = "_"))
  tdir <- tempdir(check = TRUE)
  file.copy(df$files, tdir)
  file.rename(str_c(tdir, "/", df$files), str_c(tdir, "/", df$new_name))
  concatenate_soundfiles(path = tdir, result_file_name = name, separate_duration = 0.1)
  file.copy(str_c(tdir, "/", name, ".wav"), "merged", recursive = TRUE)
  unlink(tdir, recursive = TRUE)
})

draw_sound(sounds_from_folder = "merged",
           pic_folder_name = "merged", 
           title_as_filename = FALSE)

# create animal pictures ---------------------------------------------------
# setwd("/home/agricolamz/work/materials/2022_HSE_m_instrumental_phonetics/materials/sounds/for_practice/animals")
# 
# files <- list.files(pattern = ".mp3")
# 
# map(files, function(i){
#   library(tuneR)
#   r <- readMP3(i)
#   writeWave(r, str_c(str_remove(i, ".mp3"), ".wav"), extensible=FALSE)
# })
# 
# file.remove(files)

setwd("/home/agricolamz/work/materials/2022_HSE_m_instrumental_phonetics/materials/sounds/for_practice/")
draw_sound(sounds_from_folder = "animals",
           pic_folder_name = "animals", 
           title_as_filename = FALSE)


# draw consonants and stress -----------------------------------------------

setwd("/home/agricolamz/work/materials/2022_HSE_m_instrumental_phonetics/materials/sounds/for_practice/consonants")
library(tidyverse)
library(phonfieldwork)
tibble(files = list.files(pattern = ".mp3")) %>% 
  mutate(group = as.double(str_extract(files, "\\d{2}"))) %>% 
  group_by(group) %>% 
  mutate(files = files[sample(row_number())],
         stumuli = str_extract(files, "(?<=(\\d{2}_)).*(?=\\.)"),
         id = 1:n(),
         new_name = str_c(id, files)) ->
  result

dir.create("merged")

groups <- unique(result$group)

map(seq_along(groups), function(i){
  result %>% 
    filter(group == groups[i]) ->
    df
  name = str_c(str_c(c(i, df$stumuli), collapse = "_"))
  tdir <- tempdir(check = TRUE)
  file.copy(df$files, tdir)
  file.rename(str_c(tdir, "/", df$files), str_c(tdir, "/", df$new_name))
  concatenate_soundfiles(path = tdir, result_file_name = name, separate_duration = 0.1)
  file.copy(str_c(tdir, "/", name, ".wav"), "merged", recursive = TRUE)
  unlink(tdir, recursive = TRUE)
})

draw_sound(sounds_from_folder = "merged",
           pic_folder_name = "merged", 
           title_as_filename = FALSE)
