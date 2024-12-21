library(tidyverse)
library(gtools)
getwd()

rm(list = ls())

df <- read_table("or.txt")

head(df)

colnames(df)

df %>% select(var, value) -> df

idx01 <- grepl("0_+[0-9]*[0-9]/1_+[0-9]*[0-9]", df$var)
idx02 <- grepl("0_+[0-9]*[0-9]/2_+[0-9]*[0-9]", df$var)
idx03 <- grepl("1_+[0-9]*[0-9]/2_+[0-9]*[0-9]", df$var)

df01 <- df[idx01,]
df02 <- df[idx02,]
df12 <- df[idx03,]

# POS Chunk

df01 <- separate(df01, var, into = c("POS","Chunk"),sep = "/")

df01F <- df01 %>%
   mutate(POS = factor(POS, levels = mixedsort(unique(POS)))) %>% 
   mutate(Chunk = factor(Chunk, levels = mixedsort(unique(Chunk))))


df01F %>% ggplot(aes(x = POS, y = value, color = Chunk, group = Chunk)) +
   geom_point() +
   geom_line() +
   labs(title = "Mask OR : POS & Chunk")

df01F %>% ggplot(aes(x = Chunk, y = value, color = POS, group = POS)) +
   geom_point() +
   geom_line() +
   labs(title = "Mask OR : Chunk & POS")

# POS NER

df02F <- separate(df02, var, into = c("POS","NER"),sep = "/")

df02F <- df02F %>%
   mutate(POS = factor(POS, levels = mixedsort(unique(POS)))) %>% 
   mutate(NER = factor(NER, levels = mixedsort(unique(NER))))

df02F %>% ggplot(aes(x = POS, y = value, color = NER, group = NER)) +
   geom_point() +
   geom_line() +
   labs(title = "Mask OR : POS & NER")

df02F %>% ggplot(aes(x = NER, y = value, color = POS, group = POS)) +
   geom_point() +
   geom_line() +
   labs(title = "Mask OR : NER & POS")

# Chunk NER

df12F <- separate(df12, var, into = c("Chunk","NER"),sep = "/")

df12F <- df12F %>%
   mutate(Chunk = factor(Chunk, levels = mixedsort(unique(Chunk)))) %>% 
   mutate(NER = factor(NER, levels = mixedsort(unique(NER))))

df12F %>% ggplot(aes(x = Chunk, y = value, color = NER, group = NER)) +
   geom_point() +
   geom_line() +
   labs(title = "Mask OR : Chunk & NER")

df12F %>% ggplot(aes(x = NER, y = value, color = Chunk, group = Chunk)) +
   geom_point() +
   geom_line() +
   labs(title = "Mask OR : NER & Chunk")


df01FS <- sort_by.data.frame(x = df01F, y = df01F$POS)

sort_by.data.frame(x = df01F, y = df01F$Chunk)

df01F[df01F$Chunk == '1_1' | df01F$Chunk == '1_2' | df01F$Chunk == '1_3',] %>% ggplot(aes(x = POS, y = value, group = Chunk, color = Chunk)) +
   geom_point() +
   geom_line()

df01F[df01F$Chunk == '1_20',] %>% ggplot(aes(x = POS, y = value, group = Chunk, color = Chunk)) +
   geom_point() +
   geom_line()

df01F[df01F$Chunk == '1_10',] %>% ggplot(aes(x = POS, y = value, group = Chunk, color = Chunk)) +
   geom_point() +
   geom_line()

df01F[df01F$Chunk == '1_2',] %>% ggplot(aes(x = POS, y = value, group = Chunk, color = Chunk)) +
   geom_point() +
   geom_line()


