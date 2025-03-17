# Cài đặt và load thư viện
install.packages("tidyverse")  # Nếu chưa có tidyverse
install.packages("lubridate")  # Để xử lý thời gian
install.packages("tm")         # Để xử lý văn bản

library(tidyverse)
library(lubridate)
library(tm)

# Đọc dữ liệu từ file CSV
df <- read.csv("D:/BIGDATA/Facebook_outage_Tweet_data_4th_October.csv", stringsAsFactors = FALSE)

# 1. Loại bỏ các dòng chứa giá trị NA
df <- df %>% drop_na()

# 2. Chuyển cột thời gian về định dạng chuẩn
df$created_at <- as.POSIXct(df$created_at, format="%Y-%m-%d %H:%M:%S", tz="UTC")

# 3. Loại bỏ dữ liệu trùng lặp (nếu có)
df <- df %>% distinct()

# 4. Xử lý văn bản trong cột tweet (loại bỏ ký tự đặc biệt, chuyển thành chữ thường)
clean_text <- function(text) {
  text <- tolower(text)  # Chuyển thành chữ thường
  text <- gsub("[[:punct:]]", "", text)  # Loại bỏ dấu câu
  text <- gsub("[[:digit:]]", "", text)  # Loại bỏ số
  text <- gsub("\\s+", " ", text)  # Xóa khoảng trắng thừa
  return(text)
}

df$tweet <- sapply(df$tweet, clean_text)

# Kiểm tra lại dữ liệu sau khi làm sạch
head(df)
# Cài đặt và load thư viện cần thiết
install.packages("ggplot2")  # Nếu chưa có ggplot2
install.packages("dplyr")    # Nếu chưa có dplyr
library(ggplot2)
library(dplyr)

# Đọc dữ liệu từ file CSV
df <- read.csv("Facebook_outage_Tweet_data_4th_October.csv", stringsAsFactors = FALSE)

# Đếm số bài đăng của từng người dùng
user_counts <- df %>%
  group_by(username) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  head(20)  # Lấy top 20 người dùng đăng nhiều nhất

# Vẽ biểu đồ số lượng bài đăng theo người dùng
ggplot(user_counts, aes(x = reorder(username, count), y = count)) +
  geom_bar(stat = "identity", fill = "blue") +
  coord_flip() +  # Xoay biểu đồ ngang cho dễ nhìn
  labs(title = "Top 20 người dùng đăng bài nhiều nhất",
       x = "Người dùng",
       y = "Số bài đăng") +
  theme_minimal()

