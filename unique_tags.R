unique_tags = raw %>%
  group_by(tag_id) %>%
  summarize(num_detect = n()) %>%
  select(tag_id, num_detect) %>%
  arrange(desc(num_detect))