########df0111 <- sort_by.data.frame(df01F[df01F$Chunk == '1_1',], df01F[df01F$Chunk == '1_1',]$POS)
########
########v <- c()
########for(i in c(1:19)) {
########   v[i] <- df0111[i,]$value - df0111[i+1,]$value
########}
########plot(v, ylim = c(-0.01,0.01), col = 'red')
########
########c <- rainbow(19)
########
########v <- data.frame(POS = NA, Chunk = NA, Diff =  NA)
########k = 0
########for (i  in levels(df01F$Chunk)) {
########   df <- sort_by.data.frame(df01F[df01F$Chunk == i,], df01F[df01F$Chunk == i,]$POS)
########   for (j in c(1+k:19+k)) {
########      v[j,"Diff"] <- df[j - k,]$value - df[j+1 - k,]$value
########      v[j, "Chunk"] <- i
########   }
########   k = k+19
########}
########
########plot(x = c(1,19), y = c(-0.1,0.01), type = "n", main = "Difference Between Adjacent Sparsity for Each Chunk by # of POS", ylab = "Diff", xlab = "Combination of Adjacent Sparsity")
########k = 1
########for (i  in levels(df01F$POS)) {
########   df <- sort_by.data.frame(df01F[df01F$POS == i,], df01F[df01F$POS == i,]$Chunk)
########   for (j in c(1:19)) {
########      v[j] <- df[j,]$value - df[j+1,]$value
########   }
########   points(v, col = c[k], pch = 16)
########   lines(v, col = c[k])
########   k = k+1
########}

# diff graph

v <- data.frame(POS = numeric(0), Chunk = character(0), Diff = numeric(0))  # 초기화
k = 0
for (i in levels(df01F$Chunk)) {
   # 특정 Chunk 데이터 정렬
   df <- sort_by.data.frame(df01F[df01F$Chunk == i,], df01F[df01F$Chunk == i,]$POS)
   
   for (j in seq(1, nrow(df) - 1)) {  # j는 1부터 df 길이 - 1까지
      v[k + j, "Diff"] <- df[j, "value"] - df[j + 1, "value"]
      v[k + j, "Chunk"] <- i
      v[k + j, "POS"] <- df[j, "POS"]  # POS도 저장
   }
   
   k <- k + nrow(df) - 1  # k 값 갱신
}
v <- v %>%
   mutate(Chunk = factor(Chunk, levels = mixedsort(unique(Chunk))))
v %>% ggplot(aes(x = POS, y = Diff, group = Chunk, color = Chunk)) +
   geom_point() +
   geom_line() +
   theme_minimal() +
   labs(title = "Difference Between Adjacent Sparsity for Each POS by # of Chunk")

############################

v <- data.frame(NER = numeric(0), POS = character(0), Diff = numeric(0))  # 초기화
k = 0
for (i in levels(df02F$POS)) {
   # 특정 Chunk 데이터 정렬
   df <- sort_by.data.frame(df02F[df02F$POS == i,], df02F[df02F$POS == i,]$NER)
   
   for (j in seq(1, nrow(df) - 1)) {  # j는 1부터 df 길이 - 1까지
      v[k + j, "Diff"] <- df[j, "value"] - df[j + 1, "value"]
      v[k + j, "POS"] <- i
      v[k + j, "NER"] <- df[j, "NER"]  # POS도 저장
   }
   
   k <- k + nrow(df) - 1  # k 값 갱신
}
v <- v %>%
   mutate(POS = factor(POS, levels = mixedsort(unique(POS))))
v %>% ggplot(aes(x = NER, y = Diff, group = POS, color = POS)) +
   geom_point() +
   geom_line() +
   theme_minimal() +
   labs(title = "Difference Between Adjacent Sparsity for Each NER by # of POS")

#################################

v <- data.frame(Chunk = numeric(0),NER = character(0), Diff = numeric(0))  # 초기화
k = 0
for (i in levels(df12F$NER)) {
   # 특정 Chunk 데이터 정렬
   df <- sort_by.data.frame(df12F[df12F$NER == i,], df12F[df12F$NER == i,]$Chunk)
   
   for (j in seq(1, nrow(df) - 1)) {  # j는 1부터 df 길이 - 1까지
      v[k + j, "Diff"] <- df[j, "value"] - df[j + 1, "value"]
      v[k + j, "NER"] <- i
      v[k + j, "Chunk"] <- df[j, "NER"]  # POS도 저장
   }
   
   k <- k + nrow(df) - 1  # k 값 갱신
}
v <- v %>%
   mutate(NER = factor(NER, levels = mixedsort(unique(NER))))
