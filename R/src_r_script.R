
library(uncmbb)
library(dplyr)

df <- rbind(unc %>% mutate(school = "UNC"), duke %>% mutate(school = "Duke"))
df <- df %>% dplyr::filter(Type == "NCAA") %>%
             count(school, Result) %>%
             add_percent(grouped_var = "school", var = "n")
print(head(df))

p <- df %>%  ggplot(aes(x = Result, y = n)) +
        geom_bar(aes(fill = school), stat = "identity", position = "dodge") +
        geom_text(aes(group = school, label = n), position = position_dodge(width = 1), vjust = 0.01) +
        labs(title = "UNC and Duke's NCAA results since 1949-1950 season") +
        theme_bw()

print(p)

