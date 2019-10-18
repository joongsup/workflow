

library(ggplot2)
library(dplyr)

ncaa <- read.csv("data/champions.csv")

p <- ncaa %>% count(CHAMPION, COACH) %>%
         arrange(desc(n)) %>%
         filter(n >= 2)
print(p)

p <- ncaa %>% count(CHAMPION) %>%
         arrange(desc(n)) %>% 
         filter(n >= 3) %>%
         ggplot(aes(x = reorder(CHAMPION, n), y = n)) +
         geom_bar(stat = "identity") +
         coord_flip() +
         labs(title = "NCAA Men's Basketball Champions (3+ Rings Club!)", x = "School") +
         theme_bw()

print(p)