v %>% ggplot(aes(x = Chunk, y = Diff, group = NER, color = NER)) +
   geom_point() +
   geom_line() +
   theme_minimal() +
   labs(title = "Difference Between Adjacent Sparsity for Each POS by # of Chunk")


create_diff_graph <- function(df, group_col, sort_col, value_col, x_label, y_label, title_prefix) {
   # 결과 저장용 데이터프레임 초기화
   v <- data.frame(SortCol = numeric(0), GroupCol = character(0), Diff = numeric(0))
   k <- 0
   
   # 그룹별 데이터 처리
   for (group in levels(df[[group_col]])) {
      # 그룹 데이터 필터 및 정렬
      sorted_df <- sort_by.data.frame(df[df[[group_col]] == group,], df[df[[group_col]] == group,][[sort_col]])
      
      # 인접 값의 차이를 계산
      for (j in seq(1, nrow(sorted_df) - 1)) {
         v[k + j, "Diff"] <- sorted_df[j, value_col] - sorted_df[j + 1, value_col]
         v[k + j, "GroupCol"] <- group
         v[k + j, "SortCol"] <- sorted_df[j, sort_col]
      }
      
      k <- k + nrow(sorted_df) - 1  # k 값 갱신
   }
   
   # 그룹 컬럼 정렬
   v <- v %>%
      mutate(GroupCol = factor(GroupCol, levels = mixedsort(unique(GroupCol))))
   
   # 그래프 생성
   plot <- v %>%
      ggplot(aes(x = SortCol, y = Diff, group = GroupCol, color = GroupCol)) +
      geom_point() +
      geom_line() +
      theme_minimal() +
      labs(
         x = x_label,
         y = y_label,
         color = group_col,
         title = paste(title_prefix, "by # of", group_col)
      )
   
   return(plot)
}
plot1 <- create_diff_graph(
   df = df01F,
   group_col = "Chunk",
   sort_col = "POS",
   value_col = "value",
   x_label = "POS",
   y_label = "Difference",
   title_prefix = "Difference Between Adjacent Sparsity for Each POS"
)
print(plot1)
plot11 <- create_diff_graph(
   df = df01F,
   group_col = "POS",
   sort_col = "Chunk",
   value_col = "value",
   x_label = "Chunk",
   y_label = "Difference",
   title_prefix = "Difference Between Adjacent Sparsity for Each Chunk"
)
print(plot11)

plot2 <- create_diff_graph(
   df = df02F,
   group_col = "POS",
   sort_col = "NER",
   value_col = "value",
   x_label = "NER",
   y_label = "Difference",
   title_prefix = "Difference Between Adjacent Sparsity for Each NER"
)
print(plot2)
plot22 <- create_diff_graph(
   df = df02F,
   group_col = "NER",
   sort_col = "POS",
   value_col = "value",
   x_label = "POS",
   y_label = "Difference",
   title_prefix = "Difference Between Adjacent Sparsity for Each POS"
)
print(plot22)

plot3 <- create_diff_graph(
   df = df12F,
   group_col = "NER",
   sort_col = "Chunk",
   value_col = "value",
   x_label  = "Chunk",
   y_label = "Differnect",
   title_prefix = "Difference Between Adjacent Sparsity for Each Chunk"
)
print(plot3)

plot33 <- create_diff_graph(
   df = df12F,
   group_col = "Chunk",
   sort_col = "NER",
   value_col = "value",
   x_label  = "NER",
   y_label = "Differnect",
   title_prefix = "Difference Between Adjacent Sparsity for Each NER"
)
print(plot33)

2^31
