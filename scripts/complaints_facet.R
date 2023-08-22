source("scripts/libraries.R")
source("scripts/vars.R")

raw_data <- read_csv("data/21082023/raw_data_sheet.csv")

vars_to_use <-
  c("re_re_categ", "Zone", "Problem.Category", "Problem", "week")

data <- raw_data[,vars_to_use]
data <- left_join(data, problem_df, by="Problem")
data <- data[!is.na(data$Problem_recat),]
data$week <-
  stringr::str_replace_all(data$week, pattern = "_Week", replacement = "")

categories_for_viz <- data$re_re_categ %>% unique()
for(i in 1:length(categories_for_viz)){
  
  cat_i <- categories_for_viz[[i]]
  
  cat_df <- data[data$re_re_categ == cat_i,]
  
  viz_data <-
    cat_df %>% 
    group_by(Zone, Problem_recat, week) %>% 
    summarise(complaints = n()) %>% data.frame(check.names = FALSE)
  
  # Only consider top 4 complaints
  viz_data_filter <-
    viz_data %>%
    group_by(Problem_recat) %>%
    summarise(total = sum(complaints)) %>%
    arrange(desc(total)) %>%
    head(4) %>%
    pull(Problem_recat)
  
  viz_data <-
    viz_data[viz_data$Problem_recat %in% viz_data_filter, ]
  
  problem_order <- viz_data %>%
    group_by(Problem_recat) %>%
    summarize(total_complaints = sum(complaints)) %>%
    arrange(total_complaints) %>%
    pull(Problem_recat)
  
  viz_data$Problem_recat <-
    factor(viz_data$Problem_recat, levels = problem_order)
  
  custom_colors <- c("Current" = "#BAE2BB", "Previous" = "#DEC280")
  
  
  bar_viz <- ggplot(viz_data, aes(x = Problem_recat, y = complaints, fill = week)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = "Problem Category", y = "Number of Complaints per week", fill = "Week") +
    scale_fill_manual(values = custom_colors) +  # Set custom colors
    theme_minimal() + 
    coord_flip() + 
    facet_wrap(~ Zone, ncol = 3) + 
    guides(fill = guide_legend(reverse = TRUE))
  
    ggsave(plot = bar_viz, filename = glue::glue("{cat_i}.png"), 
           path = "viz/220823/weekly-complaints-bar/",bg = "white")
  
}

