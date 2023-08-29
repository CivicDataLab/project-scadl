source("scripts/libraries.R")
source("scripts/vars.R")

processed_data_path <-
  glue::glue("data/{data_shared_on}/appended_data_sheet.csv")

data_for_viz <- read_csv(processed_data_path)

# Filter data for selected categories
data_for_viz_sub <- data_for_viz[data_for_viz$new_category %in% c("Drainage","Public lighting","Sanitation","Water Supply"),]

vars_to_use <-
  c("new_category", "zone", "problem_category", "problem", "week")

data <- data_for_viz_sub[,vars_to_use]

# Recategorising problems
problem_df <-
  googlesheets4::read_sheet(ss = new_categories_file_path, sheet = "renaming-complaint")

data <- left_join(data, problem_df, by=c("new_category","problem"))


data <- data[!is.na(data$problem_recat),]

# data$week <-
#   stringr::str_replace_all(data$week, pattern = "_Week", replacement = "")

categories_for_viz <- data$new_category %>% unique()

for(i in 1:length(categories_for_viz)){
  
  cat_i <- categories_for_viz[[i]]
  
  cat_df <- data[data$new_category == cat_i,]
  
  viz_data <-
    cat_df %>% 
    group_by(zone, problem_recat, week) %>% 
    summarise(complaints = n()) %>% data.frame(check.names = FALSE)
  
  # Only consider top 4 complaints
  viz_data_filter <-
    viz_data %>%
    group_by(problem_recat) %>%
    summarise(total = sum(complaints)) %>%
    arrange(desc(total)) %>%
    head(4) %>%
    pull(problem_recat)
  
  viz_data <-
    viz_data[viz_data$problem_recat %in% viz_data_filter, ]
  
  problem_order <- viz_data %>%
    group_by(problem_recat) %>%
    summarize(total_complaints = sum(complaints)) %>%
    arrange(total_complaints) %>%
    pull(problem_recat)
  
  viz_data$problem_recat <-
    factor(viz_data$problem_recat, levels = problem_order)
  
  custom_colors <- c("current" = "#BAE2BB", "previous" = "#DEC280")
  
  
  bar_viz <- ggplot(viz_data, aes(x = problem_recat, y = complaints, fill = week)) +
    geom_bar(stat = "identity", position = "dodge") +
    labs(x = "Problem Category", y = "Number of Complaints per week", fill = "Week") +
    scale_fill_manual(values = custom_colors) +  # Set custom colors
    theme_minimal() + 
    coord_flip() + 
    facet_wrap(~ zone, ncol = 3) + 
    guides(fill = guide_legend(reverse = TRUE))
  
    viz_path <- glue::glue("viz/{data_shared_on}/weekly-complaints-bar")
    ggsave(plot = bar_viz, filename = glue::glue("{cat_i}.png"), 
           path = viz_path,bg = "white")
  
}

