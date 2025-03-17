install.packages("sparklyr")  # Cài đặt Spark cho R
install.packages("ggplot2")   # Cài đặt ggplot2 để vẽ biểu đồ
install.packages("dplyr")     # Cài đặt dplyr để xử lý dữ liệu
install.packages("readr")     # Đọc file CSV nhanh hơn

library(sparklyr)  # Kết nối Spark
library(ggplot2)   # Vẽ biểu đồ
library(dplyr)     # Xử lý dữ liệu
library(readr)     # Đọc file CSV

sc <- spark_connect(master = "local")  # Kết nối Spark ở chế độ Local
file_path <- "D:BIBIGDATA/Facebook_outage_Tweet_data_4th_October.csv"

df_spark <- spark_read_csv(sc, name = "facebook_data", path = file_path, infer_schema = TRUE, header = TRUE)
df_spark %>% head() %>% collect()  # Hiển thị vài dòng đầu tiên
df_spark %>% summarise(count = n()) %>% collect()
user_counts <- df_spark %>%
  group_by(username) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  collect()
  top_users <- user_counts %>% top_n(10, count)  # Lấy top 10 người có nhiều tweet nhất

ggplot(top_users, aes(x = reorder(username, count), y = count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +  # Xoay ngang biểu đồ
  labs(title = "Top 10 người dùng tweet nhiều nhất", x = "Người dùng", y = "Số lượng tweet") +
  theme_minimal()

